import logging

from odoo import api, models

_logger = logging.getLogger(__name__)


class geonames_th(models.Model):
    _name = "geonames_th.geonames_th"

    @api.model
    def import_data(self):
        TH = self.env.ref("base.th")
        geoname_import = self.env["city.zip.geonames.import"]
        parse_csv = geoname_import.get_and_parse_csv(TH)
        geoname_import._process_csv(parse_csv, TH)
