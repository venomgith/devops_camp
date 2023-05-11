# Используйте образ Nginx в качестве базового образа
FROM nginx:latest

# Копируйте свою страницу index.html внутрь контейнера
COPY index.html /usr/share/nginx/html/

# Откройте порт 80 для входящего трафика
EXPOSE 80

# Запустите Nginx при запуске контейнера
CMD ["nginx", "-g", "daemon off;"]