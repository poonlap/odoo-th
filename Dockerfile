ARG VERSION=latest
FROM odoo:${VERSION}
ARG VERSION
LABEL maintainer="Poonlap V. <poonlap@tanabutr.co.th>"

USER root
RUN echo "Building Docker image for Odoo version $VERSION" 
    
# Generate locale, set timezone
RUN apt-get update \
	&& apt-get -yq install locales tzdata git curl fonts-tlwg-laksaman\
	&& sed -i 's/# th_/th_/' /etc/locale.gen \
	&& locale-gen \
    && cp /usr/share/zoneinfo/Asia/Bangkok /etc/localtime

# Add Odoo Repository for upgrading and commit the image
RUN curl https://nightly.odoo.com/odoo.key | apt-key add - \
	&& echo "deb http://nightly.odoo.com/${ODOO_VERSION}/nightly/deb/ ./" >> /etc/apt/sources.list.d/odoo.list

# Add OCA modules via git
# delete sed line when l10n_th v13 is released
RUN if [ ${VERSION} = 13.0  ] || [ ${VERSION} = 'latest' ]; then l10n_th_v='12.0'; else l10n_th_v=${ODOO_VERSION}; fi \
	&& echo "l10n_th modules: " ${l10n_th_v} \
	&& mkdir -p /opt/odoo/addons \ 
	&& cd /opt/odoo/addons \
	&& git clone --single-branch --branch ${l10n_th_v} https://github.com/OCA/l10n-thailand.git \
	&& if [ ${VERSION} = 12.0 ]; then git clone --single-branch --branch ${ODOO_VERSION} https://github.com/OCA/server-tools.git; \
	   git clone --single-branch --branch ${ODOO_VERSION} https://github.com/OCA/server-ux.git; \
	   git clone --single-branch --branch ${ODOO_VERSION} https://github.com/OCA/reporting-engine.git; fi \
        && git clone --single-branch --branch ${ODOO_VERSION} https://github.com/OCA/web.git \
	&& sed -i s/${l10n_th_v}/${ODOO_VERSION}/ /opt/odoo/addons/l10n-thailand/l10n_th_partner/__manifest__.py

RUN pip3 install num2words xlwt xlrd openpyxl --no-cache-dir 


# Copy entrypoint script and Odoo configuration file
COPY ./entrypoint.sh /
RUN chmod +x /entrypoint.sh
COPY ./odoo.conf /etc/odoo/
COPY ./odoo-12.0.conf /etc/odoo/
RUN if [ ${VERSION} = 12.0 ]; then mv -v /etc/odoo/odoo-12.0.conf /etc/odoo/odoo.conf; fi
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
