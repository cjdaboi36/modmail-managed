
FROM python:3.11-slim-bookworm as base


RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    curl gnupg libcairo2 && \
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install --no-install-recommends -y nodejs && \
    npm install -g pm2 && \

    apt-get clean && rm -rf /var/lib/apt/lists/* && \

    useradd --shell /usr/sbin/nologin --create-home -d /opt/modmail modmail

FROM base as builder

COPY requirements.txt .

RUN python -m venv /opt/modmail/.venv && \
    /opt/modmail/.venv/bin/pip install --upgrade pip wheel && \
    /opt/modmail/.venv/bin/pip install -r requirements.txt

FROM base


COPY --from=builder --chown=modmail:modmail /opt/modmail/.venv /opt/modmail/.venv

WORKDIR /opt/modmail
COPY --chown=modmail:modmail . .

USER modmail:modmail

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PATH=/opt/modmail/.venv/bin:$PATH \
    USING_DOCKER=yes

CMD ["pm2-runtime", "modmail.sh"]
