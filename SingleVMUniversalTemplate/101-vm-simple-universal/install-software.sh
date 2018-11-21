#!/bin/bash
# This bash file install apache
# Parameter 1 hostname 
azure_hostname=$1

#############################################################################
log()
{
	# If you want to enable this logging, uncomment the line below and specify your logging key 
	#curl -X POST -H "content-type:text/plain" --data-binary "$(date) | ${HOSTNAME} | $1" https://logs-01.loggly.com/inputs/${LOGGING_KEY}/tag/redis-extension,${HOSTNAME}
	echo "$1"
}
#############################################################################
check_os() {
    grep ubuntu /proc/version > /dev/null 2>&1
    isubuntu=${?}
    grep centos /proc/version > /dev/null 2>&1
    iscentos=${?}
    grep redhat /proc/version > /dev/null 2>&1
    isredhat=${?}	
	if [ -f /etc/debian_version ]; then
    isdebian=0
	else
	isdebian=1	
    fi

	if [ $isubuntu -eq 0 ]; then
		OS=Ubuntu
		VER=$(lsb_release -a | grep Release: | sed  's/Release://'| sed -e 's/^[ \t]*//' | cut -d . -f 1)
	elif [ $iscentos -eq 0 ]; then
		OS=Centos
		VER=$(cat /etc/centos-release)
	elif [ $isredhat -eq 0 ]; then
		OS=RedHat
		VER=$(cat /etc/redhat-release)
	elif [ $isdebian -eq 0 ];then
		OS=Debian  # XXX or Ubuntu??
		VER=$(cat /etc/debian_version)
	else
		OS=$(uname -s)
		VER=$(uname -r)
	fi
	
	ARCH=$(uname -m | sed 's/x86_//;s/i[3-6]86/32/')

	log "OS=$OS version $VER Architecture $ARCH"
}
#############################################################################
configure_apache(){
# Apache installation 
apt-get -y update
apt-get -y install apache2
if [ $isubuntu -eq 0 ]; then
log "Install PHP 7.0"
apt-get -y install php7.0-common libapache2-mod-php7.0 php7.0-cli
else
log "Install PHP 5"
apt-get -y install php5-common libapache2-mod-php5 php5-cli
fi
apt-get -y install curl
azure_localip=`ifconfig eth0 |  grep 'inet ' | awk '{print \$2}' | sed 's/addr://'`
azure_publicip=`curl -s checkip.dyndns.org | sed -e 's/.*Current IP Address: //' -e 's/<.*$//'`
log "Local IP address: $azure_localip"
log "Public IP address: $azure_publicip"
#
# Start Apache server
#
apachectl restart

directory=/var/www/html
if [ ! -d $directory ]; then
mkdir $directory
fi

cat <<EOF > $directory/index.php 
<html>
  <head>
    <title>Sample "Hello from $azure_hostname" </title>
  </head>
  <body bgcolor=white>

    <table border="0" cellpadding="10">
      <tr>
        <td>
          <h1>Hello from $azure_hostname</h1>
		  <p>OS $OS Version $VER Architecture $ARCH </p>
		  <p>Local IP Address: </p>

<?php
echo "$azure_localip";

?>

<p>Public IP Address: </p>
<?php
echo "$azure_publicip";

?>
        </td>
      </tr>
    </table>

    <p>This is the home page for the iperf3 test on Azure VM</p>
    <p>Launch the command line from your client: </p>
    <p>     iperf3 -c $azure_hostname -p 5201 --parallel 32  </p> 
    <ul>
      <li>To <a href="http://www.microsoft.com">Microsoft</a>
      <li>To <a href="https://portal.azure.com">Azure</a>
    </ul>
  </body>
</html>
EOF


echo "Configuring Web Site for Apache: $(date)"
cat <<EOF > /etc/apache2/conf-available/html.conf 
ServerName "$azure_hostname"
<VirtualHost *:80>
        ServerAdmin webmaster@localhost
        ServerName "$azure_hostname"

        DocumentRoot /var/www/html
        <Directory />
                Options FollowSymLinks
                AllowOverride None
        </Directory>

       # Add CORS headers for HTML5 players
        Header always set Access-Control-Allow-Headers "origin, range"
        Header always set Access-Control-Allow-Methods "GET, HEAD, OPTIONS"
        Header always set Access-Control-Allow-Origin "*"
        Header always set Access-Control-Expose-Headers "Server,range"

        # Possible values include: debug, info, notice, warn, error, crit,
        # alert, emerg.
        LogLevel warn
        LogLevel warn
        ErrorLog /var/log/apache2/azure-evaluation-error.log
        CustomLog /var/log/apache2/azure-evaluation-access.log combined
</VirtualHost>
EOF

}
#############################################################################
configure_apache_centos(){
# Apache installation 
yum clean all
yum -y install httpd
yum -y install php

azure_localip=`ifconfig eth0 |  grep 'inet ' | awk '{print \$2}' | sed 's/addr://'`
azure_publicip=`curl -s checkip.dyndns.org | sed -e 's/.*Current IP Address: //' -e 's/<.*$//'`
log "Local IP address: $azure_localip"
log "Public IP address: $azure_publicip"
#
# Start Apache server
#
systemctl start httpd
systemctl enable httpd
systemctl status httpd

directory=/var/www/html
if [ ! -d $directory ]; then
mkdir $directory
fi

cat <<EOF > $directory/index.php 
<html>
  <head>
    <title>Sample "Hello from $azure_hostname" </title>
  </head>
  <body bgcolor=white>

    <table border="0" cellpadding="10">
      <tr>
        <td>
          <h1>Hello from $azure_hostname</h1>
		  <p>OS $OS Version $VER Architecture $ARCH </p>
		  <p>Local IP Address: </p>

<?php
echo "$azure_localip";

?>

<p>Public IP Address: </p>
<?php
echo "$azure_publicip";

?>
        </td>
      </tr>
    </table>

    <p>This is the home page for the iperf3 test on Azure VM</p>
    <p>Launch the command line from your client: </p>
    <p>     iperf3 -c $azure_hostname -p 5201 --parallel 32  </p> 
    <ul>
      <li>To <a href="http://www.microsoft.com">Microsoft</a>
      <li>To <a href="https://portal.azure.com">Azure</a>
    </ul>
  </body>
</html>
EOF


echo "Configuring Web Site for Apache: $(date)"
cat <<EOF > /etc/httpd/conf.d/html.conf 
ServerName "$azure_hostname"
<VirtualHost *:80>
        ServerAdmin webmaster@localhost
        ServerName "$azure_hostname"

        DocumentRoot /var/www/html
        <Directory />
                Options FollowSymLinks
                AllowOverride None
        </Directory>

       # Add CORS headers for HTML5 players
        Header always set Access-Control-Allow-Headers "origin, range"
        Header always set Access-Control-Allow-Methods "GET, HEAD, OPTIONS"
        Header always set Access-Control-Allow-Origin "*"
        Header always set Access-Control-Expose-Headers "Server,range"

        # Possible values include: debug, info, notice, warn, error, crit,
        # alert, emerg.
        LogLevel warn
        LogLevel warn
        ErrorLog /var/log/httpd/azure-evaluation-error.log
        CustomLog /var/log/httpd/azure-evaluation-access.log combined
</VirtualHost>
EOF

}
#############################################################################
configure_network(){
# firewall configuration 
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp --dport 443 -j ACCEPT
}
#############################################################################
configure_network_centos(){
# firewall configuration 
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp --dport 443 -j ACCEPT

service firewalld start
firewall-cmd --permanent --add-port=80/tcp
firewall-cmd --permanent --add-port=443/tcp
firewall-cmd --reload
}


