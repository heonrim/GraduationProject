<?php
require_once '../common.php'; // 引用共通設定

$data = getFormData(); // 使用 common.php 中的函數獲取表單數據

$db = Database::getInstance();
$conn = $db->getConnection();

$TodoSELSql = "SELECT * FROM `RecurringInstance` WHERE todo_id = ? ORDER by id DESC limit 1;";

$stmt = $conn->prepare($TodoSELSql);
if ($stmt === false) {
    die("Error preparing statement: " . $conn->error);
}
$stmt->bind_param("i", $data['id']);
if($stmt->execute() === TRUE) {
    $result = $stmt->get_result();
    if ($result->num_rows > 0) {
        $row = $result->fetch_assoc();
        $RecurringStartDate = $row['RecurringStartDate'];
        $id = $row['id'];
        $message = "User TrackingFirstDay successfully";
    } else {
        $message = "No results found";
    }
} else {
    error_log("SQL Error: " . $stmt->error);
    $message = "TodoIdSqlError" . $stmt->error;
}     
$stmt->close();
$userData = array(
    'id' => intval($id),
    'todo_id' => intval($data['id']),
    'RecurringStartDate' => $RecurringStartDate,
    'message' => $message
);
echo json_encode($userData);

$conn->close();
?>