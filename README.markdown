# Heroku buildpack: Wordpress

This is a Heroku buildpack for [Wordpress](http://wordpress.org).

The [Wordpress](http://github.com/mchung/wordpress-on-heroku) project template is a highly tuned web stack built on the following components:

* `nginx-1.3.11` - Nginx for serving content. Built specifically for Heroku. ([See compile options](https://github.com/mchung/heroku-buildpack-wordpress/blob/master/support/package_nginx))
* `php-5.4.11` - PHP-FPM for intelligent process management. APC for op-code caching. ([See compile options](https://github.com/mchung/heroku-buildpack-wordpress/blob/master/support/package_php))
* `wordpress-3.5.1` - Downloaded directly [from wordpress.org](http://wordpress.org/download/release-archive/)
* `MySQL` - ClearDB for the MySQL backend.
* `SMTP over Sendgrid` - Sendgrid for the email backend
* `Memcached` - MemCachier for the memcached backend.

## Getting Started

Fork my [Wordpress project](http://github.com/mchung/wordpress-on-heroku).
```bash
$ git clone git://github.com/username/wordpress-on-heroku.git myblog
$ cd myblog

$ git remote add upstream https://github.com/mchung/wordpress-on-heroku.git
# optionally assign an upstream

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

The buildpack bootstraps a Wordpress site using the [mchung/wordpress-on-heroku](http://github.com/mchung/wordpress-on-heroku) project template.  That repo contains everything required to configure Wordpress on Heroku.

Enabling the following Wordpress plugins will also speed things up.

* `heroku-sendgrid` - Instructs phpmailer to send email with Sendgrid
* `wpro` - Instructs Wordpress to upload everything to S3
* `batcache` - Instructs Wordpress to use memcached to cache everything
* `memcachier` - Uses a better memcached plugin
* `cloudflare` - OPTIONAL.  If Cloudflare is installed, the plugin instructs Wordpress to play nicely with CloudFlare.  It sets the correct IP addresses from visitors and comments, and also protects Wordpress from spammers.  Keep in mind that the free version doesn't support SSL.

There are also several config files for configuring the performance of Wordpress on Heroku.

* `wp-content` - Wordpress themes and plugins
* `wp-config.php` - Wordpress configuration
* `nginx.conf.erb` - Nginx configuration
* `php-fpm.conf` - PHP-FPM configuration
* `php.ini` - PHP configuration

Feel free to hack on these files.  For example, to remove the PHP-FPM status page at `/status.html`, delete the directive from `nginx.conf.erb`.  Themes and plugins can be added and deployed to the `setup/wp-content` directory.

## Usage

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

By default wp-cron is disabled. Here's how to setup a cron job.
```bash
$ heroku addons:add scheduler:standard

# Visit the Heroku scheduler dashboard and add a new task:
./cron.sh
```

Enable access to the /apc.php and /phpinfo.php stats page
```
$ heroku config:set ENABLE_SYSTEM_DEBUG=true
$ heroku config:set SYSTEM_USERNAME=admin
$ heroku config:set SYSTEM_PASSWORD=secret123

# Visit /apc.php or /phpinfo.php
```

Optional: Track changes in a separate branch called production.
```bash
$ git checkout -B production
$ git push heroku production:master
# This keeps upstream changes separate from blog changes.
```

Pull in latest changes from upstream
```bash
$ git fetch upstream
```

## How fast is this?

Here are some benchmarks.

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

## Security disclosure

Each time Wordpress is deployed, Heroku will fetch the latest buildpack from GitHub and execute the instructions in *compile* and *deploy*.  This buildpack will download the latest precompiled versions of Nginx, PHP, and Wordpress from my personal [S3 bucket](http://heroku-buildpack-wordpress.s3.amazonaws.com) then add in config files from the [`setup`](https://github.com/mchung/wordpress-on-heroku/tree/master/setup) directory.

## But doesn't Heroku only run Ruby applications?

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
* `wordup` - Really useful helper script for creating and destroying Wordpress sites.

## TODO

* Automate vendor upgrades. Make it easy to keep in sync with latest Nginx, PHP, and Wordpress.
* End-users shouldn't be able to do things that aren't supported on Heroku.
* Integrate New Relic.

## Authors and Contributors
Marc Chung (@mchung)

## License

The MIT License - Copyright (c) 2013 Marc Chung