FROM centos:7

LABEL maintainer "liufuhong@century-cn.com"

ENV FASTDFS_PATH=/opt/fdfs \
    FASTDFS_BASE_PATH=/var/fdfs \
    NGINX_VERSION="1.17.4" \
    TENGINE_VERSION="2.3.2" \
    PORT= \
    GROUP_NAME= \
    TRACKER_SERVER=

#get all the dependences and nginx
RUN yum install -y git gcc make wget automake autoconf m4 pcre pcre-devel gd-devel libcurl-devel openssl openssl-devel \
  && rm -rf /var/cache/yum/*

#create the dirs to store the files downloaded from internet
RUN mkdir -p ${FASTDFS_PATH}/libfastcommon \
 && mkdir -p ${FASTDFS_PATH}/fastdfs \
 && mkdir -p ${FASTDFS_PATH}/fastdfs-nginx-module \
 && mkdir -p ${FASTDFS_PATH}/ngx_image_thumb \
 && mkdir ${FASTDFS_BASE_PATH}

#compile the libfastcommon
WORKDIR ${FASTDFS_PATH}/libfastcommon

RUN git clone --depth 1 https://github.com/happyfish100/libfastcommon.git ${FASTDFS_PATH}/libfastcommon \
 && ./make.sh \
 && ./make.sh install \
 && rm -rf ${FASTDFS_PATH}/libfastcommon

#compile the fastdfs
WORKDIR ${FASTDFS_PATH}/fastdfs

RUN git clone --depth 1 https://github.com/happyfish100/fastdfs.git ${FASTDFS_PATH}/fastdfs \
 && ./make.sh \
 && ./make.sh install \
 && rm -rf ${FASTDFS_PATH}/fastdfs

#comile nginx
WORKDIR ${FASTDFS_PATH}/fastdfs-nginx-module

# nginx url: https://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz
# tengine url: http://tengine.taobao.org/download/tengine-${TENGINE_VERSION}.tar.gz
RUN git clone --depth 1 https://github.com/happyfish100/fastdfs-nginx-module.git ${FASTDFS_PATH}/fastdfs-nginx-module \
 && git clone --depth 1 https://github.com/oupula/ngx_image_thumb.git ${FASTDFS_PATH}/ngx_image_thumb \
 && wget http://tengine.taobao.org/download/tengine-${TENGINE_VERSION}.tar.gz \
 && tar -zxf tengine-${TENGINE_VERSION}.tar.gz \
 && cd tengine-${TENGINE_VERSION} \
 && ./configure --prefix=/usr/local/nginx --add-module=${FASTDFS_PATH}/fastdfs-nginx-module/src/ \
 --add-module=${FASTDFS_PATH}/ngx_image_thumb \
 && make \
 && make install \
 && ln -s /usr/local/nginx/sbin/nginx /usr/bin/ \
 && rm -rf ${FASTDFS_PATH}/fastdfs-nginx-module \
 && rm -rf ${FASTDFS_PATH}/ngx_image_thumb \

EXPOSE 22122 23000 8080 8888 80
VOLUME ["$FASTDFS_BASE_PATH","/etc/fdfs","/usr/local/nginx/conf/conf.d"]   

COPY conf/*.* /etc/fdfs/

RUN mkdir /nginx_conf && mkdir -p /usr/local/nginx/conf/conf.d
COPY nginx_conf/ /nginx_conf/
COPY nginx_conf/nginx.conf /usr/local/nginx/conf/

COPY start.sh /usr/bin/

#make the start.sh executable 
RUN chmod 777 /usr/bin/start.sh


ENTRYPOINT ["/usr/bin/start.sh"]
CMD ["tracker"]
