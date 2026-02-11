-- Mfinanga Electro Shop - Full Relational Schema
-- Includes Users, Products, Categories, Orders, Order Items, Payments, and Admin Management

CREATE DATABASE IF NOT EXISTS electroshop;
USE electroshop;

-- 1. Categories Table
CREATE TABLE IF NOT EXISTS categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Users Table (Customer Profiles)
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    phone VARCHAR(20),
    address TEXT,
    role ENUM('user', 'admin', 'staff') DEFAULT 'user',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 3. Admins Table (Specific Admin Metadata/Logs)
CREATE TABLE IF NOT EXISTS admins (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL UNIQUE,
    privilege_level INT DEFAULT 1, -- 1: Standard, 2: SuperAdmin
    last_login DATETIME,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- 4. Products Table
CREATE TABLE IF NOT EXISTS products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    category_id INT,
    name VARCHAR(255) NOT NULL,
    price DECIMAL(15, 2) NOT NULL,
    stock_quantity INT DEFAULT 10,
    description TEXT,
    specs JSON,
    availability VARCHAR(50) DEFAULT 'In Stock',
    image_url VARCHAR(255) DEFAULT 'pics',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE SET NULL
);

-- 5. Orders Table
CREATE TABLE IF NOT EXISTS orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    fullname VARCHAR(255) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    address TEXT NOT NULL,
    total_amount DECIMAL(15, 2) NOT NULL,
    status ENUM('pending', 'processing', 'shipped', 'delivered', 'cancelled') DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
);

-- 6. Order Items Table
CREATE TABLE IF NOT EXISTS order_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(15, 2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);

-- 7. Payments Table
CREATE TABLE IF NOT EXISTS payments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL UNIQUE,
    payment_method ENUM('mobile_money', 'card', 'bank_transfer', 'cash') NOT NULL,
    transaction_id VARCHAR(100) UNIQUE,
    amount DECIMAL(15, 2) NOT NULL,
    status ENUM('pending', 'completed', 'failed', 'refunded') DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE
);

-- Seed Initial Categories
INSERT IGNORE INTO categories (name) VALUES 
('Drones'), ('Smart Home'), ('Computing'), ('Gaming'), ('Audio'), ('Wearables'), ('Appliances'), ('Security'), ('Accessories'), ('Photography');

-- Seed Admin User (Password: admin123)
INSERT IGNORE INTO users (username, email, password, role) VALUES 
('admin', 'admin@mfinanga.co.tz', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'admin');

