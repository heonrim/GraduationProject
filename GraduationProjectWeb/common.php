<?php
// common.php

// 資料庫連接設定
require_once 'Database.php'; // 更新這個路徑到您的資料庫連接設定檔案

// 開啟會話
session_start();

// 獲取用戶提交的表單數據
function getFormData()
{
    $input_data = file_get_contents("php://input");
    return json_decode($input_data, true);
}

// 從會話中獲取用戶ID
function getUserId()
{
    return isset($_SESSION['uid']) ? $_SESSION['uid'] : null;
}

// 錯誤處理設定
// 在開發階段，您可能希望開啟錯誤報告來幫助調試。
// 在生產環境中，通常會關閉這些錯誤報告來避免泄露敏感信息。
// 根據您的需求取消下面兩行的註釋或進行調整。
// ini_set('display_errors', 1);
// error_reporting(E_ALL);

?>