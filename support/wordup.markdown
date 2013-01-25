# Wordup automatically sets up Wordpress on Heroku.

Install Wordpress in < 60 seconds.

## Who are you?

1. Someone who uses Wordpress. Perhaps a developer, which is why you're reading this on GitHub.com
2. Someone who is comfortable with the command line. Perhaps a developer, which is why you're still reading this.
3. Someone who likes to help their friends get up and running with Wordpress, but hates the setup, security, and ongoing maintenance (cleaning up logs, upgrading instances, locking down Wordpress, performance, etc.)

## Here's what you get

```
$ time wordup -c new-wordpress-site
-----> Installing Wordpress on Heroku
       Cloning into 'new-wordpress-site'...
remote: Counting objects: 166, done.
remote: Compressing objects: 100% (121/121), done.
remote: Total 166 (delta 37), reused 166 (delta 37)
Receiving objects: 100% (166/166), 1.04 MiB | 25 KiB/s, done.
Resolving deltas: 100% (37/37), done.
-----> Acquiring Heroku dynos
       Creating new-wordpress-site... done, stack is cedar
       BUILDPACK_URL=https://github.com/mchung/heroku-buildpack-wordpress.git
       http://new-wordpress-site.herokuapp.com/ | git@heroku.com:new-wordpress-site.git
       Git remote heroku added
-----> Create custom production branch
Switched to a new branch 'production'
-----> Engage!
Counting objects: 166, done.
Delta compression using up to 4 threads.
Compressing objects: 100% (121/121), done.
Writing objects: 100% (166/166), 1.04 MiB | 178 KiB/s, done.
Total 166 (delta 37), reused 166 (delta 37)
-----> Fetching custom git buildpack... done
-----> Wordpress app detected
-----> Installing Nginx v1.3.11
-----> Installing PHP v5.4.11
-----> Installing Wordpress v3.5.1
-----> Writing start.sh script
-----> Done with compile
-----> Discovering process types
       Procfile declares types     -> (none)
       Default types for Wordpress -> web
-----> Compiled slug size: 34.4MB
-----> Launching... done, v7
       http://new-wordpress-site.herokuapp.com deployed to Heroku

To git@heroku.com:new-wordpress-site.git
 * [new branch]      production -> master
Opening new-wordpress-site... done

real  2m2.875s
user  0m4.497s
sys 0m0.389s
```

## Usage

    Usage: wordup [-c|--create] [-d|--destroy] your_wordpress_site

## Example

### Create a Wordpress instance

    wordup -c new_shiny_wordpress

### Destroy a Wordpress instance

    wordup -d new_shiny_wordpress

## How to install themes or plugins

You can't upload files to Heroku because of their ephemeral filesystem. If you want to add themes or plugins, you'll need to use the following instructions:

Copy your themes or plugins into `setup/wp-content/plugins` or `setup/wp-content/themes`.

    git add wp-content
    git commit -m "New widgets"
    git push heroku master

## Requirements, Gotchas, and Other notes

* Installs Wordpress 3.5.1
* Requires git.
* Requires a Heroku account.
