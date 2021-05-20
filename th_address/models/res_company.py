# Copyright 2016 Nicolas Bessi, Camptocamp SA
# Copyright 2018 Tecnativa - Pedro M. Baeza
# Copyright 2020 Poonlap V.
# License AGPL-3.0 or later (http://www.gnu.org/licenses/agpl).

from odoo import api, models


class ResCompany(models.Model):
    _inherit = "res.company"

    @api.onchange("zip_id", "city_id", "state_id", "country_id")
    def _onchange_zip_id(self):
        if self.zip_id:
            self.update(
                {
                    "zip": self.zip_id.name,
                    "city_id": self.zip_id.city_id,
                    "city": self.zip_id.city_id.name.split(", ")[1]
                    if len(self.zip_id.city_id.name.split(", ")) == 2
                    else self.zip_id.city_id.name.split(", ")[0],
                    "street2": self.zip_id.city_id.name.split(", ")[0]
                    if len(self.zip_id.city_id.name.split(", ")) == 2
                    else "",
                    "country_id": self.zip_id.city_id.country_id,
                    "state_id": self.zip_id.city_id.state_id,
                }
            )
