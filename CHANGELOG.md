master
  * heroku-sendgrid now pulls name/email from wpdb instead of heroku config
    EMAIL_REPLY_TO, EMAIL_FROM, and EMAIL_NAME are deprecated
  * End-users can now choose versions for vendored apps. Refer to VERSIONS.md.

v0.7

2013-02-08  Marc Chung  <mchung@gmail.com>

  * Changed the Wordpress on Heroku project template.  Older blogs deploying
    against this buildpack will no longer work.  Refer to UPGRADING.md.
  * Added /app/bin to PATH

v0.6

2013-02-07  Marc Chung  <mchung@gmail.com>

  * Establish v0.6 from master