# Copyright 2021 Poonlap V.
# Licensed AGPL-3.0 or later (https://www.gnu.org/licenses/agpl.html).
{
    "name": "Thai Localization - Thai address data",
    "version": "14.0.1.0.0",
    "author": "Poonlap V.",
    "website": "https://github.com/poonlap/odoo-th",
    "license": "AGPL-3",
    "category": "Localisation/Asia",
    "summary": """
    A helper module for automatic importing address data and other settings.
    """,
    "depends": ["base_location", "base_location_geonames_import"],
    "data": [
        "views/view_th_country.xml",
        "views/view_system_parameter.xml",
    ],
    "installable": True,
    "application": False,
    "development_status": "Alpha",
    "maintainers": ["poonlap"],
}
