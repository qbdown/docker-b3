# Using the last stable slim image for Python 2
FROM python:2.7-slim-buster

# Environment setup
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    HOME=/data

VOLUME /data

# Install ONLY necessary build tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    gcc \
    libc6-dev \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt

# Clone and setup BigBrotherBot
RUN git clone https://github.com/BigBrotherBot/big-brother-bot.git /opt/b3 && \
    mv /opt/b3/b3/conf /opt/b3/b3/.conf && \
    mv /opt/b3/b3/extplugins /opt/b3/b3/.extplugins && \
    mv /opt/b3/b3/parsers /opt/b3/b3/.parsers

# Install Python requirements
# --no-cache-dir is critical for staying under the 500MB GitHub limit
RUN pip install --no-cache-dir --upgrade setuptools wheel && \
    pip install --no-cache-dir -r /opt/b3/requirements.txt

ADD start.sh /opt/start.sh
RUN chmod +x /opt/start.sh

ENTRYPOINT ["/opt/start.sh"]
CMD ["--help"]
