FROM centos:7

RUN yum install python3 python3-pip -y
ADD requirements.txt requirements.txt
RUN pip3 install -r requirements.txt
RUN mkdir /python_api
ADD src/python-api.py /python_api/main.py
CMD ["python3","/python_api/main.py"]
