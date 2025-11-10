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
    apt-get install -yq curl apt-transport-https locales tzdata && \
    # ПРИНУДИТЕЛЬНО устанавливаем РУССКУЮ локаль для корректных дат
    echo "LANG=ru_RU.UTF-8" > /etc/default/locale && \
    echo "LC_ALL=ru_RU.UTF-8" >> /etc/default/locale && \
    echo "LC_TIME=ru_RU.UTF-8" >> /etc/default/locale && \
    echo "LC_CTYPE=ru_RU.UTF-8" >> /etc/default/locale && \
    echo "ru_RU.UTF-8 UTF-8" > /etc/locale.gen && \
    echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && \
    locale-gen ru_RU.UTF-8 && \
    locale-gen en_US.UTF-8 && \
    dpkg-reconfigure -f noninteractive locales && \
    update-locale LANG=ru_RU.UTF-8 LC_ALL=ru_RU.UTF-8 LC_TIME=ru_RU.UTF-8 && \
    # Устанавливаем временную зону
    echo "Europe/Moscow" > /etc/timezone && \
    dpkg-reconfigure -f noninteractive tzdata && \
    # Добавляем репозиторий Microsoft
    curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    curl https://packages.microsoft.com/config/ubuntu/16.04/mssql-server-2019.list | tee /etc/apt/sources.list.d/mssql-server.list && \
    apt-get update && \
    # Устанавливаем SQL Server
    apt-get install -y mssql-server mssql-server-ha mssql-server-fts && \
    # Устанавливаем mssql-tools
    curl https://packages.microsoft.com/config/ubuntu/16.04/prod.list > /etc/apt/sources.list.d/mssql-release.list && \
    apt-get update && \
    ACCEPT_EULA=Y apt-get install -y mssql-tools unixodbc-dev && \
    # Очистка
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Жестко задаем РУССКУЮ локаль в системных файлах
RUN echo "export LANG=ru_RU.UTF-8" >> /etc/bash.bashrc && \
    echo "export LC_ALL=ru_RU.UTF-8" >> /etc/bash.bashrc && \
    echo "export LANGUAGE=ru_RU:ru" >> /etc/bash.bashrc && \
    echo "export LC_TIME=ru_RU.UTF-8" >> /etc/bash.bashrc

# Копируем SQL-скрипт в контейнер
COPY Public_file_Docker.sql /tmp/Public_file_Docker.sql

# Создаем директорию для скрипта
RUN mkdir -p /usr/src/app

