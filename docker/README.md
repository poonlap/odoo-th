# สารบัญ
- [docker image สำหรับ Odoo](#นี่คืออะไร)
- [Tag ที่ใช้ได้](#Tag-ที่ใช้ได้)
  - [การสร้าง docker image](#การสร้าง-docker-image)
- [ตัวอย่างการใช้](#ใช้อย่างไร)
- [ตัวอย่างหน้าจอ](#ทดสอบ)
- [วิธี upgrade odoo ใน container](#วิธี-upgrade-Odoo-จาก-nightly-build)
- [ใช้ odoo docker พัฒนาโมดูล](#ใช้-odoo-docker-พัฒนาโมดูล)
- [ชื่อจังหวัด, เขต/อำเภอ, รหัสไปรษณีย์ของไทย](#ชื่อจังหวัด-อำเภอ-ตำบล-รหัสไปรษณีย์ของไทย)

# นี่คืออะไร
Repository นี้เป็น Dockerfile สำหรับสร้าง Docker image ที่ใช้งาน Odoo 14.0 (ปัจจุบันปี 2021) หรือเวอร์ชั่นอื่นๆเช่น 13.0 หรือ Odoo 12.0 ร่วมกับภาษาไทย (Thai localization) ได้ทันที โดยรวม
- ฟอนต์ภาษาไทย [Laksaman (Sarabun)](https://thep.blogspot.com/2014/07/laksaman-font.html) สำหรับแสดงผลภาษาไทยเวลาพิมพ์เอกสาร PDF
- [OCA l10n-thailand module](https://github.com/OCA/l10n-thailand)
- [OCA web modules](https://github.com/OCA/web) 
- [OCA partner and contact management modules](https://github.com/OCA/partner-contact)
- [OCA Server UX](https://github.com/OCA/server-ux/)
- [OCA alternative reporting engines and reporting utilities ](https://github.com/OCA/reporting-engine/)
- [OCA Account reconcile modules ](https://github.com/OCA/account-reconcile) widget reconcile ที่มีในรุ่น 13.0 แต่ไม่มีในรุ่น 14.0
- [th_address โมดูลที่อยู่ภาษาไทย](https://github.com/poonlap/odoo-th/tree/14.0/th_address) สร้างข้อมูล ตำบล, อำเภอ, จังหวัด พร้อมใช้งาน และใช้ความสามารถ autocompletion ของโมดูล base_location
- [th_address_vat โมดูลกรอกที่อยู่จากเลข VAT](https://github.com/poonlap/odoo-th/tree/14.0/th_address_vat) หาที่อยู่จาก web service ของกรรมสรรพากรจากเลขประจำตัวผู้เสียภาษี และกรอกที่อยู่ให้อัตโนมัติ ไม่ผิดพลาด

[Dockerfile](https://github.com/poonlap/odoo-th/blob/14.0/docker/Dockerfile) ใช้ base มาจาก [Odoo Official](https://hub.docker.com/_/odoo) มีการเพิ่ม Odoo repository ไว้สำหรับ upgrade version ตาม nightly build ของแต่ละวันลงใน image (local) ได้ด้วย

ถึงแม้ว่าจะมี  [Odoo Docker official Images](https://hub.docker.com/_/odoo) อยู่แล้ว แต่ยังไม่ตอบโจทย์บางอย่าง เช่น 
- image ไม่ได้ตั้ง timezone เวลารันจะเห็น log ลงเวลาไม่ตรงกับเมืองไทย. 
- PDF ที่พิมพ์ออกมาไม่มีฟอนต์ภาษาไทย
- Image ของ official จะมีโมดูล default เท่านั้น ถ้าจะลง OCA l10n_thailand ก็ต้องติดตั้งเอง มี dependency ยุ่งยาก. 

จึงทำ docker image ที่สามารถรันได้เลย สำหรับใช้ทดสอบ, หรือใช้งานจริงก็ได้ โดย base image ดั้งเดิมก็มาจาก [Odoo Docker official Images](https://hub.docker.com/_/odoo)  คือเป็น image เดียวกันแต่ใส่ทุกอย่างที่อยากใช้มาให้แล้ว.

# Tag ที่ใช้ได้
- latest สำหรับรัน Odoo 14.0 รุ่นก่อนออกตัวจริงจาก [Odoo nightly build master](https://nightly.odoo.com/master/nightly/deb/) 
- 14.0 
- 13.0 

## การสร้าง docker image
ใช้ --build-arg และระบุ VERSION ตอน build. 
### Odoo 14
```
$ docker build --build-arg VERSION=14.0 -t poonlap/odoo-th:14.0 .
```
### Odoo 13
```
$ ls
Dockerfile
$ docker build --build-arg VERSION=13.0 -t poonlap/odoo-th:13.0 .
```

# ใช้อย่างไร
## รันด้วย docker (สำหรับทดสอบ)
### รัน PostgreSQL คอนเทนเนอร์
```
$ docker run -d -e POSTGRES_USER=odoo -e POSTGRES_PASSWORD=odoo -e POSTGRES_DB=postgres --name db postgres:10
```
### รัน Odoo คอนเทนเนอร์
ใช้อิมเมจ poonlap/odoo-th:14.0 หรือ poonlap/odoo-th:latest หรือ poonlap/odoo-th
```
$ docker run -p 8069:8069 --name odoo --link db:db -t poonlap/odoo-th:latest
```

## รันด้วย docker-compose (แนะนำ)
ใน repository นี้เตรียมไฟล์ docker-compose.yml ตัวอย่างไว้ให้แล้ว 
```
$ git clone https://github.com/poonlap/odoo-th.git
$ cd odoo-th/docker
$ docker-compose up

```
จากตัวอย่างจะมีการ mount โฟล์เดอร์ในคอนเทนเนอร์ไปที่ ./addons สามารถเพิ่มโมดูลที่สร้างเองหรือต้องการทดสอบไว้ที่นี่ได้. 


# ทดลองใช้
เปิดเบราเซอร์ เข้า http://localhost:8069

# ตัวอย่าง 
## โมดูล l10n_thailand
- ไปที่ Apps ลบ filter แล้วพิมพ์ thai เพื่อหาโมดูลทั้งหมดของไทย และติดตั้ง. 
- Odoo 14.0 (ณ เดือนพ.ค. 2021)

![](https://raw.githubusercontent.com/poonlap/odoo-th/14.0/docker/static/screenshots/apps_v14.png)

- Odoo 13.0 (ณ เดือนพ.ค. 2021)

![](https://raw.githubusercontent.com/poonlap/odoo-th/14.0/docker/static/screenshots/apps_v13.png)

## PDF ภาษาไทย
สร้างใบเสนอราคา ตั้งชื่อลูกค้าภาษาไทย สั่งพิมพ์ 

![](https://raw.githubusercontent.com/poonlap/odoo-th/14.0/docker/static/screenshots/quotation_pdf.png)

## ข้อมูลจังหวัด
![](https://raw.githubusercontent.com/poonlap/odoo-th/14.0/th_address/static/description/data_provinces.png)

## ข้อมูลตำบล อำเภอ
![](https://raw.githubusercontent.com/poonlap/odoo-th/14.0/th_address/static/description/data_cities.png)

## ข้อมูลรหัสไปรษณีย์
![](https://raw.githubusercontent.com/poonlap/odoo-th/14.0/th_address/static/description/data_zips.png)

# วิธี upgrade Odoo จาก nightly build
Docker image ที่สร้างไว้จะเป็นรุ่นตอนที่ build image ไว้.  เช่น ถ้า docker odoo ออก image มาวัน 2019-10-22 ตัว Odoo ก็จะมาจาก [nightly build](https://nightly.odoo.com/) ของวันนั้น. เช่น Odoo 12 ที่รันจาก docker-compose ตามตัวอย่าง

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
$ docker exec --user 0 479e50b12368 apt-get update
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

# ใช้ odoo docker พัฒนาโมดูล
## เตรียมไฟล์ docker-compose.yml
ใน image docker มี python watchdog อยู่แล้ว และใน docker-compose.yml ใช้ตัวเลือก --dev=all มีผลให้เวลา edit ไฟล์ในโมดูลแก้ไข odoo จะ restart โดยอัตโนมัติ
```
version: '2'
services:
  web:
    image: poonlap/odoo-th:latest
    command: -- --dev=all
    depends_on:
      - db
    ports:
      - "8069:8069"
    volumes:
      - ./addons:/mnt/extra-addons
      - ./config:/etc/odoo
      - odoo-web:/var/lib/odoo
  db:
    image: postgres:10
    environment:
      - POSTGRES_DB=postgres
      - POSTGRES_PASSWORD=odoo
      - POSTGRES_USER=odoo
    volumes:
      - odoo-db-data:/var/lib/postgresql/data
volumes:
  odoo-db-data:
  odoo-web:
```

```
$ docker-composer up -d
...
web_1  | 2019-12-01 22:27:57,232 1 INFO ? odoo: database: odoo@db:5432
web_1  | 2019-12-01 22:27:57,366 1 INFO ? odoo.addons.base.models.ir_actions_report: Will use the Wkhtmltopdf binary at /usr/local/bin/wkhtmltopdf
web_1  | 2019-12-01 22:27:57,436 1 INFO ? odoo.service.server: Watching addons folder /usr/lib/python3/dist-packages/odoo/addons
web_1  | 2019-12-01 22:27:57,436 1 INFO ? odoo.service.server: Watching addons folder /var/lib/odoo/addons/13.0
web_1  | 2019-12-01 22:27:57,436 1 INFO ? odoo.service.server: Watching addons folder /mnt/extra-addons
web_1  | 2019-12-01 22:27:57,436 1 INFO ? odoo.service.server: Watching addons folder /opt/odoo/addons/web
web_1  | 2019-12-01 22:27:57,436 1 INFO ? odoo.service.server: Watching addons folder /mnt/extra-addons/l10n-thailand
web_1  | 2019-12-01 22:27:57,625 1 INFO ? odoo.service.server: AutoReload watcher running with watchdog
web_1  | 2019-12-01 22:27:57,633 1 INFO ? odoo.service.server: HTTP service (werkzeug) running on 6329d67008d4:8069
...
```

## สร้าง scaffold
หา container ID ของ odoo ที่รันจาก docker-compose 
```
$ docker ps
CONTAINER ID        IMAGE                    COMMAND                  CREATED             STATUS              PORTS                              NAMES
6329d67008d4        poonlap/odoo-th:latest   "/entrypoint.sh -- -…"   17 minutes ago      Up 8 minutes        0.0.0.0:8069->8069/tcp, 8071/tcp   run_web_1
51a778ba4e1c        postgres:10              "docker-entrypoint.s…"   17 minutes ago      Up 8 minutes        5432/tcp                           run_db_1
```
ตัวอย่าง เช่น container ID เป็น 6329d67008d4
```
$ docker exec --user 0 63 odoo scaffold mymodule /mnt/extra-addons
$ ls addons/mymodule/
__init__.py  __manifest__.py  controllers/  demo/  models/  security/  views/
```
ก็จะได้โฟลเดอร์ mymodule อยู่ใน extra-addons ซึ่งจะไปอยู่ในโฟลเดอร์ addons ที่กำหนดไว้ใน docker-composer.yml นั่นเอง.


