# centos6.6-mysql-ssh-docker



挂在一个文件夹保证mysql dump 数据不会异常


docker run -d --name mysql.1.1 -p 3306:3306 -p 22:22  -v <path>:/var/lib/mysql jdeathe/centos-ssh-mysql:latest
