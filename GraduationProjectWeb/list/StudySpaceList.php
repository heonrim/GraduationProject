<?php
require_once '../common.php'; // 引用共通設定
$data = getFormData(); // 使用 common.php 中的函數獲取表單數據
$_SESSION['uid'] = $data['uid'];
$uid = getUserId(); // 使用 common.php 中的函數獲取用戶ID

$category_id = 1;

$TodoTitle = array();
$TodoIntroduction = array();
$TodoLabel = array();
$StartDateTime = array();
$ReminderTime = array();
$todo_id = array();
$todoStatus = array();
$repetition1Status = array();
$repetition2Status = array();
$repetition3Status = array();
$repetition4Status = array();
$repetition1Count = array();
$repetition2Count = array();
$repetition3Count = array();
$repetition4Count = array();

$db = Database::getInstance();
$conn = $db->getConnection();


// $TodoSELSql = "SELECT * FROM Todo T RIGHT JOIN StudySpacedRepetition SSR ON T.id = SSR.todo_id WHERE T.uid = '$uid' AND T.category_id = '1';";
$TodoSELSql = "SELECT * FROM Todo T RIGHT JOIN StudySpacedRepetition SSR ON T.id = SSR.todo_id WHERE T.uid = ? AND T.category_id = '1';";

$stmt = $conn->prepare($TodoSELSql);
$stmt->bind_param("s", $uid);
if ($stmt->execute() === TRUE) {
    $result = $stmt->get_result();
    if ($result->num_rows > 0) {
        while ($row = $result->fetch_assoc()) {
            $_SESSION['uid'] = $uid;

            $TodoTitle[] = $row['todoTitle'];
            $TodoIntroduction[] = $row['todoIntroduction'];
            $TodoLabel[] = $row['label'];
            $StartDateTime[] = $row['startDateTime'];
            $ReminderTime[] = $row['reminderTime'];
            $todoStatus[] = $row['todoStatus'];
            $repetition1Status[] = $row['repetition1Status'];
            $repetition2Status[] = $row['repetition2Status'];
            $repetition3Status[] = $row['repetition3Status'];
            $repetition4Status[] = $row['repetition4Status'];
            $repetition1Count[] = $row['repetition1Count'];
            $repetition2Count[] = $row['repetition2Count'];
            $repetition3Count[] = $row['repetition3Count'];
            $repetition4Count[] = $row['repetition4Count'];
            $todo_id[] = $row['todo_id'];
        }
    } else {
        $message = "no such Todo";
    }
} else {
    error_log("SQL Error: " . $stmt->error);
    $message = "TodoIdSqlError" . $stmt->error;
}
$stmt->close();
$userData = array(
    'userId' => $uid,
    'category_id' => $category_id,
    'todoTitle' => $TodoTitle,
    'todoIntroduction' => $TodoIntroduction,
    'todoLabel' => $TodoLabel,
    'startDateTime' => $StartDateTime,
    'reminderTime' => $ReminderTime,
    'todo_id' => $todo_id,
    'todoStatus' => $todoStatus,
    'repetition1Status' => $repetition1Status,
    'repetition2Status' => $repetition2Status,
    'repetition3Status' => $repetition3Status,
    'repetition4Status' => $repetition4Status,
    'repetition1Count' => $repetition1Count,
    'repetition2Count' => $repetition2Count,
    'repetition3Count' => $repetition3Count,
    'repetition4Count' => $repetition4Count,
    'message' => ""
);
echo json_encode($userData);
$conn->close();
?>