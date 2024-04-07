#!/usr/bin/env fish


function mount_usb

    set DEVICE "$argv[1]"
    if lsblk | grep --quiet $DEVICE
        sudo mount /dev/sd$DEVICE1 "$USER/mounts/usb-$DEVICE"
        if test $status -eq 0
            echo "usb mounted on a"
        else
            echo "failed"
        end
    end
end
