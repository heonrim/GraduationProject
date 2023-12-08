<?php
require_once '../common.php';
$data = getFormData(); // 使用 common.php 中的函數獲取表單數據
$uid = getUserId(); // 使用 common.php 中的函數獲取用戶ID
$todo_id = 0;
$message = "";

$db = Database::getInstance();
$conn = $db->getConnection();

function insertTodo($conn, $uid, $data)
{
    $TodoSql = "INSERT INTO `Todo` (`uid`, `category_id`, `todoTitle`, `todoIntroduction`, `label`, `startDateTime`, `frequency`, `reminderTime`, `todoStatus`, `dueDateTime`, `todoNote`) VALUES (?,4,?,?,?,?,0,?,0,?,?)";

    $stmt = $conn->prepare($TodoSql);
    $stmt->bind_param("ssssssss", $uid, $data['todoTitle'], $data['todoIntroduction'], $data['label'], $data['startDateTime'], $data['reminderTime'], $data['dueDateTime'], $data['todoNote']);

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
function insertRoutine($conn, $todo_id, $data)
{
    $SpacedSql = "INSERT INTO `Routine` (`todo_id`, `category_id`, `routineType`, `routineValue`, `routineTime`) VALUES (?, 4,?,?,?)";

    $stmt = $conn->prepare($SpacedSql);
    $stmt->bind_param("isdi", $todo_id, $data['routineType'], $data['routineValue'], $data['routineTime']);
    if ($stmt->execute() === TRUE) {
        $result = $stmt->get_result();
        $message = "User New Routine successfully";
    } else {
        $message = 'New Sport - Error: ' . $stmt->error;
    }
    $stmt->close();
    return $message;
}
function insertRecurringInstance($conn, $todo_id, $data, $RecurringEndDate)
{
    $InstanceSql = "INSERT INTO `RecurringInstance` (`todo_id`, `RecurringStartDate`, `RecurringEndDate`) VALUES (?, ?, ?);";

    $stmt = $conn->prepare($InstanceSql);
    $stmt->bind_param("iss", $todo_id, $data['startDateTime'], $RecurringEndDate);

    if ($stmt->execute() === TRUE) {
        $message = "User New first RecurringInstance successfully";
    } else {
        $message = "InstanceSqlError" . $stmt->error;
    }
    $stmt->close();
    return $message;
}

$TodoIdSql = "SELECT * FROM `Todo` WHERE `uid` = ? AND `category_id` = 4 AND `todoTitle` = ? AND `todoIntroduction` = ? AND `label` = ? AND `todoNote` = ? ";

$stmt = $conn->prepare($TodoIdSql);
if ($stmt === false) {
    die("Error preparing statement: " . $conn->error);
}
$stmt->bind_param("sssss", $uid, $data['todoTitle'], $data['todoIntroduction'], $data['label'], $data['todoNote']);
if ($stmt->execute() === TRUE) {
    $result = $stmt->get_result();
    if ($result->num_rows == 0) {
        $result1 = insertTodo($conn, $uid, $data);

        if ($result1['message'] == "User New Todo successfully" ) {
            $todo_id = $result1['todo_id'];
            $result2 = insertRoutine($conn, $todo_id, $data);
            if ($result2 == "User New Routine successfully" ) {
                $RecurringEndDate = $data['startDateTime'];
                $result3 = insertRecurringInstance($conn, $todo_id, $data, $RecurringEndDate);
                if ($result3 == "User New first RecurringInstance successfully") {
                    $message = "User New Task successfully";
                } else {
                    $message = $result3 ;
                }
            } else {
                $message = $result2;
            }
        } else {
            $message = $result1['message'];
        }
    } else {
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
    'category_id' => 4,
    'label' => $data['label'],
    'todoTitle' => $data['todoTitle'],
    'todoIntroduction' => $data['todoIntroduction'],
    'startDateTime' => $data['startDateTime'],
    'routineType' => $data['routineType'],
    'routineValue' => intval($data['routineValue']),
    'routineTime' => $data['routineTime'],
    'todoStatus' => 0,
    'dueDateTime' => $data['dueDateTime'],
    'reminderTime' => $data['reminderTime'],
    'message' => $message
);
echo json_encode($userData);

$conn->close();
?>