Odoo Docker with Thai localization
----------------
[Dockerfile](docker/) สำหรับสร้าง [Docker image](https://hub.docker.com/r/poonlap/odoo-th/tags?page=1&ordering=last_updated) ที่ใช้งาน Odoo 14.0 (ปัจจุบันปี 2021) หรือเวอร์ชั่นอื่นๆเช่น 13.0 ร่วมกับภาษาไทย (l10n_thailand, Thai localization) ได้ทันที

วิธีใช้
--------
```
$ git clone https://github.com/poonlap/odoo-th.git
$ cd odoo-th/docker
$ docker-compose up
```
เปิดเบราเซอร์เข้า URL
```
http://localhost:8069
```
[รายละเอียดเพิ่มเติม](docker/)

<!-- prettier-ignore-start -->
  [//]: # (addons)

Available addons (เพิ่มจาก [OCA l10n-thailand](https://github.com/OCA/l10n-thailand))
----------------
addon | version | summary
--- | --- | ---
[th_address](th_address/) | 14.0.1.0.0 | A helper module for automatic importing address data and other settings.
[th_address_vat](th_address_vat/) | 14.0.1.0.0 | Auto-completion of the address when the tax ID is provided.

[//]: # (end addons)
  <!-- prettier-ignore-end -->
