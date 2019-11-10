#!/bin/bash
# Installs bemenu_extended_cache_build as a systemd service to be executed every 20 minutes

# Process command line arguments
for i in "$@"
do
	case $i in
		-u|--user)
			PER_USER_INSTALL=YES
			shift # past argument=value
			;;
		-d|--uninstall)
			UNINSTALL=YES

	esac
done

if [ "$PER_USER_INSTALL" == "YES" ] ; then
	SCRIPT_PATH=$HOME/.local/share/systemd/user
	DECB_DEFAULT=~/.local/bin/bemenu_extended_cache_build
else
	SCRIPT_PATH=/usr/lib/systemd/user
	DECB_PATH=`whereis bemenu_extended_cache_build | sed 's/bemenu_extended_cache_build: \?//'`;
fi

if [ "$UNINSTALL" == "YES" ]; then
	echo "Uninstalling systemd service in $SCRIPT_PATH..."
	rm -v $SCRIPT_PATH/{update-bemenu-extended-db.service,update-bemenu-extended-db.timer}
	exit
fi

if [ ! -d "$SCRIPT_PATH" ]; then
	echo "Creating directory $SCRIPT_PATH..."
	mkdir -p $SCRIPT_PATH
fi

echo "Installing systemd service in $SCRIPT_PATH..."

if [ -z "$DECB_PATH" ]; then
	echo "bemenu_extended_cache_build not found at the default location."
	echo "Please enter the full path to bemenu_extended_cache_build:"
	read DECB_PATH
fi

# If per-user install, we need systemd to call bemenu_extended_cache build with /bin/sh -c
if [ "$PER_USER_INSTALL" == "YES" ]; then
	SYSTEMD_EXEC='/bin/sh -c "$DECB_PATH"'
else
	SYSTEMD_EXEC=$DECB_PATH
fi

# Clear old file (if exists) then (re)write
if [ -f $SCRIPT_PATH/update-bemenu-extended-db.service ]; then
	rm $SCRIPT_PATH/update-bemenu-extended-db.service
fi

cat <<EOT >> $SCRIPT_PATH/update-bemenu-extended-db.service
[Unit]
Description=Updates the database file used by bemenu_extended_run

[Service]
Type=oneshot
User=%i
ExecStart=$SYSTEMD_EXEC
EOT
echo "$SCRIPT_PATH/update-bemenu-extended-db.service created."
cp -v systemd/update-bemenu-extended-db.timer $SCRIPT_PATH
