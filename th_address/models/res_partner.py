# Copyright 2016 Nicolas Bessi, Camptocamp SA
# Copyright 2018 Tecnativa - Pedro M. Baeza
# Copyright 2020 Poonlap V.
# License AGPL-3.0 or later (http://www.gnu.org/licenses/agpl).

from odoo import api, models


class ResPartnerTH(models.Model):
    _inherit = "res.partner"

    @api.onchange("zip_id", "city_id", "state_id", "country_id")
    def _onchange_zip_id(self):
        if self.zip_id and self.country_id.code == "TH":
            address = self.zip_id.city_id.name.split(", ")
            self.update({"street2": address[0], "city": address[1]})
