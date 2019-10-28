FROM ubuntu:18.04
LABEL maintainer="Poonlap V. <poonlap@tanabutr.co.th>"

# Generate locale, set timezone
RUN apt-get update \
	&& apt-get -yq install locales tzdata\
	&& sed -i 's/# th_/th_/' /etc/locale.gen \
	&& locale-gen \
        && cp /usr/share/zoneinfo/Asia/Bangkok /etc/localtime


# install Laksaman font (Sarabun)
RUN apt-get -yq install fonts-tlwg-laksaman

# install postgres
RUN apt-get install postgresql -y


# Install some deps, lessc and less-plugin-clean-css
RUN apt-get install -y --no-install-recommends \
            ca-certificates \
            curl \ 
            dirmngr \
	    # if you need CJK
            # fonts-noto-cjk \
            gnupg \
            libssl1.0-dev \
            node-less \
            python3-pip \
            python3-pyldap \
            python3-qrcode \
            python3-renderpm \
            python3-setuptools \
            python3-vobject \
            python3-watchdog \
            xz-utils \
            git

# install wkhtmltopdf
RUN apt-get install -y --no-install-recommends \
	libjpeg62 \
	libx11-6 \
	libxext6 \
	libxrender1 \
	fontconfig \
	&& curl -o wkhtmltox.deb -sSL https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.5/wkhtmltox_0.12.5-1.stretch_amd64.deb \
        && echo '7e35a63f9db14f93ec7feeb0fce76b30c08f2057 wkhtmltox.deb' | sha1sum -c - \
        && dpkg --force-depends -i wkhtmltox.deb\
        && rm -rf /var/lib/apt/lists/* wkhtmltox.deb \
	&& cp -v /usr/local/bin/wkhtml* /usr/bin \
	&& apt-get install -y --fix-broken

# Repository
RUN curl https://nightly.odoo.com/odoo.key | apt-key add - \
	&& echo "deb http://nightly.odoo.com/13.0/nightly/deb/ ./" >> /etc/apt/sources.list.d/odoo.list

# Install odoo
RUN apt-get update \
	&& apt-get install -y odoo

RUN pip3 install num2words xlwt --no-cache-dir

RUN mkdir -p /opt/odoo/addons \ 
	&& cd /opt/odoo/addons \
	&& git clone https://github.com/OCA/l10n-thailand.git \
        && git clone --single-branch --branch 13.0 https://github.com/OCA/web.git

# delete this when l10n-thailand is updated to v.13
# at this moment l10n_th_partner is OK for 13.0
RUN sed -i s/12.0/13.0/ /opt/odoo/addons/l10n-thailand/l10n_th_partner/__manifest__.py

#RUN pip3 install odoo13-addon-web-responsive

# Copy entrypoint script and Odoo configuration file
COPY ./entrypoint.sh /
RUN chmod +x /entrypoint.sh
COPY ./odoo.conf /etc/odoo/
RUN chown odoo /etc/odoo/odoo.conf

# Mount /var/lib/odoo to allow restoring filestore and /mnt/extra-addons for users addons
RUN mkdir -p /mnt/extra-addons \
        && chown -R odoo /mnt/extra-addons
	VOLUME ["/var/lib/odoo", "/mnt/extra-addons"]

# Expose Odoo services
EXPOSE 8069 8071


# Set the default config file
ENV ODOO_RC /etc/odoo/odoo.conf

# Set default user when running the container
USER odoo

ENTRYPOINT ["/entrypoint.sh"]
CMD ["odoo"]
