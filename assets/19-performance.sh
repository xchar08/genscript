#!/bin/bash

sudo emerge sys-power/auto-cpufreq --autounmask{,-write,-continue}
sudo rc-update add auto-cpufreq
sudo rc-service auto-cpufreq start
cd

git clone https://github.com/AdnanHodzic/auto-cpufreq

sudo emerge psutil --autounmask{,-write,-continue}

sudo python3 ./auto-cpufreq/auto_cpufreq/power_helper.py --gnome_power_disable

echo '# settings for when connected to a power source
[charger]
# see available governors by running: cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors
# preferred governor.
governor = performance

# minimum cpu frequency (in kHz)
# example: for 800 MHz = 800000 kHz --> scaling_min_freq = 800000
# see conversion info: https://www.rapidtables.com/convert/frequency/mhz-to-hz.html
# to use this feature, uncomment the following line and set the value accordingly
# scaling_min_freq = 800000

# maximum cpu frequency (in kHz)
# example: for 1GHz = 1000 MHz = 1000000 kHz -> scaling_max_freq = 1000000
# see conversion info: https://www.rapidtables.com/convert/frequency/mhz-to-hz.html
# to use this feature, uncomment the following line and set the value accordingly
# scaling_max_freq = 1000000

# turbo boost setting. possible values: always, auto, never
turbo = auto

# settings for when using battery power
[battery]
# see available governors by running: cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors
# preferred governor
governor = powersave

# minimum cpu frequency (in kHz)
# example: for 800 MHz = 800000 kHz --> scaling_min_freq = 800000
# see conversion info: https://www.rapidtables.com/convert/frequency/mhz-to-hz.html
# to use this feature, uncomment the following line and set the value accordingly
# scaling_min_freq = 800000

# maximum cpu frequency (in kHz)
# see conversion info: https://www.rapidtables.com/convert/frequency/mhz-to-hz.html
# example: for 1GHz = 1000 MHz = 1000000 kHz -> scaling_max_freq = 1000000
# to use this feature, uncomment the following line and set the value accordingly
# scaling_max_freq = 1000000

# turbo boost setting. possible values: always, auto, never
turbo = auto' | sudo tee /etc/auto-cpufreq.conf >/dev/null

sudo auto-cpufreq --install

sudo emerge sys-power/cpupower --autounmask{,-write,-continue}

# Checks for pstate and applies required patch

if cpupower frequency-info | grep -q "driver: intel_pstate" && cpupower frequency-info | grep -q "driver: amd_cpufreq"; then
    sudo sed -i '/^GRUB_CMDLINE_LINUX=/s/"\(.*\)"/"\1 quiet splash intel_pstate=disable initcall_blacklist=amd_pstate_init amd_pstate.enable=0"/' /etc/default/grub
elif cpupower frequency-info | grep -q "driver: intel_pstate"; then
    sudo sed -i '/^GRUB_CMDLINE_LINUX=/s/"\(.*\)"/"\1 quiet splash intel_pstate=disable"/' /etc/default/grub
elif cpupower frequency-info | grep -q "driver: amd_cpufreq"; then
    sudo sed -i '/^GRUB_CMDLINE_LINUX=/s/"\(.*\)"/"\1 quiet splash initcall_blacklist=amd_pstate_init amd_pstate.enable=0"/' /etc/default/grub
fi

sudo emerge app-laptop/laptop-mode-tools --autounmask{,-write,-continue}
sudo touch /etc/laptop-mode/conf.d/cpufreq.conf
echo "CONTROL_CPU_FREQUENCY=0" | sudo tee /etc/laptop-mode/conf.d/cpufreq.conf
sudo emerge app-laptop/laptop-mode-tools --autounmask{,-write,-continue}
sudo dispatch-conf
sudo rc-service laptop_mode start 
sudo rc-update add laptop_mode default 