-- Seed Mega Catalog (37 Premium Products localized to TZS)
INSERT INTO products (name, price, description, specs, availability, image_url, category_id) VALUES
-- Drones
('SkyMaster 4K Cinema Drone', 3377400.00, 'Professional-grade cinema drone with 3-axis gimbal and 10km range.', '{"Resolution": "4K 60fps", "FlightTime": "45 mins", "GPS": "Dual Band"}', 'In Stock', 'https://images.unsplash.com/photo-1508614589041-895b88991e3e?q=80&w=800', 1),
('Stealth Mini Stealth Drone', 777400.00, 'Ultra-quiet foldable drone for beginners and enthusiasts.', '{"Weight": "249g", "Range": "4km", "Camera": "2.7K"}', 'In Stock', 'https://images.unsplash.com/photo-1507582020474-9a35b7d455d9?q=80&w=800', 1),
-- Smart Home
('HomeCore AI Central Hub', 1297400.00, 'Master controller for all your smart devices with built-in voice assistant.', '{"Connectivity": "Zigbee, Matter, WiFi", "Display": "10-inch Touch", "Security": "Encrypted"}', 'In Stock', 'https://i.pinimg.com/736x/25/79/f2/2579f2e5b42a99f571274cd5a639de41.jpg', 2),
('RoboSweep S9 Vacuum', 1687400.00, 'Self-emptying robot vacuum with LiDAR mapping and mopping.', '{"Suction": "6000Pa", "Nav": "LiDAR 3.0", "AutoDump": "Yes"}', 'Limited Stock', 'https://images.unsplash.com/photo-1518349619113-03114f06ac3a?q=80&w=800', 2),
-- Accessories
('SolarGrid Portable Station', 2337400.00, 'Large capacity 1000Wh portable power for camping and emergencies.', '{"Capacity": "1024Wh", "Outputs": "2 AC, 4 USB, 2 DC", "Solar": "Supports 200W Input"}', 'In Stock', 'https://i.pinimg.com/originals/74/f0/93/74f093f2f6c974838f206ce52d2b13a4.jpg', 9),
('VoltFast Gan Desktop Charger', 179400.00, '140W quad-port GaN charger for MacBook and phones.', '{"Ports": "3x USB-C, 1x USB-A", "Wattage": "140W Max", "Tech": "GaN Fast"}', 'In Stock', 'https://i.pinimg.com/originals/f4/99/0f/f4990f97e8e909d6239e7908f11f63ef.jpg', 9),
-- Computing
('AeroBook Pro 16"', 6497400.00, 'Ultimate workstation with M-class chip and Liquid Retina display.', '{"Storage": "1TB SSD", "RAM": "32GB", "Display": "120Hz ProMotion"}', 'In Stock', 'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?q=80&w=800', 3),
-- Gaming
('Horizon VR Headset X', 1557400.00, 'Wireless standalone VR with mixed-reality capabilities.', '{"Resolution": "4K per eye", "Tracking": "Inside-out", "Refresh": "90Hz"}', 'Limited Stock', 'https://images.unsplash.com/photo-1622979135225-d2ba269cf1ac?q=80&w=800', 4),
('Apex Mechanical Keyboard', 491400.00, 'Hot-swappable tactile switches with custom RGB lighting.', '{"Switch": "Gateron Brown", "Build": "CNC Aluminum", "Mode": "Wireless/Wired"}', 'In Stock', 'https://images.unsplash.com/photo-1595225476474-87563907a212?q=80&w=800', 4),
-- Audio
('SonicBlast Room Speaker', 907400.00, '360-degree immersive sound with deep resonance bass.', '{"Connection": "WiFi, Bluetooth 5.2", "Voice": "Alexa Built-in", "Tuning": "Auto-Room EQ"}', 'In Stock', 'https://images.unsplash.com/photo-1545454675-3531b543be5d?q=80&w=800', 5),
-- Wearables
('SleepSync Smart Ring', 777400.00, 'Minimalist Ring for sleep, heart rate, and activity tracking.', '{"Material": "Titanium", "Battery": "5 days", "Weight": "4g"}', 'In Stock', 'https://i.pinimg.com/originals/8f/e0/ed/8fe0edd26f7dcc735bda5dfd8fb9c0a3.jpg', 6),
-- Photography
('Lumina Studio Ring Light', 413400.00, 'Large 19-inch ring light with adjustable color temperature for creators.', '{"CRI": "96+", "Kelvin": "3200-5600K", "Remote": "Wireless"}', 'In Stock', 'https://images.unsplash.com/photo-1552168324-d612d77725e3?q=80&w=800', 10),
('VlogMaster Stabilizer', 517400.00, 'Professional 3-axis stabilizer for smartphones and cameras.', '{"Battery": "12 hours", "Modes": "Inception, FPV, Pan"}', 'In Stock', 'https://images.unsplash.com/photo-1582201942988-13e60e4556ee?q=80&w=800', 10),
-- Wearables
('Quantum Smartwatch Core', 413400.00, 'Essential health stats and notifications in a sleek design.', '{"Battery": "10 days", "Screen": "LCD"}', 'In Stock', 'https://images.unsplash.com/photo-1508685096489-7aacd43bd3b1?q=80&w=800', 6),
-- Mobile
('Titan Mobile Neo', 1427400.00, 'High performance at an accessible value point.', '{"RAM": "8GB", "Storage": "128GB", "Screen": "6.1 inch OLED"}', 'In Stock', 'https://images.unsplash.com/photo-1556656793-062ff98782ee?q=80&w=800', NULL),
-- Appliances
('Arctic Frost Slim Fridge', 3377400.00, 'Premium cooling for compact modern kitchens.', '{"Capacity": "320L", "Depth": "Counter-depth"}', 'In Stock', 'https://images.unsplash.com/photo-1584622781564-1d987f7333c1?q=80&w=800', 7),
-- Gaming
('NextGen PlayStation Pro', 1817400.00, 'Enhanced 4K gaming performance and ray-tracing.', '{"Storage": "2TB SSD", "GPU": "Pro Optimized"}', 'Out of Stock', 'https://images.unsplash.com/photo-1606144042614-b2417e99c4ec?q=80&w=800', 4),
-- Security
('ShieldGuard Smart Doorbell', 517400.00, '2K HDR video doorbell with person detection and two-way talk.', '{"FOV": "160 Degree", "Storage": "Local/Cloud", "Battery": "6 months"}', 'In Stock', 'https://images.unsplash.com/photo-1518113429302-3ac55e8c156f?q=80&w=800', 8),
('SecureTouch Smart Lock', 647400.00, 'Biometric fingerprint deadbolt with remote access and PIN codes.', '{"Unlock": "Finger, Tech, App, Key", "Battery": "1 year", "Finish": "Satin Nickel"}', 'In Stock', 'https://images.unsplash.com/photo-1558210865-c45446755a76?q=80&w=800', 8),
('Sentinel 4-Cam Security Sys', 2337400.00, '4K ultra-HD wired security cameras with color night vision.', '{"Channels": "8", "HDD": "2TB", "Weatherproof": "IP67"}', 'In Stock', 'https://images.unsplash.com/photo-1557597774-9d2739f85a76?q=80&w=800', 8),
-- Audio
('VocalStream X Studio Mic', 777400.00, 'Professional USB-C condenser microphone for podcasting and streaming.', '{"Pattern": "Cardioid", "BitRate": "24-bit", "RGB": "Yes"}', 'In Stock', 'https://images.unsplash.com/photo-1590602847861-f357a9332bbc?q=80&w=800', 5),
('AudioRef Studio Monitors', 1167400.00, 'Clear and accurate reference speakers for audio production.', '{"Woofer": "5.25 inch", "Power": "70W x 2", "In": "XLR, TRS"}', 'In Stock', 'https://images.unsplash.com/photo-1589003077984-894e133dabab?q=80&w=800', 5),
-- Wellness
('ScanWay Smart Body Scale', 205400.00, 'Bluetooth body composition scale tracks 13 metrics via app.', '{"Metrics": "Weight, BMI, Muscle", "Units": "kg/lb", "Sync": "Apple/Google Health"}', 'In Stock', 'https://images.unsplash.com/photo-1591123720164-de1348028a82?q=80&w=800', NULL),
('Recharge Percussion Gun', 387400.00, 'Powerful massage tool for muscle recovery and tension relief.', '{"Speeds": "20", "Heads": "6", "Battery": "4 hours"}', 'In Stock', 'https://images.unsplash.com/photo-1627384113743-6bd5a479fffd?q=80&w=800', NULL),
-- Computing
('Horizon 49" Curved Display', 3117400.00, 'Massive ultra-wide gaming monitor with QLED technology.', '{"Curvature": "1000R", "Refresh": "240Hz", "PBP": "Yes"}', 'Limited Stock', 'https://images.unsplash.com/photo-1527443224154-c4a3942d3acf?q=80&w=800', 3),
('Ghost RGB Gaming Mouse', 231400.00, 'Ultra-lightweight wireless mouse with pro-grade sensor.', '{"DPI": "26000", "Weight": "55g", "Switches": "Optical"}', 'In Stock', 'https://images.unsplash.com/photo-1615663248861-40c2466ba41e?q=80&w=800', 4),
('Throne Pro Gaming Chair', 1037400.00, 'Ergonomic racing-style chair with memory foam and 4D armrests.', '{"Tilt": "165 Degree", "Load": "150kg", "Fabric": "Breathable PU"}', 'In Stock', 'https://images.unsplash.com/photo-1598550476439-6847785fce6e?q=80&w=800', 4),
-- Smart Home
('PureAir H13 Filter Hub', 647400.00, 'Smart air purifier with HEPA H13 filtration for large spaces.', '{"CADR": "400", "Sensors": "PM2.5", "WiFi": "Yes"}', 'In Stock', 'https://images.unsplash.com/photo-1614725055042-30e797d022e3?q=80&w=800', 2),
('Aura RGB Smart Strip', 127400.00, 'Dynamic gradient light strip with music sync and voice control.', '{"Length": "5m", "LEDs": "IC Individually Addressable", "App": "HomeCore Connect"}', 'In Stock', 'https://images.unsplash.com/photo-1563124417-6fc03c401309?q=80&w=800', 2),
('GlowSphere Ambient Lamp', 205400.00, 'Smart spherical lamp for colorful ambient lighting.', '{"Colors": "16M+", "Port": "Internal Battery", "Modes": "Scene Sync"}', 'In Stock', 'https://images.unsplash.com/photo-1542728928-1413ed0081d6?q=80&w=800', 2),
-- Accessories
('DataBolt 2TB Portable SSD', 465400.00, 'Rugged ultra-fast external storage with USB-C 3.2 Gen 2.', '{"Speed": "1050MB/s", "Drop": "2m Resistance", "Enc": "AES 256-bit"}', 'In Stock', 'https://images.unsplash.com/photo-1591405351990-4726e331f141?q=80&w=800', 9),
-- Photography
('ArtFlow Pro Graphics Tablet', 907400.00, '13-inch pen display with high color accuracy for artists.', '{"Gamut": "120% sRGB", "Pen": "Battery-free, 8k Pressure", "Size": "13.3 inch"}', 'In Stock', 'https://images.unsplash.com/photo-1558655146-d09347e92766?q=80&w=800', 10),
-- Computing
('DualVision Duo Laptop', 5717400.00, 'Premium laptop with dual OLED displays for multitasking.', '{"Display": "14 inch 2.8K x 2", "CPU": "Intel i9", "RAM": "32GB"}', 'In Stock', 'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?q=80&w=800', 3),
-- Gaming
('RetroPlay Pocket Console', 335400.00, 'Handheld console with thousands of classic games pre-loaded.', '{"Screen": "3.5 inch IPS", "Battery": "6 hours", "Games": "5000+"}', 'In Stock', 'https://images.unsplash.com/photo-1526509867162-5b0c0ed1b4b6?q=80&w=800', 4),
-- Audio
('DreamTune Sleep Buds', 517400.00, 'Noise-masking sleep buds with soothing sounds and smart alarm.', '{"Battery": "10 hours", "Charging": "Case 3x", "Fit": "Ultra-Low Profile"}', 'In Stock', 'https://images.unsplash.com/photo-1590658268037-6bf12165a8df?q=80&w=800', 5),
-- Computing
('NetForce WiFi 6E Router', 777400.00, 'Tri-band high-speed router for gaming and future-proof home mesh.', '{"Speed": "AXE11000", "Ports": "2.5G WAN", "Coverage": "3500 sq ft"}', 'In Stock', 'https://images.unsplash.com/photo-1544197150-b99a580bb7a8?q=80&w=800', 3),
-- Audio
('VinylPro Modern Turntable', 1557400.00, 'Direct-drive record player with Bluetooth out and USB recording.', '{"Platter": "Aluminum", "Cartridge": "Audio-Technica", "Preamp": "Built-in"}', 'In Stock', 'https://images.unsplash.com/photo-1603048588665-791ca8aea617?q=80&w=800', 5);
