# rGriffin Docker Instructions


## Running

1. [Install docker](https://docs.docker.com/engine/install/) in your system

2. Run the following command from the terminal, change mypassword for a password you select, and the path (/home/user/tmp/) to an existing path in you local file system, you can also change /home/rstudio/tmp to a different location but keep the base path /home/rstudio/
```
docker run --rm -e PASSWORD=mypassword -p 8787:8787 -v /home/user/tmp/:/home/rstudio/tmp stanmoon/rgriffin
```
The container will be removed when it exits, but this can be changed by removing de --rm option. See more options in the [docker documentation](https://docs.docker.com/engine/reference/run/).

3. Open browser at [localhost:8787](localhost:8787) and connect with the user rstudio and with the password you provided in step 2


## Image Creation and Sharing
1. [Install docker](https://www.docker.com/get-started) in your system

2. Run the following command from the terminal, change mypassword for a password you select, and the user path (/home/user/tmp/) to an existing path in you local file system you can also change /home/rstudio/tmp to a different location but keep the base path /home/rstudio/
```
docker run --rm -p -e PASSWORD=mypassword 8787:8787 -v /home/user/tmp/:/home/rstudio/tmp rocker/verse
```

3. Open browser (localhost:8787) and connect with the user rstudio y with the password you provided in step 2

4. Follow rGriffin installation instruction (do not stop the instance after you finish this step).

5. After successful instalation and testing of rGriffin, open a new terminal and obtain the container id of the rstudio instance by typing
```
docker ps
```

A message similar to the following will be printed in the terminal
> CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS                    NAMES
> 3e4afb7d547c        rocker/verse        "/init"             21 minutes ago      Up 21 minutes       0.0.0.0:8787->8787/tcp   boring_cray
In this case 3e4afb7d547c is the container ID, we will use this ID in the next step

6. Save the new image with the following command:
```
docker commit -m "rstudio with rGriffin package" 3e4afb7d547c rstudio_rgriffin
```
Here we have created a new image -m option gives a descriptive message, the name of the image in this case is rstudio_rgriffin, but another label can be selected.

7. connect to the new docker image using the name given in step 6
```
docker run --rm -e PASSWORD=mypassword -p 8787:8787 -v /home/user/tmp/:/home/rstudio/tmp rstudio_rgriffin
```

8. open the browser and verify that rGriffin is indeed installed and running.

9. login to docker hub
```
docker login -u dockeralias
```

10. tag the image to match your alias in docker hub
```
docker tag rstudio_rgriffin dockeralias/rgriffin
```

11. push the image to the server
```
docker push dockeralias/rgriffin
```

