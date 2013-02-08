

### Upgrading from v0.6 to master

v0.7 introduces a new project template layout. Refer to the README for details.

Since buildpacks are coupled to project templates, older versions of the
Wordpress on Heroku project template will no longer work with the latest
version of the buildpack

There are two ways to fix this.

The short term fix is to update the BUILDPACK_URL to point to an older version:
```bash
$ ls setup/   # the older project template looks like this:
apc.conf.php
nginx.conf.erb
php-fpm.conf
php.ini
phpinfo.php
wp-config.php
wp-content

$ heroku config:set BUILDPACK_URL=https://github.com/mchung/heroku-buildpack-wordpress#v0.6
```

The long term fix is to update your project template to match the latest layout
```
# Put your site into maintenance mode
$ heroku maintenance:on

# Assumes production and upstream branches
$ git co master
$ git fetch origin -v; git fetch upstream -v; git merge upstream/master

# Do the merge work
# resolve conflicts.
# move stuff into appropriate directories.
# move themes & plugins into config.
# move any changed files into config.
# make sure nothing else is in the root directory.
# update heroku configs if necessary

# Upgrade environment variables
$ heroku config:set DISABLE_WP_CRON=true
$ heroku config:set ENABLE_SYSTEM_ACCESS=false
$ heroku config:set FORCE_SSL_ADMIN=true
$ heroku config:set FORCE_SSL_LOGIN=true
$ heroku config:set PATH=/app/bin:/app/vendor/nginx/sbin:/app/vendor/php/bin:/app/vendor/php/sbin:/usr/local/bin:/usr/bin:/bin
$ heroku config:set WP_CACHE=true

# GOod to go? Merge it all in.
$ git push -f heroku production:master

# Take your site out of maintenance mode
$ heroku maintenance:off
```
