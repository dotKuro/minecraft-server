FROM alpine:3.18.0 as build

ARG MC_REV='1.19.4'
ARG BUILD_TOOLS_URL='https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar'

ENV MIN_MEMORY_G=1
ENV MAX_MEMORY_G=2

RUN apk add openjdk17 git
RUN mkdir /build
WORKDIR /build
RUN wget ${BUILD_TOOLS_URL}
RUN java -jar BuildTools.jar --rev ${MC_REV}
RUN mv ./spigot-${MC_REV}.jar ./spigot.jar

FROM alpine:3.18.0
LABEL org.opencontainers.image.source https://github.com/dotkuro/minecraft-server

RUN apk add openjdk17
RUN mkdir -p /server/data
WORKDIR /server/data
COPY --from=build /build/spigot.jar /server

CMD ["sh", "-c", "java -Xms${MIN_MEMORY_G}G -Xmx${MAX_MEMORY_G}G -jar /server/spigot.jar --nogui"]