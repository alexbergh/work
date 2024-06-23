import requests
import json

SONARQUBE_URL = "<http://sonarqube.example.com>"
SONARQUBE_API_TOKEN = "your_api_token"

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

def main():
    project_key = "test_pj"
    project_name = "Test PJ"
    code_path = "/path"
    
    create_sonarqube_project(project_key, project_name)
    analyze_code(project_key, code_path)

if __name__ == "__main__":
    main()
