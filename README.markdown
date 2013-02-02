# Heroku buildpack: Wordpress

This is a Heroku buildpack for [Wordpress](http://wordpress.org)

* `nginx-1.3.11` ([see compile options](https://github.com/mchung/heroku-buildpack-wordpress/blob/master/support/package_nginx)).
* `php-5.4.11` ([see compile options](https://github.com/mchung/heroku-buildpack-wordpress/blob/master/support/package_php)).
* `wordpress-3.5.1` ([from wordpress.org](http://wordpress.org/download/release-archive/))

## Getting Started

Fork my [Wordpress project](http://github.com/mchung/wordpress-on-heroku)
```bash
$ git clone git://github.com/username/wordpress-on-heroku.git myblog
$ cd myblog

# Optionally assign an upstream
$ git remote add upstream https://github.com/mchung/wordpress-on-heroku.git

$ heroku create --s cedar
$ heroku config:add BUILDPACK_URL=https://github.com/mchung/heroku-buildpack-wordpress.git

$ git push heroku master
...
-----> Heroku receiving push
-----> Fetching custom git buildpack... done
-----> Wordpress app detected
.
[...]
.
-----> Discovering process types
       Procfile declares types     -> (none)
       Default types for Wordpress -> web
-----> Compiled slug size: 33.7MB
-----> Launching... done, v7

$ heroku open
# Open your new blog in the browser.
```

## Overview

The buildpack bootstraps the [mchung/wordpress-on-heroku]((http://github.com/mchung/wordpress-on-heroku) site template which contains several settings used to configure Heroku on Wordpress.

You may enable the following plugins to further optimize Wordpress for Heroku.

You can add your favorite themes, plugins
Fork [Wordpress on Heroku](http://github.com/mchung/wordpress-on-heroku), add your favorite theme and plugins, then deploy to Heroku.

* `heroku-sendgrid` - Configures SMTP through Sendgrid
* `wpro` - Upload everything to S3
* `batcache` - Configures Wordpress to use memcached to cache everything
* `memcachier` - A better memcached plugin
* `cloudflare` - Optional. Seriously incredible. N.B. The free plan doesn't do SSL.

## Usage

Optional: Tracking changes in a separate branch called production.
```bash
$ git checkout -B production
$ git push heroku production:master
# Now, we can keep `master` and `production` separate.
```

Adding a custom domain name
```bash
$ heroku domains:add marcchung.org
# Requires DNS settings
```

Adding a theme
```bash
$ cp -r appply setup/wp-content/themes/
$ git add .
$ git commit -m "New theme"
$ git push heroku master
```

Adding a plugin
```bash
$ cp -r google-analytics setup/wp-content/plugins/
$ git add .
$ git commit -m "New plugin"
$ git push heroku master
```

By default I've disabled wp-cron, so you'll need to add a cron job to Heroku's scheduler.
```bash
$ heroku addons:add scheduler:standard
```

Visit the Heroku scheduler dashboard and add a new task:
```bash
./cron.sh
```

Enable and view /apc.php and /phpinfo.php stats page
```
$ heroku config:set ENABLE_SYSTEM_DEBUG=true # Now visit /apc.php or /phpinfo.php
```
Disabled by default.

Pull in latest changes from upstream
```bash
$ git fetch upstream
```

## The Wordpress on Heroku stack

The [Wordpress](http://github.com/mchung/wordpress-on-heroku) project template I've created is a highly tuned web stack built on the following components:

* `Nginx` - Nginx for serving content. Built specifically for Heroku.
* `MySQL` - ClearDB for the MySQL backend.
* `PHP` - PHP-FPM for intelligent process management. APC for op-code caching.
* `SMTP over Sendgrid` - Sendgrid for outgoing email.
* `Memcached` - MemCachier for the memcached backend.

## How highly tuned?

### blitz.io

Results from a blitz.io rush on a single Heroku dyno:

![Blitz.io rush](https://s3.amazonaws.com/heroku-buildpack-wordpress/woh-blitz-details.png)

[See the report](https://www.blitz.io/report/541eb908b4ef3eec8d9c2ce2293a85ca)

### Google PageSpeed

Results from PageSpeed Insights: 94/100

[See the report](https://developers.google.com/speed/pagespeed/insights#url=wordpress-on-heroku.herokuapp.com&mobile=false)

### Web Page Performance Test

Results from WebPageTest

[See the report](http://www.webpagetest.org/result/130201_BB_624/)

## Deck out your Wordpress

Each time the project is deployed, the buildpack adds several configuration files from the [`setup`](https://github.com/mchung/wordpress-on-heroku/tree/master/setup) directory.

These files contain general settings for tuning Wordpress, PHP, and Nginx.

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

## Hacking

Not comfortable downloading and running a copy of someone else's PHP or Nginx? Not a problem!

The `support` directory also contains a handful of compilation and deployment scripts to automate several processes, which are currently used for maintenance and repo management.

* `package_nginx` - Used to compile and upload the latest version of Nginx to S3.
* `package_php` - Used to compile and upload the latest version of PHP to S3.
* `wordup` - Really useful helper script for creating and destroying instances of [Wordpress on Heroku](https://github.com/mchung/wordpress-on-heroku).

## TODO

* Automate vendor upgrades. Make it easy to keep in sync with latest Nginx, PHP, and Wordpress
* End-users shouldn't be able to do things that aren't supported on Heroku.
* New Relic

### Authors and Contributors
Marc Chung (@mchung)
