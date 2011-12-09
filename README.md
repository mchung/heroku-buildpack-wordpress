Heroku buildpack: Wordpress
===========================

This is a buildpack for Wordpress on Heroku.

Usage
-----

Example usage:

    $ ls wp-config.php
    wp-config.php

    $ heroku create --stack cedar --buildpack http://github.com/mchung/heroku-buildpack-wordpress.git

    $ git push heroku master
    ...
    -----> Heroku receiving push
    -----> Fetching custom buildpack
    -----> Wordpress app detected
