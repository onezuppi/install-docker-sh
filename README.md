# install-docker-sh 🚀

Universal Bash script to automatically deploy Docker and Docker Compose on major Linux distributions.

## 📦 Supported Distributions

- Ubuntu / Debian
- CentOS
- Fedora

## ⚙️ Requirements

- Bash
- Root privileges or ability to use `sudo`

## 📥 Installation & Usage

### 🔄 1. Clone the repository

```bash
📥 git clone https://github.com/onezuppi/install-docker-sh.git
cd install-docker-sh
chmod +x install-docker.sh      # if needed
sudo ./install-docker.sh
```

### ⚡️ 2. Quick install (no clone)

#### With `curl`:

```bash
curl -fsSL https://raw.githubusercontent.com/onezuppi/install-docker-sh/main/install-docker.sh \
  | sudo bash
```

#### With `wget`:

```bash
wget -qO- https://raw.githubusercontent.com/onezuppi/install-docker-sh/main/install-docker.sh \
  | sudo bash
```

## ✅ Verify Installation

```bash
docker --version
docker-compose --version
```

## 🔗 Repository

https://github.com/onezuppi/install-docker-sh

## 📄 License

MIT  

