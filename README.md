# นี่คืออะไร
docker image สำหรับรัน Odoo 13 ได้ทันที โดยรวม
- ฟอนต์ภาษาไทย [Laksaman (Sarabun)](https://thep.blogspot.com/2014/07/laksaman-font.html) สำหรับแสดงผลภาษาไทยเวลาพิมพ์เอกสาร PDF
- [OCA l10n-thailand module](https://github.com/OCA/l10n-thailand)
  ขณะนี้ยังเป็น version 12 นำมาใช้กับเวอร์ชั่น 13 ได้ 1 โมดูลคือ l10n_th_partner (เพิ่ม field สาขาสำหรับบริษัท) ส่วนโมดูลอื่นๆรออัพเกรดให้ใช้ได้กับเวอร์ชั่น 13 
- [OCA web modules](https://github.com/OCA/web) ที่ใช้ได้กับเวอร์ชั่น 13 แล้ว เช่น web responsive

[Dockerfile](https://github.com/poonlap/odoo-th/blob/master/Dockerfile) ดัดแปลงมาจาก [Odoo docker official image](https://hub.docker.com/_/odoo) ซึ่งตอนนี้ยังไม่มี version 13 ออกมา

# ใช้อย่างไร
## รันด้วย docker
### รัน PostgreSQL คอนเทนเนอร์
```
$ docker run -d -e POSTGRES_USER=odoo -e POSTGRES_PASSWORD=odoo -e POSTGRES_DB=postgres --name db postgres:10
```
### รัน Odoo คอนเทนเนอร์
```
$ docker run -p 8069:8069 --name odoo --link db:db -t poonlap/odoo-th
```

## รันด้วย docker-compose
สร้างไฟล์ docker-compose.yml
```
version: '2'
services:
  web:
    image: poonlap/odoo-th
    depends_on:
      - db
    ports:
      - "8069:8069"
    volumes:
      - ./addons:/mnt/extra-addons
  db:
    image: postgres:10
    environment:
      - POSTGRES_DB=postgres
      - POSTGRES_PASSWORD=odoo
      - POSTGRES_USER=odoo
```
จากตัวอย่างจะมีการ mount โฟล์เดอร์ในคอนเทนเนอร์ไปที่ ./addons สามารถเพิ่มโมดูลที่สร้างเองหรือต้องการทดสอบไว้ที่นี่ได้. 
รัน docker-compose 
```
$ ls
addons/ docker-compose.yml
$ docker-compose.exe up -d
Creating temp_db_1 ... done
Creating temp_web_1 ... done
```

# ทดลองใช้
เปิดเบราเซอร์ เข้า http://localhost:8069

# ทดสอบ 
## PDF ภาษาไทย
สร้างใบเสนอราคา ตั้งชื่อลูกค้าภาษาไทย สั่งพิมพ์ 
![](https://raw.githubusercontent.com/poonlap/images/master/testpdf.png)

## โมดูล l10n_thailand_partner
ข้อมูลสาขาสำหรับบริษัทไทย
![](https://raw.githubusercontent.com/poonlap/images/master/branch.png)