# Создаем скрипт для запуска с ПРАВИЛЬНОЙ последовательностью
RUN echo "#!/bin/bash" > /usr/src/app/entrypoint.sh && \
    echo "set -e" >> /usr/src/app/entrypoint.sh && \
    echo "" >> /usr/src/app/entrypoint.sh && \
    echo "# Принудительно устанавливаем РУССКУЮ локаль" >> /usr/src/app/entrypoint.sh && \
    echo "export LANG=ru_RU.UTF-8" >> /usr/src/app/entrypoint.sh && \
    echo "export LC_ALL=ru_RU.UTF-8" >> /usr/src/app/entrypoint.sh && \
    echo "export LANGUAGE=ru_RU:ru" >> /usr/src/app/entrypoint.sh && \
    echo "export LC_TIME=ru_RU.UTF-8" >> /usr/src/app/entrypoint.sh && \
    echo "" >> /usr/src/app/entrypoint.sh && \
    echo "# Запускаем SQL Server" >> /usr/src/app/entrypoint.sh && \
    echo "echo '=== Starting SQL Server ==='" >> /usr/src/app/entrypoint.sh && \
    echo "/opt/mssql/bin/sqlservr &" >> /usr/src/app/entrypoint.sh && \
    echo "sleep 60" >> /usr/src/app/entrypoint.sh && \
    echo "" >> /usr/src/app/entrypoint.sh && \
    echo "# Ждем готовности SQL Server" >> /usr/src/app/entrypoint.sh && \
    echo "echo '=== Waiting for SQL Server ==='" >> /usr/src/app/entrypoint.sh && \
    echo "for i in {1..12}; do" >> /usr/src/app/entrypoint.sh && \
    echo "  if /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P 'TempPa55wd#' -Q 'SELECT 1' -b -o /dev/null; then" >> /usr/src/app/entrypoint.sh && \
    echo "    echo 'SQL Server ready!'" >> /usr/src/app/entrypoint.sh && \
    echo "    break" >> /usr/src/app/entrypoint.sh && \
    echo "  fi" >> /usr/src/app/entrypoint.sh && \
    echo "  sleep 10" >> /usr/src/app/entrypoint.sh && \
    echo "done" >> /usr/src/app/entrypoint.sh && \
    echo "" >> /usr/src/app/entrypoint.sh && \
    echo "# СНАЧАЛА устанавливаем русский язык как язык по умолчанию для сервера" >> /usr/src/app/entrypoint.sh && \
    echo "echo '=== Setting Russian as Default Language ==='" >> /usr/src/app/entrypoint.sh && \
    echo "/opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P 'TempPa55wd#' -Q \"EXEC sp_configure 'default language', 25; RECONFIGURE;\" -f 65001" >> /usr/src/app/entrypoint.sh && \
    echo "" >> /usr/src/app/entrypoint.sh && \
    echo "# Перезапускаем SQL Server для применения изменений языка" >> /usr/src/app/entrypoint.sh && \
    echo "echo '=== Restarting SQL Server to apply language settings ==='" >> /usr/src/app/entrypoint.sh && \
    echo "pkill sqlservr" >> /usr/src/app/entrypoint.sh && \
    echo "sleep 30" >> /usr/src/app/entrypoint.sh && \
    echo "/opt/mssql/bin/sqlservr &" >> /usr/src/app/entrypoint.sh && \
    echo "sleep 30" >> /usr/src/app/entrypoint.sh && \
    echo "" >> /usr/src/app/entrypoint.sh && \
    echo "# Ждем готовности SQL Server после перезапуска" >> /usr/src/app/entrypoint.sh && \
    echo "echo '=== Waiting for SQL Server after restart ==='" >> /usr/src/app/entrypoint.sh && \
    echo "for i in {1..12}; do" >> /usr/src/app/entrypoint.sh && \
    echo "  if /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P 'TempPa55wd#' -Q 'SELECT 1' -b -o /dev/null; then" >> /usr/src/app/entrypoint.sh && \
    echo "    echo 'SQL Server ready after restart!'" >> /usr/src/app/entrypoint.sh && \
    echo "    break" >> /usr/src/app/entrypoint.sh && \
    echo "  fi" >> /usr/src/app/entrypoint.sh && \
    echo "  sleep 10" >> /usr/src/app/entrypoint.sh && \
    echo "done" >> /usr/src/app/entrypoint.sh && \
    echo "" >> /usr/src/app/entrypoint.sh && \
    echo "# Выполняем SQL скрипт с UTF-8 и русскими настройками дат" >> /usr/src/app/entrypoint.sh && \
    echo "echo '=== Executing SQL Script with Russian settings ==='" >> /usr/src/app/entrypoint.sh && \
    echo "# Создаем временный файл с настройками и основным скриптом" >> /usr/src/app/entrypoint.sh && \
    echo "cat > /tmp/combined_script.sql << 'EOF'" >> /usr/src/app/entrypoint.sh && \
    echo "SET LANGUAGE Russian;" >> /usr/src/app/entrypoint.sh && \
    echo "SET DATEFORMAT dmy;" >> /usr/src/app/entrypoint.sh && \
    echo "GO" >> /usr/src/app/entrypoint.sh && \
    echo ":r /tmp/Public_file_Docker.sql" >> /usr/src/app/entrypoint.sh && \
    echo "EOF" >> /usr/src/app/entrypoint.sh && \
    echo "" >> /usr/src/app/entrypoint.sh && \
    echo "/opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P 'TempPa55wd#' -i /tmp/combined_script.sql -f 65001 -t 0 -b" >> /usr/src/app/entrypoint.sh && \
    echo "echo '=== Script Execution Completed ==='" >> /usr/src/app/entrypoint.sh && \
    echo "" >> /usr/src/app/entrypoint.sh && \
    echo "tail -f /dev/null" >> /usr/src/app/entrypoint.sh && \
    chmod +x /usr/src/app/entrypoint.sh

EXPOSE 1433
CMD ["/bin/bash", "/usr/src/app/entrypoint.sh"]