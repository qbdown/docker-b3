# The last reliable slim image for Python 2
FROM python:2.7-slim-buster

# Environment setup
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# FIX FOR EXIT CODE 100: Point to Debian Archives
RUN sed -i 's/deb.debian.org/archive.debian.org/g' /etc/apt/sources.list && \
    sed -i 's|security.debian.org/debian-security|archive.debian.org/debian-security|g' /etc/apt/sources.list && \
    sed -i '/stretch-updates/d' /etc/apt/sources.list && \
    apt-get update && apt-get install -y --no-install-recommends \
    git \
    gcc \
    libc6-dev \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt

# Clone and setup BigBrotherBot
RUN git clone https://github.com/BigBrotherBot/big-brother-bot.git /opt/b3

# Install Python requirements
RUN pip install --no-cache-dir --upgrade setuptools wheel && \
    pip install --no-cache-dir -r /opt/b3/requirements.txt

# Directly run the python script
# ENTRYPOINT is the "base command"
ENTRYPOINT ["python", "/opt/b3/b3_run.py"]

# CMD provides the default flags (which can be overridden by docker run)
CMD ["--help"]
