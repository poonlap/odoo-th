โมดูลนี้ใช้สำหรับกรอกที่อยู่ของลูกค้าอัตโนมัติ จากเลขประจำตัวผู้เสียภาษี (VAT 13 หลัก). 
โดยจะใช้เลขประจำตัวผู้เสียภาษี นำไปหาที่อยู่มาให้จาก `web service ของกรมสรรพากร <http://www.rd.go.th/publish/42546.0.html>`_. 
หากเลขประจำตัวผู้เสียภาษีหรือเลขที่สาขาไม่ถูกต้อง โมดูลนี้จะแจ้งให้ผู้ใช้ทราบ

ลองใช้งาน th_address_vat จาก docker image
-----------------------------------------
โมดูลนี้รวมไว้ใน `docker odoo-th <https://github.com/poonlap/odoo-th>`_ แล้ว สามารถลองใช้ได้ทันที.::

    $ git clone https://github.com/poonlap/odoo-th.git
    $ cd odoo-th/docker
    $ docker-compose up
