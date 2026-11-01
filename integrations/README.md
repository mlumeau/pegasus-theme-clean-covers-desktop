# Optional one-launch MangoHud integration

Hold Shift while pressing Enter or clicking Play.

The theme records a timestamped `mangohudLaunch` request in Pegasus theme memory before calling the normal launch API. Ordinary launches record `enabled: false`. No additional hint is shown in the UI.

On Linux, install `pegasus_mangohud.py` into `~/.local/libexec/` and the `lutris` shim into a directory ahead of `/usr/bin` in Pegasus's PATH (make the shim executable). The shim uses `/usr/bin/lutris`. For a private streaming display, set `PEGASUS_LUTRIS_SESSION_ISOLATION=1` for the shim to preserve display-specific Lutris instances.

This integration expects the desktop theme at `~/.config/pegasus-frontend/themes/clean-covers-desktop` and portable controller Pegasus at `~/.local/opt/pegasus-stream/pegasus-fe --portable`. Theme memory is read from the corresponding `theme_settings` directory. The Lutris database is expected at `~/.local/share/lutris/pga.db`.

The helper accepts requests only from a Pegasus ancestor, matches the game title, expires requests after 15 seconds, and prevents reuse. It enables Lutris's MangoHud setting in memory in a separate process without changing saved game configuration. MangoHud and the native Python Lutris modules must be installed. Steam games require a separate Steam launch-options wrapper and are not supported by this integration.
