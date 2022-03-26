FROM debian
#COPY 1.sh /
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
#RUN cd /root \
#	&& git clone https://github.com/cppla/ServerStatus.git \
#	&& mv /root/ServerStatus-client-linux.py /root/ServerStatus/clients/client-linux.py \
#	&& chmod a+x /root/ServerStatus/clients/client-linux.py
	
RUN echo '/root/wstunnel-x64-linux --server  ws://0.0.0.0:80 &' >>/1.sh \
    && echo '/root/wstunnel-x64-linux -L 0.0.0.0:35601:127.0.0.1:35601 wss://test-81-gbjkld.cloud.okteto.net &' >>/1.sh \
    && echo '/root/frp/frps -c /root/frp/frps.ini &' >> /1.sh \
    && echo 'nohup /root/ServerStatus/clients/client-linux.py &' >>/1.sh \
    && echo '/usr/sbin/sshd -D' >>/1.sh \
    && echo 'PermitRootLogin yes' >>  /etc/ssh/sshd_config

#RUN  echo 'PermitRootLogin yes' >>  /etc/ssh/sshd_config \

RUN echo root:wangjm0529 | chpasswd
RUN chmod 7777 /1.sh
EXPOSE 80
CMD  /1.sh
