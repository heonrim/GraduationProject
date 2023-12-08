<?php
require_once '../common.php'; // 引用共通設定

$data = getFormData(); // 使用 common.php 中的函數獲取表單數據
$uid = getUserId(); // 使用 common.php 中的函數獲取用戶ID
$todo_id = 0;
$message = "";

$db = Database::getInstance();
$conn = $db->getConnection();

function insertTodo($conn, $uid, $data)
{
    $TodoSql = "INSERT INTO `Todo` (`uid`, `category_id`, `todoTitle`, `todoIntroduction`, `label`, `startDateTime`, `frequency`, `reminderTime`, `todoStatus`, `dueDateTime`, `todoNote`) VALUES (?,0,?,?,?,?,?,?,0,?,?)";

    $stmt = $conn->prepare($TodoSql);
    $stmt->bind_param("sssssisss", $uid, $data['todoTitle'], $data['todoIntroduction'], $data['label'], $data['startDateTime'], $data['frequency'], $data['reminderTime'], $data['dueDateTime'], $data['todoNote']);

    if ($stmt->execute() === TRUE) {
        $todo_id = $conn->insert_id;
        $message = "User New Todo successfully";

    } else {
        $message = "TodoSqlError: " . $stmt->error;
    }
    // return $message;
    $stmt->close();
    return array('message' => $message, 'todo_id' => $todo_id);
}
function insertStudyGeneral($conn, $todo_id, $data)
{
    $SpacedSql = "INSERT INTO StudyGeneral (`todo_id`, `category_id`, `studyValue`, `studyUnit`) VALUES (?, 0, ?, ?)";
    $stmt = $conn->prepare($SpacedSql);
    $stmt->bind_param("idi", $todo_id, $data['studyValue'], $data['studyUnit']);

    if($stmt->execute() === TRUE) {
        $result = $stmt->get_result();
        $message = "User New StudyGeneral successfully";
    } else {
        $message = 'New StudyGeneral - Error: '. $stmt->error;
    }
    $stmt->close();
    return $message;
}
function insertRecurringInstance($conn, $todo_id, $data, $RecurringEndDate)
{
    $InstanceSql = "INSERT INTO `RecurringInstance` (`todo_id`, `RecurringStartDate`, `RecurringEndDate`) VALUES (?, ?, ?);";

    $stmt = $conn->prepare($InstanceSql);
    $stmt->bind_param("iss", $todo_id, $data['startDateTime'], $RecurringEndDate);

    if($stmt->execute() === TRUE) {
        $message = "User New first RecurringInstance successfully";
    } else {
        $message = "InstanceSqlError" . $stmt->error;
    }
    $stmt->close();
    return $message;
}

$TodoIdSql = "SELECT * FROM `Todo` WHERE `uid` = ? AND `category_id` = 0 AND `todoTitle` = ? AND `todoIntroduction` = ? AND `label` = ? AND `todoNote` = ? ";

$stmt = $conn->prepare($TodoIdSql);
if ($stmt === false) {
    die("Error preparing statement: " . $conn->error);
}
$stmt->bind_param("sssss", $uid, $data['todoTitle'], $data['todoIntroduction'], $data['label'], $data['todoNote']);
if($stmt->execute() === TRUE) {
    $result = $stmt->get_result();
    if ($result->num_rows == 0) {
        // 不重複
        $result1 = insertTodo($conn, $uid, $data);

        if ($result1['message'] == "User New Todo successfully" ) {
            $todo_id = $result1['todo_id'];
            $result2 = insertStudyGeneral($conn, $todo_id, $data);

            if ($result2 == "User New StudyGeneral successfully" ) {
                if ($data['frequency'] != 0) {

                    if ($data['frequency'] == 1) {
                        // 每天重複
                        $RecurringEndDate = $data['startDateTime'];
                    } else if ($data['frequency'] == 2) {
                        // 每週重複
                        $RecurringEndDate = date('Y-m-d', strtotime($data['startDateTime'] . " +7 day"));
                    } else if ($data['frequency'] == 3) {
                        // 每月重複
                        $RecurringEndDate = date('Y-m-d', strtotime($data['startDateTime'] . " +30 day"));
                    }

                    $result3 = insertRecurringInstance($conn, $todo_id, $data, $RecurringEndDate);
                    if ($result3 == "User New first RecurringInstance successfully") {
                        $message = "User New Task successfully";
                    } else {
                        $message = $result3;
                    }
                }
            } else {
                $message = $result2;
            }
        } else {
            $message = $result1['message'];
        }
    }  else {
        $message = "The Todo is repeated";
    }
} else {
    error_log("SQL Error: " . $stmt->error);
    $message = "TodoIdSqlError" . $stmt->error;
}
$stmt->close();
$userData = array(
    'todo_id' => intval($todo_id),
    'userId' => $uid,
    'category_id' => 0,
    'todoLabel' => $data['label'],
    'todoTitle' => $data['todoTitle'],
    'todoIntroduction' => $data['todoIntroduction'],
    'startDateTime' => $data['startDateTime'],
    'studyValue' => $data['studyValue'],
    'studyUnit' => $data['studyUnit'],
    'frequency' => $data['frequency'],
    'todoStatus' => 0,
    'dueDateTime' => $data['dueDateTime'],
    'reminderTime' => $data['reminderTime'],
    'todoNote' => $data['todoNote'],
    'message' => $message
);
echo json_encode($userData);

$conn->close();
?>