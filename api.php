<?php
// api.php
require_once 'config.php';
header('Content-Type: application/json');

$method = $_SERVER['REQUEST_METHOD'];
$action = $_GET['action'] ?? '';

switch ($action) {
    case 'getProducts':
        $stmt = $pdo->query("SELECT * FROM products");
        echo json_encode($stmt->fetchAll());
        break;

    case 'addProduct':
        if ($method === 'POST') {
            $data = json_decode(file_get_contents('php://input'), true);
            $stmt = $pdo->prepare("INSERT INTO products (name, price, description, specs, availability) VALUES (?, ?, ?, ?, ?)");
            $stmt->execute([$data['name'], $data['price'], $data['description'], json_encode($data['specs']), $data['availability']]);
            echo json_encode(['success' => true, 'id' => $pdo->lastInsertId()]);
        }
        break;

    case 'removeProduct':
        if ($method === 'POST') {
            $data = json_decode(file_get_contents('php://input'), true);
            $stmt = $pdo->prepare("DELETE FROM products WHERE id = ?");
            $stmt->execute([$data['id']]);
            echo json_encode(['success' => true]);
        }
        break;

    case 'placeOrder':
        if ($method === 'POST') {
            $data = json_decode(file_get_contents('php://input'), true);
            $pdo->beginTransaction();
            try {
                $stmt = $pdo->prepare("INSERT INTO orders (user_id, fullname, phone, address, total_amount) VALUES (?, ?, ?, ?, ?)");
                $stmt->execute([$data['user_id'] ?? null, $data['fullname'], $data['phone'], $data['address'], $data['total_amount']]);
                $orderId = $pdo->lastInsertId();

                $stmt = $pdo->prepare("INSERT INTO order_items (order_id, product_id, quantity, price) VALUES (?, ?, ?, ?)");
                foreach ($data['items'] as $item) {
                    $stmt->execute([$orderId, $item['id'], $item['quantity'], $item['price']]);
                }

                $pdo->commit();
                echo json_encode(['success' => true, 'order_id' => $orderId]);
            } catch (Exception $e) {
                $pdo->rollBack();
                echo json_encode(['success' => false, 'error' => $e->getMessage()]);
            }
        }
        break;

    default:
        echo json_encode(['error' => 'Invalid action']);
        break;
}
?>
