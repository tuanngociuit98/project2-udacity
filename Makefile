setup:
	python3 -m venv ~/.flask-ml-azure
	#source ~/.flask-ml-azure/bin/activate
	
install:
	pip install --upgrade pip &&\
		pip install -r requirements.txt




lint:
	#hadolint Dockerfile #uncomment to explore linting Dockerfiles
	#pylint --disable=R,C app.py

all: install lint test