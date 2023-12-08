<?php
require_once '../common.php'; // 引用共通設定
$data = getFormData(); // 使用 common.php 中的函數獲取表單數據
$_SESSION['uid'] = $data['uid'];
$uid = getUserId(); // 使用 common.php 中的函數獲取用戶ID

$category_id = 0;

$TodoTitle = array();
$TodoIntroduction = array();
$TodoLabel = array();
$StartDateTime = array();

$dietsType = array();
$dietsValue = array();

$frequency = array();
$ReminderTime = array();
$todo_id = array();
$todoStatus = array();
$dueDateTime = array();
$todoNote = array();

$RecurringStartDate = array();
$RecurringEndDate = array();
$completeValue = array();

$db = Database::getInstance();
$conn = $db->getConnection();

// $TodoSELSql = "SELECT * FROM Todo T RIGHT JOIN Diet D ON T.id = D.todo_id WHERE T.uid = '$uid' && T.category_id = '5';";
$TodoSELSql = "SELECT T.*, RI.*, D.* FROM Todo T LEFT JOIN Diet D ON T.id = D.todo_id RIGHT JOIN RecurringInstance RI ON T.id = RI.todo_id WHERE T.uid = ? AND t.category_id = 5 AND RI.isOver = 0;";

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

            $dietsType[] = $row['dietType'];
            $dietsValue[] = $row['dietValue'];

            $frequency[] = $row['frequency'];
            $ReminderTime[] = $row['reminderTime'];
            $todo_id[] = $row['todo_id'];
            $todoStatus[] = $row['todoStatus'];
            $dueDateTime[] = $row['dueDateTime'];
            $todoNote[] = $row['todoNote'];

            $RecurringStartDate[] = $row['RecurringStartDate'];
            $RecurringEndDate[] = $row['RecurringEndDate'];
            $completeValue[] = $row['completeValue'];
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

    'dietsType' => $dietsType,
    'dietsValue' => $dietsValue,

    'frequency' => $frequency,
    'reminderTime' => $ReminderTime,
    'todo_id' => $todo_id,
    'todoStatus' => $todoStatus,
    'dueDateTime' => $dueDateTime,
    'todoNote' => $todoNote,

    'RecurringStartDate' => $RecurringStartDate,
    'RecurringEndDate' => $RecurringEndDate,
    'completeValue' => $completeValue,

    'message' => ""
);
echo json_encode($userData);
$conn->close();
?>