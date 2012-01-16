Heroku buildpack: Wordpress
===========================

This is a buildpack for Wordpress on Heroku. Uses a version of [Wordpress for Heroku](http://github.com/mchung/wordpress-on-heroku).

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
