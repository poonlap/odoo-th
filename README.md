# นี่คืออะไร
docker image สำหรับรัน Odoo 13 ได้ทันที โดยรวม
- ฟอนต์ภาษาไทย สำหรับพิมพ์ PDF 
- [OCA l10n-thailand module](https://github.com/OCA/l10n-thailand)
  ตอนนี้ยังเป็น version 12 อยู่ นำมาใช้ได้เฉพาะ l10n_th_partner 
- [OCA web modules](https://github.com/OCA/web) (เช่น web responsive)

[Dockerfile](https://github.com/poonlap/odoo-th/blob/master/Dockerfile) ดัดแปลงมาจาก [Odoo docker official image](https://hub.docker.com/_/odoo) ซึ่งตอนนี้ยังไม่มี version 13 ออกมา

# ใช้อย่างไร
## สร้าง instance ของ PostgreSQL 
```
$ docker run -d -e POSTGRES_USER=odoo -e POSTGRES_PASSWORD=odoo -e POSTGRES_DB=postgres --name db postgres:10
```
## สร้าง instance ของ Odoo
```
$ docker run -p 8069:8069 --name odoo --link db:db -t poonlap/odoo-th
```

รายละเอียดเพิ่มเติมดูที่ [README ของ Odoo docker official image](https://hub.docker.com/_/odoo)

# ทดลองใช้
เปิดเบราเซอร์ เข้า http://localhost:8069

# ทดสอบ 
## PDF ภาษาไทย
สร้างใบเสนอราคา ตั้งชื่อลูกค้าภาษาไทย สั่งพิมพ์ 
![](https://raw.githubusercontent.com/poonlap/images/master/testpdf.png)

## โมดูล l10n_thailand_partner
ข้อมูลสาขาสำหรับบริษัทไทย
![](https://raw.githubusercontent.com/poonlap/images/master/branch.png)