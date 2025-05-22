-- MySQL dump 10.13  Distrib 8.0.40, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: travelmatedb
-- ------------------------------------------------------
-- Server version	8.0.40

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `_prisma_migrations`
--

DROP TABLE IF EXISTS `_prisma_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `_prisma_migrations` (
  `id` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `checksum` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `finished_at` datetime(3) DEFAULT NULL,
  `migration_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `logs` text COLLATE utf8mb4_unicode_ci,
  `rolled_back_at` datetime(3) DEFAULT NULL,
  `started_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `applied_steps_count` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `_prisma_migrations`
--

LOCK TABLES `_prisma_migrations` WRITE;
/*!40000 ALTER TABLE `_prisma_migrations` DISABLE KEYS */;
INSERT INTO `_prisma_migrations` VALUES ('014e35de-832b-4a60-8d52-b8e5379f4623','b81f36692ee3d16163df2cc69ccbef5ecd752fbcfaadc1b170ed769c0b2d59ad','2025-04-27 14:50:41.506','20250427145041_add_favorite_tables',NULL,NULL,'2025-04-27 14:50:41.331',1),('05dc7f12-ce65-4b7d-939d-a58435fd6460','48ff6b94fc74e3d34f66e547e45b4c46fcb1ffc0f8887e7ca440a55151cf80f2','2025-04-21 02:40:02.511','20250421024001_test',NULL,NULL,'2025-04-21 02:40:01.976',1),('0d110df8-580e-4c42-b148-b83f036ae821','efa9c5c81f6dfe36341e44e1db0282e4fd1670ea8ef52051a1a147ee8a135e9c','2025-05-08 14:15:34.678','20250508141534_add_payment_history',NULL,NULL,'2025-05-08 14:15:34.617',1),('3a1bf713-ec16-4725-8f2c-98201c82055c','6934b665a58f0855bd6f2519d19c1c1feeeead53b7961f751d78316e351afd92','2025-04-25 07:48:06.129','20250425074806_add_hotel_reviews',NULL,NULL,'2025-04-25 07:48:06.031',1),('8e04901a-fdb4-4dc5-82ad-3af298727d2c','272fa4e2385505a5fa96dd74c836e63c3d55e4895746c82cf32678f167d16824','2025-04-26 03:10:09.321','20250426031009_update_image_array',NULL,NULL,'2025-04-26 03:10:09.309',1),('bc7d3300-8f13-45f9-b502-6ae8016e37b1','65bca0679f56dedd177c4ce8800bf1ff5c16b554dbc29155372e9f3229aab741','2025-04-25 10:37:13.741','20250425103713_add_blog_image_relation',NULL,NULL,'2025-04-25 10:37:13.701',1),('c63f491e-4556-4afb-8d19-510ac7b179fa','88b98d56aa627f52acbc96528b41160c4af1fa3797c091cdd2a66e3e31d25db9','2025-04-26 04:42:36.582','20250426044236_add_created_blogcmt',NULL,NULL,'2025-04-26 04:42:36.570',1),('d2a9dccc-ac30-41d0-8de4-687ef5068b8c','59c1ce3b8b33738afbc00034b8b0052e1e3b310dadda6d9950a834949e7a18d4','2025-04-25 10:23:31.830','20250425102331_add_blog_table',NULL,NULL,'2025-04-25 10:23:31.787',1),('d57bceb9-47a0-4849-99f5-e89d6b9fbc69','fc6f8e59213d3a4de3660fa7e6a0e5941a5e08b08c59deba70d5424507941264','2025-04-26 04:52:37.813','20250426045237_add_created_blogcmt',NULL,NULL,'2025-04-26 04:52:37.762',1),('fa698f8f-fed5-45ad-8f64-467dae081728','b853f5cd91cda74c4c1c80e59de12a346aec7a141291fcad9d83185e44cfdb57','2025-04-26 04:13:58.751','20250426041358_add_comment_reaction',NULL,NULL,'2025-04-26 04:13:58.599',1);
/*!40000 ALTER TABLE `_prisma_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `admin_logs`
--

DROP TABLE IF EXISTS `admin_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `admin_logs` (
  `log_id` int NOT NULL AUTO_INCREMENT,
  `admin_id` int NOT NULL,
  `action` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `action_date` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`log_id`),
  KEY `Admin_Logs_admin_id_fkey` (`admin_id`),
  CONSTRAINT `Admin_Logs_admin_id_fkey` FOREIGN KEY (`admin_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admin_logs`
--

LOCK TABLES `admin_logs` WRITE;
/*!40000 ALTER TABLE `admin_logs` DISABLE KEYS */;
/*!40000 ALTER TABLE `admin_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ai_recommendations`
--

DROP TABLE IF EXISTS `ai_recommendations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ai_recommendations` (
  `recommendation_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `recommendation_text` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`recommendation_id`),
  KEY `AI_Recommendations_user_id_fkey` (`user_id`),
  CONSTRAINT `AI_Recommendations_user_id_fkey` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ai_recommendations`
--

LOCK TABLES `ai_recommendations` WRITE;
/*!40000 ALTER TABLE `ai_recommendations` DISABLE KEYS */;
/*!40000 ALTER TABLE `ai_recommendations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `blog`
--

DROP TABLE IF EXISTS `blog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `blog` (
  `blog_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `content` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'published',
  `created_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updated_at` datetime(3) NOT NULL,
  PRIMARY KEY (`blog_id`),
  KEY `Blog_user_id_fkey` (`user_id`),
  CONSTRAINT `Blog_user_id_fkey` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `blog`
--

