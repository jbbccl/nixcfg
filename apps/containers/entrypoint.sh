#!/usr/bin/env bash

if [[ ! -S "$XDG_RUNTIME_DIR/bus" ]]; then
	dbus-daemon --session --address="unix:path=$XDG_RUNTIME_DIR/bus" --fork
	export DBUS_SESSION_BUS_ADDRESS="unix:path=$XDG_RUNTIME_DIR/bus"
	echo "using container dbus"
else
	echo "using host dbus"
fi

export PATH="/opt/toolkit/ass/bin:${PATH}"
export XDG_DATA_DIRS="/opt/toolkit/ass:${XDG_DATA_DIRS:-/usr/local/share:/usr/share}"

exec "$@"
