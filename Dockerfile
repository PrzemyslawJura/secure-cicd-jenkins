FROM python:3.11-slim

WORKDIR /app
COPY app/ /app

RUN pip install --no-cache-dir -r requirements.txt

# Create non-root user for security
RUN useradd -m appuser
USER appuser

EXPOSE 5000
CMD ["python", "main.py"]
