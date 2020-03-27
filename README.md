# Docker image for MATLAB license manager (lmgrd)

This repo hosts the Dockerfile for running `lmgrd` - the Matlab licenses manager. Below is the `run.sh` wrapper script you may need to edit:

```sh
#!/bin/bash

MY_HOSTNAME=#YOUR HOSTNAME HERE
MY_MAC=#YOUR MAC HERE
MY_LMGRD_PORT=27000
MY_MLM_PORT=27001

# MY_LICENSE_ROOT is where you store license files on the host
MY_LICENSE_ROOT="/etc/lmgrd/licenses"
# MY_LICENSE_FILE is license file you want to use relative to MY_LICENSE_ROOT
MY_LICENSE_FILE="matlab/license.dat"

docker run -it --rm --user nobody --hostname ${MY_HOSTNAME}         \
    --env LMGRD_PORT=${MY_LMGRD_PORT} --env MLM_PORT=${MY_MLM_PORT} \
    -p ${MY_LMGRD_PORT}:${MY_LMGRD_PORT}                            \
    -p ${MY_MLM_PORT}:${MY_MLM_PORT}                                \
    --env LM_LICENSE_FILE="/etc/lmgrd/licenses/${MY_LICENSE_FILE}"  \
    -v ${MY_LICENSE_ROOT}:"/etc/lmgrd/licenses"                     \
    -v "/usr/tmp":"/usr/tmp"                                        \
    --mac-address ${MY_MAC} butui/lmgrd

```

| Variable      | Meaning                                                      |
| ------------- | ------------------------------------------------------------ |
| `MY_HOSTNAME` | Any hostname, must match license file SERVER line. Suggest `lmgrd`. See below |
| `MY_MAC`      | The MAC address registered to Mathworks for the server. This must match. |

We chose to use `27000` and `27001` port for `lmgrd` and `MLM` by default. These values should meet the value in your license file. 

## Building a Matlab License File

Your `lmgrd` container will use a single license file. In example variables in `run.sh`, the license file would be located at `/etc/lmgrd/licenses/matlab/license.dat`. It must contain at least three lines like this:

```text
SERVER <HOSTNAME> <MAC> <LMGRD PORT>
DAEMON MLM "/lmgrd/etc/glnxa64/MLM" port=<MLM PORT>
VENDOR MLM "mlm.opt"
```

Where these variables (in `<>`) match what you supplied in the `run.sh` script. 

Next, you need to copy the contents of your Mathworks `license.lic` which you download from the "Activation Details for Matlab License Server" page. I simply put these three lines at the very top before the comments which start with `# BEGIN----`

Next, you need to copy your `mlm.opt` file next to your `license.dat` file. In example variables in `run.sh`, the mlm.opt file would be located at `/etc/lmgrd/licenses/matlab/mlm.opt`.

For further explanation, refer to the [manual](https://www.mathworks.com/matlabcentral/answers/uploaded_files/5871/LicenseAdministration.pdf).

For client who need to use this `lmgrd`, they could use a simple license file:

```text
SERVER <IP or HOSTNAME> INTERNET=<IP or HOSTNAME> 27000
USE_SERVER
```

Where `IP or HOSTNAME` is the IP address of the server running this docker image.

We've also seen success via

```txt
SERVER <IP or HOSTNAME> <MAC of container> 27000
USE_SERVER
```