git clone git@github.com:PaulNWms/udacity-cicd-pipeline.git
python3 -m venv ~/cicd
source ~/cicd/bin/activate
cd udacity-cicd-pipeline
make all
export FLASK_APP=app.py
az webapp up --sku F1 -n udacity-flask-ml-service

