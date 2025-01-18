FROM python:3.13-alpine3.20
LABEL manteiner="luishbsantiago@gmail.com"

# serve para controlar se irá criar arquivos .pycm. 1= não cria, 0= cria
ENV PYTHONDONTWRITEBYTECODE 1

# serve para não armazenar o histórico de comandos
# Os outputs do Python são vistos em tempo real e não são armazenados em buffer
ENV PYTHONUNBUFFERED 1

# copia djangoapp e scripts para o container
COPY ./djangoapp /djangoapp
COPY ./script /scripts

# entra na pasta djangoapp no container
WORKDIR /djangoapp

EXPOSE 8000

RUN python -m venv /venv && \
  /venv/bin/pip install --upgrade pip && \
  /venv/bin/pip install -r /djangoapp/requirements.txt && \
  adduser --disabled-password --no-create-home duser && \
  mkdir -p /data/web/static && \
  mkdir -p /data/web/media && \
  chown -R duser:duser /venv && \
  chown -R duser:duser /data/web/static && \
  chown -R duser:duser /data/web/media && \
  chmod -R 755 /data/web/static && \
  chmod -R 755 /data/web/media && \
  chmod -R +x /scripts 

# quando for digitado algum comando o linux procura primeiro em scripts, depois em venv/bin e depois no PATH
ENV PATH="/scripts:/venv/bin:$PATH"

# tudo que foi executado anteriormente foi feito como root, agora será feito como duser
USER duser

# comando que será executado quando o container for iniciado, em scripts/commands.sh
CMD ["commands.sh"]