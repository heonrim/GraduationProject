<?php
require_once '../common.php'; // 引用共通設定

$data = getFormData(); // 使用 common.php 中的函數獲取表單數據
$uid = getUserId(); // 使用 common.php 中的函數獲取用戶ID
$status = "repetition". $data['value'] ."Status";

$message = "";

$db = Database::getInstance();
$conn = $db->getConnection();

$TodoSql = "UPDATE StudySpacedRepetition SET $status = 1 WHERE `todo_id` = ? ";

$stmt = $conn->prepare($TodoSql);
if ($stmt === false) {
    die("Error preparing statement: " . $conn->error);
}
$stmt->bind_param("i", $data['id']);
if($stmt->execute() === TRUE) {
    $message = "User upDateSpaced successfully";
} else {
    error_log("SQL Error: " . $stmt->error);
    $message = "TodoIdSqlError" . $stmt->error;
}
$stmt->close();
$userData = array(
    'todo_id' => $data['id'],
    'status' => $status,
    'message' => $message
);
echo json_encode($userData);

$conn->close();
?>