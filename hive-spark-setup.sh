## SETUP LOCAL FILESYSTEM

#Setup working directory
mkdir -p /home/training/BDA_Project
cd ~/BDA_Project

# Importing JSON dataset 
hdfs dfs -put -f chelsea-twitter.json /user/data/tweets

# Downloading JSON SerDe
wget -o hive-json-serde.jar "http://files.cloudera.com/samples/hive-serdes-1.0-SNAPSHOT.jar"

# Placing JSON SerDe into Hive library folder
sudo cp /home/training/BDA_Project/hive-json-serde.jar /usr/lib/hive/lib/hive-json-serde.jar

## SETUP HDFS SERVER
# Execute Hive, registering SerDe and creating the table structure

hive
add jar /usr/lib/hive/lib/hive_serdes.jar

DROP DATABASE IF EXISTS bda CASCADE;
CREATE DATABASE bda;
USE bda;
CREATE EXTERNAL TABLE tweets (
tweet_id BIGINT,
created_at STRING,
is_retweet BOOLEAN,
screen_name STRING,
retweet_count INT, 
user_name STRING,
text STRING )
ROW FORMAT SERDE 'com.cloudera.hive.serde.JSONSerDe'
LOCATION '/user/data/tweets';

#Create Hive table to receive results from Spark
USE default;
CREATE TABLE summary (
    	date date,
	id int,
	keyword string, 
	polarity double,
	subjectivity double
);


# Create MySQL table to be imported by Sqoop
sudo mysql
create database if not exists bda;
use bda;
create table summary (
	id INT NOT NULL AUTO_INCREMENT,
	keyword NVARCHAR(255), 
	polarity INT,
	subjectivity INT,
	date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT PK_SUMMARY PRIMARY KEY (id)
);
insert into summary (keyword,polarity,subjectivity,) values 
	('novaims','@novaims'),
	('novasbe','@novasbe')
;

# Export data into HDFS using Sqoop
sqoop export \
	--connect jdbc:mysql://localhost/nova \
	--username training
	--password training
	--export-dir /user/data/tweets
	--update-mode allowinsert \
	--table hdfs_out


# Install required libraries for Python
sudo pip install plotly
sudo pip install numpy
sudo pip install nltk

# Fixing Numpy version error in Python
sudo cp /home/training/BDA_Project/__init__.py /usr/lib/spark/python/pyspark/mllib/__init__.py

# Setup Hive dependencies for Spark SQL and run Pyspark
sudo cp /etc/hive/conf/hive-site.xml /etc/spark/conf
pyspark	


