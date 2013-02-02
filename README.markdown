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

$ heroku create -s cedar
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
# open the app in a web browser
```

## Overview

The buildpack bootstraps a Wordpress site using [mchung/wordpress-on-heroku](http://github.com/mchung/wordpress-on-heroku).  That repo is Wordpress project template containing everything to configure Wordpress on Heroku.

You can also enable the following plugins to further enhance the performance.

* `heroku-sendgrid` - Sends email with Sendgrid
* `wpro` - Uploads everything to S3
* `batcache` - Instructs Wordpress to use memcached to cache everything
* `memcachier` - A better memcached plugin
* `cloudflare` - Optional. But, seriously incredible. It's optionally suggested, because the free plan doesn't do SSL, and I consider SSL a requirement for security reasons.

You can also add and deploy your favorite themes and plugins.

## Usage

```bash
Optional: Tracking changes in a separate branch called production.

$ git checkout -B production
$ git push heroku production:master
# Now, we can keep `master` and `production` separate.
```

```bash
Adding a custom domain name

$ heroku domains:add marcchung.org
# Requires DNS settings
```

```bash
Adding a theme

$ cp -r appply setup/wp-content/themes/
$ git add .
$ git commit -m "New theme"
$ git push heroku master
```

```bash
Adding a plugin

$ cp -r google-analytics setup/wp-content/plugins/
$ git add .
$ git commit -m "New plugin"
$ git push heroku master
```

```bash
By default I've disabled wp-cron, so you'll need to add a cron job to Heroku's scheduler.

$ heroku addons:add scheduler:standard

# Visit the Heroku scheduler dashboard and add a new task:
./cron.sh
```

```
Enable and view /apc.php and /phpinfo.php stats page

$ heroku config:set ENABLE_SYSTEM_DEBUG=true

# Visit /apc.php or /phpinfo.php
# This setting is disabled by default.
```

```bash
Pull in latest changes from upstream

$ git fetch upstream
```

## The Wordpress on Heroku stack

The [Wordpress](http://github.com/mchung/wordpress-on-heroku) project template is a highly tuned web stack built with the following components:

* `Nginx` - Nginx for serving content. Built specifically for Heroku.
* `MySQL` - ClearDB for the MySQL backend.
* `PHP` - PHP-FPM for intelligent process management. APC for op-code caching.
* `SMTP over Sendgrid` - Sendgrid for outgoing email.
* `Memcached` - MemCachier for the memcached backend.

## How highly tuned?

### blitz.io

Results from a blitz.io rush on a single Heroku dyno:

![Blitz.io rush](https://s3.amazonaws.com/heroku-buildpack-wordpress/woh-blitz-details.png)

[See the Blitz.io report](https://www.blitz.io/report/541eb908b4ef3eec8d9c2ce2293a85ca)

### Google PageSpeed

Results from PageSpeed Insights: 94/100

[See the PageSpeed report](https://developers.google.com/speed/pagespeed/insights#url=wordpress-on-heroku.herokuapp.com&mobile=false)

### Web Page Performance Test

Results from WebPageTest

[See the WebPageTest report](http://www.webpagetest.org/result/130201_BB_624/)

## Deck out your Wordpress

The Wordpress project template contains the config files for tuning Wordpress on Heroku.  Here's a breakdown of the config files in the project template.

* `wp-content` - Wordpress themes and plugins
* `wp-config.php` - Wordpress configuration
* `nginx.conf.erb` - Nginx configuration
* `php-fpm.conf` - PHP-FPM configuration
* `php.ini` - PHP configuration

Feel free to hack on these files.  For example, if you want to remove the PHP-FPM status page at `/status.html`, delete the directive from `nginx.conf.erb`.

## Security disclosure

Each time Wordpress is deployed, Heroku will fetch the latest buildpack from GitHub and execute the instructions in *compile* and *deploy*.  This buildpack will download the latest precompiled versions of Nginx, PHP, and Wordpress from my personal [S3 bucket](http://heroku-buildpack-wordpress.s3.amazonaws.com) then add in config files from the [`setup`](https://github.com/mchung/wordpress-on-heroku/tree/master/setup) directory.

## I thought Heroku was only for Ruby applications?

Not anymore. Heroku's latest offerings (See [Celadon Cedar stack](http://devcenter.heroku.com/articles/cedar)) makes it easy (well, easyish) for developers to install and run any language, or service.

## Constraints with Heroku

The [ephemeral filesystem](http://devcenter.heroku.com/articles/dyno-isolation)

* End-users cannot upload media assets to Heroku. WORKAROUND: Enable `wpro` and use that plugin to upload media assets to S3 instead.
* End-users cannot update themes or plugins from the admin page. WORKAROUND: Add them to `setup/wp-content/themes` or `setup/wp-content/plugins` then push to Heroku.

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

## Authors and Contributors
Marc Chung (@mchung)

## License

The MIT License - Copyright (c) 2013 Marc Chung