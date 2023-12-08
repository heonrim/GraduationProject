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

$routinesType = array();
$routinesValue = array();
$routinesTime = array();

$ReminderTime = array();
$todo_id = array();
$todoStatus = array();
$dueDateTime = array();
$todoNote = array();

$RecurringStartDate = array();
$RecurringEndDate = array();
$sleepTime = array();
$wakeUpTime = array();
$today = date("Y-n-j");
$db = Database::getInstance();
$conn = $db->getConnection();

function updateRecurringInstancRoutine($conn,$today,$uid)
{
    $update = "UPDATE RecurringInstance RI LEFT JOIN ( SELECT MAX(RecurringInstance.id) as max_id FROM RecurringInstance INNER JOIN todo T ON RecurringInstance.todo_id = T.id WHERE T.uid = ? GROUP BY RecurringInstance.todo_id ) AS LatestRI ON RI.id = LatestRI.max_id SET RI.isOver = 1 WHERE RI.todo_id IN ( SELECT id FROM todo WHERE uid = ? ) AND LatestRI.max_id IS NULL;";

    $stmt = $conn->prepare($update);
    if ($stmt === false) {
        die("Error preparing statement: " . $conn->error);
    }
    $stmt->bind_param("ii", $uid, $uid);
    if($stmt->execute() === TRUE) {
        $message = "User updateRecurringInstancRoutine successfully";
    } else {
        error_log("SQL Error: " . $stmt->error);
        $message = "UpSqlError" . $stmt->error;
    }
    $stmt->close();
    return $message;
}

// $TodoSELSql = "SELECT * FROM Todo T RIGHT JOIN Diet D ON T.id = D.todo_id WHERE T.uid = '$uid' && T.category_id = '5';";
// $TodoSELSql = "SELECT T.*, RI.*, R.* FROM Todo T LEFT JOIN Routine R ON T.id = R.todo_id RIGHT JOIN RecurringInstance RI ON T.id = RI.todo_id WHERE T.uid = ? AND t.category_id = 4 AND RI.isOver = 0;";
$TodoSELSql = "SELECT R.*,T.*, RI.RecurringStartDate,RI.RecurringEndDate, RC.sleepTime,RC.wakeUpTime FROM Todo T LEFT JOIN Routine R ON T.id = R.todo_id LEFT JOIN RecurringInstance RI ON T.id = RI.todo_id LEFT JOIN RecurringCheck RC ON RI.id = RC.Instance_id WHERE T.uid = ? AND T.category_id = 4 AND RI.isOver = 0 UNION SELECT R.*,T.*, RI.RecurringStartDate,RI.RecurringEndDate, RC.sleepTime,RC.wakeUpTime FROM Todo T RIGHT JOIN Routine R ON T.id = R.todo_id RIGHT JOIN RecurringInstance RI ON T.id = RI.todo_id RIGHT JOIN RecurringCheck RC ON RI.id = RC.Instance_id WHERE T.uid = ? AND T.category_id = 4 AND RI.isOver = 0;
";

$message = updateRecurringInstancRoutine($conn,$today,$uid);
$stmt = $conn->prepare($TodoSELSql);
$stmt->bind_param("ss", $uid, $uid);
if ($stmt->execute() === TRUE) {
    $result = $stmt->get_result();
    if ($result->num_rows > 0) { 
        //  if ($message == "User updateRecurringInstancRoutine successfully") {
            while ($row = $result->fetch_assoc()) {
                $_SESSION['uid'] = $uid;
    
                $TodoTitle[] = $row['todoTitle'];
                $TodoIntroduction[] = $row['todoIntroduction'];
                $TodoLabel[] = $row['label'];
                $StartDateTime[] = $row['startDateTime'];
        
                $routinesType[] = $row['routineType'];
                $routinesValue[] = $row['routineValue'];
                $routinesTime[] = $row['routineTime'];
        
                $ReminderTime[] = $row['reminderTime'];
                $todo_id[] = $row['todo_id'];
                $todoStatus[] = $row['todoStatus'];
                $dueDateTime[] = $row['dueDateTime'];
                $todoNote[] = $row['todoNote'];
        
                $RecurringStartDate[] = $row['RecurringStartDate'];
                $RecurringEndDate[] = $row['RecurringEndDate'];
                $sleepTime[] = $row['sleepTime'];
                $wakeUpTime[] = $row['wakeUpTime'];
            }
        //  }
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

    'routinesType' => $routinesType,
    'routinesValue' => $routinesValue,
    'routinesTime' => $routinesTime,

    'frequency' => $frequency,
    'reminderTime' => $ReminderTime,
    'todo_id' => $todo_id,
    'todoStatus' => $todoStatus,
    'dueDateTime' => $dueDateTime,
    'todoNote' => $todoNote,

    'RecurringStartDate' => $RecurringStartDate,
    'RecurringEndDate' => $RecurringEndDate,
    'sleepTime' => $sleepTime,
    'wakeUpTime' => $wakeUpTime,
 
    'message' => $message
);
echo json_encode($userData);
$conn->close();
?>