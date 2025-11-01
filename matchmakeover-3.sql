-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Jul 26, 2025 at 12:19 PM
-- Server version: 10.4.28-MariaDB
-- PHP Version: 8.1.17

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `matchmakeover`
--

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

CREATE TABLE `categories` (
  `id` int(11) NOT NULL,
  `name` text NOT NULL,
  `image` text NOT NULL,
  `gender` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `categories`
--

INSERT INTO `categories` (`id`, `name`, `image`, `gender`) VALUES
(1, 'Shirts', 'uploads/male/shirts.jpeg', 'male'),
(72, 't-shirts', 'uploads/female/pngimg.com_-_tshirt_PNG5433-removebg-preview.png', 'female'),
(74, 'T-Shirt', 'uploads/male/download-removebg-preview_(11).png', 'male'),
(75, 'Coats', 'uploads/male/download-removebg-preview_(12).png', 'male'),
(78, 'jackets', 'uploads/male/jackets.jpeg', 'male'),
(80, 'Blazer', 'uploads/female/g2.jpeg', 'female'),
(91, 'western', 'uploads/female/western.png', 'female');

-- --------------------------------------------------------

--
-- Table structure for table `colours`
--

CREATE TABLE `colours` (
  `id` int(11) NOT NULL,
  `name` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `colours`
--

INSERT INTO `colours` (`id`, `name`) VALUES
(1, 'Pink'),
(2, 'Black'),
(3, 'Blue'),
(4, 'White'),
(5, 'Red'),
(6, 'Green'),
(13, 'mint'),
(16, 'Yellow'),
(17, 'Gray'),
(18, 'Purple'),
(19, 'Brown'),
(24, 'Orange'),
(38, 'Ss'),
(39, 'Gold');

-- --------------------------------------------------------

--
-- Table structure for table `genders`
--

CREATE TABLE `genders` (
  `id` int(11) NOT NULL,
  `name` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `genders`
--

INSERT INTO `genders` (`id`, `name`) VALUES
(1, 'Male'),
(2, 'Female'),
(27, 'kids');

-- --------------------------------------------------------

--
-- Table structure for table `occasions`
--

CREATE TABLE `occasions` (
  `id` int(11) NOT NULL,
  `name` text NOT NULL,
  `image` text CHARACTER SET armscii8 COLLATE armscii8_general_ci NOT NULL,
  `image2` text NOT NULL,
  `gender` text NOT NULL,
  `color` varchar(50) NOT NULL,
  `category` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `occasions`
--

INSERT INTO `occasions` (`id`, `name`, `image`, `image2`, `gender`, `color`, `category`) VALUES
(94, 'formal', 'uploads/occasions/pink5.jpeg', 'uploads/occasions/pin5.jpeg', 'female', 'pink', 'blazer'),
(96, 'Casual', 'uploads/occasions/4C19EC43-08CC-4AC9-9C42-62A6037A13F1-image.jpg', 'uploads/occasions/4C19EC43-08CC-4AC9-9C42-62A6037A13F1-image2.jpg', 'male', 'blue', 't-shirt'),
(97, 'Casual', 'uploads/occasions/3D4D9C0A-1680-434B-9344-CBBDCF496694-image.jpg', 'uploads/occasions/3D4D9C0A-1680-434B-9344-CBBDCF496694-image2.jpg', 'male', 'black', 't-shirt'),
(98, 'Casual', 'uploads/occasions/DAAF8A0B-19B6-4B20-863F-E7ACAF52FC59-image.jpg', 'uploads/occasions/DAAF8A0B-19B6-4B20-863F-E7ACAF52FC59-image2.jpg', 'male', 'black', 'shirt'),
(99, 'Party', 'uploads/occasions/DAE34D1E-0F73-47E8-BAD2-98819633CBFA-image.jpg', 'uploads/occasions/DAE34D1E-0F73-47E8-BAD2-98819633CBFA-image2.jpg', 'male', 'black', 'blazer'),
(100, 'Casual', 'uploads/occasions/40733F58-A8E0-4CBA-B00C-39D449719DA7-image.jpg', 'uploads/occasions/40733F58-A8E0-4CBA-B00C-39D449719DA7-image2.jpg', 'male', 'blue', 'shirt'),
(101, 'Party', 'uploads/occasions/4C8B03EC-DDD9-4C52-9514-56A459608634-image.jpg', 'uploads/occasions/4C8B03EC-DDD9-4C52-9514-56A459608634-image2.jpg', 'male', 'blue', 'blazer'),
(102, 'Casual', 'uploads/occasions/09E72536-B713-40C7-8708-35CB8CDA6CD9-image.jpg', 'uploads/occasions/09E72536-B713-40C7-8708-35CB8CDA6CD9-image2.jpg', 'male', 'pink', 't-shirt'),
(103, 'Party', 'uploads/occasions/E91F5E7D-2A27-48A0-8819-C087D1BA04A0-image.jpg', 'uploads/occasions/E91F5E7D-2A27-48A0-8819-C087D1BA04A0-image2.jpg', 'female', 'pink', 'shirt'),
(104, 'Formal', 'uploads/occasions/BFFB7F12-5F91-4810-9C72-07B883686E6B-image.jpg', 'uploads/occasions/BFFB7F12-5F91-4810-9C72-07B883686E6B-image2.jpg', 'male', 'black', 'shirt'),
(105, 'Formal', 'uploads/occasions/41F43DB0-21A3-4B08-BF59-3A60DB439344-image.jpg', 'uploads/occasions/41F43DB0-21A3-4B08-BF59-3A60DB439344-image2.jpg', 'male', 'black', 't-shirt'),
(106, 'Party', 'uploads/occasions/0907D717-F8FA-4CD0-9ED9-D7622E36C2BC-image.jpg', 'uploads/occasions/0907D717-F8FA-4CD0-9ED9-D7622E36C2BC-image2.jpg', 'male', 'blue', 'jeans'),
(107, 'Casual', 'uploads/occasions/B68ECD7F-2FD0-46D1-AA17-637092D350E4-image.jpg', 'uploads/occasions/B68ECD7F-2FD0-46D1-AA17-637092D350E4-image2.jpg', 'male', 'white', 'shirt'),
(108, 'Formal', 'uploads/occasions/3CB68DD9-74BE-48EF-A6D3-9A143936627D-image.jpg', 'uploads/occasions/3CB68DD9-74BE-48EF-A6D3-9A143936627D-image2.jpg', 'male', 'white', 'shirt'),
(109, 'Casual', 'uploads/occasions/FEA381CC-FDAB-4167-919C-687390AA62CA-image.jpg', 'uploads/occasions/FEA381CC-FDAB-4167-919C-687390AA62CA-image2.jpg', 'male', 'white', 't-shirt'),
(110, 'Formal', 'uploads/occasions/F01D33FD-00FC-458D-AB64-50C74A65A090-image.jpg', 'uploads/occasions/F01D33FD-00FC-458D-AB64-50C74A65A090-image2.jpg', 'male', 'white', 'blazer'),
(111, 'Party', 'uploads/occasions/3386A90A-FB76-49C1-9122-1C1B10445ECC-image.jpg', 'uploads/occasions/3386A90A-FB76-49C1-9122-1C1B10445ECC-image2.jpg', 'male', 'white', 'jeans'),
(112, 'Formal', 'uploads/occasions/0EA89AB9-9A30-4B03-B694-BF670ACEABDD-image.jpg', 'uploads/occasions/0EA89AB9-9A30-4B03-B694-BF670ACEABDD-image2.jpg', 'female', 'white', 'shirt'),
(114, 'Festival', 'uploads/occasions/63F3875C-0ACE-4009-BF8C-4D4D7B906AD1-image.jpg', 'uploads/occasions/63F3875C-0ACE-4009-BF8C-4D4D7B906AD1-image2.jpg', 'male', 'gold', 'cargo pants');

-- --------------------------------------------------------

--
-- Table structure for table `product`
--

CREATE TABLE `product` (
  `id` int(11) NOT NULL,
  `genderid` int(11) NOT NULL,
  `categoriesid` int(11) NOT NULL,
  `occasionsid` int(11) NOT NULL,
  `coloursid` int(11) NOT NULL,
  `images` longtext NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `product`
--

INSERT INTO `product` (`id`, `genderid`, `categoriesid`, `occasionsid`, `coloursid`, `images`) VALUES
(1, 2, 66, 1, 5, ''),
(2, 1, 2, 3, 3, ''),
(3, 1, 2, 3, 3, ''),
(4, 1, 4, 4, 4, ''),
(5, 2, 68, 2, 3, ''),
(6, 2, 67, 5, 6, ''),
(9, 1, 1, 63, 3, '[]'),
(10, 1, 1, 65, 3, '[]');

-- --------------------------------------------------------

--
-- Table structure for table `signup`
--

CREATE TABLE `signup` (
  `id` int(11) NOT NULL,
  `name` text NOT NULL,
  `username` text NOT NULL,
  `email` text NOT NULL,
  `password` text NOT NULL,
  `role` enum('user','admin','','','') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `signup`
--

INSERT INTO `signup` (`id`, `name`, `username`, `email`, `password`, `role`) VALUES
(1, 'John Doe', 'johndoe', 'johndoe@example.com', '$2y$10$W/ex7Xf8ONxN5XlLe/W.xOlo8ZRoYth.g7y4.GUC3OlWQVfUutu8.', 'user'),
(2, 'John Doe', 'ha', 'harini@123.com', '$2y$10$DC33I2tmNIwpBMckON8kfe7EWbp9k6mP4jVv1GYTQT1h3Ws5VepyS', 'admin'),
(3, 'harinins', 'harini', 'harini14@gmail.com', '123456789', 'admin'),
(6, 'test', 'test', 'test@gmail.com', '1234', 'user'),
(7, 'harinin', 'ns', 'harini@gmail.com', '$2y$10$63XCtHg7qs/fijKjjK.VGeuvVwVOkLpPAVY8tHi1C1AkOFqrziNJi', 'user'),
(8, 'ns', 'n', 'ns@gmail.com', '$2y$10$RcuLd7kWNYR1lg2CiLMwP.NiCw9OjvIzCy8Qszrv4q/SkPol8zMri', 'user'),
(9, 'ns', 'h', 'ns1@gmail.com', '$2y$10$rLp2jiI7tYGUGbqKlTnw8.ld7mI/IEXK4hj/regk3ckq8r6aNy61S', 'user'),
(10, 'h123', 'ha123', 'h1@gmail.com', '$2y$10$z0iLyrB/my7pV1eFcaWzoOdhqdfEGE9okxDuQuehXnbP54bP8cYKG', 'user'),
(11, 'harinin', 'admin', 'admin@gmail.com', '$2y$10$8cz/C4yWwfx3rZO4tUjRFeoI9H2v57bTk42KTtraRzRfxnTvPIOkK', 'admin'),
(12, 'harinin', 'user', 'user@gmail.com', '$2y$10$/jTzh74iGZmm5Naqm4YWp.d8IfZeZLNhGmn7AaNIK1eotYWbvcu5.', 'user'),
(13, 'haaa', 'hhh', 'harinin496@gmail.com', '$2y$10$DnfPL3xQpEbDmQkkJCke8.hx2D9bLwH5QjKUlQTfFJd1Pj.cLvt/m', 'user'),
(14, 'hhh', 'ssss', 'hhhh123@gmail.com', '$2y$10$TmK4ML2PwdJiv2OrvR4bdOWY/CGZ1IsOptZrplSvwPKND/VpJ64de', 'user'),
(15, 'sssss', 'sasas', 'sss@gmail.com', '$2y$10$bVR9/OHy4dlVVqxHVXNkLeybNbT/mDsdN8UZciXa5XCRI/VuY3zY6', 'user'),
(16, 'hhhhhhhh', 'kkkkkk', 'kkk@gmail.com', '$2y$10$5227jeGvYb5..ZPqUHWBRePt3sE/5itN4aOCtEWtCne6JZ5Bf3Spe', 'user'),
(17, 'harini', 'nandakumar', 'harinin@gmail.com', '$2y$10$TBGsEJfgAoq8Ai6o6Z7nHePELol4UdAo3ZK6r2Cs8aAM6vqI7TB52', 'user'),
(18, 'sundari', 'nanda', 'san@gmail.com', '$2y$10$5vnZpxs9G65vDo8/9Q.1uOAMIsIgltwX3VtrvBzVyLwP7NQDbCQs2', 'user'),
(19, 'harinii', 'kuttiii', 'kutti@gmail.com', '$2y$10$S0ZAMBG.vUKPSeETJ1fliOAGB6q83TVkHVTF4k8CJ1x0L9SRPjQHW', 'user'),
(20, 'harini', 'harini95', 'kutti7@gmail.com', '$2y$10$Hjvg4GHTHajHlY483TcnWuW8bj05VauyTtCxeKbgUYhDoiBX41OUq', 'user'),
(21, 'tamizh', 'tamizh89', 'kutti745@gmail.com', '$2y$10$stADNGXQ3hhVJVr9qB3U8e5pzkVQlYxZX7bJuo2aJmkjpdrb.ZGNe', 'admin'),
(22, 'Santhosh Nandakumar', 'Santhosh', 'Santhosh@gmail.com', '$2y$10$.h6rr/SCj9MMZ.B5w6N2KeWC4VHSRcqj43PPug2bScryWSrqduGQG', 'user'),
(23, 'Sundari Nandakumar', 'Sundari', 'Sundhari12@gmail.com', '$2y$10$3Xy3QixZGFUarazH7Ayht.K6Aj6Fnm10pJx0YmjIuA9MXWVvE3mkK', 'admin');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `colours`
--
ALTER TABLE `colours`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `genders`
--
ALTER TABLE `genders`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `occasions`
--
ALTER TABLE `occasions`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `product`
--
ALTER TABLE `product`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `signup`
--
ALTER TABLE `signup`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `categories`
--
ALTER TABLE `categories`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=97;

--
-- AUTO_INCREMENT for table `colours`
--
ALTER TABLE `colours`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=40;

--
-- AUTO_INCREMENT for table `genders`
--
ALTER TABLE `genders`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;

--
-- AUTO_INCREMENT for table `occasions`
--
ALTER TABLE `occasions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=115;

--
-- AUTO_INCREMENT for table `product`
--
ALTER TABLE `product`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `signup`
--
ALTER TABLE `signup`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
