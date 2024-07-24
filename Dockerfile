FROM python:3.12-bookworm

WORKDIR /usr/src/app

# Update pip
RUN pip install -U pip

# Add python libraries
COPY requirements.txt .
RUN pip install -r requirements.txt

# Add the project tools and configs
COPY --chmod=755 build-tools/src/start.sh /usr/local/bin/start
COPY --chmod=755 build-tools/src/create.sh /usr/local/bin/create
COPY build-tools/src/extra_settings.py /usr/local/src/app/
COPY build-tools/src/extra_urls.py /usr/local/src/app/

# Add the application directory
COPY app .

# Set default entrypoint and command to run the project
ENTRYPOINT ["python", "manage.py"]
CMD ["runserver", "0.0.0.0:8080"]
