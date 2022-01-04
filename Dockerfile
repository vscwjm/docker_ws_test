FROM debian
RUN apt update
RUN apt install ssh wget npm sudo -y
RUN  npm install -g wstunnel
RUN mkdir /run/sshd 
RUN echo 'wstunnel -s 0.0.0.0:80 &' >>/1.sh
RUN echo '/usr/sbin/sshd -D' >>/1.sh
RUN echo 'PermitRootLogin yes' >>  /etc/ssh/sshd_config 
RUN echo root:uncleluo | chpasswd
RUN useradd wjm
RUN echo wjm:wjmwjmwjm | chpasswd
RUN chmod 7777 /1.sh
EXPOSE 80
CMD  /1.sh
