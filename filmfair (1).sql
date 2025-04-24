CREATE TABLE `accounts_bookings` (
  `id` int NOT NULL AUTO_INCREMENT,
  `useat` varchar(100) NOT NULL,
  `shows_id` int NOT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `accounts_bookings_shows_id_ce920ea8_fk_accounts_shows_shows` (`shows_id`),
  KEY `accounts_bookings_user_id_dd095ae2_fk_auth_user_id` (`user_id`),
  CONSTRAINT `accounts_bookings_shows_id_ce920ea8_fk_accounts_shows_shows` FOREIGN KEY (`shows_id`) REFERENCES `accounts_shows` (`shows`),
  CONSTRAINT `accounts_bookings_user_id_dd095ae2_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

LOCK TABLES `accounts_bookings` WRITE;

INSERT INTO `accounts_bookings` VALUES
  (1,'#A3,#B3',1,1),
  (2,'#B5,#C4,#C5',1,1);

UNLOCK TABLES;

DROP TABLE IF EXISTS `accounts_cinema`;

CREATE TABLE `accounts_cinema` (
  `cinema` int NOT NULL AUTO_INCREMENT,
  `role` varchar(30) NOT NULL,
  `cinema_name` varchar(50) NOT NULL,
  `phoneno` varchar(15) NOT NULL,
  `city` varchar(100) NOT NULL,
  `address` varchar(100) NOT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`cinema`),
  UNIQUE KEY `user_id` (`user_id`),
  CONSTRAINT `accounts_cinema_user_id_66116bb2_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

LOCK TABLES `accounts_cinema` WRITE;

INSERT INTO `accounts_cinema` VALUES
  (1,'cinema_manager','IIIT Audi','8950425060','Prayagraj','IIIT Allahabad',1),
  (2,'cinema_manager','CC3','8950425060','Prayagraj','IIIT Allahabad',2);

UNLOCK TABLES;

DROP TABLE IF EXISTS `accounts_movie`;

CREATE TABLE `accounts_movie` (
  `movie` int NOT NULL AUTO_INCREMENT,
  `movie_name` varchar(50) NOT NULL,
  `movie_des` longtext NOT NULL,
  `movie_rating` decimal(3,1) NOT NULL,
  `movie_poster` varchar(100) NOT NULL,
  `movie_genre` varchar(50) NOT NULL,
  `movie_duration` varchar(10) NOT NULL,
  `movie_trailer` varchar(300) NOT NULL,
  `movie_rdate` varchar(20) NOT NULL,
  PRIMARY KEY (`movie`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

LOCK TABLES `accounts_movie` WRITE;

INSERT INTO `accounts_movie` VALUES
  (1,'Secret Superstar','New Good Movie',7.9,'movies/poster/download.jpg','Action | Comedy | Romance','2hr 45min','https://www.youtube.com/watch?v=J_yb8HORges&pp=ygUYc2VjcmV0IHN1cGVyc3RhciB0cmFpbGVy','10-12-2025'),
  (2,'Zindagi Na Milegi Dobara','Good Movie',8.6,'movies/poster/MV5BOGIzYzg5NzItNDRkYS00NmIzLTk3NzQtZWYwY2VlZDhiYWQ4XkEyXkFqcGc._V1_.jpg','Action | Comedy | Romance','2hr 45min','https://www.youtube.com/watch?v=FJrpcDgC3zU&pp=ygUgemluZGFnaSBuYSBtaWxlZ2kgZG9iYXJhIHRyYWlsZXI%3D','04-04-2025'),
  (3,'Yeh Jawaani Hai Deewani','good movie',8.2,'movies/poster/MV5BODA4MjM2ODk4OF5BMl5BanBnXkFtZTcwNDgzODk1OQ._V1_.jpg','Action | Comedy | Romance','2hr 32min','https://www.youtube.com/watch?v=Rbp2XUSeUNE&pp=ygUceWVoIGphd2FuaSBoZSBkaXdhbmkgdHJhaWxlcg%3D%3D','05-04-2025');

UNLOCK TABLES;

DROP TABLE IF EXISTS `accounts_shows`;

CREATE TABLE `accounts_shows` (
  `shows` int NOT NULL AUTO_INCREMENT,
  `time` varchar(100) NOT NULL,
  `price` int NOT NULL,
  `cinema_id` int NOT NULL,
  `movie_id` int NOT NULL,
  `date` varchar(15) NOT NULL,
  PRIMARY KEY (`shows`),
  KEY `accounts_shows_cinema_id_a9c57c57_fk_accounts_cinema_cinema` (`cinema_id`),
  KEY `accounts_shows_movie_id_68d70362_fk_accounts_movie_movie` (`movie_id`),
  CONSTRAINT `accounts_shows_cinema_id_a9c57c57_fk_accounts_cinema_cinema` FOREIGN KEY (`cinema_id`) REFERENCES `accounts_cinema` (`cinema`),
  CONSTRAINT `accounts_shows_movie_id_68d70362_fk_accounts_movie_movie` FOREIGN KEY (`movie_id`) REFERENCES `accounts_movie` (`movie`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

LOCK TABLES `accounts_shows` WRITE;

INSERT INTO `accounts_shows` VALUES
  (1,'10 pm',200,1,1,'04-04-2025'),
  (2,'8 pm',150,1,1,'04-04-2025'),
  (3,'8 pm',50,2,1,'04-04-2025'),
  (4,'14:15',100,1,1,'2025-04-03');

UNLOCK TABLES;

DROP TABLE IF EXISTS `auth_group`;

CREATE TABLE `auth_group` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

LOCK TABLES `auth_group` WRITE;
UNLOCK TABLES;

DROP TABLE IF EXISTS `auth_group_permissions`;

CREATE TABLE `auth_group_permissions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `group_id` int NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  KEY `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

LOCK TABLES `auth_group_permissions` WRITE;
UNLOCK TABLES;

DROP TABLE IF EXISTS `auth_permission`;

CREATE TABLE `auth_permission` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `content_type_id` int NOT NULL,
  `codename` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`),
  CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

LOCK TABLES `auth_permission` WRITE;

INSERT INTO `auth_permission` VALUES
  (1,'Can add log entry',1,'add_logentry'),
  (2,'Can change log entry',1,'change_logentry'),
  (3,'Can delete log entry',1,'delete_logentry'),
  (4,'Can view log entry',1,'view_logentry'),
  (5,'Can add permission',2,'add_permission'),
  (6,'Can change permission',2,'change_permission'),
  (7,'Can delete permission',2,'delete_permission'),
  (8,'Can view permission',2,'view_permission'),
  (9,'Can add group',3,'add_group'),
  (10,'Can change group',3,'change_group'),
  (11,'Can delete group',3,'delete_group'),
  (12,'Can view group',3,'view_group'),
  (13,'Can add user',4,'add_user'),
  (14,'Can change user',4,'change_user'),
  (15,'Can delete user',4,'delete_user'),
  (16,'Can view user',4,'view_user'),
  (17,'Can add content type',5,'add_contenttype'),
  (18,'Can change content type',5,'change_contenttype'),
  (19,'Can delete content type',5,'delete_contenttype'),
  (20,'Can view content type',5,'view_contenttype'),
  (21,'Can add session',6,'add_session'),
  (22,'Can change session',6,'change_session'),
  (23,'Can delete session',6,'delete_session'),
  (24,'Can view session',6,'view_session'),
  (25,'Can add cinema',7,'add_cinema'),
  (26,'Can change cinema',7,'change_cinema'),
  (27,'Can delete cinema',7,'delete_cinema'),
  (28,'Can view cinema',7,'view_cinema'),
  (29,'Can add movie',8,'add_movie'),
  (30,'Can change movie',8,'change_movie'),
  (31,'Can delete movie',8,'delete_movie'),
  (32,'Can view movie',8,'view_movie'),
  (33,'Can add shows',9,'add_shows'),
  (34,'Can change shows',9,'change_shows'),
  (35,'Can delete shows',9,'delete_shows'),
  (36,'Can view shows',9,'view_shows'),
  (37,'Can add bookings',10,'add_bookings'),
  (38,'Can change bookings',10,'change_bookings'),
  (39,'Can delete bookings',10,'delete_bookings'),
  (40,'Can view bookings',10,'view_bookings');

UNLOCK TABLES;

DROP TABLE IF EXISTS `auth_user`;

CREATE TABLE `auth_user` (
  `id` int NOT NULL AUTO_INCREMENT,
  `password` varchar(128) NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) NOT NULL,
  `first_name` varchar(150) NOT NULL,
  `last_name` varchar(150) NOT NULL,
  `email` varchar(254) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

LOCK TABLES `auth_user` WRITE;

INSERT INTO `auth_user` VALUES
  (1,'pbkdf2_sha256$260000$j226WskpY7NieL3Ld8aCMe$R0hdjdOVOpJQwXOQE+CcrPPs8h6fQ/l1R90ES0vRtXk=','2025-04-03 06:36:01.947673',1,'tavish','','','tchawla827@gmail.com',1,1,'2025-04-03 06:27:32.560558'),
  (2,'pbkdf2_sha256$260000$vJ1kdVO2xau4EI5k8AvLr2$4cvM4pRWUPByLaY1AtbzTTuJ9YEC1OcMKzvpMKX4hYA=','2025-04-03 06:35:26.193045',0,'grish','Grish','Gautam','grish@gmail.com',0,1,'2025-04-03 06:35:20.616079');

UNLOCK TABLES;

DROP TABLE IF EXISTS `auth_user_groups`;

CREATE TABLE `auth_user_groups` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `group_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_groups_user_id_group_id_94350c0c_uniq` (`user_id`,`group_id`),
  KEY `auth_user_groups_group_id_97559544_fk_auth_group_id` (`group_id`),
  CONSTRAINT `auth_user_groups_group_id_97559544_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  CONSTRAINT `auth_user_groups_user_id_6a12ed8b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

LOCK TABLES `auth_user_groups` WRITE;
UNLOCK TABLES;

DROP TABLE IF EXISTS `auth_user_user_permissions`;

CREATE TABLE `auth_user_user_permissions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_user_permissions_user_id_permission_id_14a6b632_uniq` (`user_id`,`permission_id`),
  KEY `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

LOCK TABLES `auth_user_user_permissions` WRITE;
UNLOCK TABLES;

DROP TABLE IF EXISTS `django_admin_log`;

CREATE TABLE `django_admin_log` (
  `id` int NOT NULL AUTO_INCREMENT,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext,
  `object_repr` varchar(200) NOT NULL,
  `action_flag` smallint unsigned NOT NULL,
  `change_message` longtext NOT NULL,
  `content_type_id` int DEFAULT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `django_admin_log_content_type_id_c4bce8eb_fk_django_co` (`content_type_id`),
  KEY `django_admin_log_user_id_c564eba6_fk_auth_user_id` (`user_id`),
  CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  CONSTRAINT `django_admin_log_user_id_c564eba6_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`),
  CONSTRAINT `django_admin_log_chk_1` CHECK ((`action_flag` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

LOCK TABLES `django_admin_log` WRITE;

INSERT INTO `django_admin_log` VALUES
  (1,'2025-04-03 06:30:57.274712','1','Secret Superstar',1,'[{\"added\": {}}]',8,1),
  (2,'2025-04-03 06:32:19.072483','1','Secret Superstar',2,'[]',8,1),
  (3,'2025-04-03 06:36:34.830753','1','IIIT Audi',1,'[{\"added\": {}}]',7,1),
  (4,'2025-04-03 06:36:56.995979','1','IIIT Audi | Secret Superstar | 10 pm',1,'[{\"added\": {}}]',9,1),
  (5,'2025-04-03 06:39:40.827017','2','IIIT Audi | Secret Superstar | 8 pm',1,'[{\"added\": {}}]',9,1),
  (6,'2025-04-03 06:40:53.198319','2','CC3',1,'[{\"added\": {}}]',7,1),
  (7,'2025-04-03 06:41:13.890143','3','CC3 | Secret Superstar | 8 pm',1,'[{\"added\": {}}]',9,1),
  (8,'2025-04-03 06:59:11.297283','2','Zindagi Na Milegi Dobara',1,'[{\"added\": {}}]',8,1),
  (9,'2025-04-03 07:01:52.127180','3','Yeh Jawaani Hai Deewani',1,'[{\"added\": {}}]',8,1);

UNLOCK TABLES;

DROP TABLE IF EXISTS `django_content_type`;

CREATE TABLE `django_content_type` (
  `id` int NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

LOCK TABLES `django_content_type` WRITE;

INSERT INTO `django_content_type` VALUES
  (10,'accounts','bookings'),
  (7,'accounts','cinema'),
  (8,'accounts','movie'),
  (9,'accounts','shows'),
  (1,'admin','logentry'),
  (3,'auth','group'),
  (2,'auth','permission'),
  (4,'auth','user'),
  (5,'contenttypes','contenttype'),
  (6,'sessions','session');

UNLOCK TABLES;

DROP TABLE IF EXISTS `django_migrations`;

CREATE TABLE `django_migrations` (
  `id` int NOT NULL AUTO_INCREMENT,
  `app` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `applied` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

LOCK TABLES `django_migrations` WRITE;

INSERT INTO `django_migrations` VALUES
  (1,'contenttypes','0001_initial','2025-04-03 06:25:06.937153'),
  (2,'auth','0001_initial','2025-04-03 06:25:07.259029'),
  (3,'accounts','0001_initial','2025-04-03 06:25:07.492606'),
  (4,'accounts','0002_shows_date','2025-04-03 06:25:07.528024'),
  (5,'accounts','0003_movie_movie_trailer','2025-04-03 06:25:07.559710'),
  (6,'accounts','0004_movie_movie_rdate','2025-04-03 06:25:07.593330'),
  (7,'admin','0001_initial','2025-04-03 06:25:07.682324'),
  (8,'admin','0002_logentry_remove_auto_add','2025-04-03 06:25:07.688980'),
  (9,'admin','0003_logentry_add_action_flag_choices','2025-04-03 06:25:07.695072'),
  (10,'contenttypes','0002_remove_content_type_name','2025-04-03 06:25:07.733317'),
  (11,'auth','0002_alter_permission_name_max_length','2025-04-03 06:25:07.767572'),
  (12,'auth','0003_alter_user_email_max_length','2025-04-03 06:25:07.782613'),
  (13,'auth','0004_alter_user_username_opts','2025-04-03 06:25:07.790148'),
  (14,'auth','0005_alter_user_last_login_null','2025-04-03 06:25:07.821145'),
  (15,'auth','0006_require_contenttypes_0002','2025-04-03 06:25:07.823134'),
  (16,'auth','0007_alter_validators_add_error_messages','2025-04-03 06:25:07.830656'),
  (17,'auth','0008_alter_user_username_max_length','2025-04-03 06:25:07.895076'),
  (18,'auth','0009_alter_user_last_name_max_length','2025-04-03 06:25:07.934276'),
  (19,'auth','0010_alter_group_name_max_length','2025-04-03 06:25:07.947434'),
  (20,'auth','0011_update_proxy_permissions','2025-04-03 06:25:07.956945'),
  (21,'auth','0012_alter_user_first_name_max_length','2025-04-03 06:25:07.988302'),
  (22,'sessions','0001_initial','2025-04-03 06:25:08.019539');

UNLOCK TABLES;

DROP TABLE IF EXISTS `django_session`;

CREATE TABLE `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime(6) NOT NULL,
  PRIMARY KEY (`session_key`),
  KEY `django_session_expire_date_a5c62663` (`expire_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

LOCK TABLES `django_session` WRITE;

INSERT INTO `django_session` VALUES
  ('v1tfb2mhl14r9p3z8nrxnk1ae7dkf6gi','.eJxVjEEOwiAQRe_C2hCnHQq4dN8zNDMwSNVAUtqV8e7apAvd_vfef6mJtjVPW5NlmqO6KFCn340pPKTsIN6p3KoOtazLzHpX9EGbHmuU5_Vw_w4ytfytcRgkoZdEjiie2UlgE9mHrveQek6GECxYJ4xkEcEDBYII0glaY9X7Aw7eOJA:1u0EBF:0rFa1YfxndggYY4_kPPHNlHwANqZiVkeoLLpWE-PUhY','2025-04-17 06:36:01.952196');

UNLOCK TABLES;
