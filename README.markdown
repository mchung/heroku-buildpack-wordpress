Heroku buildpack: Wordpress
===========================

This is a [Heroku buildpack](http://devcenter.heroku.com/articles/buildpack) for [Wordpress](http://wordpress.org).

In order to satisfy Heroku's constraints, I suggest using my slightly customized version of [Wordpress on Heroku](http://github.com/mchung/wordpress-on-heroku). 

Usage
-----

Example usage:

	$ git clone git://github.com/mchung/wordpress-on-heroku.git wordpress
	$ cd wordpress

    $ ls wp-config.php
    wp-config.php

    $ heroku create --stack cedar --buildpack http://github.com/mchung/heroku-buildpack-wordpress.git wordpress_instance

    $ git push heroku master
    ...
    -----> Heroku receiving push
    -----> Fetching custom buildpack
    -----> Wordpress app detected

The buildpack will detect your app as `Wordpress` if it has a `wp-config.php` in the root directory. If you look at Wordpress on Heroku, you'll also see a `config` directory that has an `nginx.conf.erb` and `php.ini` configuration files. These files are copied over at deploy time. You may modify them to fit your own needs.

The `support` directory also contains a handful of compilation and deployment scripts to automate several processes.

* **package_nginx** - Used to compile and upload the latest version of Nginx to S3
* **package_php** - Used to compile and upload the latest version of PHP to S3
* ***wordup* - Helper script. Used to create and destroy instances of Wordpress on Heroku.