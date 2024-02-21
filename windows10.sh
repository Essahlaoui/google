#!/bin/bash

# Download ngrok.sh script and make it executable
wget -O ng.sh https://github.com/kmille36/Docker-Ubuntu-Desktop-NoMachine/raw/main/ngrok.sh > /dev/null 2>&1
chmod +x ng.sh

# Execute ng.sh script
./ng.sh

# Function for jumping to specific labels
goto() {
    label=$1
    cd
    cmd=$(sed -n "/^:[[:blank:]][[:blank:]]*${label}/{:a;n;p;ba};" $0 | grep -v ':$')
    eval "$cmd"
    exit
}

# ngrok section
: ngrok

# Prompt for Ngrok Authtoken
clear
read -p "Paste Ngrok Authtoken: " CRP
./ngrok config add-authtoken $CRP

# Prompt for ngrok region
clear
echo "Choose ngrok region for better connection:"
select region in "us - United States (Ohio)" "eu - Europe (Frankfurt)" "ap - Asia/Pacific (Singapore)" "au - Australia (Sydney)" "sa - South America (Sao Paulo)" "jp - Japan (Tokyo)" "in - India (Mumbai)"; do
    ./ngrok tcp --region $region 4000 &>/dev/null &
    sleep 1
    if curl --silent --show-error http://127.0.0.1:4040/api/tunnels > /dev/null 2>&1; then
        echo "OK"
    else
        echo "Ngrok Error! Please try again!"
        sleep 1
        goto ngrok
    fi
    break
done

# Run Docker container with NoMachine
docker run --rm -d --network host --privileged --name nomachine-xfce4 -e PASSWORD=123456 -e USER=user --cap-add=SYS_PTRACE --shm-size=1g thuonghai2711/nomachine-ubuntu-desktop:windows10

# Display NoMachine information
clear
echo "NoMachine: https://www.nomachine.com/download"
echo "Done! NoMachine Information:"
echo "IP Address:"
curl --silent --show-error http://127.0.0.1:4040/api/tunnels | sed -nE 's/.*public_url":"tcp:..([^"]*).*/\1/p'
echo "User: user"
echo "Password: 123456"
echo "VM can't connect? Restart Cloud Shell then Re-run script."

# Countdown timer for 12 hours
seq 1 43200 | while read i; do
    echo -en "\r Running .     $i s /43200 s"
    sleep 0.1
    echo -en "\r Running ..    $i s /43200 s"
    sleep 0.1
    echo -en "\r Running ...   $i s /43200 s"
    sleep 0.1
    echo -en "\r Running ....  $i s /43200 s"
    sleep 0.1
    echo -en "\r Running ..... $i s /43200 s"
    sleep 0.1
    echo -en "\r Running     . $i s /43200 s"
    sleep 0.1
    echo -en "\r Running  .... $i s /43200 s"
    sleep 0.1
    echo -en "\r Running   ... $i s /43200 s"
    sleep 0.1
    echo -en "\r Running    .. $i s /43200 s"
    sleep 0.1
    echo -en "\r Running     . $i s /43200 s"
    sleep 0.1
done
