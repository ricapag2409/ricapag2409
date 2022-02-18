window.addEventListener('load', function(){

  document.getElementById('pesquisar').addEventListener('keyup', function(e){
    var dadosTabela = document.getElementsByTagName('tbody')[0].getElementsByTagName('tr');
    for(i = 0; i < dadosTabela.length; i++){
      if(dadosTabela[i].getElementsByTagName('td')[1].innerText.toLowerCase().indexOf(this.value.toLowerCase()) !== -1){
        dadosTabela[i].style.display = 'table-row';
      } else{
        dadosTabela[i].style.display = 'none';
      }
    }
  });
});
