ovh-export-dns-zone for [OVH.com REST API](https://api.ovh.com/console/)
===================

This is a basic script (My first Ruby script ;)

His goal is to backup all the DNS Records, because OVH has no built-in functionnality for saving DNS Zones.

The script calls the OVH REST API for each domain you manage and put the DNS Zone into a .txt

Feel free to contribute, if I have time, I will add a file versioning process if DNS Zone is different.

Happy DNS !

## Usage

You need an `API_KEY` and an `API_SECRET` to use it, which can be obtained [there](https://www.ovh.com/fr/cgi-bin/api/createApplication.cgi).

You have to copy `config.example.yaml` to `config.yaml` and put the `API_KEY` and `API_SECRET`

You are now ready to execute the script '$ ruby app.rb', before that don't forget to install the gems ($ bundle)

If it's your 1st time you have to authorize this application, the script will open the authentification page automatically, when finished enter any key to continue.

Now you must have a new folder `backups` which contains all your exports !
