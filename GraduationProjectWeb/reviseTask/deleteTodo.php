<?php
require_once '../common.php'; // 引用共通設定

$data = getFormData(); // 使用 common.php 中的函數獲取表單數據
$uid = getUserId(); // 使用 common.php 中的函數獲取用戶ID
$tableName = $data['type'];
$message = "";

$db = Database::getInstance();
$conn = $db->getConnection();

function deleteRecurringCheck($conn, $data)
{
    $deleteRecurringCheckSql = "DELETE FROM RecurringCheck WHERE Instance_id IN ( SELECT id FROM RecurringInstance WHERE todo_id = ? );";
    $stmt = $conn->prepare($deleteRecurringCheckSql);
    $stmt->bind_param("i", $data['id']);

    if ($stmt->execute()) {
        if ($stmt->affected_rows > 0) {
            return "Todo data deleted successfully";
        } else {
            return "No data found to delete";
        }
    } else {
        error_log("SQL Error: " . $stmt->error);
        return "deleteRecurringCheckError" . $stmt->error;
    }

   
}

function deleteRecurringInstance($conn, $data)
{
    $deleteRecurringInstanceSql = "DELETE FROM RecurringInstance WHERE todo_id = ?;";
    $stmt = $conn->prepare($deleteRecurringInstanceSql);
    $stmt->bind_param("i", $data['id']);

    if ($stmt->execute()) {
        if ($stmt->affected_rows > 0) {
            return "Todo data deleted successfully";
        } else {
            return "No data found to delete";
        }
    } else {
        error_log("SQL Error: " . $stmt->error);
        return "deleteRecurringInstanceError" . $stmt->error;
    }
}

function deleteTypeTableData($conn, $data, $tableName)
{
    $deleteSql = "DELETE FROM $tableName WHERE todo_id = ?;";
    $stmt = $conn->prepare($deleteSql);
    $stmt->bind_param("i", $data['id']);

    if ($stmt->execute()) {
        if ($stmt->affected_rows > 0) {
            return "Todo data deleted successfully";
        } else {
            return "No data found to delete";
        }
    } else {
        error_log("SQL Error: " . $stmt->error);
        return "deleteTypeTableDataError" . $stmt->error;
    }
}

function deleteTodoData($conn, $data)
{
    $deleteTodoSql = "DELETE FROM Todo WHERE id = ?;";
    $stmt = $conn->prepare($deleteTodoSql);
    $stmt->bind_param("i", $data['id']);

    if ($stmt->execute()) {
        if ($stmt->affected_rows > 0) {
            return "Todo data deleted successfully";
        } else {
            return "No data found to delete";
        }
    } else {
        error_log("SQL Error: " . $stmt->error);
        return "deleteTodoDataError" . $stmt->error;
    }
}

$result1 = deleteRecurringCheck($conn, $data);

if ($result1 == "Todo data deleted successfully" || $result1 == "No data found to delete") {
    $result2 = deleteRecurringInstance($conn, $data);
    if ($result2 == "Todo data deleted successfully" || $result2 == "No data found to delete") {
        $result3 = deleteTypeTableData($conn, $data, $tableName);
        if ($result3 == "Todo data deleted successfully" || $result3 == "No data found to delete") {
            $result3 = deleteTodoData($conn, $data);
            if ($result3 == "Todo data deleted successfully" || $result3 == "No data found to delete") {
                $message = "Todo data deleted successfully";
            } else {
                $message = $result3;
            }
        } else {
            $message = $result3;
        }
    } else {
        $message = $result2;
    }
} else {
    $message = $result1;
}

$userData = array(
    'data' => $data,
    'todo_id' => $data['id'],
    'message' => $message
);
echo json_encode($userData);

$conn->close();
?>