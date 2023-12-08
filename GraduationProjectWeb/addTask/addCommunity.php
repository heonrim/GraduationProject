<?php
require_once '../common.php'; // 引用共通設定

$data = getFormData(); // 使用 common.php 中的函數獲取表單數據
$uid = getUserId(); // 使用 common.php 中的函數獲取用戶ID
$community_id = 0;
$communityCreateDate = date("Y-m-d");

$message = "";

$db = Database::getInstance();
$conn = $db->getConnection();

function insertCommunity($conn, $uid, $data, $communityCreateDate) {
    $CommunitySql = "INSERT INTO `Community` (`communityName`, `communityDescription`, `communityCreateDate`, `communityCategory`, `image`) VALUES (?, ?,?,?,?)";
    
    $stmt = $conn->prepare($CommunitySql);
    $stmt->bind_param("sssis", $data['communityName'], $data['communityDescription'], $communityCreateDate, $data['communityCategory'], $data['image']);

    if ($stmt->execute() === TRUE) {
        $community_id = $conn->insert_id;
        $message = "User New Community successfully";
    } else {
        $message = "TodoSqlError: " . $stmt->error;
    }
    // return $message;
    $stmt->close();
    return array('message' => $message, 'community_id' => $community_id);
}
function insertMemberSql($conn, $community_id, $uid, $communityCreateDate)
{
    $memberSql = "INSERT INTO `community_members` (`community_id`, `user_id`, `memberRole`, `joinDate`) VALUES (?, ?,'1',?)";

    $stmt = $conn->prepare($memberSql);
    $stmt->bind_param("iis", $community_id, $uid, $communityCreateDate);
    if($stmt->execute() === TRUE) {
        $result = $stmt->get_result();
        $message = "User New memberSql successfully";
    } else {
        $message = 'New memberSql - Error: '. $stmt->error;
    }
    $stmt->close();
    return $message;
}


$CommunitySELSql = "SELECT * FROM `Community` WHERE `communityName` = ? ;";

$stmt = $conn->prepare($CommunitySELSql);
if ($stmt === false) {
    die("Error preparing statement: " . $conn->error);
}
$stmt->bind_param("s", $data['communityName']);
if($stmt->execute() === TRUE) {
    $result = $stmt->get_result();
    if ($result->num_rows == 0) {
        $result1 = insertCommunity($conn, $uid, $data, $communityCreateDate);
        if ($result1['message'] ==  "User New Community successfully") {
            $community_id = $result1['community_id'];
            $result2 = insertMemberSql($conn, $community_id, $uid, $communityCreateDate);
            if ($result2 ==  "User New memberSql successfully") {
                $message = "User New Community successfully" ;
            } else {
                $message = $result2;
            }
        } else {
            $message = $result1['message'];
        }
    }  else {
        $message = "The Community is repeated";
    }
} else {
    error_log("SQL Error: " . $stmt->error);
    $message = "TodoIdSqlError" . $stmt->error;
}
$stmt->close();
$userData = array(
    'community_id' => intval($community_id),
    'communityName' => $data['communityName'],
    'communityDescription' => $data['communityDescription'],
    'communityCategory' => intval($communityCategory),
    'image' =>  $data['image'],
    'message' => $message
);
echo json_encode($userData);

$conn->close();
?>