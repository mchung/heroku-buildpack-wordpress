# Heroku buildpack: Wordpress

This is a Heroku buildpack for [Wordpress](http://wordpress.org).

It uses this [Wordpress](http://github.com/mchung/wordpress-on-heroku) project template to bootstrap a highly tuned Wordpress site built on the following stack:

* `nginx-1.3.11` - Nginx for serving web content.  Built specifically for Heroku.  [See compile options](https://github.com/mchung/heroku-buildpack-wordpress/blob/master/support/package_nginx).
* `php-5.4.11` - PHP-FPM for process management and APC for caching opcodes.  [See compile options](https://github.com/mchung/heroku-buildpack-wordpress/blob/master/support/package_php).
* `wordpress-3.5.1` - Downloaded directly [from wordpress.org](http://wordpress.org/download/release-archive/).
* `MySQL` - ClearDB for the MySQL backend.
* `Sendgrid` - Sendgrid for the email backend.
* `MemCachier` - MemCachier for the memcached backend.

## Getting started in 60 seconds

Fork this [Wordpress project template](http://github.com/mchung/wordpress-on-heroku).

Clone the repository
```bash
$ git clone git://github.com/username/wordpress-on-heroku.git myblog
```

Create the app on Heroku.
```bash
$ cd myblog
$ heroku create -s cedar
$ heroku config:add BUILDPACK_URL=https://github.com/mchung/heroku-buildpack-wordpress.git
```
> Don't have the Heroku Toolbelt installed? Follow these [quickstart instructions](https://devcenter.heroku.com/articles/quickstart). Takes about 2 minutes.

Deploy your Wordpress site to Heroku
```bash
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
```

Open your new Wordpress site in a web browser
```bash
$ heroku apps:open
```
> Don't forget to [add your site to the wiki](https://github.com/mchung/heroku-buildpack-wordpress/wiki/Sites-running-Wordpress-on-Heroku)

## Overview

The buildpack bootstraps a Wordpress site using the [mchung/wordpress-on-heroku](http://github.com/mchung/wordpress-on-heroku) project template.  That repo contains everything required to configure Wordpress on Heroku.

Enabling and configuring the following Wordpress plugins will also speed things up significantly.

* `heroku-sendgrid` - Instructs phpmailer to send SMTP email with Sendgrid.
  * EMAIL_REPLY_TO=alfred@example.com
  * EMAIL_FROM=batman@example.com
  * EMAIL_NAME=Bruce Wayne
* `heroku-google-analytics` - Adds Google Analytics to your site.
  * GOOG_UA_ID=UA-9999999
* `wpro` - Instructs Wordpress to upload everything to S3.
* `batcache` - Instructs Wordpress to use memcached for caching.
* `memcachier` - Depend on a modern memcached plugin.
* `cloudflare` - OPTIONAL, but awesome.  If Cloudflare is installed, the plugin instructs Wordpress to play nicely with CloudFlare.  It sets the correct IP addresses from visitors and comments, and also protects Wordpress from spammers.  Keep in mind that the free version doesn't support SSL.

> To set a config variable: `heroku config:set GOOG_UA_ID=UA=1234777-9`

There are also several config files for configuring Wordpress on Heroku.

* `wp-content` - Wordpress themes and plugins
* `wp-config.php` - Wordpress configuration
* `nginx.conf.erb` - Nginx configuration
* `php-fpm.conf` - PHP-FPM configuration
* `php.ini` - PHP configuration

Feel free to hack on these files.  For example, to remove the PHP-FPM status page at `/status.html`, delete the directive from `nginx.conf.erb`.  Themes and plugins can be added and deployed to the `setup/wp-content` directory.

## Usage

### Adding a custom domain name
```bash
$ heroku domains:add marcchung.org
$ heroku domains:add www.marcchung.org
```

Note: Adding a domain still requires some DNS setup work. Basically you'll want to do something like this:
```bash
ALIAS marcchung.org -> proxy.herokuapp.com
CNAME www.marcchung.org -> proxy.herokuapp.com
```
> [I use DNSimple and you should too](https://dnsimple.com/r/d2bc9a934910c1).

### Adding a theme
```bash
$ cp -r appply setup/wp-content/themes/
$ git add .
$ git commit -m "New theme"
$ git push heroku master
```

### Adding a plugin
```bash
$ cp -r google-analytics setup/wp-content/plugins/
$ git add .
$ git commit -m "New plugin"
$ git push heroku master
```
> Don't forget to activate it under the Plugins panel.

### Configuring cron
By default, wp-cron is fired on every page load and scheduled to run jobs like future posts or backups.  This buildpack disables wp-cron so that visitors don't have to wait to see the site.

Heroku allows you to trigger wp-cron from their scheduler
```bash
$ heroku addons:add scheduler:standard

# Visit the Heroku scheduler dashboard and add a new task:
./cron.sh
```

Alternatively, you may also re-enable wp-cron
```bash
$ heroku config:set DISABLE_WP_CRON=false
```

### Enable system access
The alternative PHP cache and a generic PHPINFO page is available at /apc.php and /phpinfo.php.
```bash
$ heroku config:set ENABLE_SYSTEM_DEBUG=true
$ heroku config:set SYSTEM_USERNAME=admin
$ heroku config:set SYSTEM_PASSWORD=secret123
# Visit /apc.php or /phpinfo.php
```

### Workflow (optional)

By keeping your changes separate, it'll be easier to pull in changes from the Wordpress site template.

Assign a remote `upstream`
```bash
$ git remote add upstream https://github.com/mchung/wordpress-on-heroku.git
```

Track changes in a separate branch called `production`.
```bash
$ git checkout -B production
$ git push heroku production:master
# This keeps upstream changes separate from blog changes.
```

Pull changes from upstream into `master`
```bash
$ git co master
$ git pull
$ git co production
$ git merge master
```

Pull changes from upstream into `production`
```bash
$ git pull --rebase upstream master
```

## How fast is this?

Fast enough. Here are some benchmarks.

### Google PageSpeed

Results from PageSpeed Insights: 94/100

[See the PageSpeed report](https://developers.google.com/speed/pagespeed/insights#url=wordpress-on-heroku.herokuapp.com&mobile=false)

### blitz.io

Results from a blitz.io rush on a single Heroku dyno:

![Blitz.io rush](https://s3.amazonaws.com/heroku-buildpack-wordpress/woh-blitz-details.png)

[See the Blitz.io report](https://www.blitz.io/report/541eb908b4ef3eec8d9c2ce2293a85ca)

### Web Page Performance Test

![Results from WebPageTest](https://s3.amazonaws.com/heroku-buildpack-wordpress/woh-webpagetest-details.png)

[See the WebPageTest report](http://www.webpagetest.org/result/130201_BB_624/)

## But doesn't Heroku only run Ruby applications?

Not anymore. Heroku's latest offerings (See [Celadon Cedar stack](http://devcenter.heroku.com/articles/cedar)) makes it easy (well, easyish) for developers to install and run any language, or service.

## Constraints with Heroku

The [ephemeral filesystem](http://devcenter.heroku.com/articles/dyno-isolation)

* End-users cannot upload media assets to Heroku. WORKAROUND: Enable `wpro` and use that plugin to upload media assets to S3 instead.
* End-users cannot update themes or plugins from the admin page. WORKAROUND: Add them to `setup/wp-content/themes` or `setup/wp-content/plugins` then push to Heroku.

## Security disclosure

Each time Wordpress is deployed, Heroku will fetch the latest buildpack from GitHub and execute the instructions in `compile` and `deploy`.  This buildpack will download the latest precompiled versions of Nginx, PHP, and Wordpress from my personal [S3 bucket](http://heroku-buildpack-wordpress.s3.amazonaws.com) then add in config files from the [`setup`](https://github.com/mchung/wordpress-on-heroku/tree/master/setup) directory.

## Hacking and Contributing

Not comfortable downloading and running a copy of someone else's PHP or Nginx executables? Not a problem!  The `support` directory also contains a handful of compilation and deployment scripts to automate several processes, which are currently used for maintenance and repo management.

* `package_nginx` - Used to compile and upload the latest version of Nginx to S3.
* `package_php` - Used to compile and upload the latest version of PHP to S3.
* `wordup` - Really useful helper script for creating and destroying Wordpress sites.

## TODO

* Automate vendor upgrades. Make it easy to keep in sync with latest Nginx, PHP, and Wordpress.
* End-users shouldn't be able to do things that aren't supported on Heroku.
* Integrate New Relic.

## Authors and Contributors

* Marc Chung - [@mchung](https://github.com/mchung) on GitHub and [@heisenthought](https://twitter.com/heisenthought) on Twitter

## Thanks

Thanks for reading this all the way through. If you find this useful, please add an entry to the [list of Wordpress sites running on Heroku](https://github.com/mchung/heroku-buildpack-wordpress/wiki/Sites-running-Wordpress-on-Heroku).

## License

The MIT License - Copyright (c) 2013 Marc Chung

<link href='http://haikuist.com/assets/embed.css' media='screen' rel='stylesheet' type='text/css'>
<div class='haikuist_snippet' id='haiku-1922'>
<div class='poem'>
<div class='line1'>
take my code with you
</div>
<div class='line2'>
and do whatever you want
</div>
<div class='line3'>
but please don't blame me
</div>
<div class='author'>
&mdash;
Aaron Swartz
</div>
</div>
<div class='meta'>
<a href="http://haikuist.com/haiku/1922">This Haiku</a>
brought to you by
<a href="http://haikuist.com/">Haikuist</a>
</div>
</div>
