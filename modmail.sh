#!/bin/bash
cd /opt/modmail || exit 1
exec pipenv run python bot.py
