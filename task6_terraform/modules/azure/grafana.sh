#!/bin/bash

# Обновление списка пакетов
sudo apt-get update

# Установка зависимостей
sudo apt-get install -y adduser libfontconfig1

# Скачивание и установка Grafana
wget https://dl.grafana.com/oss/release/grafana_8.2.2_amd64.deb
sudo dpkg -i grafana_8.2.2_amd64.deb

# Запуск Grafana и добавление в автозапуск
sudo systemctl start grafana-server
sudo systemctl enable grafana-server

echo "Grafana установлена и настроена."