FROM ubuntu:20.04
ENV TZ 'Asia/Seoul'
RUN echo "Asia/Seoul" > /etc/timezone && \ 
	apt update && apt install -y vim python3 git && \
	apt install libncurses5-dev libncursesw5-dev astyle libsdl2-dev libsdl2-ttf-dev libsdl2-image-dev libsdl2-mixer-dev libfreetype6-dev build-essential jq -y && \
	ln -snf /usr/share/zoneinfo/Asia/Seoul /etc/localtime && \ 
	DEBIAN_FRONTEND=noninteractive apt install -y tzdata && \
	dpkg-reconfigure -f noninteractive tzdata && \ 
	apt clean

RUN mkdir -p /cdda

WORKDIR /cdda

RUN git clone https://github.com/emscripten-core/emsdk.git
RUN cd emsdk && ./emsdk install latest && ./emsdk activate latest && source ./emsdk_env.sh

RUN git clone https://github.com/yellowgg2/cdda-web.git

WORKDIR /cdda/cdda-web

RUN ./build-scripts/prepare-web-data.sh && ./build-scripts/build-emscripten.sh

COPY entry-point.sh .

RUN chmod +x /cdda/entry-point.sh

CMD ["/cdda/entry-point.sh"]