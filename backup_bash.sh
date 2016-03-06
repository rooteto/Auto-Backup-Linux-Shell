#!/bin/bash

# veritabanı bağlantısı
host_user="host_kullanici_adi"
user="veritabani_kullanici_adi"
password="şifre"
mysql="/usr/bin/mysql"

# diğer ayarlar
backup_path="/home/kullanici/backup"
date=$(date +"%d-%b-%Y")

# dosya izni
umask 177

# önce tarih klasörünü oluştur
mkdir /home/kullanici/backup/"$(date +"%d-%b-%Y")"

# mysql dumplar
 
	# dump 1
	databases=$($mysql --user=$user -p$password -e "SHOW DATABASES;" | grep -Ev "(Database|information_schema|performance_schema)")
	
	for db in $databases; do
		
		# sonra tarih klasörlü sqlleri yedekle
		mysqldump --force --opt --user=$user -p$password --databases "$db" > "$backup_path/$date/$db.sql"
		
	done

# grup izni
chown -R $host_user:$host_user "$backup_path"/"$date"*
chown -R $host_user:$host_user "$backup_path"/"$date"/*

# yazma izni
find $backup_path/* -type d -exec chmod 755 {} +
find $backup_path/* -type f -exec chmod 655 {} +

# dosyaları 30 gün sonra sil
find $backup_path/* -mtime +30 -exec rm -rf {} \;
