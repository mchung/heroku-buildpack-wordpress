# Heroku buildpack: Wordpress

A buildpack to run Wordpress on Heroku.

Currently running:

* `nginx-1.3.11` ([see compile options](https://github.com/mchung/heroku-buildpack-wordpress/blob/master/support/package_nginx)).
* `php-5.4.11` ([see compile options](https://github.com/mchung/heroku-buildpack-wordpress/blob/master/support/package_php)).
* `wordpress-3.5.1` ([from wordpress.org](http://wordpress.org/download/release-archive/))

## Overview

Fork [Wordpress on Heroku](http://github.com/mchung/wordpress-on-heroku), add your favorite theme and plugins, then deploy to Heroku.

For an enhanced Heroku experience, enable the following plugins:

* `heroku-sendgrid`
* `wpro`
* `memcachier`
* `batcache`

## Usage

Getting started
```
$ git clone git://github.com/mchung/wordpress-on-heroku.git my-new-wp-blog
$ cd my-new-wp-blog
$ heroku create --stack cedar --buildpack http://github.com/mchung/heroku-buildpack-wordpress.git my-new-wp-blog
$ git push heroku master
...
-----> Heroku receiving push
-----> Fetching custom buildpack
-----> Wordpress app detected

$ heroku open
# Will open the fresh instance in your browser
```

Setup a custom domain name
```
$ heroku domains:add my-new-wp-blog.org # ensure correct DNS settings
```

Adding a theme
```
$ cp -r appply setup/wp-content/themes/
$ git add .
$ git commit -m "New theme"
$ git push heroku master
```

Adding a plugin
```
$ cp -r google-analytics setup/wp-content/plugins/
$ git add .
$ git commit -m "New plugin"
$ git push heroku master
```

Enable and view the APC stats page
```
$ heroku config:set ENABLE_APC=true

# Visit /apc.php
# Don't forget to clear the environment variable when you're done.
```


## The Wordpress on Heroku stack

This buildpack is designed specifically to work with this [Wordpress](http://github.com/mchung/wordpress-on-heroku) project template, which is a highly tuned web stack built on the following components:

* `Nginx` - Nginx for serving content. Tuned specifically for Heroku.
* `MySQL` - ClearDB for the MySQL backend.
* `PHP` - PHP-FPM for intelligent process management. APC for op-code caching.
* `SMTP over Sendgrid` - Sendgrid for outgoing email.
* `Memcache` - MemCachier for the memcache backend.

## How highly tuned?

Here are the results of a blitz.io rush on a single Heroku dyno:

![Blitz.io rush](https://s3.amazonaws.com/heroku-buildpack-wordpress/woh-blitz-details.png)

[See the report](https://www.blitz.io/report/541eb908b4ef3eec8d9c2ce2293a85ca)

## Deck out your Wordpress

Each time the project is deployed, this buildpack will copy over several configuration files from the [`setup`](https://github.com/mchung/wordpress-on-heroku/tree/master/setup) directory.

These files contain Wordpress configurations as well as general configurations used to tune the entire stack (PHP and Nginx)

* `wp-content` - Wordpress themes and plugins
* `wp-config.php` - Wordpress configuration
* `nginx.conf.erb` - Nginx configuration
* `php-fpm.conf` - PHP-FPM configuration
* `php.ini` - PHP configuration

Feel free to hack on `nginx.conf.erb`, `php-fpm.conf`, and `php.ini`.  For example, if you want to remove the PHP-FPM status page at `/status.html`, delete the directive from `nginx.conf.erb`.

## I thought Heroku was only for Ruby applications?

Not anymore. Heroku's latest offerings (See [Celadon Cedar stack](http://devcenter.heroku.com/articles/cedar)) makes it easy (well, easyish) for developers to install and run any language, or service.

## Constraints with Heroku

The [ephemeral filesystem](http://devcenter.heroku.com/articles/dyno-isolation)

* End-users cannot upload media assets to Heroku. WORKAROUND: Enable `wpro` and use that plugin to upload media assets to S3 instead.
* End-users cannot update themes or plugins from the admin page. WORKAROUND: Add them to `setup/wp-content/themes` or `setup/wp-content/plugins` then push to Heroku.

## Security disclosure

Each time Wordpress is deployed, Heroku will fetch the latest buildpack from GitHub and execute the instructions in *compile* and *deploy*.  The latest precompiled version of Nginx, PHP, and Wordpress are downloaded from my personal [S3 bucket](http://heroku-buildpack-wordpress.s3.amazonaws.com).

## Get hacking

Not comfortable downloading and running a copy of someone else's PHP or Nginx? Not a problem!

The `support` directory also contains a handful of compilation and deployment scripts to automate several processes, which are currently used for maintenance and repo management.

* `package_nginx` - Used to compile and upload the latest version of Nginx to S3.
* `package_php` - Used to compile and upload the latest version of PHP to S3.
* `wordup` - Really useful helper script for creating and destroying instances of [Wordpress on Heroku](https://github.com/mchung/wordpress-on-heroku).

## TODO

* Automate vendor upgrades. Make it easy to keep in sync with latest Nginx, PHP, and Wordpress
* End-users shouldn't be able to do things that aren't supported on Heroku.

### Authors and Contributors
Marc Chung (@mchung)
