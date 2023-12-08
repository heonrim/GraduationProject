<?php
// ini_set('display_errors', 1);
// error_reporting(E_ALL);

require_once '../Database.php';

// session_unset();
// session_destroy();
session_start();
// 獲取用戶提交的表單數據
$input_data = file_get_contents("php://input");
$data = json_decode($input_data, true);

$uid = "";
$create_at = date("Y-m-d");
$message = "";
$_SESSION['image'] = "AppIcon";
$db = Database::getInstance();
$conn = $db->getConnection();

function selectEmail($conn, $data)
{
    $emailExistSql = "SELECT * FROM `User` WHERE `email` = ? ";
    $stmt = $conn->prepare($emailExistSql);
    $stmt->bind_param("s", $data['email']);
    if ($stmt->execute() === TRUE) {
        $result = $stmt->get_result();
        if ($result->num_rows > 0) {
            $message = "email is registered";
        } else {
            $message = "email is new";
        }
    } else {
        error_log("SQL Error: " . $stmt->error);
        $message = "TodoIdSqlError" . $stmt->error;
    }
    $stmt->close();
    return $message;
}
function registerEmail($conn, $data)
{
    $hashedPassword = password_hash($data['password'], PASSWORD_DEFAULT);

    $insertUser = "INSERT INTO `User` (`email`, `password`) VALUES (?, ?)";
    $stmt = $conn->prepare($insertUser);
    $stmt->bind_param("ss", $data['email'], $hashedPassword);

    if ($stmt->execute() === TRUE) {
        $result = $stmt->get_result();
        $message = "User registered successfully";
        $_SESSION['uid'] = $conn->insert_id;
        $_SESSION['email'] = $data['email'];
    } else {
        error_log("SQL Error: " . $stmt->error);
        $message = "registerEmail - Error" . $stmt->error;
    }
    $stmt->close();
    return $message;
}
function updateUsername($conn, $uid, $data)
{
    $_SESSION['userName'] = $data['userName'];
    $sql = "UPDATE User SET `username` = ? WHERE `id` = ?;";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("si", $data['userName'], $uid);
    if ($stmt->execute() === TRUE) {
        $message = "User updateUsername successfully";
    } else {
        error_log("SQL Error: " . $stmt->error);
        $message = "updateUsername - Error" . $stmt->error;
    }
    $stmt->close();
    return $message;
}

function updateUserDescription($conn, $uid, $data)
{
    $_SESSION['userDescription'] = $data['userDescription'];
    $sql = "UPDATE User SET `userDescription` = ? WHERE `id` = ?;";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("si", $data['userDescription'], $uid);
    if ($stmt->execute() === TRUE) {
        $message = "User updateUserDescription successfully";
    } else {
        error_log("SQL Error: " . $stmt->error);
        $message = "updateUserDescription - Error" . $stmt->error;
    }
    $stmt->close();
    return $message;
}
function updateCurrentStep($conn, $uid, $data)
{
    $_SESSION['currentStep'] = $data['currentStep'];
    $sql = "UPDATE User SET `currentStep` = ? WHERE `id` = ?;";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("ii", $data['currentStep'], $uid);
    if ($stmt->execute() === TRUE) {
        $message = "User updateCurrentStep successfully";
    } else {
        error_log("SQL Error: " . $stmt->error);
        $message = "updateCurrentStep - Error" . $stmt->error;
    }
    $stmt->close();
    return $message;
}
function updateCreateAt($conn, $uid, $create_at)
{
    $_SESSION['create_at'] = $create_at;
    $sql = "UPDATE User SET `create_at` = ? WHERE `id` = ?;";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("si", $create_at, $uid);
    if ($stmt->execute() === TRUE) {
        $message = "User updateCreateAt successfully";
    } else {
        error_log("SQL Error: " . $stmt->error);
        $message = "updateCreateAt - Error" . $stmt->error;
    }
    $stmt->close();
    return $message;
}
function updateProfile($conn, $uid, $data, $create_at)
{
    $message = "";

    if ($data['userName'] !== "" && isset($data['userName'])) {
        $message = updateUsername($conn, $uid, $data);
    } else if ($data['userDescription'] !== "" && isset($data['userDescription'])) {
        $message = updateUserDescription($conn, $uid, $data);
    } else if ($data['currentStep'] !== "" && isset($data['currentStep'])) {
        $message = updateCurrentStep($conn, $uid, $data);
    } else {
        $message = updateCreateAt($conn, $uid, $create_at);
    }
    return $message;
}


if ($data['email'] !== "" && isset($data['email'])) {
    $message = selectEmail($conn, $data);
    if ($message == "email is new") {
        $message = registerEmail($conn, $data);
    }
} else {
    $uid = $_SESSION['uid'];
    $message = updateProfile($conn, $uid, $data, $create_at);
}

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

$conn->close();
?>