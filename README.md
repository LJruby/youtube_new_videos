1. create project here: https://console.cloud.google.com/
2. add youtube api v3 here: https://console.cloud.google.com/apis/library
3. create OAuth 2.0 credentials here: https://console.cloud.google.com/apis/credentials
4. download json with credentials (name it client_secrets.json) into your working directory
5. run: ruby youtube.rb 1 (this will print all the videos from your subscription channels not older than 1 day)

google is poor and gives only 10000 queries per day by default :( for example calling list_searches takes 100 units just like that :)
