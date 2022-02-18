window.addEventListener('load', function(){

  var ajax = new XMLHttpRequest();
  ajax.open('POST', 'ajaxResponse.php', true);
  ajax.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
  ajax.send(
    'acao=anoreferencia'
  );
  ajax.onreadystatechange = function () {
    if (ajax.readyState == 4 && ajax.status == 200) {
      var jsonDecoded = JSON.parse(ajax.responseText);
      document.getElementById('anoreferencia').innerHTML = '<option value="">Escolha um ano de referência</option>';
      for(i = 0; i < jsonDecoded.length; i++){
        document.getElementById('anoreferencia').innerHTML += '<option value=' + '"' + jsonDecoded[i].Codigo + '">' + jsonDecoded[i].Mes + '</option>';
      }
    }
  }

  document.getElementById('anoreferencia').addEventListener('change', function(){
    if(this.value == ''){
      console.log('não posso concluir');
    } else{
      var ajax = new XMLHttpRequest();
      ajax.open('POST', 'ajaxResponse.php', true);
      ajax.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
      ajax.send(
        'acao=marcas' +
        '&anoreferencia=' + this.value
      );
      ajax.onreadystatechange = function () {
        if (ajax.readyState == 4 && ajax.status == 200) {
          console.log(ajax.responseText);
          var jsonDecoded = JSON.parse(ajax.responseText);
          document.getElementById('marca').innerHTML = '<option value="Escolha uma marca">Escolha uma marca</option>';
          for(i = 0; i < jsonDecoded.length; i++){
            document.getElementById('marca').innerHTML += '<option value=' + '"' + jsonDecoded[i].Value + '">' + jsonDecoded[i].Label.toLowerCase().split(' ').map(x=>x[0].toUpperCase()+x.slice(1)).join(' '); + '</option>';
          }
        }
      }
    }
  });

  document.getElementById('marca').addEventListener('change', function(){
    var ajax = new XMLHttpRequest();
    ajax.open('POST', 'ajaxResponse.php', true);
    ajax.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
    ajax.send(
      'acao=modelos' +
      '&anoreferencia=' + document.getElementById('anoreferencia').value +
      '&modelo=' + this.value
    );
    ajax.onreadystatechange = function () {
      if (ajax.readyState == 4 && ajax.status == 200) {
        var jsonDecoded = JSON.parse(ajax.responseText);
        document.getElementById('modelo').innerHTML = '<option value="Escolha um modelo">Escolha um modelo</option>';
        for(i = 0; i < jsonDecoded.Modelos.length; i++){
          document.getElementById('modelo').innerHTML += '<option value=' + '"' + jsonDecoded.Modelos[i].Value + '">' + jsonDecoded.Modelos[i].Label + '</option>';
        }
      }
    }
  });

  document.getElementById('modelo').addEventListener('change', function(){
    var ajax = new XMLHttpRequest();
    ajax.open('POST', 'ajaxResponse.php', true);
    ajax.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
    ajax.send(
      'acao=ano' +
      '&anoreferencia=' + document.getElementById('anoreferencia').value +
      '&marca=' + document.getElementById('marca').value +
      '&modelo=' + document.getElementById('modelo').value
    );
    ajax.onreadystatechange = function () {
      if (ajax.readyState == 4 && ajax.status == 200) {
        var jsonDecoded = JSON.parse(ajax.responseText);
        document.getElementById('ano').innerHTML = '<option value="Escolha um ano">Escolha um ano</option>';
        for(i = 0; i < jsonDecoded.length; i++){
          if(jsonDecoded[i].Label.indexOf('32000') !== -1){
            var ano = '0 KM';
          } else{
            var ano = jsonDecoded[i].Label;
          }
          document.getElementById('ano').innerHTML += '<option value=' + '"' + jsonDecoded[i].Value + '">' + ano + '</option>';
        }
      }
    }
  });
  document.getElementById('ano').addEventListener('change', function(){
    var ajax = new XMLHttpRequest();
    ajax.open('POST', 'ajaxResponse.php', true);
    ajax.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
    ajax.send(
      'acao=dados' +
      '&anoreferencia=' + document.getElementById('anoreferencia').value +
      '&marca=' + document.getElementById('marca').value +
      '&modelo=' + document.getElementById('modelo').value +
      '&ano=' + this.value
    );
    ajax.onreadystatechange = function () {
      if (ajax.readyState == 4 && ajax.status == 200) {
        document.getElementById('resultadoConsulta').style.display = 'block';
        document.getElementById('resultadoConsulta').innerHTML = ajax.responseText;
      }
    }
  });
});
