# lightspeed_backup
script to copy files from light speed system onto network share

Setup:
 * create AD user: lightspeedbackup
 * create share on \\targetmachine called backups * this should be stored on a drive that gets backed up my unitrends
 * create subdirectory called lightspeed
 * grant read access to \\targetmachine\backups
 * grant full access to \\targetmachine\backups\lightspeed
 * copy .envTemplate to .env and edit
 * add cron.job to root crontab
