"""
Tornado API для интеграции с SonarQube.

Запуск:
    export SONARQUBE_URL="http://sonarqube.example.com"
    export SONARQUBE_API_TOKEN="your_token"
    python torn_sq_api.py
"""

import json
import logging
from concurrent.futures import ThreadPoolExecutor

import tornado.ioloop
import tornado.web

from sonarqube_client import SonarQubeClient

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Thread pool для выполнения синхронных операций
executor = ThreadPoolExecutor(max_workers=4)


class CodeAnalysisHandler(tornado.web.RequestHandler):
    """Handler для анализа кода через SonarQube."""

    async def post(self):
        """Запускает анализ кода."""
        try:
            project_key = self.get_body_argument("project_key")
            code_path = self.get_body_argument("code_path")
        except tornado.web.MissingArgumentError as e:
            self.set_status(400)
            self.finish(json.dumps({"error": f"Missing argument: {e.arg_name}"}))
            return

        try:
            # Выполняем синхронные операции в thread pool
            result = await tornado.ioloop.IOLoop.current().run_in_executor(
                executor, self._run_analysis, project_key, code_path
            )
            self.finish(json.dumps(result))
        except Exception as e:
            logger.exception("Analysis failed")
            self.set_status(500)
            self.finish(json.dumps({"error": str(e)}))

    def _run_analysis(self, project_key: str, code_path: str) -> dict:
        """Выполняет анализ в синхронном контексте."""
        with SonarQubeClient() as client:
            client.create_project(project_key, project_key)
            client.analyze_code(project_key, code_path)
        return {"message": "Code analysis initiated.", "project_key": project_key}


class HealthHandler(tornado.web.RequestHandler):
    """Health check endpoint."""

    def get(self):
        self.finish(json.dumps({"status": "ok"}))

def make_app():
    return tornado.web.Application([
        (r"/analyze-code", CodeAnalysisHandler),
        (r"/health", HealthHandler),
    ])

if __name__ == "__main__":
    app = make_app()
    app.listen(8888)
    print("Server started on port 8888")
    tornado.ioloop.IOLoop.current().start()
