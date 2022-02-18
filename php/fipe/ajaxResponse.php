<?php
if(!empty($_POST) && isset($_POST)){

  if($_POST['acao'] == 'anoreferencia'){
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL,'https://veiculos.fipe.org.br/api/veiculos//ConsultarTabelaDeReferencia');
    curl_setopt($ch, CURLOPT_POST, 1);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
  
    $result = curl_exec($ch);
    curl_close($ch);
    $jsonDecoded = json_decode($result,true);
    echo json_encode($jsonDecoded, true);
  }

  if($_POST['acao'] == 'marcas'){
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL,'https://veiculos.fipe.org.br/api/veiculos//ConsultarMarcas');
    curl_setopt($ch, CURLOPT_POST, 1);
    curl_setopt($ch, CURLOPT_POSTFIELDS, http_build_query(array('codigoTabelaReferencia' => $_POST['anoreferencia'],'codigoTipoVeiculo' => 1)));
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
  
    $result = curl_exec($ch);
    curl_close($ch);
    $jsonDecoded = json_decode($result,true);
    echo json_encode($jsonDecoded, true);
  }

  if($_POST['acao'] == 'modelos'){
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL,'https://veiculos.fipe.org.br/api/veiculos//ConsultarModelos');
    curl_setopt($ch, CURLOPT_POST, 1);
    curl_setopt($ch, CURLOPT_POSTFIELDS, http_build_query(array('codigoTipoVeiculo' => 1, 'codigoTabelaReferencia' => $_POST['anoreferencia'],'codigoMarca' => $_POST['modelo'])));
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
  
    $result = curl_exec($ch);
    curl_close($ch);
    $jsonDecoded = json_decode($result,true);
    echo json_encode($jsonDecoded, true);
  }
  if($_POST['acao'] == 'ano'){
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL,'https://veiculos.fipe.org.br/api/veiculos//ConsultarAnoModelo');
    curl_setopt($ch, CURLOPT_POST, 1);
    curl_setopt($ch, CURLOPT_POSTFIELDS, http_build_query(array('codigoTipoVeiculo' => 1, 'codigoTabelaReferencia' => $_POST['anoreferencia'],'codigoMarca' => $_POST['marca'],'codigoModelo' => $_POST['modelo'])));
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
  
    $result = curl_exec($ch);
    curl_close($ch);
    $jsonDecoded = json_decode($result,true);
    echo json_encode($jsonDecoded, true);
  }
  if($_POST['acao'] == 'dados'){
    $dadosComplementares = explode('-', $_POST['ano']);

    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL,'https://veiculos.fipe.org.br/api/veiculos//ConsultarValorComTodosParametros');
    curl_setopt($ch, CURLOPT_POST, 1);
    curl_setopt($ch, CURLOPT_POSTFIELDS, http_build_query(array('codigoTipoVeiculo' => 1, 'codigoTabelaReferencia' => $_POST['anoreferencia'],'codigoMarca' => $_POST['marca'],'codigoModelo' => $_POST['modelo'],'ano' => $_POST['ano'],'codigoTipoCombustivel' => $dadosComplementares[1], 'anoModelo' => $dadosComplementares[0],'tipoVeiculo' => 'carro','tipoConsulta' => 'tradicional')));
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
  
    $result = curl_exec($ch);
    curl_close($ch);
    $jsonDecoded = json_decode($result,true);

    if($jsonDecoded['AnoModelo'] == '32000'){
      $anoModelo = '0 KM';
    } else{
      $anoModelo = $jsonDecoded['AnoModelo'];
    }
    
    echo '
    <table class="tg">
      <thead>
        <tr>
          <th class="tg-phtq">Mês de referência:</th>
          <th class="tg-phtq">' . $jsonDecoded['MesReferencia'] . '</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td class="tg-phtq">Código Fipe:</td>
          <td class="tg-phtq">' . $jsonDecoded['CodigoFipe'] . '</td>
        </tr>
        <tr>
          <td class="tg-phtq">Marca:</td>
          <td class="tg-phtq">' . $jsonDecoded['Marca'] . '</td>
        </tr>
        <tr>
          <td class="tg-phtq">Modelo:</td>
          <td class="tg-phtq">' . $jsonDecoded['Modelo'] . '</td>
        </tr>
        <tr>
          <td class="tg-phtq">Ano Modelo:</td>
          <td class="tg-phtq">' . $anoModelo . '</td>
        </tr>
      <tr>
        <td class="tg-phtq">Preço Médio:</td>
        <td class="tg-phtq">' . $jsonDecoded['Valor'] . '</td>
      </tr>
      </tbody>
    </table>';
    }
  }
?>