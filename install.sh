#!/usr/bin/env bash
set -euo pipefail

log() { echo "[INFO] $*"; }

require_root() {
    if [ "$EUID" -ne 0 ]; then
        log "This script must be run as root"
        exit 1
    fi
}

detect_distro() {
    if [ ! -f /etc/os-release ]; then
        log "/etc/os-release not found – cannot detect distribution"
        exit 1
    fi
    . /etc/os-release
    DISTRO="$ID"
    PRETTY_NAME="$PRETTY_NAME"
}

install_docker_ubuntu_debian() {
    apt-get update
    apt-get install -y apt-transport-https ca-certificates curl software-properties-common gnupg
    curl -fsSL "https://download.docker.com/linux/$DISTRO/gpg" | apt-key add -
    add-apt-repository \
      "deb [arch=$(dpkg --print-architecture)] https://download.docker.com/linux/$DISTRO \
      $(lsb_release -cs) stable"
    apt-get update
    apt-get install -y docker-ce
}

install_docker_centos() {
    yum install -y yum-utils device-mapper-persistent-data lvm2
    yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
    yum install -y docker-ce
}

install_docker_fedora() {
    dnf -y install dnf-plugins-core
    dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
    dnf install -y docker-ce
}

install_docker() {
    log "Installing Docker on $PRETTY_NAME"
    case "$DISTRO" in
        ubuntu|debian) install_docker_ubuntu_debian ;;
        centos)       install_docker_centos     ;;
        fedora)       install_docker_fedora     ;;
        *)
            log "Distribution $DISTRO is not supported"
            exit 1
            ;;
    esac
}

start_docker_service() {
    systemctl enable docker
    systemctl start docker
}

install_docker_compose() {
    COMPOSE_VER=$(curl -s https://api.github.com/repos/docker/compose/releases/latest \
      | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
    curl -L \
      "https://github.com/docker/compose/releases/download/$COMPOSE_VER/docker-compose-$(uname -s)-$(uname -m)" \
      -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
}

main() {
    require_root
    detect_distro

    if command -v docker &>/dev/null; then
        log "Docker already installed: $(docker --version)"
    else
        install_docker
        start_docker_service
        log "Installed Docker: $(docker --version)"
    fi

    if command -v docker-compose &>/dev/null; then
        log "Docker Compose already installed: $(docker-compose --version)"
    else
        log "Installing Docker Compose"
        install_docker_compose
        log "Installed Docker Compose: $(docker-compose --version)"
    fi
}

main "$@"
