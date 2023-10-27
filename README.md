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

https://user-images.githubusercontent.com/61376012/192126512-d1835585-3000-42c0-8713-95b6900c92ef.png

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
![image](https://user-images.githubusercontent.com/61376012/187730347-3c64347d-9f05-485e-a98f-01128308ccbf.png)  


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
 ![image](https://user-images.githubusercontent.com/61376012/187731568-f31e0b91-c846-4b64-95f1-1cae861f36a1.png)  
 
 ## 3. Continuous Delivery on Azure
 
 ## Set up the Azure DevOps Account
* Log into the https://portal.azure.com/ using the Azure credentials provided by the Cloud lab environment.  
* Log into the https://dev.azure.com/ in a separate browser tab using the same Azure account. It will prompt you to give a name to your DevOps org and choose a nearby location.  
![image](https://user-images.githubusercontent.com/61376012/187732705-ac8abb31-0ee9-4948-ac7a-c68393eead95.png)  

## Set up a Service connection
![image](https://user-images.githubusercontent.com/61376012/187732898-7b9af3af-7e36-45b7-b022-8862750aa32a.png)  

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
![image](https://user-images.githubusercontent.com/61376012/187734812-4459d889-0a2b-4f79-9bf7-fa89508ea33a.png)  

```
git clone https://github.com/nhan-123/project2-azure-udacity.git
```
Create a web app service
```
az webapp up --name <Your_unique_app_name> --resource-group Azuredevops --runtime "PYTHON:3.8"
```
Create an app service and initially deploy your app in Cloud Shell  
![image](https://user-images.githubusercontent.com/61376012/187735491-cdadc2b1-e0ba-4a3e-8bc0-7ae7ff650767.png)

Verify  
![image](https://user-images.githubusercontent.com/61376012/187735694-e8295a7a-0684-43d5-b16b-fc7d12406a68.png)

Perform Prediction  
```
./make_predict_azure_app.sh 
```
![image](https://user-images.githubusercontent.com/61376012/187735980-3f628f59-6360-4f13-8980-2660327b970a.png)  

Perform Locust test  
![image](https://user-images.githubusercontent.com/61376012/192128006-366587fd-0ee5-4a8f-83be-0a4e960f446b.png)
## Azure pipline agent
Create a Personal Access Token (PAT)  
![image](https://user-images.githubusercontent.com/61376012/187736336-9268aa62-f337-4c76-ad2f-cc1566dbd139.png)
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
![image](https://user-images.githubusercontent.com/61376012/187737571-08686395-579a-45a7-b709-8b8d86faf216.png)

![image](https://user-images.githubusercontent.com/61376012/187737626-32bc08f7-d291-4062-b225-6f59c8e43798.png)

Run the following commands to finish the set up  
```
sudo ./svc.sh install
sudo ./svc.sh start
```
![image](https://user-images.githubusercontent.com/61376012/187737823-5ca3423f-e9ab-4957-af5d-de9f75d149dd.png)  

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


## Enhancements

In the process of deploying project, i have some difficulty with test I things in the future, i must create new branch and new environment for test  


## Demo 

<TODO: Add link Screencast on YouTube>


