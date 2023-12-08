<?php
// 沒有使用
require_once '../common.php'; // 引用共通設定

$data = getFormData(); // 使用 common.php 中的函數獲取表單數據

$uid = getUserId(); // 使用 common.php 中的函數獲取用戶ID
$category_id = 1;
$todoTitle = $data['title'];
$todoIntroduction = $data['description'];
// $startDateTime = $data['nextReviewDate'];
$reminderTime = $data['nextReviewTime'];

$todo_id = $data['id'];
$repetition1Status = $data['repetition1Status'];
$repetition2Status = $data['repetition2Status'];
$repetition3Status = $data['repetition3Status'];
$repetition4Status = $data['repetition4Status'];

$db = Database::getInstance();
$conn = $db->getConnection();

$TodoSql = "UPDATE Todo 
SET `todoTitle` = '$todoTitle',`todoIntroduction` = '$todoIntroduction',`reminderTime` = '$reminderTime'
WHERE `id` = '$todo_id' ;";


$StudySpacedSql = "UPDATE StudySpacedRepetition 
SET `repetition1Status` = '$repetition1Status', `repetition2Status` = '$repetition2Status', `repetition3Status` = '$repetition3Status', `repetition4Status` = '$repetition4Status'
WHERE `todo_id` = '$todo_id' ;";
if ($conn->query($TodoSql) === TRUE) {
    if ($conn->query($StudySpacedSql) === TRUE) {
        $message = "User revise Todo successfully";
    } else {
        $message = 'revise StudySpacedSql - Error: ' . $sql . '<br>' . $conn->error;
        $conn->error;
    }
} else {
    $message = $message . 'revise TodoSql - Error: ' . $sql . '<br>' . $conn->error;
    $conn->error;
}

$userData = array(
    'userId' => $uid,
    'category_id' => $category_id,
    'todoTitle' => $todoTitle,
    'todoIntroduction' => $todoIntroduction,
    'reminderTime' => $reminderTime,
    'todo_id' => $todo_id,
    'repetition1Status' => $repetition1Status,
    'repetition2Status' => $repetition2Status,
    'repetition3Status' => $repetition3Status,
    'repetition4Status' => $repetition4Status,
    'message' => $message
);
echo json_encode($userData);

$conn->close();
?>