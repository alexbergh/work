"""
SonarQube DevSecOps Integration.

CLI инструмент для анализа кода через SonarQube.

Использование:
    export SONARQUBE_URL="http://sonarqube.example.com"
    export SONARQUBE_API_TOKEN="your_token"
    python sq_dso.py --project-key my_project --code-path /path/to/code
"""

import argparse
import sys
import logging

# Добавляем путь к общему модулю
sys.path.insert(0, str(__file__).rsplit("MongoDB", 1)[0] + "API")

from sonarqube_client import SonarQubeClient

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(levelname)s - %(message)s"
)
logger = logging.getLogger(__name__)


def parse_args():
    """Парсинг аргументов командной строки."""
    parser = argparse.ArgumentParser(
        description="SonarQube DevSecOps Integration",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog=__doc__
    )
    parser.add_argument(
        "--project-key",
        required=True,
        help="Уникальный ключ проекта в SonarQube"
    )
    parser.add_argument(
        "--project-name",
        help="Имя проекта (по умолчанию = project-key)"
    )
    parser.add_argument(
        "--code-path",
        required=True,
        help="Путь к исходному коду для анализа"
    )
    parser.add_argument(
        "--branch",
        default="main",
        help="Ветка для анализа (по умолчанию: main)"
    )
    return parser.parse_args()


def main():
    """Основная функция."""
    args = parse_args()
    project_name = args.project_name or args.project_key

    try:
        with SonarQubeClient() as client:
            logger.info("Создание проекта '%s'...", project_name)
            client.create_project(args.project_key, project_name)

            logger.info("Запуск анализа кода...")
            client.analyze_code(args.project_key, args.code_path, args.branch)

            logger.info("Получение статуса Quality Gate...")
            status = client.get_quality_gate_status(args.project_key)
            logger.info("Quality Gate Status: %s", status)

    except ValueError as e:
        logger.error("Ошибка конфигурации: %s", e)
        sys.exit(1)
    except Exception as e:
        logger.error("Ошибка выполнения: %s", e)
        sys.exit(1)

    logger.info("Анализ завершён успешно")


if __name__ == "__main__":
    main()
