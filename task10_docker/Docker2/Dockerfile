# Используйте образ Ubuntu в качестве базового образа
FROM ubuntu:latest

# Установите утилиту ping
RUN apt-get update && apt-get install -y iputils-ping

# Запустите бесконечный цикл для поддержания контейнера в рабочем состоянии
CMD ["tail", "-f", "/dev/null"]