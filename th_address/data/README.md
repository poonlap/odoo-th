# ข้อมูลรหัสไปรษณีย์, ตำบล, อำเภอ และจังหวัด ของประเทศไทย
แบ่งเป็น 3 โฟลเดอร์คือ
1. โฟลเดอร์ th ข้อมูลเป็นภาษาไทย  
ข้อมูลต้นฉบับดาวน์โหลดได้จาก https://www.bot.or.th/Thai/Statistics/DataManagementSystem/Standard/StandardCode/Pages/default.aspx
2. โฟลเดอร์ en ข้อมูลเป็นภาษาอังกฤษ
ข้อมูลต้นฉบับดาวน์โหลดได้จาก https://download.geonames.org/export/zip/ มีรายละเอียดเฉพาะอำเภอ. ทางทีม [OCA l10n-thailand ได้เพิ่มตำบลไว้ให้แล้ว](https://github.com/OCA/l10n-thailand/blob/13.0/l10n_th_base_location/data/TH_en.txt).
3. โฟลเดอร์ th_en ข้อมูลภาษาไทย + ภาษาอังกฤษ

# ไฟล์
- th/TH.txt  
เป็นไฟล์ CSV ขั้นด้วย TAB โดยเตรียมจากไฟล์ที่ดาวน์โหลดมากจากข้อมูลของ[ธนาคารแห่งประเทศไทย](https://www.bot.or.th/Thai/Statistics/DataManagementSystem/Standard/StandardCode/Pages/default.aspx) ใช้ข้อมูล "ตำบล อำเภอ" เป็น 1 สถานที่.
- th/TH.zip  
ไฟล์ zip ข้างในมี TH.txt อยู่ สำหรับให้โมดูล [Base Location Geonames Import](https://github.com/OCA/partner-contact/tree/14.0/base_location_geonames_import) เรียกใช้
- en/TH.txt  
เป็นไฟล์ CSV ขั้นด้วย TAB จากโมดูล [l10n_th_base_location](https://github.com/OCA/l10n-thailand/blob/13.0/l10n_th_base_location/data/TH_en.txt)
- en/TH.zip
ไฟล์ zip ข้างในมี TH.txt อยู่ สำหรับให้โมดูล [Base Location Geonames Import](https://github.com/OCA/partner-contact/tree/14.0/base_location_geonames_import) เรียกใช้ กรณีต้องการข้อมูลเป็นภาษาอังกฤษ.

# วิธีการใช้ข้อมูล
1. ติดตั้งโมดูล "Base Location Geonames Import".  
https://github.com/OCA/partner-contact/tree/13.0/base_location_geonames_import

2. Activate the developer mode

3. ไปที่ Settings > Technical > System Parameter และสร้างพาราเมเตอร์
```
geonames.url
```
มีค่าเป็น
```
https://github.com/poonlap/th_address/raw/14.0/data/th/%s.zip
```
กรณีที่ต้องการข้อมูลเป็นภาษาอังกฤษ ตั้งค่าเป็น
```
https://github.com/poonlap/th_address/raw/14.0/data/en/%s.zip
```
กรณีที่ต้องการใช้ทั้งภาษาไทยและอังกฤษ ตั้งค่าเป็น
```
https://github.com/poonlap/th_address/raw/14.0/data/th_en/%s.zip
```
โมดูล th_address สร้าง geonames.url ไว้ให้แล้ว

4. เปลี่ยนเป็น developer mode แล้วไปที่ Contacts > Configuration > Import from Geonames  
เลือก Thailand หรือ "ประเทศไทย" (กรณีหน้าจอภาษาเป็นภาษาไทย) และ import.

หลังจากนั้นจะมี รหัสไปรษณีย์ ตำบล อำเภอ จังหวัด ของไทย ในระะบ odoo.
