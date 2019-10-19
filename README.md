# นี่คืออะไร
เป็น docker image สำหรับรัน Odoo 13  พร้อมกับฟอนต์ไทย สำหรับพิมพ์ PDF 

อาจจะเพิ่ม module OCA l10n-th ต่อไป

# ใช้อย่างไร
## สร้าง instance ของ PostgreSQL 
```
$ docker run -d -e POSTGRES_USER=odoo -e POSTGRES_PASSWORD=odoo -e POSTGRES_DB=postgres --name db postgres:10
```
## สร้าง instance ของ Odoo
```
$ docker run -p 8069:8069 --name odoo --link db:db -t poonlap/odoo13-th
```

# ทดลองใช้
เปิดเบราเซอร์ เข้า http://localhost:8069

# ทดสอบ PDF ภาษาไทย
สร้างใบเสนอราคา ตั้งชื่อลูกค้าภาษาไทย สั่งพิมพ์ 
![](https://raw.githubusercontent.com/poonlap/images/master/testpdf.png)

