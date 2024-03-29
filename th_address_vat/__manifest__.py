# Copyright 2020 Poonlap V.
# Licensed AGPL-3.0 or later (https://www.gnu.org/licenses/agpl.html).
{
    "name": "Thai address completion by Tax ID (VAT)",
    "version": "16.0.1.0.0",
    "author": "Poonlap V.",
    "website": "https://github.com/poonlap/odoo-th",
    "license": "AGPL-3",
    "category": "Localisation/Asia",
    "summary": "Auto-completion of name and address when the tax ID is provided.",
    "depends": ["th_address"],
    "data": ["views/res_partner_view.xml"],
    "external_dependencies": {"python": ["zeep"]},
    "installable": True,
    "application": False,
    "development_status": "Alpha",
    "maintainers": ["poonlap"],
}
