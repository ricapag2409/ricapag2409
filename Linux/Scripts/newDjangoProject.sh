#!/bin/bash

# Funções para colorir o texto
red() {
  if [ "$2" == "bold" ]; then
    echo -e "\033[1;31m$1\033[0m"
  else
    echo -e "\033[31m$1\033[0m"
  fi
}

green() {
  if [ "$2" == "bold" ]; then
    echo -e "\033[1;32m$1\033[0m"
  else
    echo -e "\033[32m$1\033[0m"
  fi
}

yellow() {
  if [ "$2" == "bold" ]; then
    echo -e "\033[1;33m$1\033[0m"
  else
    echo -e "\033[33m$1\033[0m"
  fi
}

blue() {
  if [ "$2" == "bold" ]; then
    echo -e "\033[1;34m$1\033[0m"
  else
    echo -e "\033[34m$1\033[0m"
  fi
}

# Passo 1, digitar o nome do projeto base, isto irá criar uma pasta com o nome

echo
yellow "Digite o nome do projeto Base" bold
read NOMEPROJETOBASE

python3 -m venv "$NOMEPROJETOBASE"

source "$NOMEPROJETOBASE/bin/activate"

#Passo 2, digite com espaço o nome dos pacotes que deseja instalar

echo
yellow "Digite com espaços o nome dos pacotes que deseja instalar, Django vai por padrão" bold
read NOMEPACOTES

HASALLAUTH=false

# Verifica se 'django-allauth' está nos pacotes informados
if echo "$NOMEPACOTES" | grep -qw "django-allauth"; then
  # Adiciona os pacotes adicionais necessários para o django-allauth
  PACOTES_ADICIONAIS="pyJWT requests cryptography"
  # Remove 'django-allauth' da lista de pacotes originais
  NOMEPACOTES=$(echo "$NOMEPACOTES" | sed 's/\bdjango-allauth\b//g')
  # Concatena 'django-allauth' e os pacotes adicionais com os demais pacotes informados
  NOMEPACOTES="django-allauth $PACOTES_ADICIONAIS $NOMEPACOTES"
  HASALLAUTH=true
fi

# Instala Django por padrão e os pacotes informados
pip3 install django $NOMEPACOTES

if [[ HASALLAUTH ]]; then
  echo
  green "Pacotes adicionais referentes ao django-allauth instalados!" bold
  echo
  green "A configuração do projeto continuará em 1 segundo, favor aguardar..."
  sleep 1
fi

# Passo 3, entra na pasta criada para que todo o restante dos arquivos sejam criados aqui dentro

cd "$NOMEPROJETOBASE" || { red "Erro ao entrar no diretório $NOMEPROJETOBASE"; exit 1; }

# Passo 4, aqui cria o projeto que será responsável pela base de todo o App

echo
yellow "Digite o nome do Projeto" bold
read NOMEPROJETO
django-admin startproject "$NOMEPROJETO"

if [ -d $NOMEPROJETO/static ]; then
  echo "Directory exists."
else
  mkdir $NOMEPROJETO/static
fi
# Passo 5, acessa a pasta criada acima para que o App fique dentro dela

cd "$NOMEPROJETO" || { red "Erro ao entrar no diretório $NOMEPROJETO"; exit 1; }

# Passo 6, Aqui de fato cria o App

echo
yellow "Digite o nome do app" bold
read NOMEAPP
django-admin startapp "$NOMEAPP"

if [ -d $NOMEAPP/templates ]; then
  echo "Directory exists."
else
  mkdir $NOMEAPP/templates
fi

# Passo 7, faz alterações importantes para já termos o ambiente de forma correta para começarmos a programar

sed -i "s/class [A-Za-z]*Config/class ${NOMEAPP}Config/" "$NOMEAPP/apps.py"
sed -i "2i\from django.http import HttpResponse" "$NOMEAPP/views.py"
echo

# Verifica se o urls.py existe na pasta do app
APP_URLS="$NOMEAPP/urls.py"
PROJETO_URLS="$NOMEPROJETO/urls.py"

