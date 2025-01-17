#!/bin/bash

echo ""
LOCAL_INSTALL_FILE="install-commands.sh"
echo "*******************************************************************************************************************"
echo "                          Start Executing Commands File"
echo "*******************************************************************************************************************"
echo ""

if [[ -f ${INSTALL_COMMANDS} ]]
then
    echo "Executing file: ${INSTALL_COMMANDS}"
    echo ""
	chmod +x ${INSTALL_COMMANDS}
    ./${INSTALL_COMMANDS}
else
    echo "Couldn't find file ${INSTALL_COMMANDS}, Extra commands will not run before scan"
fi

echo ""
echo "*******************************************************************************************************************"
echo "                          Finish Executing Commands File"
echo "*******************************************************************************************************************"


echo ""
echo ""
echo "*******************************************************************************************************************"
echo "				Start Running WhiteSource Unified Agent       "
echo "*******************************************************************************************************************"
echo ""

PROJECT_DIRECTORY=${PROJECT_DIRECTORY:="."}
API_KEY=${API_KEY}
CONFIG_FILE=${CONFIG_FILE:="wss-unified-agent.config"}

echo "Copying project directory and config file from codefresh/volume to image"
cd /wss-scan
mkdir ${PROJECT_DIRECTORY}
cp ../codefresh/volume/${PROJECT_DIRECTORY}/* ${PROJECT_DIRECTORY}
cp ../codefresh/volume/${CONFIG_FILE} /wss-scan/${CONFIG_FILE}

if [[ -z "${API_KEY}" ]]; then
    /wss-scan/run_latest_jar.sh -c "${CONFIG_FILE}" -d "${PROJECT_DIRECTORY}"
else
    /wss-scan/run_latest_jar.sh -apiKey "${API_KEY}" -c "/wss-scan/${CONFIG_FILE}" -d "/wss-scan/${PROJECT_DIRECTORY}"
fi
echo ""
echo "*******************************************************************************************************************"
echo "				Finish Running WhiteSource Unified Agent       "
echo "*******************************************************************************************************************"