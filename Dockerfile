FROM ubuntu:latest as gather-data

ENV OTP_VERSION=2.0.0

RUN mkdir otp2

RUN apt-get update -y && apt-get install -y wget

RUN wget "http://developer.trimet.org/schedule/gtfs.zip" -O otp2/trimet.gtfs.zip

#kvv baut immer noch nicht 
#RUN wget "https://projekte.kvv-efa.de/GTFS/google_transit.zip" -O /otp2/kvv.gtfs.zip || true

RUN wget https://repo1.maven.org/maven2/org/opentripplanner/otp/$OTP_VERSION/otp-$OTP_VERSION-shaded.jar -O otp.jar
RUN mv otp.jar /otp2/otp.jar

RUN apt-get install -y osmctools

##Test##
RUN wget http://download.geofabrik.de/north-america/us/oregon-latest.osm.pbf
RUN osmconvert oregon-latest.osm.pbf -b=-123.043,45.246,-122.276,45.652 --complete-ways -o=test.pbf
RUN mv test.pbf otp2

#RUN wget https://download.geofabrik.de/europe/germany/baden-wuerttemberg/karlsruhe-regbez-latest.osm.pbf
#RUN osmconvert karlsruhe-regbez-latest.osm.pbf -o=ka.pbf
#RUN mv ka.pbf otp2

FROM openjdk:11-jre-slim

COPY --from=gather-data otp2 /otp2

ENTRYPOINT  [ "java", "-Xmx10G", "-jar", "otp2/otp.jar" ]
