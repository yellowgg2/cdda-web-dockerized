FROM ubuntu:20.04
ENV TZ 'Asia/Seoul'
RUN echo $TZ > /etc/timezone && \
	ln -snf /usr/share/zoneinfo/$TZ /etc/localtime

RUN apt update && apt install -y vim python3.9 git && \
	apt install libncurses5-dev libncursesw5-dev astyle libsdl2-dev libsdl2-ttf-dev libsdl2-image-dev libsdl2-mixer-dev libfreetype6-dev build-essential jq -y && \
	DEBIAN_FRONTEND=noninteractive apt install -y tzdata && \
	dpkg-reconfigure -f noninteractive tzdata && \
	apt clean

RUN mkdir -p /cdda

WORKDIR /cdda

RUN git clone https://github.com/emscripten-core/emsdk.git

WORKDIR /cdda/emsdk

RUN ./emsdk install latest && ./emsdk activate latest

WORKDIR /cdda

RUN git clone https://github.com/yellowgg2/cdda-web.git

WORKDIR /cdda/cdda-web

RUN cd /cdda/emsdk && . ./emsdk_env.sh && cd /cdda/cdda-web && ./build-scripts/prepare-web-data.sh && ./build-scripts/build-emscripten.sh

COPY entry-point.sh /cdda/entry-point.sh

RUN chmod +x /cdda/entry-point.sh

CMD ["/cdda/entry-point.sh"]