FROM debian:jessie-slim as builder
ARG DEBIAN_FRONTEND=noninteractive

# lmgrd bin files download from MATLAB website comes with wrong interpreter
# we do manual patch here
RUN apt update && apt install wget unzip patchelf -y && mkdir /lmgrd \
	&& cd /lmgrd && wget http://ssd.mathworks.com/supportfiles/downloads/R2019b/license_manager/R2019b/daemons/glnxa64/mathworks_network_license_manager_glnxa64.zip \
	&& unzip mathworks_network_license_manager_glnxa64.zip \
	&& for file in $(ls etc/glnxa64); do patchelf --set-interpreter /lib64/ld-linux-x86-64.so.2 etc/glnxa64/${file}; done \
	&& rm -vf mathworks_network_license_manager_glnxa64.zip

FROM debian:jessie-slim
COPY --from=builder /lmgrd /lmgrd

ENTRYPOINT ["env", "/lmgrd/etc/glnxa64/lmgrd", "-z"]
