sudo mkdir -p /etc/sddm.conf.d
sudo tee /etc/sddm.conf.d/autologin.conf << eof
[Autologin]
User=$(whoami)
Session=dwm
eof

