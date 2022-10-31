## Genscript
Minimal encrypted/hardened gentoo installation script w/ xorg, bspwm, and polybar
## Installation
Firstly, open linux mint on a live cd and open a terminal. 
Then proceed with the following commands.
1. sudo su
2. enter root password
3. git clone https://github.com/jpx32/genscript/ ~/.genscript
4. ~/.genscript/assets/mint-partitioning.sh  
5. git clone https://github.com/jpx32/genscript/ ~/.genscript
6. ~/.genscript/assets/mint-crypt.sh
7. ~/.genscript/assets/mint-chroot.sh
8. git clone https://github.com/jpx32/genscript/ ~/.genscript
9. ~/.genscript/assets/gentoo.sh
10. ~/.genscript/assets/gentoo-desktop.sh
11. useradd -m -G users,wheel,audio,plugdev -s /bin/bash <username>
12. configure sudo or doas
## Usage
This will walk you through installation. You will be instructed to include a partition 
to boot to, and will zap (wipe) all current partitions. Be sure to back up any 
information on your computer before running this script. 
## Contributing
1. Fork it!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request :D
6. Please drop a star 🌟!!
## History
Currently on first iteration. 
 <p> -Includes bspwm, sxhkd, polybar, custom compositor configuration, tor browser, and runs on openrc</p>
 
## License
MIT License (Free to modify, just give proper credits!)
