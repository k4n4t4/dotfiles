% timedatectl

# use UTC for RTC
sudo timedatectl set-local-rtc 0 --adjust-system-clock

# use local time for RTC
sudo timedatectl set-local-rtc 1 --adjust-system-clock

# show time status
timedatectl status

# enable NTP
sudo timedatectl set-ntp true

# disable NTP
sudo timedatectl set-ntp false
