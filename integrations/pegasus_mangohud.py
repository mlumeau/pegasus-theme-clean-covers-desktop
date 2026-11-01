"""One-launch MangoHud for Pegasus, using Lutris's own runtime integration."""
import json
import hashlib
import os
from pathlib import Path
import re
import runpy
import sqlite3
import sys
import time


def pegasus_profile():
    """Only consume requests when called by Pegasus, never from a regular terminal."""
    pid = os.getppid()
    for _ in range(5):
        try:
            proc = Path('/proc') / str(pid)
            command = proc.joinpath('cmdline').read_bytes().split(b'\0')
            exe = proc.joinpath('exe').resolve().name
            if exe == 'pegasus-fe':
                return 'controller' if b'--portable' in command else 'desktop'
            pid = int(proc.joinpath('status').read_text().split('PPid:')[1].split()[0])
        except (OSError, ValueError, IndexError):
            return None
    return None


def consume_request(path, title, now=None):
    """Match a fresh request to this game and consume it once, including normal launches."""
    try:
        data = json.loads(Path(path).read_text())
        request = data.get("mangohudLaunch", {})
        age = (time.time() if now is None else now) - float(request.get("requestedAt", 0)) / 1000
        matches = 0 <= age <= 15 and request.get("title") == title
        # Deduplicate in a separate marker; never rewrite Pegasus's own memory file.
        marker = Path(str(path) + ".mangohud-consumed")
        token = str(request.get("requestedAt", 0))
        used = marker.read_text() if marker.exists() else ""
        if matches and used != token:
            marker.write_text(token)
            return request.get("enabled") is True
        return False
    except (OSError, ValueError, TypeError):
        return False


def requested_game():
    profile = pegasus_profile()
    if not profile:
        return None
    match = next((re.fullmatch(r'(?:lutris:)?rungameid/(\d+)/?', arg) for arg in sys.argv[1:]
                  if re.fullmatch(r'(?:lutris:)?rungameid/(\d+)/?', arg)), None)
    if not match:
        return None
    game_id = int(match[1])
    db_path = Path.home() / '.local/share/lutris/pga.db'
    try:
        with sqlite3.connect(f'file:{db_path}?mode=ro', uri=True) as db:
            row = db.execute('select name, runner from games where id = ?', (game_id,)).fetchone()
    except sqlite3.Error:
        return None
    if row and consume_request((Path.home() / '.local/opt/pegasus-stream/config/theme_settings/clean-covers.json' if profile == 'controller' else Path.home() / '.config/pegasus-frontend/theme_settings/clean-covers-desktop.json'), row[0]):
        if row[1] == 'steam':
            print('Pegasus MangoHud: Steam requires a Steam launch-options wrapper.', file=sys.stderr)
            return None
        return game_id
    return None


def install_override(game_id):
    from lutris.game import Game
    original_reload = Game.reload_config

    def reload_with_mangohud(self):
        original_reload(self)
        if str(self.id) == str(game_id):
            # Only the cascaded in-memory dictionary changes; raw saved config stays intact.
            self.config.system_config['mangohud'] = True
            env = dict(self.config.system_config.get('env') or {})
            env['MANGOHUD'] = '1'
            self.config.system_config['env'] = env
    Game.reload_config = reload_with_mangohud


def main(session_isolation=False):
    game_id = requested_game()
    if game_id is None and not session_isolation:
        os.execv('/usr/bin/lutris', ['/usr/bin/lutris'] + sys.argv[1:])
    sys.argv[0] = '/usr/bin/lutris'
    sys.path[0] = '/usr/bin'
    import gi
    gi.require_version('Gtk', '3.0')
    from gi.repository import Gio
    from lutris.gui.application import LutrisApplication
    original_init = LutrisApplication.__init__
    if game_id is not None:
        install_override(game_id)

    def scoped_init(self):
        original_init(self)
        session = '|'.join(os.environ.get(k, '') for k in ('DISPLAY', 'WAYLAND_DISPLAY', 'XDG_RUNTIME_DIR'))
        suffix = hashlib.sha256(session.encode()).hexdigest()[:16]
        if session_isolation:
            self.set_application_id('net.lutris.Lutris.Session' + suffix)
        if game_id is not None:
            # A running Lutris instance cannot receive this process's Python override.
            self.set_flags(self.get_flags() | Gio.ApplicationFlags.NON_UNIQUE)
            print(f'Pegasus MangoHud: enabled for Lutris game {game_id} (this launch only)', file=sys.stderr)
    LutrisApplication.__init__ = scoped_init
    runpy.run_path('/usr/bin/lutris', run_name='__main__')