#############################################################################
start_apache(){
apachectl restart
}
#############################################################################
start_apache_centos(){
systemctl restart httpd
systemctl enable httpd
systemctl status httpd
}

#############################################################################

environ=`env`

log "Environment before installation: $environ"

log "Installation script start : $(date)"
log "Apache Installation: $(date)"
log "#####  azure_hostname: $azure_hostname"
log "Installation script start : $(date)"
check_os
if [ $iscentos -ne 0 ] && [ $isredhat -ne 0 ] && [ $isubuntu -ne 0 ] && [ $isdebian -ne 0 ];
then
    log "unsupported operating system"
    exit 1 
else
	if [ $iscentos -eq 0 ] ; then
	    log "configure network centos"
		configure_network_centos
	    log "configure apache centos"
		configure_apache_centos
	elif [ $isredhat -eq 0 ] ; then
	    log "configure network redhat"
		configure_network_centos
	    log "configure apache redhat"
		configure_apache_centos
	else
	    log "configure network"
		configure_network
	    log "configure apache"
		configure_apache
	fi
    log "start apache"
      if [ $iscentos -eq 0 ] ; then
	    start_apache_centos
	  elif [ $isredhat -eq 0 ] ; then
	    start_apache_centos
      else
	    start_apache
	  fi
fi
exit 0 

