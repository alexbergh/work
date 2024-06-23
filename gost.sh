#!/bin/bash

# Проверка прав пользователя
if [ $(id -u)!= "0" ]; then
    echo "Этот скрипт должен быть выполнен с правами суперпользователя (root)"
    exit 1
fi

# Путь к файлу конфигурации afick
CONFIG_FILE="/etc/afick.conf"

# Путь к базе данных afick
AFICK_DB="/var/lib/afick/afick.ndb"

# Путь к файлу gostsums.txt, расположенному в корневом каталоге замонтированного CD-диска из ISO-образа
GOSTSUMS_FILE=$(findmnt -o SOURCE -T /path/to/mountpoint | grep '\.iso$' | head -n 1)

# Путь к директории с файлами для проверки
FILES_DIR="/boot"

# Путь к файлу отчета
REPORT_URL="/var/log/afick_report.txt"

# Путь к каталогу с cron-заданиями
CRON_DIR="/etc/cron.daily/"

# Путь к скрипту afick_cron
AFICK_CRON_SCRIPT="$CRON_DIR/afick_cron"

# Создаем файл конфигурации, если он не существует
if [! -f "$CONFIG_FILE" ]; then
    echo "boot\tGOST" >> $CONFIG_FILE
    echo "/bin\tGOST" >> $CONFIG_FILE
    echo "/etc/security\tPARSEC" >> $CONFIG_FILE
    echo "/etc/pam.d\tPARSEC" >> $CONFIG_FILE
    echo "/etc/fstab\tPARSEC" >> $CONFIG_FILE
    echo "/lib/modules\tPARSEC" >> $CONFIG_FILE
    echo "/lib64/security\tPARSEC" >> $CONFIG_FILE
    echo "/lib/security\tPARSEC" >> $CONFIG_FILE
    echo "/sbin\tPARSEC" >> $CONFIG_FILE
    echo "/usr/bin\tPARSEC" >> $CONFIG_FILE
    echo "/usr/lib\tPARSEC" >> $CONFIG_FILE
    echo "/usr/sbin\tPARSEC" >> $CONFIG_FILE
    echo "/boot\tGOST" >> $CONFIG_FILE
    echo "/bin\tGOST" >> $CONFIG_FILE
    echo "/etc/security\tPARSEC" >> $CONFIG_FILE
    echo "/etc/pam.d\tPARSEC" >> $CONFIG_FILE
    echo "/etc/fstab\tPARSEC" >> $CONFIG_FILE
    echo "/lib/modules\tPARSEC" >> $CONFIG_FILE
    echo "/lib64/security\tPARSEC" >> $CONFIG_FILE
    echo "/lib/security\tPARSEC" >> $CONFIG_FILE
    echo "/sbin\tPARSEC" >> $CONFIG_FILE
    echo "/usr/bin\tPARSEC" >> $CONFIG_FILE
    echo "/usr/lib\tPARSEC" >> $CONFIG_FILE
    echo "/usr/sbin\tPARSEC" >> $CONFIG_FILE
    #echo "# Дополнительные пути с правилами" >> $CONFIG_FILE
fi

# Настройка afick
echo "Настройка afick"
cp $CONFIG_FILE /tmp/afick.conf
sed -i 's/database:=\/var\/lib\/afick\/afick/database:='"$AFICK_DB"'/' /tmp/afick.conf
sed -i 's/report_url:=stdout/report_url:='"$REPORT_URL"'/' /tmp/afick.conf
# Добавьте здесь другие изменения конфигурации, если необходимо

# Запуск afick для создания/обновления базы данных
echo "Запуск afick для обновления базы данных"
afick -i

# Создание cron-задания для регулярного выполнения проверки
echo "Создание cron-задания"
cat > $AFICK_CRON_SCRIPT << EOF
#!/bin/sh
/usr/sbin/afick > /var/log/afick.log
EOF
chmod +x $AFICK_CRON_SCRIPT

# Добавление задания в crontab для ежедневного выполнения
(crontab -l ; echo "0 2 * * * $AFICK_CRON_SCRIPT") | crontab -

echo "Настройка завершена"
