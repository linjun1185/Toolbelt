#! /bin/bash

zephir build
cp ext/modules/nirlah.so /Applications/MAMP/bin/php/php5.5.10/lib/php/extensions/no-debug-non-zts-20121212/nirlah.so
/Applications/MAMP/Library/bin/apachectl -f"/Library/Application Support/appsolute/MAMP PRO/conf/httpd.conf" -k restart