if [ ! -f "$APP_URLS" ]; then
  red "urls.py não encontrado em $NOMEAPP. Verificando no diretório do projeto..." bold
  echo
  if [ -f "$PROJETO_URLS" ]; then
    cp "$PROJETO_URLS" "$APP_URLS"
    green "urls.py encontrado no diretório do projeto e copiado para $NOMEAPP..." bold
    echo
  else
    red "urls.py não encontrado no diretório do projeto. Nenhum arquivo será copiado." bold
    echo
  fi
else
  blue "urls.py já existe em $NOMEAPP." bold
  echo
fi

APP_CONFIG="$NOMEAPP.apps.${NOMEAPP}Config"

if [[ HASALLAUTH ]]; then
  sed -i "/INSTALLED_APPS = \[/a \    '$APP_CONFIG',\n    'django.contrib.sites',\n    'allauth',\n    'allauth.account',\n    'allauth.socialaccount',\n    'allauth.socialaccount.providers.google'," "$NOMEPROJETO/settings.py"
  sed -i "/MIDDLEWARE = \[/a \    'allauth.account.middleware.AccountMiddleware', #django-allauth-middleware" "$NOMEPROJETO/settings.py"
  sed -i "58i\\\nSITE_ID = 1\n\nAUTHENTICATION_BACKENDS = (\n    'django.contrib.auth.backends.ModelBackend',\n    'allauth.account.auth_backends.AuthenticationBackend',\n)\n\nLOGIN_REDIRECT_URL = '/' #digitar aqui para onde irá redirecionar após login\nLOGOUT_REDIRECT_URL = '/' #Digitar aqui para onde irá redirecionar o usuário ao deslogar\n\nACCOUNT_EMAIL_VERIFICATION = \"none\"\nACCOUNT_EMAIL_REQUIRED = True\nSOCIALACCOUNT_QUERY_EMAIL = True\n\nSOCIALACCOUNT_PROVIDERS = {\n    'google': {\n        'APP': {\n           'client_id': 'SEU_CLIENT_ID', #Digitar aqui o seu Client ID obtido pelo Google Developer Console\n            'secret': 'SEU_CLIENT_SECRET', #Digitar aqui o seu Client Secret obtido pelo Google Developer Console\n           'key': ''\n        },\n        'SCOPE': [\n           'profile',\n           'email',\n        ],\n        'AUTH_PARAMS': {\n           'access_type': 'online',\n        }\n    }\n}" "$NOMEPROJETO/settings.py"
  sed -i "/'context_processors': \[/a \                'django.template.context_processors.i18n',\n                'django.template.context_processors.media',\n                'django.template.context_processors.static',\n                'django.template.context_processors.tz'," "$NOMEPROJETO/settings.py"
  sed -i "/urlpatterns = \[/a \    path('accounts/', include('allauth.urls'))," "$NOMEPROJETO/urls.py"
else
  sed -i "/INSTALLED_APPS = \[/a \    '$APP_CONFIG'," "$NOMEPROJETO/settings.py"
fi

sed -i "19i\from . import views" "$NOMEAPP/urls.py"
sed -i "/path('admin\/', admin\.site\.urls),/d" "$NOMEAPP/urls.py"
sed -i "20i\app_name = \"$NOMEAPP\"\n" "$NOMEPROJETO/urls.py"
sed -i "s/from django.urls import path/from django.urls import path,include/" "$NOMEPROJETO/urls.py"
sed -i "/urlpatterns = \[/a \    path('$NOMEAPP/',include('$NOMEAPP.urls'),name=\"$NOMEAPP\")," "$NOMEPROJETO/urls.py"
sed -i "s/TIME_ZONE = 'UTC'/TIME_ZONE = 'America\/Sao_Paulo'/" "$NOMEPROJETO/settings.py"
sed -i "161i\\\n# Diretório onde estão armazenados os arquivos estáticos do projeto\nSTATICFILES_DIRS = [\n    os.path.join(BASE_DIR, \"static\"),\n]" "$NOMEPROJETO/settings.py"
sed -i "14i\\\nimport os\n" "$NOMEPROJETO/settings.py"
sed -i "s/STATIC_URL = 'static\/'/STATIC_URL = '\/static\/'/" "$NOMEPROJETO/settings.py"

# Passo 7, faz a migração do banco de dados inicial para podermos começar a codar.
python3 manage.py makemigrations
python3 manage.py migrate

# Passo 8, Ok com a configuração!
echo
green "Configuração do projeto concluída com sucesso!" bold
