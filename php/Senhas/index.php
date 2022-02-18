<?php
	require('db.php');
	//include('restrito.php');
?>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Senhas</title>
	<link href="assets/css/style.css" rel="stylesheet" type="text/css"/>
	<script type="text/javascript" src="assets/js/scripts.js"></script>
</head>
<body>

	<?php
		$sql = $pdo->prepare("SELECT link,imagem,servico,usuario,senha FROM senhas ORDER BY servico ASC");
		$sql->execute();
		$result = $sql->fetchAll();
	?>
	<p style="text-align:center; font-weight: bold; text-transform: uppercase;">SENHAS</p>
	<p style="text-align:center;">
		<label for="pesquisar">PESQUISAR SENHAS: <input type="text" name="pesquisar" id="pesquisar"></label>
	</p>

	<table class="tg">
		<thead>
			<tr>
				<th class="tg-yw4l">Logo</th>
				<th class="tg-yw4l">Serviço</th>
				<th class="tg-yw4l">Usuário</th>
				<th class="tg-yw4l">Senha</th>
			</tr>
		</thead>
		<tbody>
			<?php 
				foreach($result as $value){
					echo '
					<tr>
						<td class="tg-6k2t"><a href=' . '"' . $value['link'] . '"' . ' target="_blank"><img width="50" src=' . '"' . 'assets/img/' . $value['imagem'] . '"></a></td> 
						<td class="tg-6k2t">' . $value['servico']. '</td>
						<td class="tg-mb3i">' . $value['usuario']. '</td>
						<td class="tg-mb3i">' . $value['senha']. '</td>
					</tr>';
				}
			?>
		</tbody>
	</table>
	
</body>
</html>