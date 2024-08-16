FROM python:3.12-bookworm

WORKDIR /usr/src/app

# Update pip
RUN pip install -U pip

# Add python libraries
COPY requirements.txt .
RUN pip install -r requirements.txt

# Add the application directory
COPY app .

# Set default entrypoint and command to run the project
ENTRYPOINT ["python", "manage.py"]
CMD ["runserver", "0.0.0.0:8080"]
