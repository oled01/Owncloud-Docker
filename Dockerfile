#Get Image - Image Sektion
FROM ubuntu:14.04

#Update Ubuntu Build
RUN apt-get update -y && apt-get upgrade -y && apt-get install wget -y

#Install Apache2 Server and all php files for owncloud
RUN apt-get install apache2 -y
RUN apt-get install php5 php5-mysql -y
RUN apt-get install php5-gd php5-json php5-curl php5-intl php5-mcrypt php5-imagick -y

#For Errorfinding and testing nano my favourite editor
RUN apt-get install nano -y

RUN mkdir -p /data

#Prepare for owncloud installation
RUN wget https://download.owncloud.org/community/owncloud-9.1.0.tar.bz2 -O /var/www/html/owncloud.tar.bz2
RUN tar -xvf /var/www/html/owncloud.tar.bz2 -C /data && rm -rf /var/www/htm/owncloud.tar.bz2
RUN chmod 777 -R /data

#Reset Apache parameters to pass all owncloud security warnings
RUN sed -i 's/AllowOverride None/AllowOverride ALL/g' /etc/apache2/apache2.conf \
    && sed -i 's/LogFormat "%h /LogFormat "%{X-Forwarded-For}i /' /etc/apache2/apache2.conf

RUN sed -i 's#DocumentRoot /var/www/html#DocumentRoot /data/owncloud#g' /etc/apache2/sites-available/000-default.conf
RUN sed -i 's#DocumentRoot /var/www/html#DocumentRoot /data/owncloud#g' /etc/apache2/sites-available/default-ssl.conf

#Configure SSL on Server
#RUN mkdir /etc/apache2/ssl
#COPY sslcerts/server.crt /etc/apache2/ssl/server.crt
#COPY sslcerts/server.key /etc/apache2/ssl/server.key

#RUN sed "32 s#SSLCertificateFile.*#SSLCertificateFile /etc/apache2/ssl/server.crt#" etc/apache2/sites-available/default-ssl.conf > /etc/apache2/sites-available/default-ssl.conf1
#RUN sed "33 s#SSLCertificateKeyFile.*#SSLCertificateKeyFile /etc/apache2/ssl/server.key#" /etc/apache2/sites-available/default-ssl.conf1 > /etc/apache2/sites-available/default-ssl.conf2
#RUN rm -rf /etc/apache2/sites-available/default-ssl.conf && rm -rf /etc/apache2/sites-available/default-ssl.conf1
#RUN mv /etc/apache2/sites-available/default-ssl.conf2 /etc/apache2/sites-available/default-ssl.conf 

#RUN ln -s /etc/apache2/sites-available/default-ssl.conf /etc/apache2/sites-enabled/default-ssl.conf
#RUN a2enmod ssl

#Tell Docker default ports for -P command
EXPOSE 8080

# no priveleged ports!
# EXPOSE 443

ENTRYPOINT ["/usr/sbin/apache2ctl","-D","FOREGROUND"]
