<?php
class Database
{
    private static $instance = null;
    private $conn;
    private $servername = "localhost";
    // private $servername = "163.17.136.73";
    private $user = "kumo";
    private $pass = "coco3430";
    // private $dbname = "spaced";
    private $dbname = "GP";
    private $port = 1433;

    private function __construct()
    {
        date_default_timezone_set('Asia/Taipei');
        
        $this->conn = new mysqli($this->servername, $this->user, $this->pass, $this->dbname);
        // $this->conn = new mysqli($this->servername, $this->user, $this->pass, $this->dbname, $this->port);
        if ($this->conn->connect_error) {
            die("連接失敗：" . $this->conn->connect_error);
        }
    }

    public static function getInstance()
    {
        if (!self::$instance) {
            self::$instance = new Database();
        }
        return self::$instance;
    }

    public function getConnection()
    {
        return $this->conn;
    }
}

?>