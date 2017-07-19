#!/bin/bash 
NGINX_CONFIG='/etc/nginx/sites-available'
NGINX_SITES_ENABLED='/etc/nginx/sites-enabled'
#WEB_DIR='/var/www'
SED=`which sed`
CURRENT_DIR=`dirname $0`

if [ -z $1 ]; then
	echo "No domain name given"
	exit 1
fi
DOMAIN=$1

# check the domain is roughly valid!

#Replace dots with underscores
SITE_DIR=`echo $DOMAIN | $SED 's/\./_/g'`

# Now we need to copy the virtual host template
CONFIG=$NGINX_CONFIG/$DOMAIN.conf
sudo cp $CURRENT_DIR/odoo_virtual_host.template $CONFIG
sudo $SED -i "s/DOMAIN/$DOMAIN/g" $CONFIG
sudo $SED -i "s!ROOT!$WEB_DIR/$SITE_DIR!g" $CONFIG

# create symlink to enable site
sudo ln -s $CONFIG $NGINX_SITES_ENABLED/$DOMAIN.conf

# reload Nginx to pull in new config
sudo /etc/init.d/nginx reload

echo "Odoo Nginx Site Created for $DOMAIN"
