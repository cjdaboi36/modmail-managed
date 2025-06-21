FROM python:3.11-slim-bookworm as base


RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    curl gnupg libcairo2 build-essential && \
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install --no-install-recommends -y nodejs && \
    npm install -g pm2 && \
    pip install --upgrade pip && \
    pip install pipenv && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN useradd --shell /usr/sbin/nologin --create-home -d /opt/modmail modmail


WORKDIR /opt/modmail


COPY Pipfile ./
COPY Pipfile.lock ./


RUN pipenv install --deploy --ignore-pipfile

COPY . .


RUN chown -R modmail:modmail /opt/modmail

USER modmail:modmail

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    USING_DOCKER=yes \
    PATH="/opt/modmail/.local/share/virtualenvs/modmail-*/bin:$PATH"

CMD ["pm2-runtime", "mod]()
