### Heroku buildpack: Wordpress

A [Heroku buildpack](http://devcenter.heroku.com/articles/buildpack) for [Wordpress](http://wordpress.org).

Currently running:
* `nginx-1.3.11` ([see compile options](https://github.com/mchung/heroku-buildpack-wordpress/blob/master/support/package_nginx)).
* `php-5.4.11` ([see compile options](https://github.com/mchung/heroku-buildpack-wordpress/blob/master/support/package_php)).
* `wordpress-3.5.1` ([from wordpress.org](http://wordpress.org/download/release-archive/))

### Overview

Fork [Wordpress on Heroku](http://github.com/mchung/wordpress-on-heroku), add in your own themes and plugins, deploy to Heroku. Don't forget to enable the plugins for Heroku `heroku-sendgrid` and `wpro`.

### Usage

Getting Started

    $ git clone git://github.com/mchung/wordpress-on-heroku.git my-new-wp-blog
    $ cd my-new-wp-blog
    $ heroku create --stack cedar --buildpack http://github.com/mchung/heroku-buildpack-wordpress.git my-new-wp-blog
    $ git push heroku master
    ...
    -----> Heroku receiving push
    -----> Fetching custom buildpack
    -----> Wordpress app detected

    $ heroku domains:add my-new-wp-blog.info
    $ heroku open
    # Will open the fresh instance in your browser

Using a custom domain name

    $ heroku domains:add my-new-wp-blog.info


This buildpack is designed to work together with this specific [Wordpress](http://github.com/mchung/wordpress-on-heroku) repo, which configures all the Heroku-specific details to get Wordpress running on Nginx, PHP-FPM, and MySQL.

### Constraints

For a list of constraints and known issues, please check out the [Wordpress on Heroku](http://github.com/mchung/wordpress-on-heroku) repo.

### Caveat

Each time Wordpress is deployed, Heroku will fetch the latest buildpack from GitHub and execute the instructions in *compile* and *deploy*.  In this case, the latest precompiled version of Nginx, PHP, and Wordpress are downloaded from my [S3 bucket](http://heroku-buildpack-wordpress.s3.amazonaws.com).  Details are listed below.

### Configuration

During deployment, the buildpack will copy over several configuration files in `setup`.

* `wp-content` - Wordpress themes and plugins
* `wp-config.php` - Wordpress configuration
* `nginx.conf.erb` - Nginx configuration
* `php-fpm.conf` - PHP-FPM configuration
* `php.ini` - PHP configuration

You can hack on `nginx.conf.erb`, `php-fpm.conf`, and `php.ini` but only *if* you know what you're doing.  For example, by default, you can view the PHP-FPM status page at `/status.html`.  To remove the status page, remove the directive from `nginx.conf.erb`.

### Support

The `support` directory also contains a handful of compilation and deployment scripts to automate several processes, which are currently used for maintenance and management.

* `package_nginx` - Used to compile and upload the latest version of Nginx to S3.
* `package_php` - Used to compile and upload the latest version of PHP to S3.
* `wordup` - Helper script. Used to create and destroy instances of Wordpress on Heroku.

### TODO

* Automate vendor upgrades. Make it easy to keep in sync with latest Nginx, PHP, and Wordpress

### Authors and Contributors
Marc Chung (@mchung)
