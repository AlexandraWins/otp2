FROM ubuntu:latest as gather-data

ENV OTP_VERSION=2.0.0

RUN mkdir otp2

RUN apt-get update -y && apt-get install -y wget

RUN wget "https://projekte.kvv-efa.de/GTFS/google_transit.zip" -O /otp2/kvv.gtfs.zip || true

RUN wget https://repo1.maven.org/maven2/org/opentripplanner/otp/$OTP_VERSION/otp-$OTP_VERSION-shaded.jar -O otp.jar
RUN mv otp.jar /otp2/otp.jar

RUN apt-get install -y osmctools

RUN wget https://download.geofabrik.de/europe/germany/baden-wuerttemberg/karlsruhe-regbez-latest.osm.pbf
RUN osmconvert karlsruhe-regbez-latest.osm.pbf -o=ka.pbf
RUN mv ka.pbf otp2

FROM openjdk:11-jre-slim

ENV TZ=Europe/Berlin
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

COPY --from=gather-data otp2 /otp2

ENTRYPOINT  [ "java", "-Xmx10G", "-jar", "otp2/otp.jar" ]
