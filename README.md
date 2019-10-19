# Docker image for MATLAB license manager (lmgrd)

This repo hosts the Dockerfile for running lmgrd. To run a container:

```shell
docker run -itd --user nobody --hostname HOSTNAME --env LMGRD_PORT=27000 --env MLM_PORT=27001 -p 27000:27000 -p 27001:27001 -v LICENSEDIR:/etc/lmgrd/licenses --mac-address MAC butui/lmgrd
```

where `HOSTNAME` is the hostname of the container, MAC is the MAC address of the container. And this Docker image use `27000` and `27001` port for `lmgrd` and `MLM` by default. You could modify these ports by setting the environment variable `LMGRD_PORT` and `MLM_PORT` without manual modify the `Dockerfile` or the license file. These values should meet the value in your license file. Your license file should contain two lines like this:

```text
SERVER lmgrd 486775754811 27000
DAEMON MLM "/lmgrd/etc/glnxa64/MLM" port=27001
```

For further explanation, refer to the [manual](https://www.mathworks.com/matlabcentral/answers/uploaded_files/5871/LicenseAdministration.pdf). `LICENSEDIR` is where you store your license manager. You could easily update the license file without rebuild the Docker image. You might need to restart the Docker container if needed.

For client who need to use this lmgrd, they could use a simple license file:

```text
SERVER 192.168.99.10 INTERNET=192.168.99.10 27000
USE_SERVER
```

