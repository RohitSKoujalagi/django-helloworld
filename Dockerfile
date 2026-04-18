# 1. Use the slim version of the official image for a smaller, more secure footprint
FROM python:3.11-slim

# 2. Set environment variables for optimized Python execution in containers
# Prevents Python from writing .pyc files to disk
ENV PYTHONDONTWRITEBYTECODE=1 
# Ensures Python output is logged straight to the terminal without buffering
ENV PYTHONUNBUFFERED=1

WORKDIR /app

# 3. Install necessary OS packages and immediately clean up the apt cache
RUN apt-get update && apt-get install -y --no-install-recommends \
    sqlite3 \
    && rm -rf /var/lib/apt/lists/*

# 4. Copy ONLY requirements first to leverage Docker layer caching
COPY requirements.txt /app/

# 5. Install Python dependencies without caching the installation files
RUN pip install --no-cache-dir -r requirements.txt

# 6. Copy the rest of the application code (fixed syntax on this line)
COPY . /app/

EXPOSE 8000

# 7. Start the application using a production WSGI server (Gunicorn)
# Updated to point exactly to your helloworld/wsgi.py file
CMD ["sh", "-c", "python manage.py migrate && gunicorn helloworld.wsgi:application --bind 0.0.0.0:8000"]