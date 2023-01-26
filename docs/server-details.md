# AlmaLinux OpenQA UI Server/Worker

Use direct installation of AlmaLinux OpenQA UI Server/Worker environment when Bare Metal(s) or VM(s) are available with native KVM emulation support.

Some ready-made scripts are available for the speedup installation process. Clone the repo, review, adjust the install scripts as needed and run the scripts.

?> Refer to the documentation for detailed steps of installation.

## Scripts Details

Following list of scripts are available in server folder for customize and use.

* `install_openqa_server` - OpenQA Server UI and database install script.
* `install_openqa_worker` - OpenQA Worker install script, multiple worker nodes can be run from a single install.
* `install_openqa_single` - All-in-one install, both server, and worker in a single host. Ideal for a standalone DEV/QA host.
* `post_install` - A helper script to import and populate the AlmaLinux OpenQA project for custom test development.
* `gen_api_keys.py` - Helper/support script to generate API keys for a custom automated install. Review and customize as needed.
