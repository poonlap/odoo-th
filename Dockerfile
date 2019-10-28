FROM odoo:latest
LABEL maintainer="Poonlap V. <poonlap@tanabutr.co.th>"
USER root

# Generate locale, set timezone
RUN apt-get update \
	&& apt-get -yq install locales tzdata git fonts-tlwg-laksaman\
	&& sed -i 's/# th_/th_/' /etc/locale.gen \
	&& locale-gen \
        && cp /usr/share/zoneinfo/Asia/Bangkok /etc/localtime

# Add OCA modules via git
RUN mkdir -p /opt/odoo/addons \ 
	&& cd /opt/odoo/addons \
	&& git clone https://github.com/OCA/l10n-thailand.git \
        && git clone --single-branch --branch 13.0 https://github.com/OCA/web.git

# delete this when l10n-thailand is updated to v.13
# at this moment l10n_th_partner is OK for 13.0
RUN sed -i s/12.0/13.0/ /opt/odoo/addons/l10n-thailand/l10n_th_partner/__manifest__.py


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
