# Используем базовый образ Ubuntu 16.04
FROM ubuntu:16.04

# Устанавливаем переменные окружения для MS SQL Server
ENV ACCEPT_EULA=Y
ENV SA_PASSWORD=TempPa55wd#
ENV MSSQL_PID=Developer
ENV MSSQL_ENABLE_HADR=0
ENV MSSQL_ENABLE_MIXED_AUTH=1

# Устанавливаем необходимые пакеты
RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get install -yq curl apt-transport-https && \
    # Добавляем репозиторий Microsoft
    curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    curl https://packages.microsoft.com/config/ubuntu/16.04/mssql-server-2019.list | tee /etc/apt/sources.list.d/mssql-server.list && \
    apt-get update && \
    # Устанавливаем SQL Server и дополнительные компоненты
    apt-get install -y mssql-server mssql-server-ha mssql-server-fts && \
    # Устанавливаем mssql-tools для выполнения SQL-скриптов
    curl https://packages.microsoft.com/config/ubuntu/16.04/prod.list > /etc/apt/sources.list.d/mssql-release.list && \
    apt-get update && \
    ACCEPT_EULA=Y apt-get install -y mssql-tools unixodbc-dev && \
    # Очистка кеша apt
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Копируем SQL-скрипт в контейнер
COPY Public_file.sql /tmp/Public_file.sql

# Создаем директорию для скрипта
RUN mkdir -p /usr/src/app

# Создаем скрипт для запуска
RUN echo "#!/bin/bash" > /usr/src/app/entrypoint.sh && \
    echo "/opt/mssql/bin/sqlservr &" >> /usr/src/app/entrypoint.sh && \
    echo "sleep 120" >> /usr/src/app/entrypoint.sh && \
    echo "/opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P 'TempPa55wd#' -i /tmp/Public_file.sql" >> /usr/src/app/entrypoint.sh && \
    echo "tail -f /dev/null" >> /usr/src/app/entrypoint.sh && \
    chmod +x /usr/src/app/entrypoint.sh

# Открываем порт для MS SQL Server
EXPOSE 1433

# Запускаем скрипт при старте контейнера
CMD ["/bin/bash", "/usr/src/app/entrypoint.sh"]