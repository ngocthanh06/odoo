FROM python:3.12-slim-bookworm

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    ODOO_HOME=/opt/odoo \
    ODOO_DATA=/opt/odoo/data

WORKDIR ${ODOO_HOME}

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        build-essential \
        git \
        curl \
        libpq-dev \
        libxml2-dev \
        libxslt1-dev \
        libldap2-dev \
        libsasl2-dev \
        libjpeg-dev \
        zlib1g-dev \
        libfreetype6-dev \
        libpng-dev \
        liblcms2-dev \
        libopenjp2-7-dev \
        libtiff5-dev \
        libmagic1 \
        libmagic-dev \
        libffi-dev \
        libssl-dev \
        libyaml-dev \
        wkhtmltopdf \
    && ln -sf /usr/bin/wkhtmltopdf /usr/local/bin/wkhtmltopdf \
    && ln -sf /usr/bin/wkhtmltoimage /usr/local/bin/wkhtmltoimage \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt ./requirements.txt
RUN pip install --upgrade pip setuptools wheel \
    && pip install --no-cache-dir -r requirements.txt

COPY . .

RUN mkdir -p ${ODOO_DATA} \
    && chmod +x odoo-bin

EXPOSE 8069 8072

CMD ["./odoo-bin", "--addons-path=addons,odoo/addons"]
