<?php 
	try{
		$user = 'root';
		$pwd = '';
		$dbName = 'senhasgerais';
		$pdo = new PDO("mysql:host=localhost;dbname=$dbName", "$user", "$pwd");
		$pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
	} catch(PDOException $e){
		echo 'Erro ao conectar com o banco de dados: ' . $e->getMessage();
	}
?>