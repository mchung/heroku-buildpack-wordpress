This is a list of vendored Nginx and PHP packages made available by this buildpack.  They are hosted on S3 and maintained by @mchung.

Nginx
* 1.5.0 (development)
* 1.4.2 (stable)
* 1.4.1 (stable)
* 1.3.12 (development)
* 1.3.11 (development)
* 1.2.7 (stable)

PHP
* 5.5.2 (5.5-stable)
* 5.4.11 (5.4-stable)
* 5.3.9 (5.3-stable)

Wordpress *downloaded directly* from [Wordpress](http://wordpress.org/download/release-archive/)
* 3.8.1
* 3.8
* 3.7.1
* 3.6
* 3.5.1
* 3.5.0

Configure Wordpress on Heroku to use specific versions of Nginx and PHP
```bash
$ git clone git://github.com/your_name/wordpress-on-heroku.git mydogblog
$ cd mydogblog
$ heroku create -s cedar
$ heroku labs:enable user-env-compile
$ heroku config:set NGINX_VERSION=1.5.0
$ heroku config:set PHP_VERSION=5.4.11
$ heroku config:set WORDPRESS_VERSION=3.5.1
$ heroku config:set BUILDPACK_URL=https://github.com/mchung/heroku-buildpack-wordpress.git
$ git push heroku master
```

Configure existing Wordpress on Heroku to use a specific version of Wordpress
```bash
$ cd existing_wp
$ heroku labs:enable user-env-compile
$ heroku config:set WORDPRESS_VERSION=3.6.2
$ git push heroku master
```

To request a new vendored package, [please file an issue](https://github.com/mchung/heroku-buildpack-wordpress/issues/new?title=Request%20for%20new%20vendor%20package&body=Hi-%0A%0APlease add:%0A%0A```%0Anginx-2.3.18%0Aphp-4.5%0A```%0A%0AThank%20you)
