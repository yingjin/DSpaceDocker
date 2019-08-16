# DSpaceDocker

This is for development only.

Please download this package, DSpace from https://github.com/ricedss/DSpace.git and assetstore available at https://github.com/yingjin/assetstore.git.

Under DSpaceDocker, there is a dspace directory. Please place DSpace downloaded from https://github.com/ricedss/DSpace.git under the dspace directory and following this instruction -
  - git clone https://github.com/ricedss/DSpace.git
  - cd DSpace 
  - git checkout imagineRio-dspace-6.x 
  
Download assetstore and place it under DSpace directory; this may take a while.
  - git clone https://github.com/yingjin/assetstore.git    

Back to DSpaceDocker dir which has the dspace-compose.yml file available. Run following command:

  - docker-compose -p d6 -f docker-compose.yml -f d6.override.yml -f src.override.yml up -d

Access the DSpace at http://localhost:8080/xmlui. The rest api is available at http://localhost:8080/xmlui.


To take the site down, you need to run

  - docker-compose -p d6 -f docker-compose.yml -f d6.override.yml -f src.override.yml down
  
To remove images, you can do
  - docker image prune
  
It's likely images are still there and you have to remove them one by one. 
You can do 
  - docker image ls -a
  - docker rmi <imageID>
  
Then, last, if you want to clean all the volumes,
  - docker volume prune
  
  
