# DevSecOps Toolkit

Коллекция инструментов и конфигураций для DevSecOps, безопасности инфраструктуры и пентеста.

## Структура репозитория

```
.
├── DevSecOps/
│   ├── API/              # SonarQube API интеграция
│   ├── MongoDB/          # Kubernetes манифесты для MongoDB
│   └── k8s/              # Kubernetes security конфигурации (CIS Benchmark)
├── MikroTik/             # RouterOS конфигурации (Filter, Mangle, RAW, QoS)
├── wazuh/                # Wazuh SIEM правила
├── audit_lin.sh          # Настройка Linux Auditd
├── gost.sh               # Настройка ГОСТ-совместимой проверки целостности (afick)
├── test_web.sh           # Скрипт веб-пентеста
├── all_tests.yml         # Справочник инструментов пентеста
└── aide_ovirt.conf       # AIDE конфигурация для oVirt
```

## Компоненты

### DevSecOps/API

SonarQube интеграция для автоматического анализа кода.

```bash
# Установка зависимостей
pip install -r requirements.txt

# Настройка
export SONARQUBE_URL="http://sonarqube.example.com"
export SONARQUBE_API_TOKEN="your_token"

# Запуск API сервера
python DevSecOps/API/torn_sq_api.py

# CLI использование
python DevSecOps/MongoDB/sq_dso.py --project-key my_project --code-path /path/to/code
```

### DevSecOps/k8s

Kubernetes security конфигурации, совместимые с CIS Kubernetes Benchmark v1.10.

См. [DevSecOps/k8s/readme.md](DevSecOps/k8s/readme.md) для подробностей.

### Linux Audit

```bash
# Настройка auditd (требует root)
sudo ./audit_lin.sh

# Настройка afick для ГОСТ-совместимой проверки
sudo ./gost.sh
```

### Веб-пентест

```bash
# Сканирование целевого хоста
./test_web.sh 192.168.1.100
```

Включает:
- ICMP ping проверку
- Nmap сканирование портов
- Nikto сканирование веб-сервера

### MikroTik

RouterOS конфигурации для:
- **Filter** — правила файрвола
- **Mangle** — маркировка пакетов
- **RAW** — предварительная фильтрация
- **QoS** — качество обслуживания

### Wazuh SIEM

Кастомные правила для:
- Windows Security events (Event ID 4625)
- SSH аутентификация
- Cisco устройства
- Файловый мониторинг

## Требования

### Python
- Python 3.8+
- См. `requirements.txt`

### Системные
- Linux (Debian/Ubuntu) для audit скриптов
- nmap, nikto для веб-пентеста
- Kubernetes 1.25+ для k8s манифестов

## Безопасность

> **Важно**: API токены и credentials должны храниться в переменных окружения или secrets management системе. Никогда не коммитьте секреты в репозиторий.

## Лицензия

GNU General Public License v3.0 — см. [LICENSE](LICENSE)
