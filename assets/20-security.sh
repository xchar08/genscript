#!/bin/bash

read -p "Please enter your username: " us

#tor repo 
sudo eselect repository enable torbrowser
sudo emerge --sync

sudo eix-update

# tripwire 
sudo emerge app-admin/tripwire --autounmask{,-write,-continue}
sudo twsetup.sh
sudo mktwpol.sh -u
sudo twadmin --create-polfile /etc/tripwire/twpol.txt
sudo tripwire --init
sudo tripwire --check

# tor 
sudo emerge net-vpn/tor --autounmask{,-write,-continue}
sudo rc-service tor start
sudo rc-update add tor default 

# web browsers
sudo emerge www-client/torbrowser-launcher --autounmask{,-write,-continue}

# firewall
sudo emerge net-firewall/ufw
sudo rc-update add ufw default
sudo rc-service ufw start

# security patches

#antivirus
sudo emerge app-antivirus/clamav --autounmask{,-write,-continue}
sudo freshclam
sudo rc-service freshclam start 
sudo rc-service clamd start 
sudo rc-update add clamd default 
sudo emerge app-antivirus/clamtk --autounmask{,-write,-continue}

#ssh
sudo emerge net-misc/sshrc --autounmask{,-write,-continue}

#ssh hardening 
sudo sh -c 'echo "PermitRootLogin no" >> /etc/ssh/sshd_config'
sudo sh -c 'echo "AllowUsers ${us}" >> /etc/ssh/sshd_config'

#mac changer
sudo emerge net-analyzer/macchanger --autounmask{,-write,-continue}

sudo touch /etc/local.d/macchanger.start
sudo touch /etc/local.d/macchanger.stop
echo -e '#!/bin/bash\nmacchanger -r $(ip a | grep enp | awk '\''{print $2}'\'' | tr -d :)' | sudo tee /etc/local.d/macchanger.start >/dev/null && sudo chmod +x /etc/local.d/macchanger.start
echo -e '#!/bin/bash\nkillall macchanger' | sudo tee /etc/local.d/macchanger.stop >/dev/null && sudo chmod +x /etc/local.d/macchanger.stop
sudo rc-update add local default 

#super strict ufw
sudo ufw limit 22/tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw enable

#fail2ban
sudo emerge net-analyzer/fail2ban --autounmask{,-write,-continue}
sudo emerge dev-python/pyinotify --autounmask{,-write,-continue}

sudo sed -i 's/enabled = false/enabled = true/g' /etc/fail2ban/jail.conf
sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
sudo mv filter.d/ jail.d/

sudo emerge www-servers/apache --autounmask{,-write,-continue}
sudo rc-update add apache2 defualt
sudo rc-service apache2 start

sudo wget https://raw.githubusercontent.com/xchar08/gentoo-secured-dwl/main/assets/00_default_ssl_vhost.conf /etc/apache2/vhosts.d/00_default_ssl_vhost.conf

sudo emerge www-servers/nginx --autounmask{,-write,-continue}
sudo rc-update add nginx default
sudo sed -i 's/127.0.0.1/127.0.0.1:8080/g' /etc/nginx/nginx.conf
sudo rc-service nginx start
sudo emerge app-admin/monit --autounmask{,-write,-continue}
sudo rc-update add monit
sudo rc-service start start
sudo touch /var/log/monit.log
sudo emerge net-proxy/squid --autounmask{,-write,-continue}
sudo rc-update add squid
sudo rc-service squid start
sudo touch /var/log/squid/access.log
sudo mkdir -p /var/log/named
sudo touch /var/log/named/security.log
sudo emerge dev-db/mysql --autounmask{,-write,-continue}
sudo emerge --config dev-db/mysql
sudo rc-update add mysql default
sudo rc-service mysql start

sudo eselect repository enable dargor
sudo emerge --sync

sudo eix-update

sudo emerge dev-db/msodbcsql --autounmask{,-write,-continue}
sudo mkdir -p /var/opt/mssql/log/
sudo touch /var/opt/mssql/log/errorlog
sudo emerge dev-db/mongodb --autounmask{,-write,-continue}
sudo rc-update add mongodb default
sudo rc-service mongodb start

sudo touch /var/log/fail2ban.log

sudo emerge sys-process/lsof --autounmask{,-write,-continue}

sudo emerge net-misc/stunnel --autounmask{,-write,-continue}
sudo rc-update add stunnel default
sudo wget https://raw.githubusercontent.com/xchar08/gentoo-secured-dwl/main/assets/stunnel.conf /etc/stunnel/stunnel.conf
sudo openssl req -new -x509 -days 365 -nodes -out /etc/stunnel/stunnel.pem -keyout /etc/stunnel/stunnel.pem

sudo rc-service stunnel start 

