# นี่คืออะไร
Docker image ที่ใช้งาน Odoo 13 หรือ Odoo 12 ได้ทันที โดยรวม
- ฟอนต์ภาษาไทย [Laksaman (Sarabun)](https://thep.blogspot.com/2014/07/laksaman-font.html) สำหรับแสดงผลภาษาไทยเวลาพิมพ์เอกสาร PDF
- [OCA l10n-thailand module](https://github.com/OCA/l10n-thailand)
- [OCA web modules](https://github.com/OCA/web) ที่ใช้ได้กับเวอร์ชั่น 13 แล้ว เช่น web responsive

[Dockerfile](https://github.com/poonlap/odoo-th/blob/master/Dockerfile) ใช้ base มาจาก [Odoo Official](https://hub.docker.com/_/odoo) มีการเพิ่ม Odoo repository ไว้สำหรับ upgrade version ตาม nightly build ของแต่ละวันลงใน image (local) ได้ด้วย

# ทำไมจึงทำ Docker Image ของ Odoo
ถึงแม้ว่าจะมี  [Odoo Docker official Images](https://hub.docker.com/_/odoo) อยู่แล้ว แต่ยังไม่ตอบโจทย์บางอย่าง เช่น 
- image ไม่ได้ตั้ง timezone เวลารันจะเห็น log ลงเวลาไม่ตรงกับเมืองไทย. 
- PDF ที่พิมพ์ออกมาไม่มีฟอนต์ภาษาไทย
- Image ของ official จะมีโมดูล default เท่านั้น ถ้าจะลง OCA l10n_thailand ก็ต้องติดตั้งเอง มี dependency ยุ่งยาก. 

จึงทำ docker image ที่สามารถรันได้เลย สำหรับใช้ทดสอบ, หรือใช้งานจริงก็ได้ โดย base image ดั้งเดิมก็มาจาก   [Odoo Docker official Images](https://hub.docker.com/_/odoo)  คือเป็น image เดียวกันแต่ใส่ทุกอย่างที่อยากใช้มาให้แล้ว.

# Tag ที่ใช้ได้
- 13.0, latest
- 12.0
Tag ทั้งสองตัวใช้ Dockerfile ตัวเดียวกัน ต่างกันตอน build image ใช้ ARG ชื่อ VERSION ระบุรุ่น.
```
$ docker build --build-arg VERSION=12.0 -t poonlap/odoo-th:12.0 .
```
ถ้าไม่ระบุรุ่น จะเป็นเวอร์ชั่น 13.0.

# ใช้อย่างไร
## รันด้วย docker (สำหรับทดสอบ)
### รัน PostgreSQL คอนเทนเนอร์
```
$ docker run -d -e POSTGRES_USER=odoo -e POSTGRES_PASSWORD=odoo -e POSTGRES_DB=postgres --name db postgres:10
```
### รัน Odoo 13 คอนเทนเนอร์
ใช้อิมเมจ poonlap/odoo-th:13.0 หรือ poonlap/odoo-th:latest หรือ poonlap/odoo-th
```
$ docker run -p 8069:8069 --name odoo13 --link db:db -t poonlap/odoo-th:13.0
```
### รัน Odoo 12 คอนเทนเนอร์
ใช้อิมเมจ poonlap/odoo-th:12.0
```
$ docker run -p 8069:8069 --name odoo12 --link db:db -t poonlap/odoo-th:12.0
```

## รันด้วย docker-compose (สำหรับใช้งานจริงจัง)
สร้างไฟล์ docker-compose.yml ตัวอย่างเป็น Odoo 12.0
```
version: '2'
services:
  web:
    image: poonlap/odoo-th:12.0
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
## โมดูล l10n_thailand ทั้งหมด
- ถ้าใช้ image poonlap/odoo-th:12.0 จะสามารถใช้โมดูล l10n_thailand ได้ทั้งหมด รันคอนเทนเนอร์แล้ว ไปที่ Apps ลบ filter แล้วพิมพ์ thai เพื่อหาโมดูลทั้งหมดของไทย และติดตั้ง. โมดูลอื่นๆของ OCA ที่จำเป็นที่ l10n_thailand ใช้จะติดตั้งอัตโนมัติตามไปด้วย เช่น [server-tools](https://github.com/OCA/server-tools) เป็นต้น.
- ถ้าใช้ image poonlap/odoo-th:13.0 ตอนนี้ใช้ได้เฉพาะ l10n_thailand_partner เท่านั้น

![](https://raw.githubusercontent.com/poonlap/images/master/odoo12_l10nth.png)

![](https://raw.githubusercontent.com/poonlap/images/master/l10n_thailand.png)

## PDF ภาษาไทย
สร้างใบเสนอราคา ตั้งชื่อลูกค้าภาษาไทย สั่งพิมพ์ 

![](https://raw.githubusercontent.com/poonlap/images/master/testpdf.png)

## โมดูล l10n_thailand_partner
ข้อมูลสาขาสำหรับบริษัทไทย

![](https://raw.githubusercontent.com/poonlap/images/master/branch.png)

# วิธี upgrade Odoo จาก nightly build
Docker image ที่สร้างไว้จะเป็นรุ่นตอนที่ build image ไว้ เช่น ถ้า docker odoo ออก image มาวัน 2019-10-22 ตัว Odoo ก็จะมาจาก [nightly build](https://nightly.odoo.com/) ของวันนั้น. เช่น Odoo 12 ที่รันจาก docker-compose ตามตัวอย่าง

```
$ docker-compose up
...
db_1   | 2019-10-30 08:25:52.304 UTC [52] LOG:  database system was shut down at 2019-10-30 08:25:52 UTC
db_1   | 2019-10-30 08:25:52.307 UTC [1] LOG:  database system is ready to accept connections
web_1  | 2019-10-30 15:25:52,549 1 INFO ? odoo: Odoo version 12.0-20191022
...
```
สมมติว่าเราต้องการ upgrade จาก 12.0-20191022 เป็นวันนี้. ต้องหา container id รัน docker exec และ docker commit ตามตัวอย่าง
```
$ docker ps
CONTAINER ID        IMAGE                  COMMAND                  CREATED             STATUS              PORTS                              NAMES
479e50b12368        poonlap/odoo-th:12.0   "/entrypoint.sh odoo"    26 minutes ago      Up 8 minutes        0.0.0.0:8069->8069/tcp, 8071/tcp   temp_web_1
c05c1d4033d7        postgres:10            "docker-entrypoint.s…"   26 minutes ago      Up 8 minutes        5432/tcp                           temp_db_1
$ docker exec --user 0 47 apt-get update
Hit:1 http://deb.nodesource.com/node_8.x stretch InRelease
Hit:2 http://security-cdn.debian.org/debian-security stretch/updates InRelease
Ign:3 http://cdn-fastly.deb.debian.org/debian stretch InRelease
Hit:4 http://cdn-fastly.deb.debian.org/debian stretch-updates InRelease
Hit:5 http://cdn-fastly.deb.debian.org/debian stretch-backports InRelease
Hit:6 http://cdn-fastly.deb.debian.org/debian stretch Release
Ign:8 http://nightly.odoo.com/12.0/nightly/deb ./ InRelease
Get:9 http://nightly.odoo.com/12.0/nightly/deb ./ Release [1186 B]
Hit:10 http://apt.postgresql.org/pub/repos/apt stretch-pgdg InRelease
Get:11 http://nightly.odoo.com/12.0/nightly/deb ./ Release.gpg [819 B]
Get:12 http://nightly.odoo.com/12.0/nightly/deb ./ Packages [1892 B]
Fetched 3897 B in 3s (1000 B/s)
Reading package lists...
$ docker exec --user 0 47 apt-get -y upgrade odoo
Reading package lists...
Building dependency tree...
Reading state information...
Calculating upgrade...
The following package was automatically installed and is no longer required:
  libuv1
Use 'apt autoremove' to remove it.
The following packages will be upgraded:
  odoo
1 upgraded, 0 newly installed, 0 to remove and 0 not upgraded.
Need to get 51.8 MB of archives.
After this operation, 1635 kB of additional disk space will be used.
Get:1 http://nightly.odoo.com/12.0/nightly/deb ./ odoo 12.0.20191030 [51.8 MB]
debconf: delaying package configuration, since apt-utils is not installed
Fetched 51.8 MB in 23s (2160 kB/s)
(Reading database ... 45816 files and directories currently installed.)
Preparing to unpack .../odoo_12.0.20191030_all.deb ...
invoke-rc.d: could not determine current runlevel
invoke-rc.d: policy-rc.d denied execution of stop.
Unpacking odoo (12.0.20191030) over (12.0.20191022) ...
Setting up odoo (12.0.20191030) ...
invoke-rc.d: could not determine current runlevel
invoke-rc.d: policy-rc.d denied execution of start.
$ docker commit 47 poonlap/odoo-th:12.0.20191030
sha256:a181cf602f114b3fe48967abbf6810a6d5b9105100a97b86d2483be27e2327c1
$ docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
poonlap/odoo-th     12.0.20191030       a181cf602f11        7 minutes ago       1.83GB
poonlap/odoo-th     12.0                d5e0e7e33bb1        4 hours ago         1.33GB
postgres            10                  9a05a2b9e69f        13 days ago         211MB
```
แล้วจะได้ image ที่ tag เป็นตัวใหม่ เช่นในตัวอย่าง poonlap/odoo-th:12.0.20191030.
แก้ไฟล์ docker-compose ให้ใช้ image poonlap/odoo-th:12.0.20191030 ก็จะได้ Odoo เวอร์ชั่นใหม่.
