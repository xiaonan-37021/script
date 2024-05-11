#!/bin/bash

# 当前日期，格式为YYYYMMDD
CURRENT_DATE=$(date +%Y%m%d)

# 备份文件的路径和名称
BACKUP_FILE="/home/MysqlbackupPush/mysql-backup-${CURRENT_DATE}.sql"

# MySQL 用户名和密码
MYSQL_USER="root"
MYSQL_PASSWORD="YOUR_MYSQL_PASSWORD"

# 使用mysqldump进行备份
# --all-databases 表示备份所有数据库
# 如果你的MySQL服务器不在本地，可能还需要添加 -h 参数指定服务器地址
mysqldump -u${MYSQL_USER} -p${MYSQL_PASSWORD} --all-databases > ${BACKUP_FILE}
if [ $? -ne 0 ]; then
    echo "备份失败，停止脚本执行。"
    exit 1
fi


sftp_user="YOUR_USER"  # 确保这里设置了正确的用户名
sftp_host="YOUR_HOST"        # 确保这里设置了正确的主机地址
sftp_dir="YOUR_Backup_Address"
sftp_password="YOUR_Host_Password"


# 使用sftp协议推送备份文件到目标主机
/usr/expect/bin/expect <<EOF
spawn sftp $sftp_user@$sftp_host
expect "password:"
send "$sftp_password\r"
expect "sftp>"
send "cd $sftp_dir\r"
expect "sftp>"
send "put ${BACKUP_FILE}\r"
expect "sftp>"
send "exit\r"
EOF

rm -rf ${BACKUP_FILE}