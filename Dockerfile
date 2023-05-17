FROM alpine:3.18.0 as build

ARG MC_REV='1.19.4'
ARG BUILD_TOOLS_URL='https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar'

RUN apk add openjdk17 git
RUN mkdir /build
WORKDIR /build
RUN wget ${BUILD_TOOLS_URL}
RUN java -jar BuildTools.jar --rev ${MC_REV}
RUN mv ./spigot-${MC_REV}.jar ./spigot.jar

FROM alpine:3.18.0

RUN apk add openjdk17
RUN mkdir /server
WORKDIR /server
COPY --from=build /build/spigot.jar .

CMD ["java", "-jar", "spigot.jar", "--nogui"]