#!/bin/bash

# Проверка прав пользователя
if [ "$(id -u)" != "0" ]; then
    echo "Этот скрипт должен быть выполнен с правами суперпользователя (root)."
    exit 1
fi

# Проверка установки службы Auditd
if ! dpkg-query -W -f='${Status}' auditd >/dev/null 2>&1; then
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
echo "-w /var/log -p wa -k var_log_changes" | sudo tee -a /etc/audit/rules.d/audit.rules

# Аудит пользователей, групп, базы данных паролей
echo "-w /etc/group -p wa -k etcgroup" | sudo tee -a /etc/audit/rules.d/audit.rules
echo "-w /etc/passwd -p wa -k etcpasswd" | sudo tee -a /etc/audit/rules.d/audit.rules
echo "-w /etc/gshadow -k etcgroup" | sudo tee -a /etc/audit/rules.d/audit.rules
echo "-w /etc/shadow -k etcpasswd" | sudo tee -a /etc/audit/rules.d/audit.rules
echo "-w /etc/security/opasswd -k opasswd" | sudo tee -a /etc/audit/rules.d/audit.rules

# Аудит изменений в файле Sudoers
echo "-w /etc/sudoers -p wa -k actions" | sudo tee -a /etc/audit/rules.d/audit.rules

# Аудит паролей
echo "-w /usr/bin/passwd -p x -k passwd_modification" | sudo tee -a /etc/audit/rules.d/audit.rules
echo "-w /usr/bin/gpasswd -p x -k gpasswd_modification" | sudo tee -a /etc/audit/rules.d/audit.rules

# Аудит изменения идентификаторов групп
echo "-w /usr/sbin/groupadd -p x -k group_modification" | sudo tee -a /etc/audit/rules.d/audit.rules
echo "-w /usr/sbin/groupmod -p x -k group_modification" | sudo tee -a /etc/audit/rules.d/audit.rules
echo "-w /usr/sbin/addgroup -p x -k group_modification" | sudo tee -a /etc/audit/rules.d/audit.rules
echo "-w /usr/sbin/useradd -p x -k user_modification" | sudo tee -a /etc/audit/rules.d/audit.rules
echo "-w /usr/sbin/usermod -p x -k user_modification" | sudo tee -a /etc/audit/rules.d/audit.rules
echo "-w /usr/sbin/adduser -p x -k user_modification" | sudo tee -a /etc/audit/rules.d/audit.rules

# Аудит конфигурации и входов
echo "-w /etc/login.defs -p wa -k login" | sudo tee -a /etc/audit/rules.d/audit.rules
echo "-w /etc/securetty -p wa -k login" | sudo tee -a /etc/audit/rules.d/audit.rules
echo "-w /var/log/faillog -p wa -k login" | sudo tee -a /etc/audit/rules.d/audit.rules
echo "-w /var/log/lastlog -p wa -k login" | sudo tee -a /etc/audit/rules.d/audit.rules
echo "-w /var/log/tallylog -p wa -k login" | sudo tee -a /etc/audit/rules.d/audit.rules

# Отслеживание запуска определенного приложения
echo "-a exit,always -F path=/usr/bin/myapp -F perm=x -k myapp_execution" | sudo tee -a /etc/audit/rules.d/audit.rules

# Отслеживание системных вызовов
echo "-a exit,always -F arch=b64 -S execve -F uid=0 -k authentication_events" | sudo tee -a /etc/audit/rules.d/audit.rules
echo "-a exit,always -F arch=b32 -S execve -F uid=0 -k authentication_events" | sudo tee -a /etc/audit/rules.d/audit.rules

# Отслеживание сетевых подключений
echo "-a exit,always -F arch=b64 -S bind -S connect -F success=0 -k network_events" | sudo tee -a /etc/audit/rules.d/audit.rules

# Запись в журнал аудита при подключении устройства USB
echo "-w /dev/bus/usb -p rwxa -k usb" | sudo tee -a /etc/audit/rules.d/audit.rules

# Применение правил и перезагрузка auditd
sudo augenrules --load
sudo systemctl restart auditd

echo "Настройка auditd завершена успешно."
