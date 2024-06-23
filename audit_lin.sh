#!/bin/bash

# Проверка прав пользователя
if [ $(id -u)!= "0" ]; then
    echo "Этот скрипт должен быть выполнен с правами суперпользователя (root)."
    exit 1
fi

# Проверка установки службы Auditd
if! dpkg-query -W -f='${Status}' auditd >/dev/null 2>&1; then
    echo "Установка службы Auditd"
    apt-get update && apt-get install -y auditd
else
    echo "Служба Auditd уже установлена."
fi

# Настройка службы Auditd
echo "Настройка службы Auditd"
echo "max_log_file = 50" | sudo tee -a /etc/audit/auditd.conf
echo "num_logs = 5" | sudo tee -a /etc/audit/auditd.conf
echo "log_file = /var/log/audit/audit.log" | sudo tee -a /etc/audit/auditd.conf
echo "log_group = root" | sudo tee -a /etc/audit/auditd.conf

# Добавление правил регистрации событий безопасности
echo "Добавление правил регистрации событий безопасности"

# Отслеживание изменений в директории или файле
echo "sudo auditctl -w /var/log -p wa -k var_log_changes" | sudo tee -a /etc/audit/audit.rules

# Аудит пользователей, групп, базы данных паролей
echo "sudo auditctl -w /etc/group -p wa -k etcgroup" | sudo tee -a /etc/audit/audit.rules
echo "sudo auditctl -w /etc/passwd -p wa -k etcpasswd" | sudo tee -a /etc/audit/audit.rules
echo "sudo auditctl -w /etc/gshadow -k etcgroup" | sudo tee -a /etc/audit/audit.rules
echo "sudo auditctl -w /etc/shadow -k etcpasswd" | sudo tee -a /etc/audit/audit.rules
echo "sudo auditctl -w /etc/security/opasswd -k opasswd" | sudo tee -a /etc/audit/audit.rules

# Аудит изменений в файле Sudoers
echo "sudo auditctl -w /etc/sudoers -p wa -k actions" | sudo tee -a /etc/audit/audit.rules

# Аудит паролей
echo "sudo auditctl -w /usr/bin/passwd -p x -k passwd modification" | sudo tee -a /etc/audit/audit.rules
echo "sudo auditctl -w /usr/bin/gpasswd -p x -k gpasswdmodification" | sudo tee -a /etc/audit/audit.rules

# Аудит изменения идентификаторов групп
echo "sudo auditctl -w /usr/sbin/groupadd -p x -k group modification" | sudo tee -a /etc/audit/audit.rules
echo "sudo auditctl -w /usr/sbin/groupmod -p x -k group_modification" | sudo tee -a /etc/audit/audit.rules
echo "sudo auditctl -w /usr/sbin/addgroup -p x -k group modification" | sudo tee -a /etc/audit/audit.rules
echo "sudo auditctl -w /usr/sbin/useradd -p x -k user modification" | sudo tee -a /etc/audit/audit.rules
echo "sudo auditctl -w /usr/sbin/usermod -p x -k user modification" | sudo tee -a /etc/audit/audit.rules
echo "sudo auditctl -w /usr/sbin/adduser -p x -k user modification" | sudo tee -a /etc/audit/audit.rules

# Аудит конфигурации и входов
echo "sudo auditctl -w /etc/login.defs -p wa -k login" | sudo tee -a /etc/audit/audit.rules
echo "sudo auditctl -w /etc/securetty -p wa -k login" | sudo tee -a /etc/audit/audit.rules
echo "sudo auditctl -w /var/log/faillog -p wa -k login" | sudo tee -a /etc/audit/audit.rules
echo "sudo auditctl -w /var/log/lastlog -p wa -k login" | sudo tee -a /etc/audit/audit.rules
echo "sudo auditctl -w /var/log/tallylog -p wa -k login" | sudo tee -a /etc/audit/audit.rules

# Отслеживание запуска определенного приложения
echo "sudo auditctl -a exit,always -F path=/usr/bin/myapp -F perm=x -k myapp execution" | sudo tee -a /etc/audit/audit.rules

# Отслеживание системных вызовов
echo "sudo auditctl -a exit,always -F arch=b64 -S execve -F uid=0 -k authentication events" | sudo tee -a /etc/audit/audit.rules
echo "sudo auditctl -a exit,always -F arch=b32 -S execve -F uid=0 -k authentication events" | sudo tee -a /etc/audit/audit.rules

# Отслеживание сетевых подключений
echo "sudo auditctl -a exit,always -F arch=b64 -S bind -S connect -F success=0 -k network events" | sudo tee -a /etc/audit/audit.rules

# Запись в журнал аудита при подключении устройства USB
echo "sudo auditctl -w /dev/bus/usb -p rwxa -k usb" | sudo tee -a /etc/audit/audit.rules

echo "Все настройки подготовлены для выполнения."
