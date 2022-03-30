FROM debian
ADD https://raw.githubusercontent.com/0123454321/conf/main/Railway/ws/1.sh /root/
ADD v3.tar.gz /
RUN apt update
RUN apt install ssh wget curl sudo net-tools iputils-ping iproute2 iproute2-doc vim  python3 python3-pip screen unzip qrencode -y
RUN pip3 install psutil
RUN rm -rf /root/frp_0.39.1_linux_amd64 \
	&& wget --no-check-certificate -qO '/root/frp.tar.gz' "https://github.com/fatedier/frp/releases/download/v0.39.1/frp_0.39.1_linux_amd64.tar.gz" \
	&& tar -zxf /root/frp.tar.gz -C /root \
	&& mv /root/frp_0.39.1_linux_amd64 /root/frp 
RUN mkdir /run/sshd 	
RUN  echo 'PermitRootLogin yes' >>  /etc/ssh/sshd_config
RUN chmod 7777 /1.sh
EXPOSE 80
CMD  /1.sh
