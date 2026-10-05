"""
SonarQube API Client Module.

Общий модуль для работы с SonarQube API.
Использует переменные окружения для конфигурации.
"""

import os
import logging
from typing import Optional
from dataclasses import dataclass

import requests
from requests.exceptions import RequestException

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


@dataclass
class SonarQubeConfig:
    """Конфигурация SonarQube."""
    url: str
    token: str
    timeout: int = 30

    @classmethod
    def from_env(cls) -> "SonarQubeConfig":
        """Создаёт конфигурацию из переменных окружения."""
        url = os.getenv("SONARQUBE_URL")
        token = os.getenv("SONARQUBE_API_TOKEN")

        if not url or not token:
            raise ValueError(
                "SONARQUBE_URL и SONARQUBE_API_TOKEN должны быть заданы в переменных окружения"
            )

        return cls(url=url.rstrip("/"), token=token)


class SonarQubeClient:
    """Клиент для работы с SonarQube API."""

    def __init__(self, config: Optional[SonarQubeConfig] = None):
        """
        Инициализация клиента.

        Args:
            config: Конфигурация. Если не указана, берётся из env.
        """
        self.config = config or SonarQubeConfig.from_env()
        self._session = requests.Session()
        self._session.headers.update({
            "Authorization": f"Bearer {self.config.token}"
        })

    def create_project(self, project_key: str, project_name: str) -> dict:
        """
        Создаёт проект в SonarQube.

        Args:
            project_key: Уникальный ключ проекта.
            project_name: Имя проекта.

        Returns:
            dict: Ответ от API.

        Raises:
            RequestException: При ошибке запроса.
        """
        url = f"{self.config.url}/api/projects/create"
        data = {"key": project_key, "name": project_name}

        try:
            response = self._session.post(url, data=data, timeout=self.config.timeout)
            response.raise_for_status()
            logger.info("Проект '%s' успешно создан в SonarQube", project_name)
            return response.json() if response.text else {}
        except RequestException as e:
            logger.error("Ошибка создания проекта: %s", e)
            raise

    def analyze_code(
        self,
        project_key: str,
        code_path: str,
        branch: str = "main"
    ) -> dict:
        """
        Запускает анализ кода.

        Args:
            project_key: Ключ проекта.
            code_path: Путь к исходному коду.
            branch: Ветка для анализа.

        Returns:
            dict: Результат анализа.

        Raises:
            RequestException: При ошибке запроса.
        """
        url = f"{self.config.url}/api/qualitygates/evaluate"
        data = {
            "projectKey": project_key,
            "analysisMode": "preview",
            "branch": branch,
            "sonar.analysis.issuesMode": "issues",
            "sonar.sources": code_path,
        }

        try:
            response = self._session.post(url, data=data, timeout=self.config.timeout)
            response.raise_for_status()
            logger.info("Анализ кода для '%s' завершён успешно", project_key)
            return response.json() if response.text else {}
        except RequestException as e:
            logger.error("Ошибка анализа кода: %s", e)
            raise

    def get_quality_gate_status(self, project_key: str) -> dict:
        """
        Получает статус Quality Gate проекта.

        Args:
            project_key: Ключ проекта.

        Returns:
            dict: Статус Quality Gate.
        """
        url = f"{self.config.url}/api/qualitygates/project_status"
        params = {"projectKey": project_key}

        try:
            response = self._session.get(url, params=params, timeout=self.config.timeout)
            response.raise_for_status()
            return response.json()
        except RequestException as e:
            logger.error("Ошибка получения статуса: %s", e)
            raise

    def close(self):
        """Закрывает сессию."""
        self._session.close()

    def __enter__(self):
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        self.close()
