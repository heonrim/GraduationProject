<?php
require_once '../common.php'; // 引用共通設定

$data = getFormData(); // 使用 common.php 中的函數獲取表單數據
$uid = getUserId(); // 使用 common.php 中的函數獲取用戶ID
$todo_id = 0;
$todoNote = "";

$db = Database::getInstance();
$conn = $db->getConnection();

function insertTodo($conn, $uid, $data, $todoNote)
{
    $TodoSql = "INSERT INTO `Todo` (`uid`, `category_id`, `todoTitle`, `todoIntroduction`, `label`, `startDateTime`, `frequency`, `reminderTime`, `todoStatus`, `dueDateTime`, `todoNote`) VALUES (?,1,?,?,?,?,0,?,0,?,?)";

    $stmt = $conn->prepare($TodoSql);
    $stmt->bind_param("ssssssss", $uid, $data['title'], $data['description'], $data['label'], $data['nextReviewDate'], $data['nextReviewTime'], $data['fourteenth'], $todoNote);

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
function insertStudySpacedRepetition($conn, $todo_id, $data)
{
    $SpacedSql = "INSERT INTO `StudySpacedRepetition` (`todo_id`, `repetition1Count`, `repetition2Count`, `repetition3Count`, `repetition4Count`, `repetition1Status`, `repetition2Status`, `repetition3Status`, `repetition4Status`) VALUES (?, ?,?,?,?, 0, 0, 0, 0)";

    $stmt = $conn->prepare($SpacedSql);
    $stmt->bind_param("issss", $todo_id, $data['First'], $data['third'], $data['seventh'], $data['fourteenth']);

    if($stmt->execute() === TRUE) {
        $result = $stmt->get_result();
        $message = "User New StudySpacedRepetition successfully";
    } else {
        $message = 'New StudyGeneral - Error: '. $stmt->error;
    }
    $stmt->close();
    return $message;
}

$TodoSELSql = "SELECT * FROM `Todo` WHERE `uid` = ? AND `category_id` = 1 AND `todoTitle` = ? AND `todoIntroduction` = ? AND `label` = ? ;";

$stmt = $conn->prepare($TodoSELSql);
if ($stmt === false) {
    die("Error preparing statement: " . $conn->error);
}
$stmt->bind_param("ssss", $uid, $data['title'], $data['description'], $data['label']);

if ($stmt->execute() === TRUE) {
    $result = $stmt->get_result();
    if ($result->num_rows == 0) {

        $result1 = insertTodo($conn, $uid, $data, $todoNote);

        if ($result1['message'] == "User New Todo successfully" ) {
            $todo_id = $result1['todo_id'];
            $result2 = insertStudySpacedRepetition($conn, $todo_id, $data);

            if ($result2 == "User New StudySpacedRepetition successfully" ) {

                $message = "User New Task successfully";
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
    echo "TodoSELSqlError" . $stmt->error;
    $message = "TodoSELSqlError" . $stmt->error;
}
$stmt->close();
$userData = array(
    'userId' => $uid,
    'category_id' => 1,
    'todoTitle' => $data['title'],
    'todoIntroduction' => $data['description'],
    'todoLabel' => $data['label'],
    'startDateTime' => $data['nextReviewDate'],
    'reminderTime' => $data['nextReviewTime'],
    'todo_id' =>  intval($todo_id),
    'repetition1Count' => $data['First'],
    'repetition2Count' => $data['third'],
    'repetition3Count' => $data['seventh'],
    'repetition4Count' => $data['fourteenth'],
    'message' => $message
);
echo json_encode($userData);

$conn->close();
?>