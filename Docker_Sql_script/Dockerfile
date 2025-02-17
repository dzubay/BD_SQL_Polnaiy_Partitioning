# Используем существующий образ
FROM beejay/mssql-fts:ubuntu

# Переключаемся на пользователя root для копирования файлов
USER root

# Копируем SQL-файл в контейнер
COPY Public_file.sql /usr/src/app/Public_file.sql

# Переключаемся обратно на пользователя mssql
USER mssql

# Устанавливаем переменные окружения для SQL Server
ENV ACCEPT_EULA=Y
ENV SA_PASSWORD=TempPa55wd#
ENV MSSQL_PID=Developer

# Настройка рабочей директории
WORKDIR /usr/src/app

# Команда для запуска SQL Server и выполнения SQL-файла
CMD /opt/mssql/bin/sqlservr & \
    sleep 30 && \
    /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P 'TempPa55wd#' -i /usr/src/app/Public_file.sql
