FROM ubuntu:latest
LABEL maintainer="Christopher Reed <mail@seeread.info>"

# COPY . /app

RUN apt-get update -q && \
	export DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y --no-install-recommends tzdata

RUN dpkg-reconfigure -f noninteractive tzdata
RUN apt-get update -q && \
	export DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y --no-install-recommends sudo curl git-core gnupg wget vim fish && \
    apt-get install -y --no-install-recommends wget curl rsync netcat mg vim bzip2 zip unzip && \
    apt-get install -y --no-install-recommends libx11-6 libxcb1 libxau6 && \
    apt-get install -y --no-install-recommends lxde tightvncserver xvfb dbus-x11 x11-utils && \
    apt-get install -y --no-install-recommends xfonts-base xfonts-75dpi xfonts-100dpi && \
    apt-get install -y --no-install-recommends python-pip python-dev python-qt4 && \
    apt-get install -y --no-install-recommends libssl-dev && \
    apt-get autoclean -y && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*


RUN adduser --quiet --disabled-password --shell /bin/fish --home /home/devuser --gecos "User" devuser  && \
    echo "devuser:p@ssword1" | chpasswd &&  usermod -aG sudo devuser

USER devuser
ENV TERM xterm
ENV USER devuser

WORKDIR /home/devuser

RUN mkdir -p .vnc
COPY xstartup .vnc/
#RUN chmod a+x .vnc/xstartup
RUN touch .vnc/passwd
RUN /bin/bash -c "echo -e 'password\npassword\nn' | vncpasswd" > .vnc/passwd
RUN chmod 400 .vnc/passwd
RUN chmod go-rwx .vnc
RUN touch .Xauthority

COPY start-vncserver.sh ./

USER root
RUN echo "mycontainer" > /etc/hostname
RUN echo "127.0.0.1	localhost" >> /etc/hosts
RUN echo "127.0.0.1	mycontainer" >> /etc/hosts

USER devuser
EXPOSE 5901
CMD [ "./start-vncserver.sh" ]
