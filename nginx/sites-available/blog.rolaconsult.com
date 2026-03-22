server {
    listen 80;
    listen [::]:80;
    server_name blog.rolaconsult.com;
    return 301 https://$host$request_uri;
}

server {
    listen 443 ssl;
    listen [::]:443 ssl;
    server_name blog.rolaconsult.com;

    root /var/www/secure_store;
    index index.php ;

    # SSL - managed by Certbot
    ssl_certificate /etc/letsencrypt/live/blog.rolaconsult.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/blog.rolaconsult.com/privkey.pem;
    include /etc/letsencrypt/options-ssl-nginx.conf;
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem;

    # WordPress permalinks
    location / {
        try_files $uri $uri/ /index.php?$args;
    }

    # PHP handling
    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php8.3-fpm.sock;
	
	fastcgi_cache MYCACHE;
	fastcgi_cache_valid 200 60m;
	fastcgi_cache_use_stale error timeout invalid_header updating;

	fastcgi_cache_bypass $skip_cache;
	fastcgi_no_cache $skip_cache;

	add_header X-Cache $upstream_cache_status;

        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include fastcgi_params;
    }

    # Block xmlrpc if not needed
    location = /xmlrpc.php {
        deny all;
    }

    # Deny hidden files
    location ~ /\. {
        deny all;
    }
    location ~* \.(css|js|jpg|jpeg|png|gif|ico|svg|webp)$ {
	    expires 30d;
	    add_header Cache_Control "public";

    }
}


