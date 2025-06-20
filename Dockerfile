FROM python:3.11-slim-bookworm AS base

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    libcairo2 bash curl git jq nginx nodejs npm openssh-client sudo python3.11-venv && \
    npm install -g pm2 && \
    pip install --no-cache-dir pipenv && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    useradd --shell /usr/sbin/nologin --create-home -d /opt/modmail modmail

FROM base AS builder

WORKDIR /opt/modmail
COPY Pipfile ./
COPY Pipfile.lock ./


RUN python -m venv /opt/modmail/.venv && \
    /opt/modmail/.venv/bin/pip install --upgrade pip && \
    /opt/modmail/.venv/bin/pip install pipenv && \
    /opt/modmail/.venv/bin/pipenv install --deploy --ignore-pipfile

FROM base

WORKDIR /opt/modmail
USER modmail:modmail

COPY --from=builder --chown=modmail:modmail /opt/modmail/.venv /opt/modmail/.venv
COPY --chown=modmail:modmail . .

RUN chmod +x /opt/modmail/modmail.sh

ENV PATH="/opt/modmail/.venv/bin:$PATH" \
    PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    USING_DOCKER=yes

CMD ["bash", "modmail.sh"]
