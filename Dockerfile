ARG VERSION=latest
FROM odoo:${VERSION}
ARG VERSION
LABEL maintainer="Poonlap V. <poonlap@tanabutr.co.th>"

USER root
RUN echo "Building Docker image for Odoo version $VERSION" 
    
# Generate locale, set timezone
RUN apt-get update \
<<<<<<< HEAD
	&& apt-get -yq install locales tzdata\
=======
	&& apt-get -yq install locales tzdata git curl fonts-tlwg-laksaman\
>>>>>>> official_base
	&& sed -i 's/# th_/th_/' /etc/locale.gen \
	&& locale-gen \
    && cp /usr/share/zoneinfo/Asia/Bangkok /etc/localtime

<<<<<<< HEAD

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
=======
# Add Odoo Repository for upgrading and commit the image
RUN curl https://nightly.odoo.com/odoo.key | apt-key add - \
	&& echo "deb http://nightly.odoo.com/${ODOO_VERSION}/nightly/deb/ ./" >> /etc/apt/sources.list.d/odoo.list

# Add OCA modules via git
# delete sed line when l10n_th v13 is released
RUN if [ ${VERSION} = 13.0  ] || [ ${VERSION} = 'latest' ]; then l10n_th_v='12.0'; else l10n_th_v=${ODOO_VERSION}; fi \
	&& echo "l10n_th modules: " ${l10n_th_v} \
	&& mkdir -p /opt/odoo/addons \ 
>>>>>>> official_base
	&& cd /opt/odoo/addons \
	&& git clone --single-branch --branch ${l10n_th_v} https://github.com/OCA/l10n-thailand.git \
    && git clone --single-branch --branch ${ODOO_VERSION} https://github.com/OCA/web.git \
	&& sed -i s/${l10n_th_v}/${ODOO_VERSION}/ /opt/odoo/addons/l10n-thailand/l10n_th_partner/__manifest__.py


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
