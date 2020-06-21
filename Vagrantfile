$hostname = "dev-machine"

$script_startup = <<-SCRIPT
echo Starting SHELL v.1.0.0
echo Update Packetlists...
apt-get update
echo Setting mysql root password...
debconf-set-selections <<< 'mysql-server-5.5 mysql-server/root_password password root' 
debconf-set-selections <<< 'mysql-server-5.5 mysql-server/root_password_again password root'
echo Installing packages...
sudo apt-get install -y apache2 mariadb-server mariadb-client php7.2 php7.2-mysql libapache2-mod-php7.2 php7.2-cli php7.2-cgi php7.2-gd php-xdebug
echo Setting up mysql-server...
sudo service mysql stop
sudo sed -i "s/bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/my.cnf
sudo service mysql start
echo "use mysql;update user set host='%' where user='root' and host='#{$hostname}';flush privileges;" | mysql -uroot -proot
echo "ServerName localhost" >> /etc/apache2/apache2.conf
sudo cat > /etc/php7.2/mods-available/xdebug.ini << EOF
zend_extension=xdebug.so
xdebug.remote_enable=On
xdebug.remote_connect_back=On
xdebug.remote_autostart=Off
xdebug.remote_log=/tmp/xdebug.log
EOF
a2enmod rewrite
sudo service apache2 restart 
echo Install WP...
wget -c https://wordpress.org/latest.tar.gz
tar -xzvf latest.tar.gz
sudo rsync -av wordpress/* /var/www/html/
sudo chown -R www-data:www-data /var/www/html/
sudo chmod -R 777 /var/www/html/
sudo rm /var/www/html/index.html
mysqladmin -u root -proot create 'wordpress';
mysql -u root -ppassword -e "use mysql; CREATE USER 'developer'@'localhost' IDENTIFIED BY 'LocalDevPass'; GRANT ALL PRIVILEGES ON * . * TO 'developer'@'localhost'; FLUSH PRIVILEGES;"
echo   
echo ----------------------------
echo         Webserver
echo url: http://localhost:8080
echo --
echo           Mysql
echo username: developer
echo password: LocalDevPass
echo database: wordpress
echo ----------------------------
echo       powered by JK
echo       jk-powered.de
SCRIPT

$script_backup = <<-SCRIPT
echo Starting Backup Database...
sudo mysqldump -ppassword wordpress > /databases/wordpress.sql
echo Database Backup done.
SCRIPT

Vagrant.configure(2) do |config|
	config.vm.box = "ubuntu/bionic64"
	config.vm.hostname = $hostname
	config.vm.network "forwarded_port", guest: 80, host: 8080
	config.vm.network "forwarded_port", guest: 3306, host: 6033
	config.vm.synced_folder "webpage/", "/var/www/html", owner: "vagrant", create: true, mount_options: ["dmode=777,fmode=777"]
	config.vm.synced_folder "databases/", "/databases", owner: "vagrant", create: true, mount_options: ["dmode=777,fmode=777"]
	config.vm.provider "virtualbox" do |vb|
		vb.memory = 1024
	end
	config.trigger.before :halt do |trigger|
		trigger.run_remote = {inline: $script_backup}
	end
	config.vm.provision "shell", inline: $script_startup
end
