ping: 
	@echo "pong"


# name : database name 
create-database:
	touch ./process/$(name).creating-database
	- ./scripts/create-database.sh $(name)
	rm -rf ./process/$(name).creating-database

# domain: site domain
# database: database name
# email: email to active ssl certificate
create-site:
	touch ./process/$(domain).creating-site
	- ./scripts/create-site.sh $(domain) $(database) $(email)
	rm -rf ./process/$(domain).creating-site

# domain: site domain
delete-site:
	touch ./process/$(domain).deleting-site
	- ./scripts/delete.sh $(domain)
	rm -rf ./process/$(domain).deleting-site

cron:
	- @[ -f ./process/cron.running ] && echo "cron is already running" || ./scripts/cron.sh
	@rm -rf ./process/cron.running

# domain: site domain
backup-site:
	- @[ -f ./process/$(domain).running ] && echo "$(domain) backup is already running" || ./scripts/backup.sh $(domain)
	@rm -rf ./process/$(domain).running

# bucket: bucket name
backup:
	- @[ -f ./process/backup.running ] && echo "backup is already running" || ./scripts/backup-aws.sh $(bucket)
	@rm -rf ./process/backup.running

list-apps:
	./scripts/list.sh

get-process:
	@ls ./process

clear-process:
	@rm -rf ./process/*.*
