#!/bin/bash

# © 2018 Thiago Macedo, ADAX Technology
# License AGPL-3.0 or later (http://www.gnu.org/licenses/agpl.html).

#--------------------------------------------------
# Atualizando Servidor
#--------------------------------------------------
echo -e "\n---- Atualizando Servidor ----"
sudo apt-get update
sudo apt-get upgrade -y
sudo locale-gen en_US en_US.UTF-8 pt_BR.UTF-8

#--------------------------------------------------
# Instalando PostgreSQL Server
#--------------------------------------------------
echo -e "\n---- Instalando PostgreSQL Server ----"
sudo apt-get install postgresql -y
sudo service postgresql restart
echo -e "\n---- Criando usuário "odoo" no PostgreSQL Server ----"
sudo -u postgres psql -e --command "CREATE USER odoo WITH SUPERUSER PASSWORD '1q2w3e4r'"

#--------------------------------------------------
# Instalando Dependências
#--------------------------------------------------
echo -e "\n--- Instalando Python 3 + pip3 --"
sudo apt-get install python3 python3-pip python3-suds -y

echo -e "\n---- Instalando Ferramentas ----"
sudo apt-get install wget git git-core zip htop tig cups bzr python-pip gdebi-core npm virtualenv -y

echo -e "\n---- Instalando outras dependências ----"
sudo apt-get install -y libxml2-dev libxslt-dev libldap2-dev libssl-dev libsnmp-dev libffi-dev libevent-dev libpq-dev
sudo apt-get install -y libpng12-dev libjpeg-dev libfreetype6-dev libxmlsec1-dev libsasl2-dev
sudo apt-get install -y expect-dev xfonts-75dpi xfonts-base default-jre ure libreoffice-java-common libreoffice-writer
sudo apt-get install -y fonts-symbola node-clean-css node-less texlive-fonts-extra

echo -e "\n---- Instalando pacotes Python ----"
sudo apt-get install -y python-pypdf2 python-dateutil python-feedparser python-ldap python-libxslt1 python-lxml
sudo apt-get install -y python-mako python-openid python-psycopg2 python-pybabel python-pychart python-pydot
sudo apt-get install -y python-pyparsing python-reportlab python-simplejson python-tz python-vatnumber python-vobject
sudo apt-get install -y python-webdav python-werkzeug python-xlwt python-yaml python-zsi python-docutils python-psutil
sudo apt-get install -y python-mock python-unittest2 python-jinja2 python-pypdf python-decorator python-requests
sudo apt-get install -y python-passlib python-pil python-dev python3-dev python-gevent python3-lxml

echo -e "\n--- Instalando pacotes via pip3 --"
sudo -H pip3 install Babel==2.3.4
sudo -H pip3 install decorator==4.0.10
sudo -H pip3 install docutils==0.12
sudo -H pip3 install ebaysdk==2.1.5
sudo -H pip3 install feedparser==5.2.1
sudo -H pip3 install gevent==1.1.2
sudo -H pip3 install greenlet==0.4.10
sudo -H pip3 install html2text==2016.9.19
sudo -H pip3 install Jinja2==2.8
sudo -H pip3 install lxml==3.5.0
sudo -H pip3 install Mako==1.0.4
sudo -H pip3 install MarkupSafe==0.23
sudo -H pip3 install mock==2.0.0
sudo -H pip3 install num2words==0.5.4
sudo -H pip3 install ofxparse==0.16
sudo -H pip3 install passlib==1.6.5
sudo -H pip3 install Pillow==3.4.2
sudo -H pip3 install psutil==4.3.1
sudo -H pip3 install psycopg2==2.7.1
sudo -H pip3 install pydot==1.2.3
sudo -H pip3 install pyldap==2.4.28
sudo -H pip3 install pyparsing==2.1.10
sudo -H pip3 install PyPDF2==1.26.0
sudo -H pip3 install pyserial==3.1.1
sudo -H pip3 install python-dateutil==2.5.3
sudo -H pip3 install pytz==2016.7
sudo -H pip3 install pyusb==1.0.0
sudo -H pip3 install PyYAML==3.12
sudo -H pip3 install qrcode==5.3
sudo -H pip3 install reportlab==3.3.0
sudo -H pip3 install requests==2.11.1
sudo -H pip3 install six==1.10.0
sudo -H pip3 install suds-jurko==0.6
sudo -H pip3 install vatnumber==1.2
sudo -H pip3 install vobject==0.9.3
sudo -H pip3 install Werkzeug==0.11.11
sudo -H pip3 install XlsxWriter==0.9.3
sudo -H pip3 install xlwt==1.3.*
sudo -H pip3 install xlrd==1.0.0

