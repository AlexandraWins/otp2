FROM ubuntu:latest as gather-data

ENV OTP_VERSION=2.0.0

RUN mkdir otp2

RUN apt-get update -y && apt-get install -y wget

RUN wget "http://developer.trimet.org/schedule/gtfs.zip" -O otp2/trimet.gtfs.zip

#kvv baut immer noch nicht 
#RUN wget "https://projekte.kvv-efa.de/GTFS/google_transit.zip" -O /otp2/kvv.gtfs.zip || true
#RUN wget "https://www.nvbw.de/fileadmin/user_upload/service/open_data/fahrplandaten_mit_liniennetz/hnv.zip" -O otp2/nvbw_hnn.gtfs.zip || true
#RUN wget "https://www.nvbw.de/fileadmin/user_upload/service/open_data/fahrplandaten-mit-liniennetz/vpe.zip" -O otp2/nvbw_vpe.gtfs.zip || true
#RUN wget "https://www.openvvs.de/dataset/e66f03e4-79f2-41d0-90f1-166ca609e491/resource/bfbb59c7-767c-4bca-bbb2-d8d32a3e0378/download/google_transit.zip" -O otp2/google_transit.gtf$
#RUN wget "https://www.nvbw.de/fileadmin/user_upload/service/open_data/fahrplandaten_mit_liniennetz/vgc.zip" -O otp2/nvbw_vgc.gtfs.zip || true
#RUN wget "https://www.nvbw.de/fileadmin/user_upload/service/open_data/fahrplandaten_mit_liniennetz/oam.zip" -O otp2/nvbw_oam.gtfs.zip || true
#RUN wget "https://www.nvbw.de/fileadmin/user_upload/service/open_data/fahrplandaten_mit_liniennetz/filsland.zip" -O otp2/nvbw_filsland.gtfs.zip || true
#RUN wget "https://www.nvbw.de/fileadmin/user_upload/service/open_data/fahrplandaten_mit_liniennetz/ding.zip" -O otp2/nvbw_ding.gtfs.zip || true
#RUN wget "https://www.nvbw.de/fileadmin/user_upload/service/open_data/fahrplandaten_mit_liniennetz/bodo.zip" -O otp2/nvbw_bodo.gtfs.zip || true
#RUN wget "https://www.nvbw.de/fileadmin/user_upload/service/open_data/fahrplandaten_mit_liniennetz/naldo.zip" - O otp2/nvbw_naldo.gtfs.zip || true
#RUN wget "https://www.nvbw.de/fileadmin/user_upload/service/open_data/fahrplandaten_mit_liniennetz/vhb.zip" -O otp2/nvbw_vhb.gtfs.zip || true
#RUN wget "https://www.nvbw.de/fileadmin/user_upload/service/open_data/fahrplandaten_mit_liniennetz/tuticket.zip" -O otp2/nvbw_tuticket.gtfs.zip || true
#RUN wget "https://www.nvbw.de/fileadmin/user_upload/service/open_data/fahrplandaten_mit_liniennetz/tgo.zip" -O otp2/nvbw_tgo.gtfs.zip || true
#RUN wget "https://www.nvbw.de/fileadmin/user_upload/service/open_data/fahrplandaten_mit_liniennetz/vgf.zip" -O otp2/nvbw_vgf.gtfs.zip || true
#RUN wget "https://www.mobidata-bw.de/dataset/rexer-mitlinienverlauf-gtfs" -O otp2/mobidata_rexer.gtfs.zip || true
#RUN wget "https://www.nvbw.de/fileadmin/user_upload/service/open_data/fahrplandaten_mit_liniennetz/swhn.zip" -O otp2/nvwb_swhn.gtfs.zip || true
#RUN wget "https://www.nvbw.de/fileadmin/user_upload/service/open_data/fahrplandaten_mit_liniennetz/sweg.zip" -O otp2/nvwb_sweg.gtfs.zip || true
#RUN wget "https://www.nvbw.de/fileadmin/user_upload/service/open_data/fahrplandaten_mit_liniennetz/sbg.zip" - O otp2/nvwb_sbg.gtfs.zip || true
#RUN wget "https://www.nvbw.de/fileadmin/user_upload/service/open_data/fahrplandaten_mit_liniennetz/rvs.zip" -O otp2/nvwb_rvs.gtfs.zip || true
#RUN wget "https://www.mobidata-bw.de/dataset/rab-gtfs-mitlinienverlauf" - O otp2/mobidata_rab.gtfs.zip || true
#RUN wget "https://www.nvbw.de/fileadmin/user_upload/service/open_data/fahrplandaten_mit_liniennetz/vpe.zip" -O otp2/nvbw_vpe.gtfs.zip || true
#RUN wget "https://www.nvbw.de/fileadmin/user_upload/service/open_data/fahrplandaten_ohne_liniennetz/rbs.zip" -O otp2/nvbw_rbs.gtfs.zip || true
#RUN wget "https://api.idbus.com/gtfs.zip" -O otp2/idbus.gtfs.zip || true
#RUN wget "http://data.ndovloket.nl/flixbus/flixbus-eu.zip" -O otp2/flixbus.gtfs.zip || true

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

RUN mkdir otp

COPY --from=gather-data otp2 /otp2

ENTRYPOINT  [ "java", "-Xmx10G", "-jar", "otp2/otp.jar" ]
