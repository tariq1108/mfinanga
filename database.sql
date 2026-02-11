-- Create Database
CREATE DATABASE IF NOT EXISTS electroshop;
USE electroshop;

-- Users Table
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role ENUM('user', 'admin') DEFAULT 'user',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Products Table
CREATE TABLE IF NOT EXISTS products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    price DECIMAL(15, 2) NOT NULL,
    description TEXT,
    specs JSON,
    availability VARCHAR(50) DEFAULT 'In Stock',
    image_url VARCHAR(255) DEFAULT 'pics',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Orders Table
CREATE TABLE IF NOT EXISTS orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    fullname VARCHAR(255) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    address TEXT NOT NULL,
    total_amount DECIMAL(15, 2) NOT NULL,
    status ENUM('pending', 'shipped', 'delivered', 'cancelled') DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
);

-- Order Items Table
CREATE TABLE IF NOT EXISTS order_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(15, 2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);

-- Seed Mega Catalog (37 Premium Products localized to TZS)
INSERT INTO products (name, price, description, specs, availability, image_url) VALUES
-- 1-17: Original Premium Set
('SkyMaster 4K Cinema Drone', 3377400.00, 'Professional-grade cinema drone with 3-axis gimbal and 10km range.', '{"Resolution": "4K 60fps", "FlightTime": "45 mins", "GPS": "Dual Band"}', 'In Stock', 'https://images.unsplash.com/photo-1508614589041-895b88991e3e?q=80&w=800'),
('Stealth Mini Stealth Drone', 777400.00, 'Ultra-quiet foldable drone for beginners and enthusiasts.', '{"Weight": "249g", "Range": "4km", "Camera": "2.7K"}', 'In Stock', 'https://images.unsplash.com/photo-1507582020474-9a35b7d455d9?q=80&w=800'),
('HomeCore AI Central Hub', 1297400.00, 'Master controller for all your smart devices with built-in voice assistant.', '{"Connectivity": "Zigbee, Matter, WiFi", "Display": "10-inch Touch", "Security": "Encrypted"}', 'In Stock', 'https://images.unsplash.com/photo-1589156229687-496a31ad1d1f?q=80&w=800'),
('RoboSweep S9 Vacuum', 1687400.00, 'Self-emptying robot vacuum with LiDAR mapping and mopping.', '{"Suction": "6000Pa", "Nav": "LiDAR 3.0", "AutoDump": "Yes"}', 'Limited Stock', 'https://images.unsplash.com/photo-1518349619113-03114f06ac3a?q=80&w=800'),
('SolarGrid Portable Station', 2337400.00, 'Large capacity 1000Wh portable power for camping and emergencies.', '{"Capacity": "1024Wh", "Outputs": "2 AC, 4 USB, 2 DC", "Solar": "Supports 200W Input"}', 'In Stock', 'https://images.unsplash.com/photo-1621905251189-08b45d6a269e?q=80&w=800'),
('VoltFast Gan Desktop Charger', 179400.00, '140W quad-port GaN charger for MacBook and phones.', '{"Ports": "3x USB-C, 1x USB-A", "Wattage": "140W Max", "Tech": "GaN Fast"}', 'In Stock', 'https://images.unsplash.com/photo-1606208427954-aa8319c4815e?q=80&w=800'),
('AeroBook Pro 16"', 6497400.00, 'Ultimate workstation with M-class chip and Liquid Retina display.', '{"Storage": "1TB SSD", "RAM": "32GB", "Display": "120Hz ProMotion"}', 'In Stock', 'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?q=80&w=800'),
('Horizon VR Headset X', 1557400.00, 'Wireless standalone VR with mixed-reality capabilities.', '{"Resolution": "4K per eye", "Tracking": "Inside-out", "Refresh": "90Hz"}', 'Limited Stock', 'https://images.unsplash.com/photo-1622979135225-d2ba269cf1ac?q=80&w=800'),
('Apex Mechanical Keyboard', 491400.00, 'Hot-swappable tactile switches with custom RGB lighting.', '{"Switch": "Gateron Brown", "Build": "CNC Aluminum", "Mode": "Wireless/Wired"}', 'In Stock', 'https://images.unsplash.com/photo-1595225476474-87563907a212?q=80&w=800'),
('SonicBlast Room Speaker', 907400.00, '360-degree immersive sound with deep resonance bass.', '{"Connection": "WiFi, Bluetooth 5.2", "Voice": "Alexa Built-in", "Tuning": "Auto-Room EQ"}', 'In Stock', 'https://images.unsplash.com/photo-1545454675-3531b543be5d?q=80&w=800'),
('SleepSync Smart Ring', 777400.00, 'Minimalist Ring for sleep, heart rate, and activity tracking.', '{"Material": "Titanium", "Battery": "5 days", "Weight": "4g"}', 'In Stock', 'https://images.unsplash.com/photo-1631672828448-f9b604022647?q=80&w=800'),
('Lumina Studio Ring Light', 413400.00, 'Large 19-inch ring light with adjustable color temperature for creators.', '{"CRI": "96+", "Kelvin": "3200-5600K", "Remote": "Wireless"}', 'In Stock', 'https://images.unsplash.com/photo-1552168324-d612d77725e3?q=80&w=800'),
('VlogMaster Stabilizer', 517400.00, 'Professional 3-axis stabilizer for smartphones and cameras.', '{"Battery": "12 hours", "Modes": "Inception, FPV, Pan"}', 'In Stock', 'https://images.unsplash.com/photo-1582201942988-13e60e4556ee?q=80&w=800'),
('Quantum Smartwatch Core', 413400.00, 'Essential health stats and notifications in a sleek design.', '{"Battery": "10 days", "Screen": "LCD"}', 'In Stock', 'https://images.unsplash.com/photo-1508685096489-7aacd43bd3b1?q=80&w=800'),
('Titan Mobile Neo', 1427400.00, 'High performance at an accessible value point.', '{"RAM": "8GB", "Storage": "128GB", "Screen": "6.1 inch OLED"}', 'In Stock', 'https://images.unsplash.com/photo-1556656793-062ff98782ee?q=80&w=800'),
('Arctic Frost Slim Fridge', 3377400.00, 'Premium cooling for compact modern kitchens.', '{"Capacity": "320L", "Depth": "Counter-depth"}', 'In Stock', 'https://images.unsplash.com/photo-1584622781564-1d987f7333c1?q=80&w=800'),
('NextGen PlayStation Pro', 1817400.00, 'Enhanced 4K gaming performance and ray-tracing.', '{"Storage": "2TB SSD", "GPU": "Pro Optimized"}', 'Out of Stock', 'https://images.unsplash.com/photo-1606144042614-b2417e99c4ec?q=80&w=800'),
-- 18-37: 20 New Massive Expansion Products
('ShieldGuard Smart Doorbell', 517400.00, '2K HDR video doorbell with person detection and two-way talk.', '{"FOV": "160 Degree", "Storage": "Local/Cloud", "Battery": "6 months"}', 'In Stock', 'https://images.unsplash.com/photo-1518113429302-3ac55e8c156f?q=80&w=800'),
('SecureTouch Smart Lock', 647400.00, 'Biometric fingerprint deadbolt with remote access and PIN codes.', '{"Unlock": "Finger, Tech, App, Key", "Battery": "1 year", "Finish": "Satin Nickel"}', 'In Stock', 'https://images.unsplash.com/photo-1558210865-c45446755a76?q=80&w=800'),
('Sentinel 4-Cam Security Sys', 2337400.00, '4K ultra-HD wired security cameras with color night vision.', '{"Channels": "8", "HDD": "2TB", "Weatherproof": "IP67"}', 'In Stock', 'https://images.unsplash.com/photo-1557597774-9d2739f85a76?q=80&w=800'),
('VocalStream X Studio Mic', 777400.00, 'Professional USB-C condenser microphone for podcasting and streaming.', '{"Pattern": "Cardioid", "BitRate": "24-bit", "RGB": "Yes"}', 'In Stock', 'https://images.unsplash.com/photo-1590602847861-f357a9332bbc?q=80&w=800'),
('AudioRef Studio Monitors', 1167400.00, 'Clear and accurate reference speakers for audio production.', '{"Woofer": "5.25 inch", "Power": "70W x 2", "In": "XLR, TRS"}', 'In Stock', 'https://images.unsplash.com/photo-1589003077984-894e133dabab?q=80&w=800'),
('ScanWay Smart Body Scale', 205400.00, 'Bluetooth body composition scale tracks 13 metrics via app.', '{"Metrics": "Weight, BMI, Muscle", "Units": "kg/lb", "Sync": "Apple/Google Health"}', 'In Stock', 'https://images.unsplash.com/photo-1591123720164-de1348028a82?q=80&w=800'),
('Recharge Percussion Gun', 387400.00, 'Powerful massage tool for muscle recovery and tension relief.', '{"Speeds": "20", "Heads": "6", "Battery": "4 hours"}', 'In Stock', 'https://images.unsplash.com/photo-1627384113743-6bd5a479fffd?q=80&w=800'),
('Horizon 49" Curved Display', 3117400.00, 'Massive ultra-wide gaming monitor with QLED technology.', '{"Curvature": "1000R", "Refresh": "240Hz", "PBP": "Yes"}', 'Limited Stock', 'https://images.unsplash.com/photo-1527443224154-c4a3942d3acf?q=80&w=800'),
('Ghost RGB Gaming Mouse', 231400.00, 'Ultra-lightweight wireless mouse with pro-grade sensor.', '{"DPI": "26000", "Weight": "55g", "Switches": "Optical"}', 'In Stock', 'https://images.unsplash.com/photo-1615663248861-40c2466ba41e?q=80&w=800'),
('Throne Pro Gaming Chair', 1037400.00, 'Ergonomic racing-style chair with memory foam and 4D armrests.', '{"Tilt": "165 Degree", "Load": "150kg", "Fabric": "Breathable PU"}', 'In Stock', 'https://images.unsplash.com/photo-1598550476439-6847785fce6e?q=80&w=800'),
('PureAir H13 Filter Hub', 647400.00, 'Smart air purifier with HEPA H13 filtration for large spaces.', '{"CADR": "400", "Sensors": "PM2.5", "WiFi": "Yes"}', 'In Stock', 'https://images.unsplash.com/photo-1614725055042-30e797d022e3?q=80&w=800'),
('Aura RGB Smart Strip', 127400.00, 'Dynamic gradient light strip with music sync and voice control.', '{"Length": "5m", "LEDs": "IC Individually Addressable", "App": "HomeCore Connect"}', 'In Stock', 'https://images.unsplash.com/photo-1563124417-6fc03c401309?q=80&w=800'),
('GlowSphere Ambient Lamp', 205400.00, 'Smart spherical lamp for colorful ambient lighting.', '{"Colors": "16M+", "Port": "Internal Battery", "Modes": "Scene Sync"}', 'In Stock', 'https://images.unsplash.com/photo-1542728928-1413ed0081d6?q=80&w=800'),
('DataBolt 2TB Portable SSD', 465400.00, 'Rugged ultra-fast external storage with USB-C 3.2 Gen 2.', '{"Speed": "1050MB/s", "Drop": "2m Resistance", "Enc": "AES 256-bit"}', 'In Stock', 'https://images.unsplash.com/photo-1591405351990-4726e331f141?q=80&w=800'),
('ArtFlow Pro Graphics Tablet', 907400.00, '13-inch pen display with high color accuracy for artists.', '{"Gamut": "120% sRGB", "Pen": "Battery-free, 8k Pressure", "Size": "13.3 inch"}', 'In Stock', 'https://images.unsplash.com/photo-1558655146-d09347e92766?q=80&w=800'),
('DualVision Duo Laptop', 5717400.00, 'Premium laptop with dual OLED displays for multitasking.', '{"Display": "14 inch 2.8K x 2", "CPU": "Intel i9", "RAM": "32GB"}', 'In Stock', 'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?q=80&w=800'),
('RetroPlay Pocket Console', 335400.00, 'Handheld console with thousands of classic games pre-loaded.', '{"Screen": "3.5 inch IPS", "Battery": "6 hours", "Games": "5000+"}', 'In Stock', 'https://images.unsplash.com/photo-1526509867162-5b0c0ed1b4b6?q=80&w=800'),
('DreamTune Sleep Buds', 517400.00, 'Noise-masking sleep buds with soothing sounds and smart alarm.', '{"Battery": "10 hours", "Charging": "Case 3x", "Fit": "Ultra-Low Profile"}', 'In Stock', 'https://images.unsplash.com/photo-1590658268037-6bf12165a8df?q=80&w=800'),
('NetForce WiFi 6E Router', 777400.00, 'Tri-band high-speed router for gaming and future-proof home mesh.', '{"Speed": "AXE11000", "Ports": "2.5G WAN", "Coverage": "3500 sq ft"}', 'In Stock', 'https://images.unsplash.com/photo-1544197150-b99a580bb7a8?q=80&w=800'),
('VinylPro Modern Turntable', 1557400.00, 'Direct-drive record player with Bluetooth out and USB recording.', '{"Platter": "Aluminum", "Cartridge": "Audio-Technica", "Preamp": "Built-in"}', 'In Stock', 'https://images.unsplash.com/photo-1603048588665-791ca8aea617?q=80&w=800');
