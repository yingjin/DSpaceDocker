# DSpaceDocker

This is for development only.

Please download this package, DSpace from https://github.com/ricedss/DSpace.git and assetstore available at https://github.com/yingjin/assetstore.git.

Under DSpaceDocker, there is a dspace directory. Please place DSpace downloaded from https://github.com/ricedss/DSpace.git under the dspace directory. 

Create a folder called loaddata under DSpace directory and then place the assetstore under DSpace/loaddata/.

Back to DSpaceDocker dir which has the dspace-compose.yml file available. Run following command:

docker-compose -p d6 -f docker-compose.yml -f d6.override.yml -f src.override.yml up -d

Access the DSpace at http://localhost:8080/xmlui. The rest api is available at http://localhost:8080/xmlui.



