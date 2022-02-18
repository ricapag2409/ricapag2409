Sistema de gerenciamento de senhas, é necessário acessar ou o phpMyAdmin ou o Mysql Workbench e inserir manualmente as senhas no banco de dados, após a inserção, o sistema mostra uma tabela contendo as senhas com seus respectivos usuários + senhas + logotipo(se clicado em cima ele redireciona para o link de login).

O arquivo db.php contém as informações para acessarmos o banco de dados.
O arquivo restrito.php é caso você queira colocar alguma autenticação antes (WEB Authentication) antes de vermos as senhas, caso queira habilitar, descomentar a linha 2 do arquivo index.php
