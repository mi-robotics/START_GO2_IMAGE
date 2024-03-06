Install steps:

```sh
git clone --recurse-submodules git@github.com:mi-robotics/START_GO2_IMAGE.git
```

```sh
sudo  docker build -t noetic .
```

```sh
sudo docker run -it --rm --net=host -e DISPLAY=$DISPLAY -v /tmp/.X11-unix/:/tmp/.X11-unix noetic
```

