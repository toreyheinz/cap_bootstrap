0.3.1 / 2012-04-25
==================
* change flow so that rather than everything (install + setup) being run by deploy:install, there are tasks added to the users deploy.rb by the generator so that the user can control which recipes are run.
	* This is foundational for future changes to add other recipes (e.g. mysql) which would be alternatives that the user could control.
	* This also allows the user to more easily control partial re-runs if they encounter a problem, just want to reinstall a specific part, or only want to run setups for a second application on a box that has already been installed to.

0.2 / 2012-04-02
================
* task for tailing rails production logs, cap tail_logs
* maintenance page detection in nginx.conf, works with cap:web:disable
* put application name into unicorn upstream in anticipation of multiple apps on a server
* set up ufw firewall on install
* set timezone to UTC on install

0.1 / 2012-04-02
==================
* Gemifying the original files from Railscast 337