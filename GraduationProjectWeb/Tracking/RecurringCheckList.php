<?php
require_once '../common.php'; // 引用共通設定

$data = getFormData(); // 使用 common.php 中的函數獲取表單數據

$checkDate = array();
$completeValue = array();

$db = Database::getInstance();
$conn = $db->getConnection();

// $TodoSELSql = "SELECT * FROM `RecurringCheck` WHERE Instance_id = '$id';";
$TodoSELSql = "SELECT * FROM RecurringInstance AS RI, RecurringCheck AS RC WHERE RI.todo_id = ? && RC.instance_id = RI.id;";

$TodoMonthlySql = "SELECT CONCAT(CAST(years AS CHAR), '年', LPAD(month, 2, '0'), '月') AS yearsMonth, SUM(monthlyCompleteValue) AS monthlyCompleteValue, SUM(monthlyCount) AS monthlyCount FROM ( SELECT YEAR(ri.RecurringStartDate) AS years, MONTH(ri.RecurringStartDate) AS month, SUM(ri.completeValue) AS monthlyCompleteValue, COUNT(*) AS monthlyCount FROM RecurringInstance ri WHERE MONTH(ri.RecurringStartDate) = MONTH(ri.RecurringEndDate) AND ri.todo_id = ? GROUP BY YEAR(ri.RecurringStartDate), MONTH(ri.RecurringStartDate) UNION ALL SELECT YEAR(rc.checkDate) AS years, MONTH(rc.checkDate) AS month, SUM(rc.completeValue) AS monthlyCompleteValue, COUNT(DISTINCT ri.id) AS monthlyCount FROM RecurringCheck rc JOIN RecurringInstance ri ON rc.Instance_id = ri.id WHERE MONTH(ri.RecurringStartDate) != MONTH(ri.RecurringEndDate) AND ri.todo_id = ? GROUP BY YEAR(rc.checkDate), MONTH(rc.checkDate) ) AS combined GROUP BY years, month;";
$stmtSELSql = $conn->prepare($TodoSELSql);
if ($stmtSELSql === false) {
    die("Error preparing statement: " . $conn->error);
}
$stmtSELSql->bind_param("i", $data['id']);
if ($stmtSELSql->execute() === TRUE) {
    $result = $stmtSELSql->get_result();
    if ($result->num_rows > 0) {
        while ($row = $result->fetch_assoc()) {
            $checkDate[] = $row['checkDate'];
            $completeValue[] = $row['completeValue'];
            $message = "User RecurringCheckList successfully";
        }

        $stmtMonthlySql = $conn->prepare($TodoMonthlySql);
        if ($stmtMonthlySql === false) {
            die("Error preparing statement: " . $conn->error);
        }
        $stmtMonthlySql->bind_param("ii", $data['id'], $data['id']);
        if ($stmtMonthlySql->execute() === TRUE) {
            $result = $stmtMonthlySql->get_result();
            if ($result->num_rows > 0) {
                while ($row = $result->fetch_assoc()) {
                    $yearsMonth[] = $row['yearsMonth'];
                    $monthlyCount[] = $row['monthlyCount'];
                    $monthlyCompleteValue[] = $row['monthlyCompleteValue'];
                    $message = "User RecurringCheckList successfully";
                }
            } else {
                $message = "no such Todo";
            }
        } else {
            error_log("SQL Error: " . $stmtMonthlySql->error);
            $message = "TodoIdSqlError" . $stmtMonthlySql->error;
        }
        $stmtMonthlySql->close();
    } else {
        $message = "no such Todo";
    }
} else {
    error_log("SQL Error: " . $stmtSELSql->error);
    $message = "TodoIdSqlError" . $stmtSELSql->error;
}
$stmtSELSql->close();
$userData = array(
    'data' => $data,
    'checkDate' => $checkDate,
    'completeValue' => $completeValue,
    'yearsMonth' => $yearsMonth,
    'monthlyCount' => $monthlyCount,
    'monthlyCompleteValue' => $monthlyCompleteValue,
    'targetvalue' => $data['targetvalue'],
    'message' => $message
);
echo json_encode($userData);
$conn->close();
?>