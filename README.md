# Overview
([![Python application test with Github Actions](https://github.com/tuanngociuit98/project2-udacity/actions/workflows/main.yml/badge.svg)])
# flask-ml-service
A sample Flask application to showcase the Azure Pipeline.

## Environment
Python 3.8

## Project Plan
* The link to a Trello board for the project:
* A link to a spreadsheet that includes the original and final project plan: https://docs.google.com/spreadsheets/d/1m6zZXn3XC81D-l7tc1rlogK6gIEbZ8dp6SONkMXYoBE/edit#gid=0

## Instructions
This diagram shows how code can be tested automatically by enabling GitHub Actions. The push change to GitHub triggers the GitHub Actions container, which in turn runs a series of commands.  

![image](https://github.com/tuanngociuit98/project2-udacity/assets/33689489/c5f52222-da4a-4ffb-bb3a-2a3fe3265e11)


# Continuous Delivery on Azure
## 1. Set up azure cloud shell
1. Create a Github Repo (if not created)    
2. Open Azure Cloud Shell  
3. Create ssh-keys in Azure Cloud Shell  
4. Upload ssh-keys to Github  
5. Create scaffolding for the project (if not created)  

## Create the Makefile
```
install:
	pip install --upgrade pip &&\
		pip install -r requirements.txt

test:
	python -m pytest -vv test_hello.py


lint:
	pylint --disable=R,C hello.py

all: install lint test
```
## Create requirements.txt

```
Flask== 2.2.2
pandas==1.3.5
scikit-learn==1.0.2
joblib==1.2.0
pylint==2.13.8
pytest==7.1.2
Werkzeug==2.2.2
```

## Create the script file and test file.
Create hello.py with the following code at the top level of your Github repo 
```
def toyou(x):
    return "hi %s" % x


def add(x):
    return x + 1


def subtract(x):
    return x - 1
```
Create test_hello.py with the following code at the top level of your Github repo
```
from hello import toyou, add, subtract


def setup_function(function):
    print("Running Setup: %s" % function.__name__)
    function.x = 10


def teardown_function(function):
    print("Running Teardown: %s" % function.__name__)
    del function.x

### Run to see failed test
#def test_hello_add():
#    assert add(test_hello_add.x) == 12

def test_hello_subtract():
    assert subtract(test_hello_subtract.x) == 9
```

## Local Test
Now it is time to run make all which will install, lint, and test code. This enables us to ensure we don't check in broken code to GitHub as it installs, lints, and tests the code in one command. Later we will have a remote build server perform the same step.
![image](https://github.com/tuanngociuit98/project2-udacity/assets/33689489/8ac0d9f8-2835-49c6-94bc-c1a01bf31fae)
 
## 2. Configure GitHub Actions
## Enable Github Actions
Go to your Github Account and enable Github Actions.  


## Replace yml code
```
name: Python application test with Github Actions

on: [push]

jobs:
  build:

    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v2
    - name: Set up Python 3.8
      uses: actions/setup-python@v1
      with:
        python-version: 3.8
    - name: Install dependencies
      run: |
        make install
    - name: Lint with pylint
      run: |
        make lint
    - name: Test with pytest
      run: |
        make test
```
## Verify Remote Tests pass
 Push the changes to GitHub and verify that both lint and test steps pass in your project.  
 ![image](https://github.com/tuanngociuit98/project2-udacity/assets/33689489/982da017-2341-464c-a57b-8f4566456aff)
 
 
 ## 3. Continuous Delivery on Azure
 
 ## Set up the Azure DevOps Account
* Log into the https://portal.azure.com/ using the Azure credentials provided by the Cloud lab environment.  
* Log into the https://dev.azure.com/ in a separate browser tab using the same Azure account. It will prompt you to give a name to your DevOps org and choose a nearby location.  
![image](https://user-images.githubusercontent.com/61376012/187732705-ac8abb31-0ee9-4948-ac7a-c68393eead95.png)  

## Set up a Service connection
![image](https://github.com/tuanngociuit98/project2-udacity/assets/33689489/a7b768ca-113f-4a3b-a17d-ef062c5e95e5)

  

## Clone code from this start repo
Your repo should have these file  
```
├── Makefile
├── app.py
├── boston_housing_prediction.joblib
├── make_predict.sh
├── make_predict_azure_app.sh
└── requirements.txt
```
## Config azure pipline
Configure the Azure Pipeline app in Github >> Settings >> Integrations >> Applications  

## Setup pipeline

![image](https://user-images.githubusercontent.com/61376012/187734288-36b2f8cd-531e-4c41-91d7-8c5ad41de349.png)  

After successful linking, your Azure DevOps organization should be able to hook with any of your Github repositories to set up a pipeline.  

## Create a Web App Manually
Clone the repo in Cloud shell  
![image](https://github.com/tuanngociuit98/project2-udacity/assets/33689489/c73bb864-dd68-4eda-9acc-8d23db3d923e)
 

```
git clone git@github.com:tuanngociuit98/project2-udacity.git
```
Create a web app service
```
az webapp up --name <Your_unique_app_name> --resource-group Azuredevops --runtime "PYTHON:3.8"
```
Create an app service and initially deploy your app in Cloud Shell  
![image](https://github.com/tuanngociuit98/project2-udacity/assets/33689489/7a803715-9d27-43bf-9ed5-d14c39ab1d1f)


Verify  
![image](https://github.com/tuanngociuit98/project2-udacity/assets/33689489/9f0f4dc3-fe4c-4695-844d-223192ad2035)


Perform Prediction  
```
./make_predict_azure_app.sh 
```
![image](https://github.com/tuanngociuit98/project2-udacity/assets/33689489/c98803a9-8a4b-4a0d-ab72-ae89479278d6)
 

Perform Locust test  
![image](https://user-images.githubusercontent.com/61376012/192128006-366587fd-0ee5-4a8f-83be-0a4e960f446b.png)
## Azure pipline agent
Create a Personal Access Token (PAT)  
![image](https://github.com/tuanngociuit98/project2-udacity/assets/33689489/f3e2606b-9eef-4a96-9366-f155930a9e25)

Create a new PAT, and ensure that it has a "Full access" scope  

Create an Agent pool  
![image](https://user-images.githubusercontent.com/61376012/187736556-190e9e4e-4099-4574-9079-49784629d94c.png)  

Choose the agent pool as "Self-hosted". Provide the Agent pool a name and grant access permissions to all pipelines  

Create a Linux VM  
Navigate to the "Virtual machines" service in the Azure Portal, and then select "+ Create" to create a VM.  
![image](https://user-images.githubusercontent.com/61376012/187736982-d8fb1ce7-c2ea-4943-900c-3342ad5e73db.png)  
Leave th remaining fields as default. Review and create the VM. It will take a few minutes for the deployment.  
![image](https://user-images.githubusercontent.com/61376012/187737143-92254fb2-b2d3-4e93-9ee8-58a486cc3bd8.png)  

After you SSH into the VM to setup VM  
```
sudo snap install docker
# Check Python version because this agent will build your code
python3 --version
sudo groupadd docker
sudo usermod -aG docker $USER
exit
```
Go back to the DevOps portal, and open the newly created Agent pool to add a new agent. The snapshot below will help you understand better.  
![image](https://github.com/tuanngociuit98/project2-udacity/assets/33689489/26687975-056c-481e-8854-f825e7cde197)


![image](https://github.com/tuanngociuit98/project2-udacity/assets/33689489/ca077e77-b8bf-4a1f-ba61-7b3b3b66092e)


Run the following commands to finish the set up  
```
sudo ./svc.sh install
sudo ./svc.sh start
```
![image](https://github.com/tuanngociuit98/project2-udacity/assets/33689489/4d7bac37-ccde-4ba3-8b3f-d1b2470efcd7)


We have to install some additional packages to enable our agent build the Flask application code. These commands are specific to our sample Flask application, you can extend them per your application requirements:  

```
sudo apt-get update
sudo apt update
sudo apt install software-properties-common
sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt install python3.8
sudo apt-get install python3.8-venv
sudo apt-get install python3-pip
python3.8 —version
pip —version 
sudo apt-get install python3.8-distutils
sudo apt-get -y install zip
```
In you Azure DevOps, navigate to Organization Settings >> Agent Pools >> myAgentPool and then select the Agents tab. Confirm that the self-hosted agent is online.  
![image](https://github.com/tuanngociuit98/project2-udacity/assets/33689489/522e8fb7-af81-46e3-99c1-c029b398be77)

## Set up the DevOps Pipeline
Create a Pipeline
Go back to the DevOps project, select Pipeline and create a new one
![image](https://github.com/tuanngociuit98/project2-udacity/assets/33689489/9b811d9f-c8ee-4003-8cfa-0f39afe48a1d)

Choose the Github repository as the source code location

![image](https://github.com/tuanngociuit98/project2-udacity/assets/33689489/3479730e-d678-418a-bff7-b4ef549ca985)

![image](https://github.com/tuanngociuit98/project2-udacity/assets/33689489/47b57bc4-ae0f-4a36-8b93-f711b1444e20)

Update azure-pipelines.yml file
```
# Starter pipeline    
# Start with a minimal pipeline that you can customize to build and deploy your code.
# Add steps that build, run tests, deploy, and more:
# https://aka.ms/yaml
trigger:
- main

# TODO: Replace the agent pool name
pool: myAgentPool

variables:
  # TODO: Replace the service connection name
  azureServiceConnectionId: 'my-connection'
  # TODO: Replace 'mywebapp193576' with the existing Web App name
  webAppName: 'mywebapp28102023'
  # Environment name
  environmentName: 'deployment'
  # Project root folder. Point to the folder containing manage.py file.
  projectRoot: $(System.DefaultWorkingDirectory)
  pythonVersion: 3.8
stages:
- stage: Build
  displayName: Build stage
  jobs:
  - job: BuildJob

    steps:
    - task: UsePythonVersion@0
      inputs:
        versionSpec: '$(pythonVersion)'
      displayName: 'Use Python $(pythonVersion)'
    
    - script: |
        python -m venv antenv
        source antenv/bin/activate
        python -m pip install --upgrade pip
        pip install setup
        pip install -r requirements.txt
      workingDirectory: $(projectRoot)
      displayName: "Install requirements"
    
    - script: |
        python -m venv antenv
        source antenv/bin/activate
        make install
        make lint
      workingDirectory: $(projectRoot)
      displayName: "Run Lint test"
      
    - task: ArchiveFiles@2
      displayName: 'Archive files'
      inputs:
        rootFolderOrFile: '$(projectRoot)'
        includeRootFolder: false
        archiveType: zip
        archiveFile: $(Build.ArtifactStagingDirectory)/$(Build.BuildId).zip
        replaceExistingArchive: true

    - upload: $(Build.ArtifactStagingDirectory)/$(Build.BuildId).zip
      displayName: 'Upload package'
      artifact: drop

- stage: Deploy
  displayName: 'Deploy Web App'
  dependsOn: Build
  condition: succeeded()
  jobs:
  - deployment: DeploymentJob
    environment: $(environmentName)
    strategy:
      runOnce:
        deploy:
          steps:
          
          - task: UsePythonVersion@0
            inputs:
              versionSpec: '$(pythonVersion)'
            displayName: 'Use Python version'

          - task: AzureWebApp@1
            displayName: 'Deploy Azure Web App '
            inputs:
              azureSubscription: $(azureServiceConnectionId)
              appName: $(webAppName)
              package: $(Pipeline.Workspace)/drop/$(Build.BuildId).zip
```
## Enhancements

In the process of deploying project, i have some difficulty with test I things in the future, i must create new branch and new environment for test  


## Demo 
https://www.youtube.com/watch?v=fUOBdTc8Cjk


