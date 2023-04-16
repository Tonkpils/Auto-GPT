# Use an official Python base image from the Docker Hub
FROM python:3.11-slim

# Set environment variables
ENV PIP_NO_CACHE_DIR=yes \
    PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1

RUN apt-get update && \
      apt-get install -y wget gnupg && \
      wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add - && \
      sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list' && \
      apt-get update && \
      apt-get install -y google-chrome-stable

# Create a non-root user and set permissions
RUN useradd --create-home appuser
WORKDIR /home/appuser
RUN chown appuser:appuser /home/appuser
USER appuser

# Copy the requirements.txt file and install the requirements
COPY --chown=appuser:appuser requirements.txt .
RUN pip install --no-cache-dir --user -r requirements.txt

# Copy the application files
COPY --chown=appuser:appuser . .

# Set the entrypoint
ENTRYPOINT ["python", "-m", "autogpt"]
