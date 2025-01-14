FROM ubuntu:bionic

RUN apt update -y && \
  apt install -y gdb curl libc++-dev lib32gcc1 && \
  rm -rf /var/lib/apt/lists/*
RUN useradd -m steam
WORKDIR /home/steam/Steam
RUN curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf -
RUN chmod +x steamcmd.sh
RUN chown -R steam:steam /home/steam

USER steam
RUN ./steamcmd.sh +force_install_dir /home/steam/pavlovserver +login anonymous +app_update 622970 +exit
RUN chmod +x /home/steam/pavlovserver/PavlovServer.sh
RUN mkdir -p /home/steam/pavlovserver/Pavlov/Saved/Config/LinuxServer

WORKDIR /home/steam
COPY --chown=steam:steam start.sh .
RUN chmod +x start.sh

ENTRYPOINT ["./start.sh"]
