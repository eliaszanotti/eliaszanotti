#!/bin/bash

install_packages() {
    echo -e "\e[32mInstalling packages...\e[0m"
    sudo apt-get update
    sudo apt-get install autojump filezilla git terminator vim zsh nodejs npm
}

install_code() {
    echo -e "\e[32mInstalling VS Code...\e[0m"
    wget -qO- "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64" -O vscode.deb
    sudo apt-get install ./vscode.deb
    rm vscode.deb
}

install_docker() {
	echo -e "\e[32mInstalling Docker...\e[0m"
    for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done

    sudo apt-get update
    sudo apt-get install ca-certificates curl
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
        $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
        sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update

    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

    sudo groupadd docker
    sudo usermod -aG docker $USER
}

install_kvm() {
    echo -e "\e[32mInstalling KVM...\e[0m"
    sudo apt-get install qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils virtinst virt-manager
    sudo apt-get install virtiofsd
    sudo apt-get install spice-vdagent spice-webdavd

    sudo systemctl enable libvirtd
    sudo systemctl start libvirtd

    sudo usermod -aG libvirt $USER
    sudo usermod -aG kvm $USER
}

if [ $# -eq 0 ]; then
    install_packages
    install_code
    install_docker
    install_kvm
else
    for arg in "$@"
    do
        case "$arg" in
            --packages)
                install_packages
                ;;
            --code)
                install_code
                ;;
            --docker)
                install_docker
                ;;
            --kvm)
                install_kvm
                ;;
            *)
                echo "Usage: $0 {--packages|--code|--docker|--kvm}"
                exit 1
                ;;
        esac
    done
fi
