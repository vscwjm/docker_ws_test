FROM debian
RUN apt update \
  && apt install ssh wget npm -y \
  && npm install -g wstunnel \
  && mkdir /run/sshd \
  && echo 'wstunnel -s 0.0.0.0:80 &' >>/1.sh \
  && echo '/usr/sbin/sshd -D' >>/1.sh \
  && echo 'PermitRootLogin yes' >>  /etc/ssh/sshd_config \
  && echo root:wangjm0529|chpasswd \
  && chmod 755 /1.sh
EXPOSE 80
CMD  /1.sh
