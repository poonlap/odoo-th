# Copyright 2020 Poonlap V. <poonlap@tanabutr.co.th>
# License AGPL-3.0 or later (https://www.gnu.org/licenses/agpl.html)
import logging
import pprint
import re
from collections import OrderedDict
from logging import DEBUG, INFO
from os import path
from pathlib import Path

import requests, certifi
from odoo import _, api, models, fields
from requests import Session
from zeep import Client, Transport, helpers

_logger = logging.getLogger(__name__)


class ResPartner(models.Model):
    _inherit = "res.partner"
    
    branch = fields.Char(string="Branch ID", help="Branch ID, e.g., 00000, 00001, ...")
    tin_web_service_url = (
        "https://rdws.rd.go.th/serviceRD3/checktinpinservice.asmx?wsdl"
    )
    vat_web_service_url = "https://rdws.rd.go.th/serviceRD3/vatserviceRD3.asmx?wsdl"

    @staticmethod
    def check_rd_tin_service(tin):
        """Return bool after verifiying Tax Identification Number (TIN)
        or Personal Identification Number (PIN)
        by using Revenue Department's web service to prevent forging.
        :param tin: a string for TIN or PIN
        """

        sess = Session()
        mod_dir = path.dirname(path.realpath(__file__))
        
        transp = Transport(session=sess)
        try:
            cl = Client(ResPartner.tin_web_service_url, transport=transp)
        except requests.exceptions.SSLError:
            _logger.log(INFO, "Set session verify to False.")
            sess.verify = False
            transp = Transport(session=sess)
            cl = Client(ResPartner.tin_web_service_url, transport=transp)
        result = cl.service.ServiceTIN("anonymous", "anonymous", tin)
        res_ord_dict = helpers.serialize_object(result)
        _logger.log(DEBUG, pprint.pformat(res_ord_dict))
        return res_ord_dict["vIsExist"] is not None

    @staticmethod
    def get_info_rd_vat_service(tin, branch=0):
        """Return ordered dict with necessary result from
        Revenue Department's web service.
        :param tin: a string for TIN or PIN
        :param branch: one digit of branch number
        """
        branch = int(branch)
        sess = Session()
        # mod_dir = path.dirname(path.realpath(__file__))
        # cert_path = str(Path(mod_dir).parents[0]) + "/static/cert/adhq1_ADHQ5.cer"
        # sess.verify = False
        transp = Transport(session=sess)
        try:
            cl = Client(ResPartner.vat_web_service_url, transport=transp)
        except requests.exceptions.SSLError:
            # if failed, try to set verify to False.
            _logger.log(INFO, "Set session verify to False.")
            sess.verify = False
            transp = Transport(session=sess)
            cl = Client(ResPartner.vat_web_service_url, transport=transp)
        result = cl.service.Service(
            "anonymous",
            "anonymous",
            TIN=tin,
            ProvinceCode=0,
            BranchNumber=branch,
            AmphurCode=0,
        )
        odata = helpers.serialize_object(result)
        _logger.log(DEBUG, pprint.pformat(odata))
        data = OrderedDict()
        if odata["vmsgerr"] is None:
            for key, value in odata.items():
                if (
                    value is None
                    or value["anyType"][0] == "-"
                    or key in {"vNID", "vBusinessFirstDate"}
                ):
                    continue
                data[key] = value["anyType"][0]
            return data
        return False

    @api.onchange("vat", "branch")
    def _onchange_vat_branch(self):
        word_map = {
            "vBuildingName": "อาคาร ",
            "vFloorNumber": "ชั้นที่ ",
            "vVillageName": "หมู่บ้าน ",
            "vRoomNumber": "ห้องเลขที่ ",
            "vHouseNumber": "เลขที่ ",
            "vMooNumber": "หมู่ที่ ",
            "vSoiName": "ซอย ",
            "vStreetName": "ถนน ",
            "vThambol": "ต.",
            "vAmphur": "อ.",
            "vProvince": "จ.",
            "vPostCode": "",
        }
        street_map = [
            [
                "vBuildingName",
                "vRoomNumber",
                "vFloorNumber",
                "vHouseNumber",
                "vStreetName",
                "vSoiName",
            ],
            ["vVillageName", "vMooNumber", "vThambol"],
        ]
        check_branch = re.compile(r"^\d{5}$")
        if not self.branch:
            self.branch = "00000" if self.vat else ""
        else:
            self.branch = "{:05d}".format(int(self.branch))

        if self.vat:
            if ResPartner.check_rd_tin_service(self.vat):
                match = check_branch.match(self.branch)
                if match is None:
                    return {
                        "warning": {
                            "title": _("Branch validation failed"),
                            "message": _(
                                "Branch number %s must be 5 digits." % self.branch
                            ),
                        }
                    }
                data = ResPartner.get_info_rd_vat_service(self.vat, self.branch)
                _logger.log(DEBUG, pprint.pformat(data))

                if not data:
                    return {
                        "warning": {
                            "title": _("Warning: Validation failed."),
                            "message": _(
                                "TIN %s is valid. Branch %s is not valid."
                                % (self.vat, self.branch)
                            ),
                        }
                    }

                if len(data) == 0:
                    return {
                        {
                            "title": _("Can not get info from TIN" % self.vat),
                            "message": _(
                                "%s is valid but no address information." % self.vat
                            ),
                        }
                    }

                if data["vProvince"] == "กรุงเทพมหานคร":
                    word_map["vThambol"] = "แขวง"
                    word_map["vAmphur"] = "เขต"

                street = ["", ""]

                for j in range(len(street)):
                    for i in street_map[j]:
                        if i in data.keys():
                            street[j] += word_map[i] + data[i] + " "

                amphur = word_map["vAmphur"] + data["vAmphur"]

                province_id = self.env["res.country.state"].search(
                    [["name", "ilike", data["vProvince"]]]
                )

                self.update(
                    {
                        "name": data["vtitleName"] + " " + data["vName"],
                        "street": street[0],
                        "street2": street[1],
                        "city": amphur,
                        "zip": data["vPostCode"],
                        "state_id": province_id,
                        "country_id": self.env.ref("base.th").id,
                    }
                )
            else:
                return {
                    "warning": {
                        "title": _("Warning: TIN may not be valid."),
                        "message": _("Failed to verify TIN or PIN %s." % self.vat),
                    },
                }
