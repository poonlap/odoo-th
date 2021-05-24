Dockerfile สำหรับสร้าง Docker image ที่ใช้งาน Odoo 14.0 (ณ ตอนที่เขียน เดือน พ.ค. 2021) หรือเวอร์ชั่นอื่นๆเช่น 13.0 หรือ 12.0 ร่วมกับภาษาไทย (Thai localization) ได้ทันที โดยรวม

- ฟอนต์ภาษาไทย [Laksaman (Sarabun)](https://thep.blogspot.com/2014/07/laksaman-font.html) สำหรับแสดงผลภาษาไทยเวลาพิมพ์เอกสาร PDF
- [OCA l10n-thailand module](https://github.com/OCA/l10n-thailand)
- [OCA web modules](https://github.com/OCA/web)
- [OCA partner and contact management modules](https://github.com/OCA/partner-contact)
- [OCA Server UX](https://github.com/OCA/server-ux/)
- [OCA alternative reporting engines and reporting utilities ](https://github.com/OCA/reporting-engine/)
- [OCA Account reconcile modules ](https://github.com/OCA/account-reconcile) widget reconcile ที่มีในรุ่น 13.0 แต่ไม่มีในรุ่น 14.0
- [th_address โมดูลที่อยู่ภาษาไทย](https://github.com/poonlap/odoo-th/tree/14.0/th_address) สร้างข้อมูล ตำบล, อำเภอ, จังหวัด พร้อมใช้งาน และใช้ความสามารถ autocompletion ของโมดูล base_location
- [th_address_vat โมดูลกรอกที่อยู่จากเลข VAT](https://github.com/poonlap/odoo-th/tree/14.0/th_address_vat) หาที่อยู่จาก web service ของกรรมสรรพากรจากเลขประจำตัวผู้เสียภาษี และกรอกที่อยู่ให้อัตโนมัติ ไม่ผิดพลาด
- ตั้ง timezone ประเทศไทย สำหรับดูเวลาใน log. ถ้ารัน [Odoo Docker official Images](https://hub.docker.com/_/odoo) เวลาจะไม่ตรงกับเมืองไทย.
- [Dockerfile](https://github.com/poonlap/odoo-th/blob/14.0/docker/Dockerfile) ใช้ base มาจาก [Odoo Official](https://hub.docker.com/_/odoo) มีการเพิ่ม Odoo repository ไว้สำหรับ upgrade version ตาม nightly build ของแต่ละวันลงใน image (local)

# สารบัญ
- [การสร้าง docker image](#การสร้าง-docker-image)
- [รันด้วย docker-compose](#รันด้วย-docker-compose)
- [ตัวอย่างหน้าจอ](#ต้วอย่างหน้าจอ)
- [วิธี upgrade odoo ใน container](#วิธี-upgrade-Odoo-จาก-nightly-build)
- [ใช้ odoo docker พัฒนาโมดูล](#ใช้-odoo-docker-พัฒนาโมดูล)
- [รัน Unit test](#รัน-Unit-Test)

# การสร้าง docker image

ใช้ --build-arg และระบุ VERSION ตอน build.

## Odoo 14

```
$ docker build --build-arg VERSION=14.0 -t poonlap/odoo-th:14.0 .
$ docker tag poonlap/odoo-th:14.0 poonlap/odoo-th:latest
```

## Odoo 13

```
$ docker build --build-arg VERSION=13.0 -t poonlap/odoo-th:13.0 .
```

# รันด้วย docker-compose

ใน repository นี้เตรียมไฟล์ docker-compose.yml ตัวอย่างไว้ให้แล้ว

```
$ git clone https://github.com/poonlap/odoo-th.git
$ cd odoo-th/docker
$ docker-compose up

```

จากตัวอย่างจะมีการ mount โฟล์เดอร์ในคอนเทนเนอร์ไปที่ ./addons สามารถเพิ่มโมดูลที่สร้างเองหรือต้องการทดสอบไว้ที่นี่ได้.

หลังจากรัน docker-composer ได้แล้ว เปิดเบราเซอร์ เข้า http://localhost:8069

# ตัวอย่างหน้าจอ

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

Docker image ที่สร้างไว้จะเป็นรุ่นตอนที่ build image ไว้. ดูรุ่นวันที่ได้ตอนที่รัน ตัวอย่างเช่น

```
$ docker-compose up
...
db_1   | 2021-05-24 15:54:53.932 UTC [1] LOG:  database system is ready to accept connections
web_1  | 2021-05-24 22:54:54,415 1 INFO ? odoo: Odoo version 14.0-20210520
...
```
วันนี้ที่รันเป็นวันที่ 2021-05-24 แต่ Odoo เป็นเวอร์ชั่น 14.0-20210520. สมมติว่าเราต้องการ upgrade ให้เป็น nightly build ปัจจุบัน (20210524), ก่อนอื่นต้องหา container id แล้วรัน docker exec เพื่อเข้าไปใน shell.

```
$  docker ps
CONTAINER ID   IMAGE                    COMMAND                  CREATED         STATUS         PORTS                                                      NAMES
4e8a53b7b0f3   poonlap/odoo-th:latest   "/entrypoint.sh -- -…"   3 minutes ago   Up 3 minutes   0.0.0.0:8069->8069/tcp, :::8069->8069/tcp, 8071-8072/tcp   docker_web_1
66d6e5d3800d   postgres:10              "docker-entrypoint.s…"   3 minutes ago   Up 3 minutes   5432/tcp                                                   docker_db_1
$ docker exec --user 0 -ti 4e8a53b7b0f3 bash 
root@4e8a53b7b0f3:/# apt-get update; apt-get upgrade -y odoo
Hit:1 http://deb.debian.org/debian buster InRelease
Hit:2 http://security.debian.org/debian-security buster/updates InRelease
Hit:3 http://deb.debian.org/debian buster-updates InRelease
Ign:4 http://nightly.odoo.com/14.0/nightly/deb ./ InRelease
Hit:5 http://nightly.odoo.com/14.0/nightly/deb ./ Release
Reading package lists... Done
Reading package lists... Done
Building dependency tree
Reading state information... Done
Calculating upgrade... Done
The following packages will be upgraded:
  liblz4-1 libx11-6 libx11-data odoo
4 upgraded, 0 newly installed, 0 to remove and 0 not upgraded.
Need to get 172 MB of archives.
After this operation, 7032 kB disk space will be freed.
Get:1 http://security.debian.org/debian-security buster/updates/main amd64 liblz4-1 amd64 1.8.3-1+deb10u1 [53.3 kB]
Get:2 http://security.debian.org/debian-security buster/updates/main amd64 libx11-data all 2:1.6.7-1+deb10u2 [299 kB]
Get:3 http://security.debian.org/debian-security buster/updates/main amd64 libx11-6 amd64 2:1.6.7-1+deb10u2 [757 kB]
Get:4 http://nightly.odoo.com/14.0/nightly/deb ./ odoo 14.0.20210524 [171 MB]
Fetched 172 MB in 9min 54s (289 kB/s)
debconf: delaying package configuration, since apt-utils is not installed
(Reading database ... 63575 files and directories currently installed.)
Preparing to unpack .../odoo_14.0.20210524_all.deb ...
Unpacking odoo (14.0.20210524) over (14.0.20210520) ...
Preparing to unpack .../liblz4-1_1.8.3-1+deb10u1_amd64.deb ...
Unpacking liblz4-1:amd64 (1.8.3-1+deb10u1) over (1.8.3-1) ...
Setting up liblz4-1:amd64 (1.8.3-1+deb10u1) ...
(Reading database ... 63580 files and directories currently installed.)
Preparing to unpack .../libx11-data_2%3a1.6.7-1+deb10u2_all.deb ...
Unpacking libx11-data (2:1.6.7-1+deb10u2) over (2:1.6.7-1+deb10u1) ...
Preparing to unpack .../libx11-6_2%3a1.6.7-1+deb10u2_amd64.deb ...
Unpacking libx11-6:amd64 (2:1.6.7-1+deb10u2) over (2:1.6.7-1+deb10u1) ...
Setting up libx11-data (2:1.6.7-1+deb10u2) ...
Setting up odoo (14.0.20210524) ...
invoke-rc.d: could not determine current runlevel
invoke-rc.d: policy-rc.d denied execution of restart.
Setting up libx11-6:amd64 (2:1.6.7-1+deb10u2) ...
Processing triggers for libc-bin (2.28-10) ...
root@4e8a53b7b0f3:/# exit
exit
```
เมื่อ upgrade แล้วก็ commit image ใส่ tag ใหม่เช่น poonlap/odoo-th:14.0.20210524
```
$ docker commit 4e8a53b7b0f3 poonlap/odoo-th:14.0.20210524
$ docker images
REPOSITORY        TAG             IMAGE ID       CREATED              SIZE
poonlap/odoo-th   14.0.20210524   b56efd9ff583   About a minute ago   3.36GB
poonlap/odoo-th   latest          c4bc84892571   4 days ago           2.6GB
odoo              latest          eeb9bda32241   5 days ago           1.4GB
postgres          10              ae022a26b238   9 months ago         200MB
```

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

# รัน Unit Test
กรณีที่สร้างโมดูลแล้วต้องการรัน Unit Test. ตัวอย่าง รัน Unit Test ของโมดูบ l10n_th_partner 
```
$  docker-compose run --rm web  --test-enable -i l10n_th_partner -d testdb --log-level=test
Creating network "docker_default" with the default driver
Creating docker_db_1 ... done
Creating docker_web_run ... done
2021-05-24 23:46:50,472 1 INFO ? odoo: Odoo version 14.0-20210520
2021-05-24 23:46:50,473 1 INFO ? odoo: Using configuration file at /etc/odoo/odoo.conf
2021-05-24 23:46:50,473 1 INFO ? odoo: addons paths: ['/usr/lib/python3/dist-packages/odoo/addons', '/var/lib/odoo/addons/14.0', '/mnt/extra-addons', '/opt/odoo/addons', '/opt/odoo/addons/l10n-thailand', '/opt/odoo/addons/web', '/opt/odoo/addons/partner-contact', '/opt/odoo/addons/server-ux', '/opt/odoo/addons/reporting-engine', '/opt/odoo/addons/account-reconcile', '/opt/odoo/addons/odoo-th']
2021-05-24 23:46:50,473 1 INFO ? odoo: database: odoo@db:5432
2021-05-24 23:46:50,622 1 INFO ? odoo.addons.base.models.ir_actions_report: Will use the Wkhtmltopdf binary at /usr/local/bin/wkhtmltopdf
2021-05-24 23:46:50,726 1 INFO ? odoo.service.server: HTTP service (werkzeug) running on e139b89dcdb5:8069
2021-05-24 23:46:50,751 1 INFO testdb odoo.modules.loading: loading 1 modules...
2021-05-24 23:46:50,768 1 INFO testdb odoo.modules.loading: 1 modules loaded in 0.02s, 0 queries (+0 extra)
2021-05-24 23:46:50,876 1 INFO testdb odoo.modules.loading: updating modules list
2021-05-24 23:46:50,882 1 INFO testdb odoo.addons.base.models.ir_module: ALLOW access to module.update_list on [] to user __system__ #1 via n/a
2021-05-24 23:46:51,664 1 INFO testdb odoo.modules.loading: loading 30 modules...
2021-05-24 23:46:51,738 1 WARNING testdb py.warnings: /usr/lib/python3/dist-packages/jinja2/sandbox.py:82: DeprecationWarning: Using or importing the ABCs from 'collections' instead of from 'collections.abc' is deprecated, and in 3.8 it will stop working
  from collections import MutableSet, MutableMapping, MutableSequence

2021-05-24 23:46:51,885 1 INFO testdb odoo.modules.loading: Loading module l10n_th_partner (28/30)
2021-05-24 23:46:52,131 1 INFO testdb odoo.modules.registry: module l10n_th_partner: creating or updating database tables
2021-05-24 23:46:52,229 1 INFO testdb odoo.modules.loading: loading l10n_th_partner/data/res.partner.company.type.csv
2021-05-24 23:46:52,284 1 INFO testdb odoo.modules.loading: loading l10n_th_partner/data/res.partner.title.csv
2021-05-24 23:46:52,410 1 INFO testdb odoo.modules.loading: loading l10n_th_partner/views/res_company_view.xml
2021-05-24 23:46:52,438 1 INFO testdb odoo.modules.loading: loading l10n_th_partner/views/res_partner_company_type_view.xml
2021-05-24 23:46:52,455 1 INFO testdb odoo.modules.loading: loading l10n_th_partner/views/res_partner_view.xml
2021-05-24 23:46:52,564 1 INFO testdb odoo.modules.loading: loading l10n_th_partner/views/res_users_view.xml
2021-05-24 23:46:52,615 1 INFO testdb odoo.addons.base.models.ir_translation: module l10n_th_partner: loading translation file (th) for language th_TH
2021-05-24 23:46:52,615 1 INFO testdb odoo.tools.translate: loading /opt/odoo/addons/l10n-thailand/l10n_th_partner/i18n/th.po
2021-05-24 23:46:52,649 1 INFO testdb odoo.addons.l10n_th_partner.tests.test_l10n_th_partner: Starting TestL10nThPartner.test_res_partner ...
2021-05-24 23:46:52,783 1 INFO testdb odoo.addons.l10n_th_partner.tests.test_l10n_th_partner: Starting TestL10nThPartner.test_res_users ...
2021-05-24 23:46:52,899 1 INFO testdb odoo.modules.loading: Module l10n_th_partner loaded in 1.01s (incl. 0.24s test), 481 queries (+147 test)
2021-05-24 23:46:52,905 1 WARNING testdb odoo.models: The model geonames_th.geonames_th has no _description
2021-05-24 23:46:52,937 1 INFO testdb odoo.modules.loading: 30 modules loaded in 1.27s, 481 queries (+147 extra)
2021-05-24 23:46:52,993 1 WARNING testdb odoo.modules.loading: The model geonames_th.geonames_th has no access rules, consider adding one. E.g. access_geonames_th_geonames_th,access_geonames_th_geonames_th,model_geonames_th_geonames_th,base.group_user,1,0,0,0
2021-05-24 23:46:53,100 1 INFO testdb odoo.modules.registry: verifying fields for every extended model
2021-05-24 23:46:53,296 1 INFO testdb odoo.modules.loading: Modules loaded.
2021-05-24 23:46:53,303 1 INFO testdb odoo.service.server: Starting post tests
2021-05-24 23:46:53,305 1 INFO testdb odoo.service.server: 0 post-tests in 0.00s, 0 queries
^C2021-05-24 23:46:55,140 1 INFO testdb odoo.service.server: Initiating shutdown
2021-05-24 23:46:55,141 1 INFO testdb odoo.service.server: Hit CTRL-C again or send a second signal to force the shutdown.

$ docker-compose down
Stopping docker_db_1 ... done
Removing docker_db_1 ... done
Removing network docker_default
```