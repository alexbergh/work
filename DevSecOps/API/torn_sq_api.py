import tornado.ioloop
import tornado.web
import requests
import json

SONARQUBE_URL = "<http://sonarqube.example.com>"
SONARQUBE_API_TOKEN = "api_token"

def create_sonarqube_project(project_key, project_name):
    url = f"{SONARQUBE_URL}/api/projects/create"
    headers = {"Authorization": f"Bearer {SONARQUBE_API_TOKEN}"}
    data = {"key": project_key, "name": project_name}
    response = requests.post(url, headers=headers, data=data)
    if response.status_code == 200:
        print(f"Project '{project_name}' created successfully in SonarQube.")
    else:
        print(f"Failed to create project in SonarQube. Status code: {response.status_code}")

def analyze_code(project_key, code_path):
    url = f"{SONARQUBE_URL}/api/qualitygates/evaluate"
    headers = {"Authorization": f"Bearer {SONARQUBE_API_TOKEN}"}
    data = {
        "projectKey": project_key,
        "analysisMode": "preview",
        "branch": "main",
        "sonar.analysis.issuesMode": "issues",
        "sonar.sources": code_path,
    }
    response = requests.post(url, headers=headers, data=data)
    if response.status_code == 200:
        print("Code analysis completed successfully.")
    else:
        print(f"Failed to analyze code. Status code: {response.status_code}")

class CodeAnalysisHandler(tornado.web.RequestHandler):
    async def post(self):
        project_key = self.get_body_argument('project_key')
        code_path = self.get_body_argument('code_path')
        
        create_sonarqube_project(project_key, project_key)
        analyze_code(project_key, code_path)
        
        self.finish(json.dumps({"message": "Code analysis initiated."}))

def make_app():
    return tornado.web.Application([
        (r"/analyze-code", CodeAnalysisHandler),
    ])

if __name__ == "__main__":
    app = make_app()
    app.listen(8888)
    print("Server started on port 8888")
    tornado.ioloop.IOLoop.current().start()
