# AlmaLinux OpenQA UI Server/Worker

This folder contains support script for direct installation of AlmaLinux OpenQA UI Server/Worker environment.

Please refer to documentaion folder for detailed steps of installation.

## Scripts Details

* `install_openqa_server` - OpenQA Server UI and database install script.
* `install_openqa_worker` - OpenQA Worker install script, multiple worker nodes can be run from single install.
* `install_openqa_single` - All-in-one install, both server and worker in a single host.  Ideal for standalone DEV/QA host.
* `post_install` - Helper script to import and populate AlmaLinux OpenQA project for custom test development.
* `gen_api_keys.py` - Helper/support script to generate api keys for custom automated install. Review and customize as needed.
