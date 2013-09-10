# Example 

	# Get install script.
	wget https://raw.github.com/gianebao/ec2-bootstaps/master/nginx-php-centos.sh
	
	# Run script as super user
	sudo sh nginx-php-centos.sh
	# You can also install some optional stuff
	sudo yum install --assumeyes \
    	mysql \
        php54-iconv \
        php54-mysql \
        php54-odbc \
        php54-pdo \
        php54-soap