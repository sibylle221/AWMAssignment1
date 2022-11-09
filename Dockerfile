##
## Dockerfile to generate a Docker image from a GeoDjango project
##

## Start from an existing image with Miniconda installed
FROM continuumio/miniconda3

MAINTAINER Mark Foley

ENV PYTHONUNBUFFERED 1
ENV DJANGO_SETTINGS_MODULE=geodjango_tutorial.settings

## Ensure that everything is up-to-date
RUN apt-get -y update && apt-get -y upgrade
RUN conda update -n base conda && conda update -n base --all

## Make a working directory in the image and set it as working dir.
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

## UPDATE: these are not necessary as conda gets whatever it needs anyway.
## Get the following libraries. We can install them "globally" on the image as it will contain only our project

#RUN apt-get -y install build-essential python-cffi libcairo2 libpango-1.0-0 libpangocairo-1.0-0 libgdk-pixbuf2.0-0 libffi-dev shared-mime-info

## You should have already exported your conda environment to an "ENV.yml" file.
## Now copy this to the image and install everything in it. Make sure to install a WSGI server - it may not be in the source
## environment.
COPY ENV.yml /usr/src/app
RUN conda env create -n geodjango_tutorial --file ENV.yml

## Make RUN commands use the new environment
## See https://pythonspeed.com/articles/activate-conda-dockerfile/ for explanation
RUN echo "conda activate geodjango_tutorial" >> ~/.bashrc
SHELL ["/bin/bash", "--login", "-c"]

## Set up conda to match our test environment
RUN conda config --add channels conda-forge && conda config --set channel_priority strict
RUN cat ~/.condarc

## Install the appropriate WSGI server. If ccoming from Linux or Macc, this will probably be already there. If coming
## from MS Windows, you'll need to install it here.

#RUN conda install uwsgi
RUN conda install gunicorn

## Copy everything in your Django project to the image and display a directory listing.
COPY . /usr/src/app
RUN ls -la

## Make sure that static files are up to date and available.
RUN python manage.py collectstatic --no-input

## Expose port on the image. We'll map a localhost port to this later. You can change this if desired.
EXPOSE 8002


## Run a WSGI server - "uwsgi" or "gunicorn". uWSGI is a Web Server Gateway Interface (WSGI) server implementation
## that is typically used to run Python web applications. Gunicorn 'Green Unicorn' is a Python WSGI HTTP Server for UNIX.
## It is an alternative to uWSGI.

#CMD uwsgi --ini uwsgi.ini
CMD gunicorn geodjango_tutorial.wsgi --config gunicorn.conf.py

#THESE ARE FOR ME TO MAINTAIN CONTAINERS PLEASE IGNORE
#docker create --name awm_container --network awm --network-alias awm -t -p 25432:5432 -v db_data:/var/lib/postgresql kartoza/postgis
#docker create --name awmpga4_container --network awm --network-alias awm -t -v pga4_db:/var/lib/pgadmin -p 20080:80 -e 'PGADMIN_DEFAULT_EMAIL=C19305471@mytudublin.ie' -e 'PGADMIN_DEFAULT_PASSWORD=password' dpage/pgadmin4
#docker create --name geodjango_container --network awm --network-alias awm -t -p 8001:8001 geodjango_tutorial
#docker create --name awm_container --network awm --network-alias awm -t -p 25432:5432 -e POSTGRES_USER=docker -e POSTGRES_PASS=docker -v db_data:/var/lib/postgresql kartoza/postgis
#docker create --name awm_certbot --network awm --network-alias awm -p 80:80 -p 443:443 -t -v wmap_web_data:/usr/share/nginx/html -v $HOME/awm_certbot/conf:/etc/nginx/conf.d -v /etc/letsencrypt:/etc/letsencrypt -v /var/www/certbot awm_certbot
#docker create --name wmap_pgadmin4 --network awm --network-alias wmap-pgadmin4 -t -v wmap_pgadmin_data:/var/lib/pgadmin -e 'PGADMIN_DEFAULT_EMAIL=C19305471@mytudublin.ie' -e 'PGADMIN_DEFAULT_PASSWORD=password' dpage/pgadmin4
#docker create --name wmap_postgis --network awm --network-alias wmap-postgis -t -v wmap_postgis_data:/var/lib/postgresql -e 'POSTGRES_USER=docker' -e 'POSTGRES_PASS=docker' kartoza/postgis
#docker create --name geodjango_container --network awm --network-alias awm -t geodjango_tutorial
#docker build -t geodjango_container .
#server {
#    listen 80;
#    server_name .propelhealth.online;
#
#        location / {
#            return 301 https://$host$request_uri;
#        }
#
#        location /.well-known/acme-challenge/ {
#            root /var/www/certbot;
#        }
#    }
#
#server {
#    listen 443 ssl;
#
#    root /usr/share/nginx/html;
#    index index.html;
#
#    server_name .propelhealth.online;
#
#    ssl_certificate /etc/letsencrypt/live/propelhealth.online/fullchain.pem;
#    ssl_certificate_key /etc/letsencrypt/live/propelhealth.online/privkey.pem;
#
#    include /etc/letsencrypt/options-ssl-nginx.conf;
#    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem;
#
#    location = /favicon.ico { access_log off; log_not_found off; }
#
#    location /pgadmin4 {
#        proxy_set_header X-Script-Name /pgadmin4;
#        proxy_pass http://wmap-pgadmin4;
#    }
#
#    location / {
#        proxy_pass http://wmap-django:8001;
#    }
#
#
##    }
#docker create --name awm_certbot --network awm --network-alias awm -t -v html_data:/usr/src/app/static awm_certbot
#docker create --name awm_certbot --network awm --network-alias awm  -t -v wmap_web_data:/usr/share/nginx/html -v $HOME/awm_certbot/conf:/etc/nginx/conf.d -v /etc/letsencrypt:/etc/letsencrypt -v /var/www/certbot awm_certbot
#docker create --name wmap_geodjango --network awm --network-alias awm -t sibylle221/awm
#docker buildx build --platform=linux/amd64 -t geodjango_container .