sudo emerge dev-util/gitlab-cli --autounmask{,-write,-continue}
sudo mkdir -p /var/log/gitlab/gitlab-rails
sudo touch /var/log/gitlab/gitlab-rails/application.log

sudo mkdir -p /var/lib/portsentry/
sudo touch /var/lib/portsentry/portsentry.history

sudo emerge www-misc/monitorix --autounmask{,-write,-continue}
sudo touch /var/log/monitorix-httpd
sudo rc-update add monitorix default
sudo rc-service monitorix start

sudo wget https://raw.githubusercontent.com/xchar08/gentoo-secured-dwl/main/assets/paths-common.conf /etc/fail2ban/paths-common.conf

sudo wget https://raw.githubusercontent.com/xchar08/gentoo-secured-dwl/main/assets/jail.conf /etc/fail2ban/jail.conf
cat /etc/fail2ban/jail.conf | sudo tee /etc/fail2ban/jail.local

sudo rc-update add fail2ban default
sudo rc-service fail2ban start

sudo emerge sys-process/audit --autounmask{,-write,-continue}
sudo rc-update add auditd default
sudo rc-service auditd start

#klogd

sudo emerge app-admin/sysklogd --autounmask{,-write,-continue}
sudo dispatch-conf
sudo emerge app-admin/sysklogd --autounmask{,-write,-continue}
sudo rc-update add sysklogd default

sudo wget https://raw.githubusercontent.com/xchar08/gentoo-secured-dwl/main/assets/sysklog.conf -O /etc/syslog.conf
sudo bash -c 'echo -e "# Config file for /etc/init.d/sysklogd\n\nSYSLOGD=\"-m 0 -s -s -k\"" > /etc/conf.d/sysklogd'

sudo rc-service sysklogd start

#add a password to grub

#sudo bash -c 'read -p "Enter a superuser username: " username && echo "set superusers=\"$username\"" >> /etc/grub.d/40_custom; read -s -p "Enter a superuser password: " password && echo -e "\npassword_pbkdf2 $username $(grub-mkpasswd-pbkdf2 <<< "$password")" >> /etc/grub.d/40_custom && grub-mkconfig -o /boot/grub/grub.cfg'

#disable core dumps

echo '* soft core 0' | sudo tee -a /etc/security/limits.conf > /dev/null && echo "Added line '* soft core 0' to /etc/security/limits.conf"

#add PAM hashing algo
sudo sed -i '$s/.*/password        sufficient      pam_unix.so sha512 rounds=1000/' /etc/pam.d/system-auth

#set the password to expire every 30 days
echo "password        required        pam_pwquality.so enforce_for_root try_first_pass retry=3 type=" | sudo tee -a /etc/pam.d/system-auth > /dev/null

#configure the hashing rounds
echo -e "ENCRYPT_METHOD SHA512\nSHA_CRYPT_MIN_ROUNDS 1000" | sudo tee -a /etc/login.defs > /dev/null

#max and min passwd age + umask
echo "PASS_MIN_DAYS 1
PASS_MAX_DAYS 90
UMASK 027" | sudo tee -a /etc/login.defs

#update clamav daily
echo "UpdateDatabase daily" | sudo tee -a /etc/clamav/freshclam.conf

#resolve hosts
echo "$(ip route get 1.1.1.1 | awk '{print $7; exit}') $(hostname) $(hostname -f)" | sudo tee -a /etc/hosts

#legal warning
echo "Authorized Access Only. Disconnect IMMEDIATELY if you are not an authorized user!" | sudo tee /etc/issue

#acct
sudo emerge sys-process/acct --autounmask{,-write,-continue}
echo 'rc_sys="acct"' | sudo tee -a /etc/rc.conf
sudo rc-update add acct default
sudo /etc/init.d/acct start
sudo emerge app-admin/sysstat --autounmask{,-write,-continue}
echo 'rc_sys="sysstatd"' | sudo tee -a /etc/rc.conf
sudo rc-update add sysstat default
sudo /etc/init.d/sysstat start

#ca certs
sudo emerge app-misc/ca-certificates --autounmask{,-write,-continue}
sudo emerge dev-libs/openssl --autounmask{,-write,-continue}

openssl crl2pkcs7 -nocrl -certfile /etc/ssl/certs/ca-certificates.crt | openssl pkcs7 -print_certs -noout | while read line; do if echo $line | grep -q "notAfter="; then expire=$(date -d "$(echo $line | sed 's/notAfter=//')" +%s); now=$(date +%s); exp=2592000; if [ $(($expire-$now)) -le $exp ]; then echo $line; fi; fi; done

#modprobe binfmt-misc
sudo modprobe binfmt-misc

#wireshark
sudo emerge net-analyzer/wireshark