echo -e "\n--- Instalando pacotes via pip3 Diversos --"
sudo -H pip3 install cachetools
sudo -H pip3 install pdfconv
sudo -H pip3 install paramiko
sudo -H pip3 install simplejson
echo -e "\n--- Instalando pacotes via pip3 Localização Brasil --"
sudo -H pip3 install pytrustnfe3
sudo -H pip3 install suds-jurko-requests
sudo -H pip3 install python3-cnab
sudo -H pip3 install python3-boleto
sudo -H pip3 install xmlsec

echo -e "\n---- Instalando 'less' ----"
sudo npm install -g less less-plugin-clean-css
sudo ln -s /usr/bin/nodejs /usr/bin/node

echo -e "\n---- Instalando 'WKHTMLTOX' ----"
cd /tmp
sudo wget https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.1/wkhtmltox-0.12.1_linux-trusty-amd64.deb
sudo dpkg -i wkhtmltox-0.12.1_linux-trusty-amd64.deb
cd

#--------------------------------------------------
# Instalando Servidor Odoo
#--------------------------------------------------
echo -e "\n---- Criando usuário e diretórios para instalação do Servidor Odoo ----"
sudo adduser --system --home=/opt/odoo --group odoo

echo -e "\n---- Criando diretório de Log ----"
mkdir /var/log/odoo
sudo chown -R odoo: /var/log/odoo

echo -e "\n---- Baixando core do Servidor Odoo ----"
sudo git clone https://www.github.com/odoo/odoo --depth 1 --branch 11.0 --single-branch /opt/odoo/core
sudo git clone https://github.com/Trust-Code/odoo-brasil.git --depth 1 --branch 11.0 --single-branch /opt/odoo/modulos/localbr
echo "\n---- Criando arquivo de configuração do Servidor ADAX ERP ---"
sudo cat <<EOF > /etc/odoo.conf
[options]
addons_path = /opt/odoo/core/addons,/opt/odoo/modulos/localbr,/opt/odoo/modulos/backend
admin_passwd = 1q2w3e4r
auto_reload = False
csv_internal_sep = ,
db_host = localhost
db_port = 5432
db_maxconn = 64
db_name = False
#dbfilter = ^%d$
xmlrpc = True
xmlrpc_port = 8888
db_template = template0
db_user = odoo
db_password= 1q2w3e4r
logfile = /var/log/odoo/log
EOF

echo "\n---- Criando arquivo de inicialização do servidor ---"
sudo cat <<EOF > /etc/systemd/system/odoo.service
[Unit]
Description= Servidor Odoo - ADAX Technology
Documentation=http://www.adaxtechnology.com/
Contact=contato@adaxtechnology.com

[Service]

# Ubuntu:

Type=simple
User=odoo
PIDFile=/var/run/odoo.pid
ExecStart=/opt/odoo/core/odoo-bin -c /etc/odoo.conf
Restart=on-abort

[Install]
WantedBy=default.target
EOF

sudo chmod a+x /etc/systemd/system/odoo.service

echo -e "\n---- Startando serviço do Servidor Odoo ----"
sudo systemctl enable odoo.service

echo -e "\n---- Ativando serviço do Servidor Odoo no boot ----"
sudo systemctl start odoo.service
sudo service odoo status


