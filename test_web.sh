#!/bin/bash

function valid_ip {
    local ip=$1
    local stat=1

    if [[ $ip =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        IFS='.' read -ra addr <<< "$ip"
        [[ ${addr[0]} -le 255 && ${addr[1]} -le 255 && ${addr[2]} -le 255 && ${addr[3]} -le 255 ]]
        stat=$?
    fi
    return $stat
}

if [ "$#" -ne 1 ] || ! valid_ip $1; then
    echo -n "Введите IP-адрес: "
    read target
    while ! valid_ip $target; do
        echo -n "Некорректный IP. Повторный ввод: "
        read target
    done
else
    target=$1
fi

datestamp=$(date "+%Y-%m-%d_%H-%M-%S") 

echo "Сканирование начато."
echo "Цель: $target"
echo "-------------------------------"

echo "Проверка ответа на ICMP Echo (Ping)"
ping -c 3 $target > "${target}_${datestamp}_ping.txt"
if [ $? -eq 0 ]; then
    echo "Цель отвечает на ping. Результаты сохранены в файле ${target}_${datestamp}_ping.txt"
else
    echo "Цель не отвечает на ping, возможно, присутствует файервол. Результаты сохранены в файле ${target}_${datestamp}_ping.txt"
fi
echo "-------------------------------"

echo "Наяато сканирования портов"
nmap -v -Pn -sS --scanflags SYNACK -T4 --reason $target > "${target}_${datestamp}_nmap_scan.txt"
echo "Сканирование портов завершено. Результаты сохранены в файле ${target}_${datestamp}_nmap_scan.txt"
echo "-------------------------------"

echo "Запуск сканирования веб-сервера"
nikto -h $target > "${target}_${datestamp}_nikto_scan.txt"
echo "Сканирование веб-сервера завершено. Результаты сохранены в файле ${target}_${datestamp}_nikto_scan.txt"
echo "-------------------------------"

echo "Сканирование завершено"
