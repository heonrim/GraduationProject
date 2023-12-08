<?php
require_once '../common.php'; // 引用共通設定

$data = getFormData(); // 使用 common.php 中的函數獲取表單數據
$uid = getUserId(); // 使用 common.php 中的函數獲取用戶ID

$message = "";

$db = Database::getInstance();
$conn = $db->getConnection();

$UpSql = "UPDATE User SET `username` = ? , `userDescription` = ? , `image` = ? WHERE `id` = ? ;";

$stmt = $conn->prepare($UpSql);
if ($stmt === false) {
    die("Error preparing statement: " . $conn->error);
}

$_SESSION['username'] = $data['username'];
$_SESSION['userDescription'] = $data['userDescription'];
$_SESSION['image'] = $data['image'];

$stmt->bind_param("ssss", $_SESSION['username'], $_SESSION['userDescription'], $_SESSION['image'], $uid);
if($stmt->execute() === TRUE) {
    $message = "User reviseProfile successfully";
} else {
    error_log("SQL Error: " . $stmt->error);
    $message = "UpSqlError" . $stmt->error;
}
$stmt->close();

// $userData = array(
//     'id' => $uid,
//     'userName' => $data['username'],
//     'userDescription' => $data['userDescription'],
//     'message' => $message
// );
$userData = array(
    'data' => $data,
    'id' => intval($uid),
    'email' => $_SESSION['email'],
    'userName' => $_SESSION['username'],
    'userDescription' => $_SESSION['userDescription'],
    'currentStep' => $_SESSION['currentStep'],
    'create_at' => $_SESSION['create_at'],
    'image' => $_SESSION['image'],
    'message' => $message
);
echo json_encode($userData);

$conn->close();
?>