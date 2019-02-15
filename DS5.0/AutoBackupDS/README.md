README.md
---------
This repo is for autobackup solution for opendj servers. 
It backups daily export-ldif and weekly full backup.
All backup files are pushed to s3 bucket and it keeps certain amount of copy specified on the property file.


How to setup:
-------------
1. Create binddn password file. 
Ex: echo <Password> > .pw.txt

2. Change permition to read only
Ex: chmod 400 .pw.txt 

3. Modify properties file according to the environment. 
The property file has 3 sections: 
The first section needs to be changed per environment.
The second section needs to be changed for each aws instances and
the last section do not need to be changed. Unless, it is required. 
Daily and weekly backup services is the index number of the opendj types array.

3. Run s3-structure.sh script ONLY ONCE per environment. 
Basically it creates all necesery folder structure on S3

4. Daily Cron task need to be configured for export-ldif.sh script.
This script connect each OpenDJ server and backup specified backend in ldif form. 
Push all files to aws S3 bucket and remove the local copy from instance. 
It is recomended to run every six hours. 

Evert 6 hours
crontab -e
Ex: */6 * * * * /opt/opendj-scripts/autobackups/export_ldif.sh >> /opt/opendj-scripts/autobackups/export_ldif.log 2>&1


5. Weekly Cron task need to be configured for backup.sh script. 
This script connect OpenDJ server and get full backup including schemas and tasks.
Creates zip file and push it to aws S3 bucket and remove the local copy from instance 
It is recomended to run weekly. 

Every sunday 3AM 
crontab -e
Ex: 0 3 * * 6 /opt/opendj-scripts/autobackups/backup.sh >> /opt/opendj-scripts/autobackups/backup.log 2>&1

 

