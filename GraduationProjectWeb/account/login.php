<?php
// ini_set('display_errors', 1);
// error_reporting(E_ALL);

require_once '../Database.php';

// 獲取用戶提交的表單數據
session_unset();
session_destroy();
session_start();

$input_data = file_get_contents("php://input");
$data = json_decode($input_data, true);

$message = "";

$db = Database::getInstance();
$conn = $db->getConnection();

function registerGmail($conn, $data)
{
    $hashedPassword = $data['gid'];
    $insertUser = "INSERT INTO `User` (`email`, `password`) VALUES (?, ?)";
    $stmt = $conn->prepare($insertUser);
    $stmt->bind_param("ss", $data['email'], $hashedPassword);

    if ($stmt->execute() === TRUE) {
        $result = $stmt->get_result();
        $message = "User registerGmail successfully";
        $_SESSION['uid'] = $conn->insert_id;
        $_SESSION['email'] = $data['email'];
    } else {
        error_log("SQL Error: " . $stmt->error);
        $message = "registerGmail - Error" . $stmt->error;
    }
    $stmt->close();
    return $message;
}

// 從資料庫中檢索用戶信息
$loginSql = "SELECT * FROM User WHERE email = ?";
$stmt = $conn->prepare($loginSql);
$stmt->bind_param("s", $data['email']);
if ($stmt->execute() === TRUE) {
    $result = $stmt->get_result();
    if ($result->num_rows > 0) {
        while ($row = $result->fetch_assoc()) {
            if ((password_verify($data['password'], $row['password'])) || ($data['gid'] == $row['password'])) {
                // 密碼匹配，設置會話變數
                $_SESSION['uid'] = $row['id'];
                $_SESSION['email'] = $data['email'];
                $_SESSION['userName'] = $row['userName'];
                $_SESSION['userDescription'] = $row['userDescription'];
                $_SESSION['currentStep'] = $row['currentStep'];
                $_SESSION['create_at'] = $row['create_at'];
                $_SESSION['image'] = $row['image'];
                $message = "User login successfully";
                break;
            } else {
                $message = "Invalid password";
            }
        }
    } else if ($data['gid'] !== "" && isset($data['gid'])) {
        $message = registerGmail($conn, $data);
    } else {
        $message = "No such account";
    }
} else {
    error_log("SQL Error: " . $stmt->error);
    $message = "loginSql - Error" . $stmt->error;
}

$stmt->close();

$userData = array(
    'data' => $data,
    'id' => $_SESSION['uid'],
    'email' => $_SESSION['email'],
    'userName' => $_SESSION['userName'],
    'userDescription' => $_SESSION['userDescription'],
    'currentStep' => $_SESSION['currentStep'],
    'create_at' => $_SESSION['create_at'],
    'image' => $_SESSION['image'],
    'message' => $message
);
echo json_encode($userData);

// 關閉與 MySQL 的連接
$conn->close();
?>