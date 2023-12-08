<?php
require_once '../common.php'; // 引用共通設定

$data = getFormData(); // 使用 common.php 中的函數獲取表單數據
$uid = getUserId(); // 使用 common.php 中的函數獲取用戶ID
date_default_timezone_set('Asia/Taipei');
$checkDate = date("Y-m-d");
$routineTime = date("H:i:s");
$startDate  = date("Y-m-d");
$endDate  = date("Y-m-d", strtotime($startDate . ' +1 day'));
$isOver = 1 ;
$completeValueOld = 0;
$completeValueNew = 0;
$message = "";

$db = Database::getInstance();
$conn = $db->getConnection();


function insertRecurringInstance($conn, $data, $checkDate)
{
    $InstanceSql = "INSERT INTO `RecurringInstance` (`todo_id`, `RecurringStartDate`, `RecurringEndDate`) VALUES ( ? , ? , ? );";



    $stmt = $conn->prepare($InstanceSql);
    $stmt->bind_param("iss", $data['id'], $checkDate, $checkDate);

    if ($stmt->execute() === TRUE) {
        $RI_id = $conn->insert_id;
        $message = "User New first RecurringInstance successfully";
    } else {
        $message = "insertRecurringInstance: " . $stmt->error;
    }
    // return $message;
    $stmt->close();
    return array('message' => $message, 'RI_id' => $RI_id);
}

$stmtSEL = $conn->prepare("SELECT * FROM `RecurringInstance` WHERE todo_id = ? AND `RecurringEndDate` = ? AND `RecurringStartDate` = ?;");
$stmtSEL->bind_param("iss", $data['id'], $data['RecurringEndDate'], $data['RecurringStartDate']);
$stmtSEL->execute();
$result = $stmtSEL->get_result();

if ($data['routineType'] == 2 && $data['RecurringStartDate'] != $checkDate) {
    $result = insertRecurringInstance($conn, $data, $checkDate);
    if ($result['message'] == "User New first RecurringInstance successfully") {
        $Instance_id = $result['RI_id'];
        $stmt = $conn->prepare("INSERT INTO `RecurringCheck` (`Instance_id`, `checkDate`, `completeValue`, `sleepTime`, `wakeUpTime`) VALUES (?, ?, ?, ?, ?);");
        $data['completeValue'] = null;
        $wakeUpTime = null;
        $stmt->bind_param("isiss", $Instance_id, $checkDate, $data['completeValue'], $routineTime, $wakeUpTime);
        if($stmt->execute()) {
            $message = "User New RecurringCheck successfully";
        
        } else {
            $message = "New RecurringCheck - Error: " . $stmt->error;
        }
    } else {
        $message = $result['message'];
    }
} elseif ($result->num_rows > 0) {
    if ($data['isComplete']) {
        $occurrenceStatus = 1;
    } else {
        $occurrenceStatus = 0;
    }
    $row = $result->fetch_assoc();
    $Instance_id = $row['id'];
    // $completeValueOld = $row['completeValue'];
    // if ($row['completeValue'] == null ){
    //     $completeValueOld = 0 ;
    //     $completeValueNew = 0;
    // } else {
    //     $completeValueOld = $row['completeValue'];
    //     $completeValueNew = $completeValueOld + $data['completeValue'];
    // }
    $completeValueOld = $row['completeValue'];
    $completeValueNew = $completeValueOld + $data['completeValue'];
    $stmt = $conn->prepare("INSERT INTO `RecurringCheck` (`Instance_id`, `checkDate`, `completeValue`, `sleepTime`, `wakeUpTime`) VALUES (?, ?, ?, ?, ?);");

    if ($data['completeValue'] != 0 && $data['routineType'] != 3) {
        // 一般檢核 （ 記得要設定completeValue != 0 ）
        $sleepTime = null;
        $wakeUpTime = null;
        $stmt->bind_param("isiss", $Instance_id, $checkDate, $data['completeValue'], $sleepTime, $wakeUpTime);
    // } elseif ($data['routineType'] == 0 || $data['routineType'] == 2) {
    } elseif ($data['routineType'] == 0) {
        // 早睡、區間睡覺
        $data['completeValue'] = null;
        $wakeUpTime = null;
        $stmt->bind_param("isiss", $Instance_id, $checkDate, $data['completeValue'], $routineTime, $wakeUpTime);
    } elseif ($data['routineType'] == 1) {
        // 早起
        $data['completeValue'] = null;
        $sleepTime = null;
        $stmt->bind_param("isiss", $Instance_id, $checkDate, $data['completeValue'], $sleepTime, $routineTime);
    } elseif ($data['routineType'] == 3) {
            // 區間起床
            $routineTypeStmt = $conn->prepare("UPDATE RecurringCheck SET `wakeUpTime` = ? WHERE `Instance_id` = ? ;");
            $routineTypeStmt->bind_param("si", $routineTime, $Instance_id);
        
            if ($routineTypeStmt->execute()) {
                $message = "User upDateCompleteValue successfully";
            } else {
                $message = $message . 'User upDateCompleteValue - Error: ' . $routineTypeStmt->error;
            }
            $routineTypeStmt->close();

            // $sleepTime = null;
            // $data['completeValue'] = null;
            // $wakeUpTime = $routineTime;
            // $stmt->bind_param("isiss", $Instance_id, $checkDate, $data['completeValue'], $sleepTime, $routineTime);
    }
    if($stmt->execute() || $data['routineType'] != 3) {
        $message = "User New RecurringCheck successfully";
    
        // 使用預備語句更新 RecurringInstance
        $updateStmt = $conn->prepare("UPDATE RecurringInstance SET `completeValue` = ? , `occurrenceStatus` = ? WHERE `todo_id` = ? AND `RecurringEndDate` = ? AND `RecurringStartDate` = ? ;");
        $updateStmt->bind_param("iiiss", $completeValueNew, $occurrenceStatus, $data['id'], $data['RecurringEndDate'], $data['RecurringStartDate']);
    
        if ($updateStmt->execute()) {
            $message = "User upDateCompleteValue successfully";
        } else {
            $message = $message . 'User upDateCompleteValue - Error: ' . $updateStmt->error;
        }
        $updateStmt->close();
    } else {
        $message = "New RecurringCheck - Error: " . $stmt->error;
    }
    $stmt->close();
} else {
    $message = "No results found";
}
$stmtSEL->close();
$userData = array(
    'todo_id' => $data['id'],
    'RecurringStartDate' => $data['RecurringStartDate'],
    'RecurringEndDate' => $data['RecurringEndDate'],
    'completeValue' => $data['completeValue'],
    'message' => $message,
    'Instance_id' => $Instance_id,
    'occurrenceStatus' => $occurrenceStatus,
    'completeValueNew' => $completeValueNew,
    'completeValueOld' => $completeValueOld,
    'wakeUpTime' => $wakeUpTime,
    'sleepTime' => $sleepTime,
    'routineType' => $data['routineType'],
    'routineTime' => $routineTime
);
echo json_encode($userData);

$conn->close();
?>