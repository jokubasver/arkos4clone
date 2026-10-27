#!/bin/bash
# EmulationStation launcher for standalone Dolphin: dolphin.sh <gc|wii> <rom>
# The user directory is <sd>/gc (saves, memory cards, Wii NAND, states), shared
# by both systems and kept on the same SD card as the ROM.

rom="$2"
sd="$(echo "${rom}" | cut -d/ -f2)"
user_dir="/${sd}/gc"
defaults="/opt/dolphin/defaults/Config"

mkdir -p "${user_dir}/Config"
for f in "${defaults}"/*.ini; do
  [ -f "${user_dir}/Config/$(basename "${f}")" ] || cp "${f}" "${user_dir}/Config/"
done

export XDG_RUNTIME_DIR=/run/user/1000
# killer_daemon runs pkill/pidof, which only see the first 15 characters of the name
echo "VAR=dolphin-emu-nog" > /home/ark/.config/KILLIT
sudo systemctl restart killer_daemon.service
/opt/dolphin/dolphin-emu-nogui -p drm -u "${user_dir}" -e "${rom}" > /tmp/dolphin.log 2>&1
sudo systemctl stop killer_daemon.service
