# Data for provinces, cities, postcodes in Thai language.
- The original data is from
  https://www.bot.or.th/Thai/Statistics/DataManagementSystem/Standard/StandardCode/Pages/default.aspx
- Geocodes in the file TH.txt are fake, I put them just for importing by Base Location Geonames Import.
- The file TH.txt is a prepared data, TH.zip is just zipped format. 
- The TH.txt was prepared to the same format as
https://download.geonames.org/export/zip/

## How to use the data
1. Install the module "Base Location Geonames Import".
https://github.com/OCA/partner-contact/tree/13.0/base_location_geonames_import

2. Activate the developer mode
3. Go to Settings > Technical > System Parameters and create the parameter names "geonames.url" and set the value to
```
https://github.com/poonlap/odoo-th/raw/master/data/%s.zip
```
4. Go to Contacts > Configuration > Import from Geonames
5. Select country "Thailand" (ประเทศไทย) and import.

After then you can easily input the address by zip code or city name.

# Data for provinces, cities, postcodes in English.
The data from geonames.org is outdated. There is no information of Bung kan which separated from Nong Kai. You can set geonames.url to
```
https://github.com/poonlap/odoo-th/raw/master/data/%s_EN.zip
```
and import the geonames in English for Thailand. 

To avoid conflicted with Thai language, I added a suffix "_en" to the ID names.