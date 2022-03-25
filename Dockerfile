FROM debian
COPY frps.ini /root/
RUN apt update
RUN apt install ssh wget npm sudo net-tools vim -y
RUN npm install -g wstunnel
RUN wget -P /root/ https://github.com/erebe/wstunnel/releases/download/v4.1/wstunnel-x64-linux \
    && chmod a+x /root/wstunnel-x64-linux
RUN rm -rf /root/frp_0.39.1_linux_amd64 \
	&& wget --no-check-certificate -qO '/root/frp.tar.gz' "https://github.com/fatedier/frp/releases/download/v0.39.1/frp_0.39.1_linux_amd64.tar.gz" \
	&& tar -zxf /root/frp.tar.gz -C /root \
	&& mv /root/frp_0.39.1_linux_amd64 /root/frp \
	&& mv /root/frps.ini /root/frp/frps.ini
RUN mkdir /run/sshd 
RUN echo '/root/wstunnel-x64-linux --server  ws://0.0.0.0:80 &' >>/1.sh \
    && echo '/root/frp/frps &' >> /1.sh \
    && echo '/usr/sbin/sshd -D' >>/1.sh \
    && echo 'PermitRootLogin yes' >>  /etc/ssh/sshd_config
RUN echo root:wangjm0529 | chpasswd
RUN chmod 7777 /1.sh
EXPOSE 80
CMD  /1.sh
