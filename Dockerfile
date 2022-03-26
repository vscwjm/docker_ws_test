FROM debian
COPY frps.ini /root/
COPY wstunnel-x64-linux /root/
COPY ServerStatus-client-linux.py /root/client-linux.py
RUN apt update
RUN apt install ssh wget curl sudo net-tools iputils-ping iproute2 iproute2-doc vim  python3 python3-pip screen unzip qrencode -y
RUN pip3 install psutil
RUN chmod a+x /root/wstunnel-x64-linux \
	&& chmod a+x /root/client-linux.py
RUN rm -rf /root/frp_0.39.1_linux_amd64 \
	&& wget --no-check-certificate -qO '/root/frp.tar.gz' "https://github.com/fatedier/frp/releases/download/v0.39.1/frp_0.39.1_linux_amd64.tar.gz" \
	&& tar -zxf /root/frp.tar.gz -C /root \
	&& mv /root/frp_0.39.1_linux_amd64 /root/frp \
	&& mv /root/frps.ini /root/frp/frps.ini
RUN mkdir /run/sshd 	
RUN echo '/root/wstunnel-x64-linux --server  ws://0.0.0.0:80 &' >>/1.sh \
    && echo '/root/wstunnel-x64-linux -L 0.0.0.0:35601:127.0.0.1:35601 wss://test-81-gbjkld.cloud.okteto.net &' >>/1.sh \
    && echo '/root/frp/frps -c /root/frp/frps.ini &' >> /1.sh \
    && echo 'nohup /root/client-linux.py &' >>/1.sh \
    && echo '/usr/sbin/sshd -D' >>/1.sh \
    && echo 'PermitRootLogin yes' >>  /etc/ssh/sshd_config
RUN echo root:wangjm0529 | chpasswd
RUN chmod 7777 /1.sh
#COPY v2ray_config.json /root/
#COPY v2ray_vmess.json /root/
EXPOSE 80
CMD  /1.sh
