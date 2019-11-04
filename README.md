# FastDFS-Nginx Docker 

[fastdfs](https://github.com/happyfish100/fastdfs)

## Usage:

```
docker run -dti --network=host --name tracker -v /var/fdfs/tracker:/var/fdfs ygqygq2/fastdfs-nginx tracker

docker run -dti --network=host --name storage0 -e TRACKER_SERVER=10.1.5.85:22122 -v /var/fdfs/storage0:/var/fdfs ygqygq2/fastdfs-nginx storage

docker run -dti --network=host --name storage1 -e TRACKER_SERVER=10.1.5.85:22122 -v /var/fdfs/storage1:/var/fdfs ygqygq2/fastdfs-nginx storage

docker run -dti --network=host --name storage2 -e TRACKER_SERVER=10.1.5.85:22122 -e GROUP_NAME=group2 -e PORT=22222 -v /var/fdfs/storage2:/var/fdfs ygqygq2/fastdfs-nginx storage
```
---
## DockerFile Config
### Nginx和Tengine版本
```dockerfile
ENV FASTDFS_PATH=/opt/fdfs \
    FASTDFS_BASE_PATH=/var/fdfs \
    NGINX_VERSION="1.17.4" \
    TENGINE_VERSION="2.3.2" \
    PORT= \
    GROUP_NAME= \
    TRACKER_SERVER=
```
如上面代码所示，在[Dockerfile](docker/Dockerfile)中，没有获取最新发布的版本，而是指定某个版本号，更新版本需要手动更新  
### Nginx和Tengine的切换
```
 && wget http://tengine.taobao.org/download/tengine-${TENGINE_VERSION}.tar.gz
 && tar -zxf tengine-${TENGINE_VERSION}.tar.gz \
 && cd tengine-${TENGINE_VERSION} \
```
默认使用Tengine，要切换为Nginx则将上面代码替换成下面的代码(直接全局搜索替换即可，因为只会搜到一条)
```
 && wget https://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz
 && tar -zxf nginx-${TENGINE_VERSION}.tar.gz \
 && cd nginx-${TENGINE_VERSION} \
```
## Docker-compose Usage
[docker-compose](docker/docker-compose.yml)中storage0环境变量`TRACKER_SERVER`修改为部署后能够访问tracker的地址  

执行以下命令
```shell script
cd docker
# 使用docker-compose构建
docker-compose build
# 创建容器并后台运行
docker-compose up -d
# 查看log
docker-compose logs -f
```
