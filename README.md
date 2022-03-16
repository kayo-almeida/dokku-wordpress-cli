# Dokku Wordpress Cli

## Quick-starting

```
git clone git@github.com:kayo-almeida/dokku-wordpress-cli.git
cd dokku-wordpress-cli && bash install.sh
```

## Creating a database

```bash
dwc create-database name=test
```

## Creating a site

```bash
dwc create-site domain=test.kayo.ninja database=test email=kayo.almeida.dev@gmail.com
```

## Running a backup

```bash
dwc backup bucket=backup-bucket-name
```

## List in progress tasks

```bash
dwc get-process
```

## Clear in progress tasks

```bash
dwc clear-process
```

## Running cron job to check mysql and apache

```bash
dwc cron
```
