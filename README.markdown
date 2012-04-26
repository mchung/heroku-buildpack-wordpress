### Heroku buildpack: Wordpress

A [Heroku buildpack](http://devcenter.heroku.com/articles/buildpack) for [Wordpress](http://wordpress.org).  Current Nginx: 1.2.0 ([see compile options](https://github.com/mchung/heroku-buildpack-wordpress/blob/master/support/package_nginx)).  Current PHP: 5.4.1 ([see compile options](https://github.com/mchung/heroku-buildpack-wordpress/blob/master/support/package_php)).
### Usage

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

    $ heroku open 
    # Will open the fresh instance in your browser


The buildpack will detect a `Wordpress` app if a `wp-config.php` is located in the root directory.  

### Constraints 

The constraints that Heroku places on deployed Wordpress instances are documented on this customized version of [Wordpress on Heroku](http://github.com/mchung/wordpress-on-heroku).  This buildpack must be used in conjunction with Wordpress on Heroku.

### Caveat
Each time an app is redeployed, Heroku will fetch the latest buildpack from the buildpack's Git repository and execute the instructions in *compile* and *deploy* (but not *release*).  In this case, it means downloading the latest precompiled version of Nginx and PHP from an S3 bucket.

### Configuration

When the Wordpress instance starts up, it copies over several configuration files found in the `config` directory of [Wordpress on Heroku](http://github.com/mchung/wordpress-on-heroku). Since these files are stored in the Wordpress repo, they may be modified.  For example, to remove the PHP-FPM status page (available by default at /status.html), remove the directive from `nginx.conf.erb`.

### Support
The `support` directory also contains a handful of compilation and deployment scripts to automate several processes, which are currently used for maintenance and management.

* **package_nginx** - Used to compile and upload the latest version of Nginx to S3.
* **package_php** - Used to compile and upload the latest version of PHP to S3.
* **wordup** - Helper script. Used to create and destroy instances of Wordpress on Heroku.

### Authors and Contributors
Marc Chung (@mchung)
