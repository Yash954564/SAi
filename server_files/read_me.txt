There're three files, that needs to be uploaded to your server.


These two files are related to deep links:
=========================================
-----------------------------------------

1. apple-app-site-association
2. assetlinks.json

You need to upload these files to your website root folder / .well-known directory and they must be publicly accessible like below:

https://domain.com/.well-known/apple-app-site-association
https://domain.com/.well-known/assetlinks.json

Android Asset Links:
============================

Open and Edit assetlinks.json file and enter your app package name against "package_name" key like below:

"package_name": "com.domain.app"

You also need to provide sha256 of your keystore.

There're two flavour of same app in this files. One is for production sha256 and the other is for development purpose.



Apple App Site Association:
============================

Open and edit the apple-app-site-association file and enter your apple developer team id and app identifier against "appID" key like below:

"appID": "TEAM_ID_XX.com.domain.app"




This one files is related to facebook app ownership:
=========================================
-----------------------------------------

If you integrate Facebook login in your mobile app, Facebook cross-checks your app's ownership on your website at following address:

https://domain.com/app-ads.txt

Open and edit the app-ads.txt file and replace FB_APP_ID_GOES_HERE with your Facebook app id. And then upload to your website root folder.
