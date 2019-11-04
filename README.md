# FastDFS-Nginx Docker 
forked from [ygqygq2/fastdfs-nginx](https://github.com/ygqygq2/fastdfs-nginx)  

[FastDFS](https://github.com/happyfish100/fastdfs)  

**默认分支`master`已整合缩略图模块，需要未整合缩略图模块请转至`整合no-image-thumb`分支查看详情**
在原项目已将tracker，storage和nginx进行了整合的基础上，添加docker-compose配置，以及添加nginx第三方模块[ngx_image_thumb
](https://github.com/oupula/ngx_image_thumb)作为缩略图处理方案

## Docker Usage
```
docker run -dti --network=host --name tracker -v /var/fdfs/tracker:/var/fdfs natsusai/fastdfs-nginx tracker

docker run -dti --network=host --name storage0 -e TRACKER_SERVER=10.1.5.85:22122 -v /var/fdfs/storage0:/var/fdfs natsusai/fastdfs-nginx storage

docker run -dti --network=host --name storage1 -e TRACKER_SERVER=10.1.5.85:22122 -v /var/fdfs/storage1:/var/fdfs natsusai/fastdfs-nginx storage

docker run -dti --network=host --name storage2 -e TRACKER_SERVER=10.1.5.85:22122 -e GROUP_NAME=group2 -e PORT=22222 -v /var/fdfs/storage2:/var/fdfs natsusai/fastdfs-nginx storage
```
## Docker-compose Usage
[docker-compose](docker/docker-compose.yml)中storage0环境变量`TRACKER_SERVER`修改为部署后能够访问tracker的地址  

执行以下命令
```shell script
# 使用docker-compose构建
docker-compose build
# 创建容器并后台运行
docker-compose up -d
# 查看log
docker-compose logs -f
```
---
上传文件后根据返回的值查看文件
```
return string: group1/M00/00/00/wKgI_F2_sXiAcJ5cAABsJSKu9NM400.jpg
default url: http://192.168.1.25:8080/group1/M00/00/00/wKgI_F2_sXiAcJ5cAABsJSKu9NM400.jpg
image thumb: http://192.168.1.25:8080/group1/M00/00/00/wKgI_F2_sXiAcJ5cAABsJSKu9NM400.m200x200.jpg
```
**注意**如果添加了缩略图模块并自定义了`GROUP`名称，请参考下面代码在[start.sh](start.sh)文件中添加相应的配置
```shell script
mkdir -p /opt/fdfs/data/group1/M00
ln -s /var/fdfs/data/* /opt/fdfs/data/group1/M00
```
nginx访问文件端口在[storage.conf](nginx_conf/conf.d/storage.conf)中修改

## Config
- Change Nginx or Tengine Version
```dockerfile
ENV FASTDFS_PATH=/opt/fdfs \
    FASTDFS_BASE_PATH=/var/fdfs \
    NGINX_VERSION="1.17.4" \
    TENGINE_VERSION="2.3.2" \
    PORT= \
    GROUP_NAME= \
    TRACKER_SERVER=
```
如上面代码所示，在[Dockerfile](docker/|Dockerfile)中，没有获取最新发布的版本，而是指定某个版本号，需要手动更新版本号  

修改`NGINX_VERSION`或`TENGINE_VERSION`即可
- Switch to Nginx or Tengine
```
 && wget http://tengine.taobao.org/download/tengine-${TENGINE_VERSION}.tar.gz
 && tar -zxf tengine-${TENGINE_VERSION}.tar.gz \
 && cd tengine-${TENGINE_VERSION} \
```
默认使用Tengine，要切换为Nginx则将[Dockerfile](docker/|Dockerfile)中上面的代码替换成下面的代码
```
 && wget https://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz
 && tar -zxf nginx-${TENGINE_VERSION}.tar.gz \
 && cd nginx-${TENGINE_VERSION} \
```