LOCK TABLES `blog` WRITE;
/*!40000 ALTER TABLE `blog` DISABLE KEYS */;
INSERT INTO `blog` VALUES (2,8,'Testing-Huynh','Testtttttttt','published','2025-04-26 03:14:11.316','2025-04-26 03:14:11.316'),(4,8,'Test321321321','tadeawedwadwadwadwatadeawedwadwadwadwatadeawedwadwadwadwatadeawedwadwadwadwatadeawedwadwadwadwatadeawedwadwadwadwatadeawedwadwadwadwatadeawedwadwadwadwatadeawedwadwadwadwatadeawedwadwadwadwatadeawedwadwadwadwatadeawedwadwadwadwatadeawedwadwadwadwatadeawedwadwadwadwatadeawedwadwadwadwatadeawedwadwadwadwatadeawedwadwadwadwatadeawedwadwadwadwatadeawedwadwadwadwatadeawedwadwadwadwatadeawedwadwadwadwatadeawedwadwadwadwatadeawedwadwadwadwatadeawedwadwadwadwatadeawedwadwadwadwatadeawedwadwadwadwatadeawedwadwadwadwatadeawedwadwadwadwatadeawedwadwadwadwatadeawedwadwadwadwatadeawedwadwadwadwatadeawedwadwadwadwatadeawedwadwadwadwatadeawedwadwadwadwatadeawedwadwadwadwatadeawedwadwadwadwatadeawedwadwadwadwatadeawedwadwadwadwatadeawedwadwadwadwatadeawedwadwadwadwatadeawedwadwadwadwatadeawedwadwadwadwa','published','2025-04-27 07:46:25.726','2025-04-27 07:46:25.726');
/*!40000 ALTER TABLE `blog` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `blog_comments`
--

DROP TABLE IF EXISTS `blog_comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `blog_comments` (
  `comment_id` int NOT NULL AUTO_INCREMENT,
  `blog_id` int NOT NULL,
  `user_id` int NOT NULL,
  `content` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `parent_comment_id` int DEFAULT NULL,
  `updated_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`comment_id`),
  KEY `Blog_Comments_blog_id_fkey` (`blog_id`),
  KEY `Blog_Comments_user_id_fkey` (`user_id`),
  KEY `Blog_Comments_parent_comment_id_fkey` (`parent_comment_id`),
  CONSTRAINT `Blog_Comments_blog_id_fkey` FOREIGN KEY (`blog_id`) REFERENCES `blog` (`blog_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `Blog_Comments_parent_comment_id_fkey` FOREIGN KEY (`parent_comment_id`) REFERENCES `blog_comments` (`comment_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `Blog_Comments_user_id_fkey` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `blog_comments`
--

LOCK TABLES `blog_comments` WRITE;
/*!40000 ALTER TABLE `blog_comments` DISABLE KEYS */;
INSERT INTO `blog_comments` VALUES (20,2,8,'TEST','2025-04-27 07:57:25.651',NULL,'2025-04-27 07:57:25.651'),(30,2,15,'321321','2025-04-27 11:06:22.631',NULL,'2025-04-27 11:06:22.631'),(34,4,15,'321321','2025-04-28 08:46:34.010',NULL,'2025-04-28 08:46:34.010'),(35,4,15,'test','2025-04-28 08:46:37.320',NULL,'2025-04-28 08:46:37.320');
/*!40000 ALTER TABLE `blog_comments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `blogimage`
--

DROP TABLE IF EXISTS `blogimage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `blogimage` (
  `image_id` int NOT NULL AUTO_INCREMENT,
  `blog_id` int NOT NULL,
  `image_url` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`image_id`),
  KEY `BlogImage_blog_id_fkey` (`blog_id`),
  CONSTRAINT `BlogImage_blog_id_fkey` FOREIGN KEY (`blog_id`) REFERENCES `blog` (`blog_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `blogimage`
--

LOCK TABLES `blogimage` WRITE;
/*!40000 ALTER TABLE `blogimage` DISABLE KEYS */;
INSERT INTO `blogimage` VALUES (2,2,'1745637251074.jpg'),(4,4,'1745739985723.jpg');
/*!40000 ALTER TABLE `blogimage` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bookings`
--

DROP TABLE IF EXISTS `bookings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bookings` (
  `booking_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `tour_id` int NOT NULL,
  `number_of_people` int NOT NULL,
  `booking_date` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `status` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  PRIMARY KEY (`booking_id`),
  KEY `Bookings_user_id_fkey` (`user_id`),
  KEY `Bookings_tour_id_fkey` (`tour_id`),
  CONSTRAINT `Bookings_tour_id_fkey` FOREIGN KEY (`tour_id`) REFERENCES `tours` (`tour_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `Bookings_user_id_fkey` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bookings`
--

LOCK TABLES `bookings` WRITE;
/*!40000 ALTER TABLE `bookings` DISABLE KEYS */;
/*!40000 ALTER TABLE `bookings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `chatbot_history`
--

DROP TABLE IF EXISTS `chatbot_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `chatbot_history` (
  `chat_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `message` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `sender` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `timestamp` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`chat_id`),
  KEY `Chatbot_History_user_id_fkey` (`user_id`),
  CONSTRAINT `Chatbot_History_user_id_fkey` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `chatbot_history`
--

LOCK TABLES `chatbot_history` WRITE;
/*!40000 ALTER TABLE `chatbot_history` DISABLE KEYS */;
/*!40000 ALTER TABLE `chatbot_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comment_reactions`
--

DROP TABLE IF EXISTS `comment_reactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `comment_reactions` (
  `reaction_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `comment_id` int NOT NULL,
  `type` enum('like','love','haha','wow') COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`reaction_id`),
  UNIQUE KEY `Comment_Reactions_user_id_comment_id_key` (`user_id`,`comment_id`),
  KEY `Comment_Reactions_comment_id_fkey` (`comment_id`),
  CONSTRAINT `Comment_Reactions_comment_id_fkey` FOREIGN KEY (`comment_id`) REFERENCES `blog_comments` (`comment_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `Comment_Reactions_user_id_fkey` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comment_reactions`
--

LOCK TABLES `comment_reactions` WRITE;
/*!40000 ALTER TABLE `comment_reactions` DISABLE KEYS */;
INSERT INTO `comment_reactions` VALUES (1,8,20,'like'),(9,8,30,'haha'),(12,15,35,'haha');
/*!40000 ALTER TABLE `comment_reactions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `favorite_hotels`
--

DROP TABLE IF EXISTS `favorite_hotels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `favorite_hotels` (
  `favorite_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `hotel_id` int NOT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`favorite_id`),
  UNIQUE KEY `Favorite_Hotels_user_id_hotel_id_key` (`user_id`,`hotel_id`),
  KEY `Favorite_Hotels_hotel_id_fkey` (`hotel_id`),
  CONSTRAINT `Favorite_Hotels_hotel_id_fkey` FOREIGN KEY (`hotel_id`) REFERENCES `hotels` (`hotel_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `Favorite_Hotels_user_id_fkey` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `favorite_hotels`
--

LOCK TABLES `favorite_hotels` WRITE;
/*!40000 ALTER TABLE `favorite_hotels` DISABLE KEYS */;
/*!40000 ALTER TABLE `favorite_hotels` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `favorite_tours`
--

DROP TABLE IF EXISTS `favorite_tours`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `favorite_tours` (
  `favorite_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `tour_id` int NOT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`favorite_id`),
  UNIQUE KEY `Favorite_Tours_user_id_tour_id_key` (`user_id`,`tour_id`),
  KEY `Favorite_Tours_tour_id_fkey` (`tour_id`),
  CONSTRAINT `Favorite_Tours_tour_id_fkey` FOREIGN KEY (`tour_id`) REFERENCES `tours` (`tour_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `Favorite_Tours_user_id_fkey` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `favorite_tours`
--

LOCK TABLES `favorite_tours` WRITE;
/*!40000 ALTER TABLE `favorite_tours` DISABLE KEYS */;
INSERT INTO `favorite_tours` VALUES (18,8,4,'2025-04-28 08:05:17.374'),(19,8,3,'2025-04-28 08:05:26.602'),(20,8,1,'2025-04-28 08:05:39.675'),(21,8,2,'2025-04-28 08:05:46.629'),(34,15,1,'2025-04-28 10:19:07.102'),(36,15,4,'2025-04-28 10:19:13.255');
/*!40000 ALTER TABLE `favorite_tours` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hotel_reviews`
--

DROP TABLE IF EXISTS `hotel_reviews`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hotel_reviews` (
  `review_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `hotel_id` int NOT NULL,
  `rating` int NOT NULL,
  `comment` text COLLATE utf8mb4_unicode_ci,
  `review_date` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`review_id`),
  KEY `Hotel_Reviews_user_id_fkey` (`user_id`),
  KEY `Hotel_Reviews_hotel_id_fkey` (`hotel_id`),
  CONSTRAINT `Hotel_Reviews_hotel_id_fkey` FOREIGN KEY (`hotel_id`) REFERENCES `hotels` (`hotel_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `Hotel_Reviews_user_id_fkey` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hotel_reviews`
--

LOCK TABLES `hotel_reviews` WRITE;
/*!40000 ALTER TABLE `hotel_reviews` DISABLE KEYS */;
INSERT INTO `hotel_reviews` VALUES (5,1,1,5,'Amazing stay!','2025-04-25 09:25:55.231');
/*!40000 ALTER TABLE `hotel_reviews` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hotelreviewimage`
--

DROP TABLE IF EXISTS `hotelreviewimage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hotelreviewimage` (
  `id` int NOT NULL AUTO_INCREMENT,
  `review_id` int NOT NULL,
  `image_url` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `HotelReviewImage_review_id_fkey` (`review_id`),
  CONSTRAINT `HotelReviewImage_review_id_fkey` FOREIGN KEY (`review_id`) REFERENCES `hotel_reviews` (`review_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hotelreviewimage`
--

LOCK TABLES `hotelreviewimage` WRITE;
/*!40000 ALTER TABLE `hotelreviewimage` DISABLE KEYS */;
INSERT INTO `hotelreviewimage` VALUES (2,5,'1745573691087.jpg');
/*!40000 ALTER TABLE `hotelreviewimage` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hotels`
--

DROP TABLE IF EXISTS `hotels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hotels` (
  `hotel_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `price` decimal(10,2) NOT NULL,
  `location` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `image_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `available_seats` int NOT NULL,
  PRIMARY KEY (`hotel_id`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hotels`
--

LOCK TABLES `hotels` WRITE;
/*!40000 ALTER TABLE `hotels` DISABLE KEYS */;
INSERT INTO `hotels` VALUES (1,'JW Marriott Hotel Hanoi','Khách sạn sang trọng nằm trong tòa nhà ven hồ đẹp mắt, cách Trung tâm Hội nghị Quốc gia Việt Nam 8 phút đi bộ, cách khu Phố cổ sôi động 9 km và cách Sân bay Quốc tế Nội Bài 27 km',300.00,'No 8 P. Đỗ Đức Dục, Road, Nam Từ Liêm, Hà Nội','https://dynamic-media-cdn.tripadvisor.com/media/photo-o/2e/9a/ae/15/entrance.jpg?w=500&h=-1&s=1',100),(2,'Lotte Hotel Hanoi','Khách sạn sang trọng, hiện đại này nằm trên tầng cao của tòa nhà Lotte Center 65 tầng, cách Lăng Chủ tịch Hồ Chí Minh 3 km và Sân bay Quốc tế Nội Bài 27 km',150.00,'54 P. Liễu Giai, Cống Vị, Ba Đình, Hà Nội','https://dynamic-media-cdn.tripadvisor.com/media/photo-o/2e/9a/ae/15/entrance.jpg?w=500&h=-1&s=1',100),(3,'Meliá Hanoi','Khách sạn hiện đại này cách Nhà Hát Lớn Hà Nội 1,1 km, và cách cả khu Phố cổ và Văn Miếu 1,7 km',60.00,'44 P. Lý Thường Kiệt, Trần Hưng Đạo, Hoàn Kiếm, Hà Nội','https://dynamic-media-cdn.tripadvisor.com/media/photo-o/2e/9a/ae/15/entrance.jpg?w=500&h=-1&s=1',100),(4,'Sofitel Legend Metropole Hanoi','Khách sạn sang trọng với kiến trúc tân cổ điển này tọa lạc trên con đường có những hàng cây và dãy cửa hàng, cách Nhà hát Lớn Hà Nội 5 phút đi bộ và Sân bay Quốc tế Nội Bài 27 km.',200.00,'15 P. Ngô Quyền, Street, Hoàn Kiếm, Hà Nội','https://dynamic-media-cdn.tripadvisor.com/media/photo-o/2e/9a/ae/15/entrance.jpg?w=500&h=-1&s=1',100),(5,'Sheraton Hanoi Hotel','Tọa lạc trong tòa cao ốc hướng ra Sông Hồng và Hồ Tây, khách sạn cao cấp này cách Lăng Chủ Tịch Hồ Chí Minh 4 km và cách Ga Hà Nội 5 km.',150.00,'K5, Nghi Tàm/11 Đ. Xuân Diệu, Quảng An, Tây Hồ, Hà Nội','https://dynamic-media-cdn.tripadvisor.com/media/photo-o/2e/9a/ae/15/entrance.jpg?w=500&h=-1&s=1',100),(6,'Terracotta hotel & resort Dalat','Khu nghỉ dưỡng Terracotta Đà Lạt rộng hơn 17 hecta, toạ lạc trên bán đảo ven hồ Tuyền Lâm, cách trung tâm Đà Lạt 6km, gồm 240 phòng nghỉ và 90 căn biệt thự',50.00,'Phân khu chức năng 7.9 KDL hồ Tuyền Lâm, Phường 3, Lâm Đồng','https://dynamic-media-cdn.tripadvisor.com/media/photo-o/2e/9a/ae/15/entrance.jpg?w=500&h=-1&s=1',100),(7,'MerPerle Dalat Hotel','LƯU TRÚ & NGHỈ DƯỠNG. Sở hữu hệ thống 389 phòng với 8 loại phòng khác nhau phù hợp với đa dạng nhu cầu của du khách. Dịch vụ lưu trú & nghỉ dưỡng đẳng cấp',60.00,'1 Đ. Hùng Vương, Phường 10, Đà Lạt, Lâm Đồng','https://dynamic-media-cdn.tripadvisor.com/media/photo-o/2e/9a/ae/15/entrance.jpg?w=500&h=-1&s=1',100),(8,'Colline Dalat','Khám phá. Khám phá nét quyến rũ của Đà Lạt trong thời gian lưu trú tại Colline. Ghé thăm những khu chợ sôi động, hồ Xuân Hương thanh bình và kho tàng văn hóa.',120.00,'10 Phan Bội Châu, Phường 1, Đà Lạt, Lâm Đồng','https://dynamic-media-cdn.tripadvisor.com/media/photo-o/2e/9a/ae/15/entrance.jpg?w=500&h=-1&s=1',100),(9,'Mercure Dalat Resort','Tọa lạc ở Đà Lạt, cách Vườn hoa Đà Lạt 19 phút đi bộ, Mercure Dalat Resort cung cấp chỗ nghỉ có khu vườn, chỗ đậu xe riêng miễn phí, sân hiên và nhà hàng.',140.00,'03 Nguyễn Du, Street Ward 09, Đà Lạt, Lâm Đồng','https://dynamic-media-cdn.tripadvisor.com/media/photo-o/2e/9a/ae/15/entrance.jpg?w=500&h=-1&s=1',100),(10,'Golf Valley Hotel','Diện tích 28 m2, được thiết kế theo phong cách đương đại và trang bị nhiều tiện nghi cao cấp, phòng Superior là lựa chọn tuyệt vời cho khách du lịch một mình ...',200.00,'94 Đường Bùi Thị Xuân, Phường 2, Đà Lạt, Lâm Đồng','https://dynamic-media-cdn.tripadvisor.com/media/photo-o/2e/9a/ae/15/entrance.jpg?w=500&h=-1&s=1',100),(11,'New World Saigon Hotel','Tọa lạc trong khu vực kinh doanh sôi động của thành phố, khách sạn cao cấp này cách Chợ Bến Thành 5 phút đi bộ và cách Dinh Độc Lập 11 phút đi bộ',200.00,'76 Đ. Lê Lai, Phường Bến Thành, Quận 1, Hồ Chí Minh','https://dynamic-media-cdn.tripadvisor.com/media/photo-o/2e/9a/ae/15/entrance.jpg?w=500&h=-1&s=1',100),(12,'La Vela Saigon Hotel','Khách sạn sang trọng và cao tầng này cách Bảo tàng Chứng tích Chiến tranh 1 km, cách Dinh Độc Lập 2 km và cách Sân bay Quốc tế Tân Sơn Nhất 4 km',140.00,'280 Đ. Nam Kỳ Khởi Nghĩa, Phường 8, Quận 3, Hồ Chí Minh','https://dynamic-media-cdn.tripadvisor.com/media/photo-o/2e/9a/ae/15/entrance.jpg?w=500&h=-1&s=1',100),(13,'Hotel Nikko Saigon','Nằm trong khu thương mại của thành phố, khách sạn cao cấp này cách Chợ Bến Thành 2 km và cách Nhà thờ Đức Bà Sài Gòn 3 km',220.00,' 235 Đ. Nguyễn Văn Cừ, Phường Nguyễn Cư Trinh, Quận 1, Hồ Chí Minh','https://dynamic-media-cdn.tripadvisor.com/media/photo-o/2e/9a/ae/15/entrance.jpg?w=500&h=-1&s=1',100),(14,'Caravelle Hotel','Khách sạn cao cấp này có lối thiết kế hiện đại cao tầng, cách trạm xe buýt gần nhất 2 phút đi bộ, cách Nhà thờ Đức Bà Sài Gòn 9 phút đi bộ và chợ Bến Thành 11 phút đi bộ.',250.00,'19-23 Lam Son Square, Bến Nghé, Quận 1, Hồ Chí Minh','https://dynamic-media-cdn.tripadvisor.com/media/photo-o/2e/9a/ae/15/entrance.jpg?w=500&h=-1&s=1',100),(15,'Lotte Hotel Saigon','Khách sạn cao tầng hạng sang nhìn ra sông Sài Gòn, nằm cách chợ Bến Thành 2 km và chỉ mất 10 phút đi bộ là đến Nhà hát Thành phố Hồ Chí Minh',500.00,' 2A-4A Tôn Đức Thắng, Bến Nghé, Quận 1, Hồ Chí Minh','https://dynamic-media-cdn.tripadvisor.com/media/photo-o/2e/9a/ae/15/entrance.jpg?w=500&h=-1&s=1',100),(16,'Hyatt Regency Danang Resort and Spa','Khách sạn cao cấp nhìn ra bãi biển Non Nước, cách Bảo tàng Điêu khắc Chăm 8 km và Cầu Rồng 10 km',200.00,'5 Trường Sa, Street, Ngũ Hành Sơn, Đà Nẵng','https://dynamic-media-cdn.tripadvisor.com/media/photo-o/2e/9a/ae/15/entrance.jpg?w=500&h=-1&s=1',100),(17,'Haian Beach Hotel & Spa','Khách sạn cao tầng và hiện đại này nằm đối diện Bãi biển Mỹ Khê và cách Sân bay Quốc tế Đà Nẵng 6 km',50.00,'278 Võ Nguyên Giáp, Bắc Mỹ Phú, Ngũ Hành Sơn, Đà Nẵng','https://dynamic-media-cdn.tripadvisor.com/media/photo-o/2e/9a/ae/15/entrance.jpg?w=500&h=-1&s=1',100),(18,'Mường Thanh Luxury Da Nang Hotel','Khách sạn sang trọng này nằm đối diện Bãi biển Mỹ Khê, cách Bảo tàng Điêu khắc Chăm 4 km và cách Sân bay Quốc tế Đà Nẵng 6 km',50.00,' 270 Võ Nguyên Giáp, Bắc Mỹ Phú, Ngũ Hành Sơn, Đà Nẵng','https://dynamic-media-cdn.tripadvisor.com/media/photo-o/2e/9a/ae/15/entrance.jpg?w=500&h=-1&s=1',100),(19,'Novotel Danang Premier Han River','Đi bộ 10 phút từ các trạm xe buýt, bạn sẽ đến với khách sạn hiện đại này nằm trong tòa nhà kiểu tháp đối diện Sông Hàn, cách Cầu Rồng 2 km.',90.00,'36 Bạch Đằng, Thạch Thang, Hải Châu, Đà Nẵng','https://dynamic-media-cdn.tripadvisor.com/media/photo-o/2e/9a/ae/15/entrance.jpg?w=500&h=-1&s=1',100),(20,'Furama Resort Danang','Được dịch từ tiếng Anh​-​Tọa lạc trong khu vườn nhiệt đới tươi tốt nhìn ra biển, khu nghỉ dưỡng thư thái ven biển này cách Cầu Rồng 4 km',160.00,'105 Võ Nguyên Giáp, Khuê Mỹ, Ngũ Hành Sơn, Đà Nẵng','https://dynamic-media-cdn.tripadvisor.com/media/photo-o/2e/9a/ae/15/entrance.jpg?w=500&h=-1&s=1',100);
/*!40000 ALTER TABLE `hotels` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notifications`
--

DROP TABLE IF EXISTS `notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notifications` (
  `notification_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `message` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `notification_date` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`notification_id`),
  KEY `Notifications_user_id_fkey` (`user_id`),
  CONSTRAINT `Notifications_user_id_fkey` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notifications`
--

LOCK TABLES `notifications` WRITE;
/*!40000 ALTER TABLE `notifications` DISABLE KEYS */;
/*!40000 ALTER TABLE `notifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `paymenthistory`
--

DROP TABLE IF EXISTS `paymenthistory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `paymenthistory` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `order_code` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `payment_method` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  UNIQUE KEY `PaymentHistory_order_code_key` (`order_code`),
  KEY `PaymentHistory_user_id_fkey` (`user_id`),
  CONSTRAINT `PaymentHistory_user_id_fkey` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `paymenthistory`
--

LOCK TABLES `paymenthistory` WRITE;
/*!40000 ALTER TABLE `paymenthistory` DISABLE KEYS */;
INSERT INTO `paymenthistory` VALUES (1,8,'1746714813972',2000.00,'Thanh toán đơn hàng','cancelled',NULL,'2025-05-08 14:33:34.576');
/*!40000 ALTER TABLE `paymenthistory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payments`
--

DROP TABLE IF EXISTS `payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payments` (
  `payment_id` int NOT NULL AUTO_INCREMENT,
  `booking_id` int NOT NULL,
  `payment_date` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `amount` decimal(10,2) NOT NULL,
  `payment_method` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'successful',
  PRIMARY KEY (`payment_id`),
  KEY `Payments_booking_id_fkey` (`booking_id`),
  CONSTRAINT `Payments_booking_id_fkey` FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`booking_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payments`
--

LOCK TABLES `payments` WRITE;
/*!40000 ALTER TABLE `payments` DISABLE KEYS */;
/*!40000 ALTER TABLE `payments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reviewimage`
--

DROP TABLE IF EXISTS `reviewimage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reviewimage` (
  `id` int NOT NULL AUTO_INCREMENT,
  `review_id` int NOT NULL,
  `image_url` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `ReviewImage_review_id_fkey` (`review_id`),
  CONSTRAINT `ReviewImage_review_id_fkey` FOREIGN KEY (`review_id`) REFERENCES `reviews` (`review_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reviewimage`
--

LOCK TABLES `reviewimage` WRITE;
/*!40000 ALTER TABLE `reviewimage` DISABLE KEYS */;
INSERT INTO `reviewimage` VALUES (1,1,'1745203302727.jpg');
/*!40000 ALTER TABLE `reviewimage` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reviews`
--

DROP TABLE IF EXISTS `reviews`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reviews` (
  `review_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `tour_id` int NOT NULL,
  `rating` int NOT NULL,
  `comment` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `review_date` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`review_id`),
  KEY `Reviews_user_id_fkey` (`user_id`),
  KEY `Reviews_tour_id_fkey` (`tour_id`),
  CONSTRAINT `Reviews_tour_id_fkey` FOREIGN KEY (`tour_id`) REFERENCES `tours` (`tour_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `Reviews_user_id_fkey` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reviews`
--

LOCK TABLES `reviews` WRITE;
/*!40000 ALTER TABLE `reviews` DISABLE KEYS */;
INSERT INTO `reviews` VALUES (1,8,1,5,'Rất đẹp và vui!','2025-04-19 06:41:01.078');
/*!40000 ALTER TABLE `reviews` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tour_images`
--

DROP TABLE IF EXISTS `tour_images`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tour_images` (
  `image_id` int NOT NULL AUTO_INCREMENT,
  `tour_id` int NOT NULL,
  `image_url` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `image_order` int NOT NULL DEFAULT '1',
  PRIMARY KEY (`image_id`),
  KEY `Tour_Images_tour_id_fkey` (`tour_id`),
  CONSTRAINT `Tour_Images_tour_id_fkey` FOREIGN KEY (`tour_id`) REFERENCES `tours` (`tour_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tour_images`
--

LOCK TABLES `tour_images` WRITE;
/*!40000 ALTER TABLE `tour_images` DISABLE KEYS */;
/*!40000 ALTER TABLE `tour_images` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tour_itinerarys`
--

DROP TABLE IF EXISTS `tour_itinerarys`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tour_itinerarys` (
  `itinerary_id` int NOT NULL AUTO_INCREMENT,
  `tour_id` int NOT NULL,
  `day_number` int NOT NULL,
  `start_time` datetime(3) DEFAULT NULL,
  `activity` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `location` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`itinerary_id`),
  KEY `Tour_Itinerarys_tour_id_fkey` (`tour_id`),
  CONSTRAINT `Tour_Itinerarys_tour_id_fkey` FOREIGN KEY (`tour_id`) REFERENCES `tours` (`tour_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tour_itinerarys`
--

LOCK TABLES `tour_itinerarys` WRITE;
/*!40000 ALTER TABLE `tour_itinerarys` DISABLE KEYS */;
/*!40000 ALTER TABLE `tour_itinerarys` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tour_logs`
--

DROP TABLE IF EXISTS `tour_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tour_logs` (
  `log_id` int NOT NULL AUTO_INCREMENT,
  `tour_id` int NOT NULL,
  `action` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `action_date` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`log_id`),
  KEY `Tour_Logs_tour_id_fkey` (`tour_id`),
  CONSTRAINT `Tour_Logs_tour_id_fkey` FOREIGN KEY (`tour_id`) REFERENCES `tours` (`tour_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tour_logs`
--

LOCK TABLES `tour_logs` WRITE;
/*!40000 ALTER TABLE `tour_logs` DISABLE KEYS */;
/*!40000 ALTER TABLE `tour_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tours`
--

DROP TABLE IF EXISTS `tours`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tours` (
  `tour_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `price` decimal(10,2) NOT NULL,
  `duration` int NOT NULL,
  `location` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `image_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `available_seats` int NOT NULL,
  PRIMARY KEY (`tour_id`)
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tours`
--

LOCK TABLES `tours` WRITE;
/*!40000 ALTER TABLE `tours` DISABLE KEYS */;
INSERT INTO `tours` VALUES (1,'Ba Na Hills','Đến với Sun World Ba Na Hills, du khách sẽ được trải nghiệm khí hậu bốn mùa trong một ngày, chu du trên những tuyến cáp treo, đắm chìm trong cảnh quan thiên nhiên của những cánh rừng nguyên sinh nối tiếp ở Bà Nà, thưởng thức ẩm thực đa dạng và tận hưởng không khí lễ hội ngập tràn.',50.00,2,'Thôn An Sơn, xã Hòa Ninh, huyện Hòa Vang, TP Đà Nẵng','https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQPLWOowgMwwjlo4Fu20otQdpBXf2wyfe2LZQ&s',100),(2,'The Marble Mountains','Ngũ Hành Sơn là một danh thắng gồm 6 ngọn núi đá vôi nhô lên trên một bãi cát ven biển, trên một diện tích khoảng 2 km² nằm cách trung tâm thành phố Đà Nẵng, Việt Nam khoảng 8 km về phía Đông Nam, ngay trên tuyến đường Đà Nẵng - Hội An',20.00,1,'81 Huyền Trân Công Chúa, Hoà Hải, Ngũ Hành Sơn, Đà Nẵng','https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRAhNHp6qMcpXQzkHhI2Z0NU7o_gQipNj7lUw&s',100),(3,'Danang Downtown (formerly Asia Park)','Công viên giải trí có vòng đu quay khổng lồ & trò tàu lượn khác và khu vực vui chơi theo chủ đề các nước Châu Á.',10.00,1,' Đ. 2 Tháng 9, Hoà Cường Bắc, Hải Châu, Đà Nẵng','https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcROX7rKH1EY8AZb4SGyhYZKkdTgm5AXh8QhXg&s',100),(4,'Hoi An ancient town','Hội An là một thành phố trực thuộc tỉnh Quảng Nam, Việt Nam. Phố cổ Hội An từng là một thương cảng quốc tế sầm uất, gồm những di sản kiến trúc đã có từ hàng trăm năm trước, được UNESCO công nhận là di sản văn hóa thế giới từ năm 1999',100.00,1,'Quảng Nam','https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaeT5AOLFrw1qfDdpDSR29Auo0-w0NJZtsUw&s',100),(5,'Mikazuki Water Park 365','Trải nghiệm công viên nước phong cách Nhật Bản tại Mikazuki Water Park 365. Với gian trong nhà & ngoài trời là những lựa chọn tuyệt vời để trải nghiệm cùng bạn bè & gia đình. Hãy cùng lạc vào “xứ sở mặt trời mọc” thu nhỏ giữa lòng thành phố biển Đà Nẵng xinh đẹp.',100.00,1,'Khu du lịch Xuân Thiều, Nguyễn Tất Thành, Hoà Hiệp Nam, Liên Chiểu, Đà Nẵng','https://lh3.googleusercontent.com/p/AF1QipOSdERf4JXKF5mNt8CUKG4HjdF6O8fNXm8I3yLp=s1360-w1360-h1020',100),(6,'Thanh Ha Pottery Village, Hoi An','Ngôi làng có các xưởng gốm truyền thống nằm dọc các con ngõ và nổi tiếng với món mì đặc trưng.',100.00,1,'Phạm Phán, Thanh Hà, Hội An, Quảng Nam',NULL,100),(7,'Da Nang Museum of Cham Sculpture','Bảo tàng Điêu khắc Chăm Đà Nẵng là bảo tàng trưng bày hiện vật Chăm quy mô nhất ở Việt Nam, trực thuộc Bảo tàng Đà Nẵng',20.00,1,'Số 02 Đ. 2 Tháng 9, Bình Hiên, Hải Châu, Đà Nẵng',NULL,100),(8,'Coconut boat tour','Chuyến tham quan sông nước và rừng dừa bằng thuyền thúng truyền thống cùng các hoạt động văn hóa.',50.00,1,'Cẩm Thanh, Hội An, Quảng Nam',NULL,100),(9,'Ho Chi Minh\'s Mausoleum','Lăng Chủ tịch Hồ Chí Minh, còn gọi là Lăng Hồ Chủ tịch, Lăng Bác, là nơi gìn giữ thi hài Chủ tịch Hồ Chí Minh. Lăng được chính thức khởi công ngày 2 tháng 9 năm 1973, tại vị trí lễ đài cũ giữa Quảng trường Ba Đình, nơi Chủ tịch Hồ Chí Minh từng chủ trì các cuộc gặp mặt quan trọng.',100.00,1,'1 Hùng Vương, Điện Biên, Ba Đình, Hà Nội',NULL,100),(10,'Vietnam Military History Museum','Bảo tàng Lịch sử Quân sự Việt Nam là một trong các bảo tàng quốc gia và đứng đầu trong hệ thống Bảo tàng Quân đội, hiện đang lưu giữ, trưng bày hơn 15 vạn tài liệu, hiện vật, trong đó có nhiều sưu tập độc đáo và 4 Bảo vật Quốc gia, gồm máy bay MiG-21 số hiệu 4324, máy bay MiG-21 số hiệu 5121',129.00,1,'Tây Mỗ, Nam Từ Liêm, Hà Nội',NULL,100),(11,'Hanoi Opera House','Nhà hát Lớn Hà Nội là một công trình kiến trúc tại thành phố Hà Nội, Việt Nam, phục vụ biểu diễn nghệ thuật.',60.00,1,'1 Tràng Tiền, Phan Chu Trinh, Hoàn Kiếm, Hà Nội',NULL,100),(12,'Hoa Lo Prison','Nhà tù Hỏa Lò hay nhà pha Hỏa Lò là một nhà tù do thực dân Pháp xây dựng trên khu đất xưa thuộc làng Hỏa Lò',50.00,1,'1  P. Hoả Lò, Trần Hưng Đạo, Hoàn Kiếm, Hà Nội',NULL,100),(13,'Imperial Citadel of Thang Long','Hoàng thành Thăng Long là quần thể di tích gắn với lịch sử kinh thành Thăng Long - Đông Kinh và tỉnh thành Hà Nội bắt đầu từ thời kì tiền Thăng Long qua thời Đinh - Tiền Lê, phát triển mạnh dưới thời Lý, Trần, Lê và thành Hà Nội dưới triều Nguyễn',50.00,1,'19c Hoàng Diệu, Điện Biên, Ba Đình, Hà Nội',NULL,100),(14,'Thang Long Water Puppet Theatre','Địa điểm biểu diễn nghệ thuật có tổ chức các tiết mục múa rối nước trên sân khấu cùng nhạc nền.',45.00,1,'57B P. Đinh Tiên Hoàng, Hàng Bạc, Hoàn Kiếm, Hà Nội',NULL,100),(15,'Vietnam Museum of Ethnology','Bảo tàng Dân tộc học Việt Nam là tổ chức sự nghiệp trực thuộc Viện Hàn lâm Khoa học xã hội Việt Nam, có chức năng nghiên cứu khoa học, sưu tầm, kiểm kê, bảo quản, phục chế hiện vật và tư liệu về các dân tộc; tổ chức trưng bày',40.00,1,'Nguyễn Văn Huyên, Quan Hoa, Cầu Giấy, Hà Nội ',NULL,100),(16,'Hồ Đồng Đò','Hồ Đồng Đò Sóc Sơn là một điểm du lịch nổi tiếng ở Hà Nội, thu hút du khách bởi vẻ đẹp hoang sơ và yên bình. Khu lịch Hồ Đồng Đò Sóc Sơn sẽ phù hợp với những ai yêu thiên nhiên, muốn tận hưởng không khí trong lành và tạm lánh những ồn ào của phố thị.',100.00,2,'Sóc Sơn, Hà Nội',NULL,100),(17,'Notre Dame Cathedral of Saigon','Nhà thờ chính tòa Đức Bà Sài Gòn, thường được gọi tắt là Nhà thờ Đức Bà, là nhà thờ chính tòa của Tổng giáo phận Sài Gòn. Nhà thờ không chỉ là biểu tượng của Công giáo ở Việt Nam, mà còn là một trong những công trình kiến trúc độc đáo của Thành phố Hồ Chí Minh và điểm đến nổi tiếng với du khách',60.00,1,'01 Công trường Công xã Paris, Bến Nghé, Quận 1, Hồ Chí Minh',NULL,100),(18,'Independence Palace','Dinh Độc Lập là một tòa nhà của nhà nước tại Thành phố Hồ Chí Minh, từng là nơi ở và làm việc của Tổng thống Việt Nam Cộng hòa trước Sự kiện 30 tháng 4 năm 1975. Hiện nay, Dinh Độc Lập đã được Chính phủ Việt Nam xếp hạng là di tích quốc gia đặc biệt.',30.00,1,'Phường Bến Thành, Quận 1, Hồ Chí Minh',NULL,100),(19,'War Remnants Museum','Bảo tàng Chứng tích Chiến tranh là một bảo tàng vì hòa bình ở số 28 đường Võ Văn Tần, Phường Võ Thị Sáu, Quận 3, Thành phố Hồ Chí Minh. Bảo tàng Chứng tích Chiến tranh trực thuộc Sở Văn hóa và Thể thao Thành phố Hồ Chí Minh, là thành viên của hệ thống Bảo tàng vì hòa bình thế giới và Hội đồng các bảo tàng thế giới.',20.00,1,'Phường 6, Quận 3, Hồ Chí Minh',NULL,100),(20,'Saigon Zoo & Botanical Gardens','Thảo Cầm Viên Sài Gòn, hay còn được gọi ở địa phương là Sở Thú, là công viên bảo tồn động vật - thực vật rộng 16,8 ha ở Thành phố Hồ Chí Minh, Việt Nam. Đây là vườn thú lâu đời đứng hàng thứ tám trên thế giới.',30.00,1,'2 Đ. Nguyễn Bỉnh Khiêm, Bến Nghé, Quận 1, Hồ Chí Minh',NULL,100),(21,'Cu Chi Tunnel','Địa đạo Củ Chi là một hệ thống phòng thủ trong lòng đất ở huyện Củ Chi, cách trung tâm Thành phố Hồ Chí Minh 69 km về hướng Tây-Bắc. Hệ thống này được quân kháng chiến Việt Minh và Mặt trận Dân tộc Giải phóng miền Nam Việt Nam đào trong thời kỳ Chiến tranh Đông Dương và Chiến tranh Việt Nam.',20.00,1,'Phú Hiệp, Củ Chi, Hồ Chí Minh',NULL,100),(22,'Thuy Chau Ecotourism','Công viên sinh thái nhân tạo có rừng cây thanh bình và lối đi bộ ven sông, khu dã ngoại và bể bơi.',20.00,1,'Bình An, Dĩ An, Bình Dương',NULL,100),(23,'Dam Sen Water Park','Chỉ với 1 vé quý khách được vui chơi cả ngày tại Đầm Sen Nước Đến với Công Viên Nước Đầm Sen, các bạn sẽ cảm nhận ngay về một ốc đảo xanh mát tọa lạc ngay giữa lòng thành phố.Với 36 thiết bị trò chơi dưới nước hiện đại cùng một hồ tạo sóng mát lạnh rộng 3000m2',15.00,1,'3 Đ. Hòa Bình, Phường 3, Quận 11, Hồ Chí Minh ',NULL,100),(24,'Ben Thanh Market','Chợ Bến Thành là một ngôi chợ nằm tại Quận 1, Thành phố Hồ Chí Minh. Chợ được khởi công xây dựng từ năm 1912, hình ảnh đồng hồ ở cửa nam của ngôi chợ này được xem là biểu tượng không chính thức của Thành phố Hồ Chí Minh.',20.00,1,'Phường Bến Thành, Quận 1, Hồ Chí Minh',NULL,100),(25,'Mongo Land Dalat','Mongo Land Đà Lạt là điểm đến siêu hot hit đang được nhiều du khách săn đón mỗi khi đến với thành phố ngàn hoa. Nơi đây không chỉ sở hữu không gian cao nguyên rộng lớn mà còn có nhiều tiểu cảnh để check-in “sống ảo”.',20.00,1,'Tổ 16 thôn 1, Tà Nung, Đà Lạt',NULL,100),(26,'Puppy Farm','Khu vườn bên sườn đồi có trang trại cà chua, những cánh đồng hoa cùng hoạt động hái dâu và vui chơi cùng chó.',35.00,1,'Cam Ly, Măng Lin, Đà Lạt','https://imagetravel.vn/wp-content/uploads/2024/10/puppy-farm-dia-diem-du-lich.jpg',100),(27,'Datanla Waterfall','Đatanla hay Datanla là thác ở thành phố Đà Lạt, tỉnh Lâm Đồng, Việt Nam. Thác nằm trong khu du lịch Đatanla, cách thác Prenn 8 km và thành phố Đà Lạt 10 km và là điểm tham quan, phiêu lưu mạo hiểm.',50.00,1,'QL20 Đèo Prenn, Phường 3, Đà Lạt',NULL,100),(28,'The Florest - Hoa Trong Rừng','The Florest - Hoa Trong Rừng là vườn hoa lớn nhất Đà Lạt với diện tích trồng hoa hơn 5,5ha',20.00,1,'Thôn 4, Đà Lạt',NULL,100),(29,'Valley Of Love','Thung Lũng Tình Yêu là một trong những thắng cảnh thơ mộng nhất tại Đà Lạt, cách trung tâm thành phố khoảng 5 km về phía bắc. Đó là nơi đập Đa Thiện quy tụ những dòng suối nhỏ chảy từ đồi núi cao, thành hồ Đa Thiện trong vắt uốn quanh thung lũng rợp bóng thông xanh.',50.00,1,'3-5-7 Đường Mai Anh Đào, Phường 8, Đà Lạt',NULL,100),(30,'Săn Mây Cầu Gỗ - Bình Minh','\"Cây cầu nổi tiếng này được tọa lạc ngay trong khu vực Đồi Chè Cầu Đất (thôn Trường Thọ, xã Trạm Hành), nằm cách trung tâm thành phố Đà Lạt khoảng 25km. Từ trung tâm thành phố các bạn đi theo hướng về khu vực Trại Mát để đến với Đồi Chè Cầu Đất.',40.00,1,'Đồi chè, Đà Lạt, Lâm Đồng',NULL,100),(31,'Da Lat Diocese Cathedral','Nhà thờ chính tòa Đà Lạt là một nhà thờ Công giáo ở Việt Nam. Đây là nhà thờ chính tòa của vị giám mục Giáo phận Đà Lạt, cũng là nhà thờ lớn nhất Đà Lạt, một trong những công trình kiến trúc tiêu biểu và cổ xưa nhất của thành phố này do người Pháp để lại',30.00,1,'15 Đ. Trần Phú, Phường 3, Đà Lạt',NULL,100),(32,'Bao Dai Palace 3','Dinh III, còn gọi là Dinh Bảo Đại, được xây trong khoảng từ năm 1933 đến 1938 là nơi gia đình vua Bảo Đại sinh sống và làm việc ở thành phố Đà Lạt. Dinh III do hai kiến trúc sư người Pháp tên là Paul Veysseyre và Arthur Kruze thiết kế.',20.00,1,'1 Đường Triệu Việt Vương, Phường 4, Đà Lạt',NULL,100);
/*!40000 ALTER TABLE `tours` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tours_location`
--

DROP TABLE IF EXISTS `tours_location`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tours_location` (
  `location_id` int NOT NULL AUTO_INCREMENT,
  `tour_id` int NOT NULL,
  `location_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `latitude` decimal(10,6) NOT NULL,
  `longitude` decimal(10,6) NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`location_id`),
  KEY `Tours_Location_tour_id_fkey` (`tour_id`),
  CONSTRAINT `Tours_Location_tour_id_fkey` FOREIGN KEY (`tour_id`) REFERENCES `tours` (`tour_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tours_location`
--

LOCK TABLES `tours_location` WRITE;
/*!40000 ALTER TABLE `tours_location` DISABLE KEYS */;
/*!40000 ALTER TABLE `tours_location` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `phone` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `role` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'user',
  `preferences` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `isBlocked` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `Users_email_key` (`email`),
  UNIQUE KEY `Users_phone_key` (`phone`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'trung123','levinhtrung1510@gmail.com','$2b$10$FJ2nrObFRQth2ibQTlmmTuOojHTiblwisb5k4CuCyJPr3e93U0q6y','111123','admin',NULL,0),(5,'Tường Huỳnh','tuonghuynh76@gmail.com','$2b$10$TO2323Zt0lnXxa7zvVjOf.yc0fsf/OsRPjNmjLuZd6kKxnIFodTXS','321321321','admin',NULL,0),(6,'tuong123','tuong@gmail.com','$2b$10$1L2WaTvudcqEldzNbfKjwu/mUeqmMlGQu8WX8jflhZAVGNZRvFJse','032142131','admin',NULL,0),(7,'tuong1','tuong1@gmail.com','$2b$10$n6Ot7E4oqR/BoWWYuSqiQOW/MHHSb.HKvHvTNbiTLFq6YcJC75ZFy','321345321','user',NULL,0),(8,'Mystic','tuonghuynh13122001@gmail.com','$2b$10$OVWz.IUzHGQ6bEUxM0.XbebQTG2gmFOvVCTB7j9bd9QS26O35.fRG','32135321','user',NULL,0),(12,'Tuong','tuong123@gmail.com','$2b$10$7YhwbL3.wMPVQEMEimDrlOCr/N2.w7xh5pBogHCchXG8BJMpKor1.','321513433','user',NULL,0),(13,'admin','admin@gmail.com','$2b$10$P0zESYt550q2SQEMi9Lwkufot53O0IOCTPIK2NEP2wvXDPPp1ak32','032143232','admin',NULL,0),(14,'Tuong','tg@gmail.com','$2b$10$WpN3WPxs2E5P7au56lhse.qeUjnlL/6vHpMwXPWedWinHrObxbhF2','321451321','user',NULL,0),(15,'Tuong','tuong1234@gmail.com','$2b$10$PhFq./v0sd4y2C2QS61g6eKaMYAwzqM/D6R4bjodT7.GHU7AdqUA2','3214132132','user',NULL,0);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-05-09 22:04:04
