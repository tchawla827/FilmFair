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
