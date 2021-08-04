        !/bin/bash
        echo "userdata-start"
        apt-get update
        apt-get install -y apache2
        echo "Welcome to my website" > index.html cp index.html /var/www/html
        echo "userdata-end"