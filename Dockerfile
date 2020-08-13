FROM python:3.8.5-buster

WORKDIR usr/src/app

COPY . .


RUN pip install --no-cache-dir -r requirements.txt 

 
ENTRYPOINT ["python", "run.py"]




