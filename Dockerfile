FROM ubuntu:18.04

# Install wordpress, php, apache2 php, mysql and php mysql

RUN apt -y update
RUN apt-get -y update 
RUN apt-get -y upgrade
RUN DEBIAN_FRONTEND="noninteractive" apt-get -y install tzdata


# Set the Server Timezone to CST
RUN echo "America/Chicago" > /etc/timezone

#RUN dpkg-reconfigure -f noninteractive tzdata


RUN apt install -y wordpress php libapache2-mod-php 

# Copy the wordpress script into a new location

COPY wordpress.conf /etc/apache2/sites-available/

RUN a2ensite wordpress #enables the site
RUN a2enmod rewrite  #enable URL rewriting
#RUN service apache2 reload  #reload apache2


# Script for non interactive mode for installing mysql
	
	
# Download and Install the Latest Updates for the OS
RUN apt-get update && apt-get upgrade -y
 

# Enable Ubuntu Firewall and allow SSH & MySQL Ports
#RUN ufw enable
#RUN ufw allow 22
#RUN ufw allow 3306
 
# Install essential packages
RUN apt-get -y install zsh htop
 
# Install MySQL Server in a Non-Interactive mode. Default root password will be "root"

RUN echo "mysql-server mysql-server/root_password password root" | debconf-set-selections
RUN echo "mysql-server mysql-server/root_password_again password root" | debconf-set-selections
RUN apt-get -y install mysql-server
 
# Run the MySQL Secure Installation wizard
#RUN sudo mysql_secure_installation
 
RUN sed -i 's/127\.0\.0\.1/0\.0\.0\.0/g' /etc/mysql/my.cnf
#RUN mysql -uroot -p -e 'USE mysql; UPDATE `user` SET `Host`="%" WHERE `User`="root" AND `Host`="localhost"; DELETE FROM `user` WHERE `Host` != "%" AND `User`="root"; FLUSH PRIVILEGES;'
 
RUN service mysql restart


EXPOSE 80
EXPOSE 3306
EXPOSE 22

CMD ["/usr/sbin/apache2", "-D", "FOREGROUND"]
