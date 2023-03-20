# gblan-dev-docker

これは、Docker 環境で [hiro345g/gblan](https://github.com/hiro345g/gblan) の開発をするためのものです。内部的に [hiro345g/devnode\-desktop](https://github.com/hiro345g/devnode-desktop)を使います。devnode-desktop を使うと Node.js 環境、Docker クライアント、VNC による GUI 環境が使えるコンテナーを手軽に利用できるようになります。

devnode-desktop コンテナー内から使える Docker ボリュームの devnode-desktop-node-repo-data にカスタム gblan 開発用リポジトリーを用意して開発するようにしています。


## 必要なもの

gblan を動作させるには、Docker Engine、Docker Compose が必要です。利用にあたっての説明では、Docker 拡張機能、Dev Containers 拡張機能をインストールした Visual Studio Code (VS Code) が使える前提としてあります。

### Docker

- [Docker Engine](https://docs.docker.com/engine/)
- [Docker Compose](https://docs.docker.com/compose/)

これらは [Docker Desktop](https://docs.docker.com/desktop/) をインストールしてあれば使えます。
Linux では Docker Desktop をインストールしなくても Docker Engine と Docker Compose だけをインストールして使えます。
例えば、Ubuntu を使っているなら [Install Docker Engine on Ubuntu](https://docs.docker.com/engine/install/ubuntu/) を参照してインストールしておいてください。

### Visual Studio Code

- [Visual Studio Code](https://code.visualstudio.com/)
- [Docker 拡張機能](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-docker)
- [Dev Containers 拡張機能](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)

VS Code の拡張機能である Docker と Dev Containers を VS Code へインストールしておく必要があります。

### 動作確認済みの環境

次の環境で動作確認をしてあります。Windows や macOS でも動作するはずです。

```console
$ cat /etc/os-release 
PRETTY_NAME="Ubuntu 22.04.2 LTS"
NAME="Ubuntu"
VERSION_ID="22.04"
VERSION="22.04.2 LTS (Jammy Jellyfish)"
VERSION_CODENAME=jammy
ID=ubuntu
ID_LIKE=debian
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
UBUNTU_CODENAME=jammy

$ docker version
Client: Docker Engine - Community
 Cloud integration: v1.0.31
 Version:           23.0.1
 API version:       1.42
 Go version:        go1.19.5
 Git commit:        a5ee5b1
 Built:             Thu Feb  9 19:47:01 2023
 OS/Arch:           linux/amd64
 Context:           default

Server: Docker Engine - Community
 Engine:
  Version:          23.0.1
  API version:      1.42 (minimum version 1.12)
  Go version:       go1.19.5
  Git commit:       bc3805a
  Built:            Thu Feb  9 19:47:01 2023
  OS/Arch:          linux/amd64
  Experimental:     false
 containerd:
  Version:          1.6.18
  GitCommit:        2456e983eb9e37e47538f59ea18f2043c9a73640
 runc:
  Version:          1.1.4
  GitCommit:        v1.1.4-0-g5fd4c4d
 docker-init:
  Version:          0.19.0
  GitCommit:        de40ad0

$ docker compose version
Docker Compose version v2.15.1
```

## ファイルの構成

ファイルの構成は次の通りです。

```text
${GBLAN_DEV_DIR}/
├── README.md ... このファイル
├── docker-compose.yml ... devnode-desktop 環境入手用
├── repo-gblan/ ... カスタム gblan 開発用リポジトリー作成用
│   ├── README.md
│   ├── gblan-dev.code-workspace
│   └── script/
│       ├── add_gblan_dev.sh
│       └── init_repo.sh
└── script/
    ├── copy_from_dc.sh
    ├── deploy_from_dc.sh
    ├── init.sh
    └── init2.sh
```

以降、このディレクトリーを `${GBLAN_DEV_DOCKER_DIR}` と表記します。

## 環境構築

gblan の開発環境を構築する手順は次のようになります。

1. devnode-desktop の取得
2. devnode-desktop の起動
3. 開発で使うリポジトリーの用意

ここでは VS Code を使って作業します。VS Code の画面を開き「ファイル」-「フォルダーを開く」で `${GBLAN_DEV_DOCKER_DIR}` を開きます。それから、VS Code のメニューから「ターミナル」-「新しいターミナル」でターミナルを開きます。

以降、それぞれ、「`${GBLAN_DEV_DOCKER_DIR}` の VS Code の画面」、「`${GBLAN_DEV_DOCKER_DIR}` の VS Code のターミナル」と表記します。

### devnode-desktop の取得

最初に devnode-desktop の取得をします。そのための処理が `${GBLAN_DEV_DOCKER_DIR}/docker-compose.yml` に指定してあるので、これを `Compose Up` します。すると gblan-dev-docker コンテナーが起動して devnode-desktop 取得の処理が実行されます。「`${GBLAN_DEV_DOCKER_DIR}` の VS Code の画面」の Dcoker 拡張機能の画面で gblan-dev-docker が停止したら、 `Compose Down` します。

「`${GBLAN_DEV_DOCKER_DIR}` の VS Code のターミナル」を使う場合は、`${GBLAN_DEV_DOCKER_DIR}` をカレントディレクトリーとして次のコマンドを実行します。

```console
docker compose run --rm gblan-dev-docker
```

これで、`${GBLAN_DEV_DOCKER_DIR}/devnode-desktop` に devnode-desktop がダウンロードされて使えるようになります。内部的には gblan-dev-docker コンテナー内で `sh /gblan/gblan-dev-docker/script/init.sh` が実行されます。なお、`init.sh` の実体は `${GBLAN_DEV_DOCKER_DIR}/script/init.sh` です。

### devnode-desktop の起動

取得した devnode-desktop コンテナーを Dev Container として起動します。
VS Code のメニューから起動する方法は次のようになります。

1. VS Code で「表示」-「コマンドパレット」を表示
2. 「Dev Containers: Open Folder in Container...」をクリック
3. フォルダーを選択する画面になるので `${GBLAN_DEV_DOCKER_DIR}/devnode-desktop` を指定

こうすると、`${GBLAN_DEV_DOCKER_DIR}/devnode-desktop/.devcontainer/devcontainer.json` の指定にしたがって、devnode-desktop コンテナーにアタッチした VS Code の画面が表示されます。ここでは、これ以降、この画面を「devnode-desktop コンテナーの VS Code 画面」と表現します。

なお、ターミナルを使う場合は、`${GBLAN_DEV_DOCKER_DIR}/devnode-desktop` をカレントディレクトリーとして次のコマンドを実行します。

```console
code .
```

すると、`${GBLAN_DEV_DOCKER_DIR}/devnode-desktop` ディレクトリーが VS Code で開かれて画面が表示されます。その後に、VS Code に通知が表示されるので、そこにある「Reopen in Container」というボタンをクリックします。

### gblan 開発で使うカスタマイズ用リポジトリーの用意

ここでは、devnode-desktop コンテナー内に gblan カスタマイズ用のリポジトリーを用意する方法について説明します。

開発で使うリポジトリーは、devnode-desktop コンテナー内の `devnode-desktop:/home/node/repo/gblan` に用意します。gblan リポジトリーを作成するのに必要なファイルは `${GBLAN_DEV_DOCKER_DIR}/repo-gblan` に用意してあります。これを devnode-desktop コンテナーの `devnode-desktop:/home/node/` へコピーしてから、コンテナー内で `init_repo.sh` を実行して gblan 開発で使うリポジトリーを用意します。

なお、`init_repo.sh` の内容は次のようになっています。変数の GIT_USER_NAME、GIT_USER_EMAIL は自分が使うものへ変更しておくと良いでしょう。

```sh
#!/bin/sh
REPO_GBLAN_DIR=/home/node/repo/gblan
GIT_USER_NAME=user001
GIT_USER_EMAIL=user001@example.jp

BASE_DIR=$(cd $(dirname $0)/..;pwd)

if [ -e ${REPO_GBLAN_DIR} ]; then
  echo "already exists: ${REPO_GBLAN_DIR}"
  exit 1;
fi
mkdir -p ${REPO_GBLAN_DIR}/dc
mv ${BASE_DIR}/README.md ${REPO_GBLAN_DIR}/
mv ${BASE_DIR}/gblan-dev.code-workspace ${REPO_GBLAN_DIR}/

cd ${REPO_GBLAN_DIR}
git config --global init.defaultBranch main
git init
git config user.name ${GIT_USER_NAME}
git config user.email ${GIT_USER_EMAIL}
git add .
git commit -m "init"
```

それでは、gblan 開発で使うリポジトリーを用意します。「`${GBLAN_DEV_DOCKER_DIR}` の VS Code のターミナル」で、カレントディレクトリーが `${GBLAN_DEV_DOCKER_DIR}/` となっている状態で、次のコマンドを実行します（`${GBLAN_DEV_DOCKER_DIR}/script/init2.sh` にシェルスクリプトがあるので、macOS や Linux 環境ではそちらを実行しても良いです）。

```console
docker compose -p devnode-desktop cp ./repo-gblan devnode-desktop:/home/node/
docker compose -p devnode-desktop exec devnode-desktop sh /home/node/repo-gblan/script/init_repo.sh
```

上から順に、repo-gblan を devnode-desktop コンテナーへコピー、コンテナー内で `init_repo.sh` を実行という処理をしています。

これで gblan の開発をするための基本的な環境構築ができました。後は、「カスタマイズ用リポジトリーへ gblan-dev を追加」に従って作業をします。その後の開発作業は devnode-desktop コンテナーの VS Code 画面で可能です。

## カスタマイズ用リポジトリーへ gblan-dev を追加

カスタマイズ用リポジトリーへ gblan-dev を追加するには、次の2つの方法があります。

- devnode-desktop コンテナー内で追加
- Docker ホストに gblan-dev を用意して追加

いずれも、devnode-desktop コンテナーを起動した状態で作業をします。

### devnode-desktop コンテナー内で追加

devnode-desktop コンテナー内でカスタマイズ用リポジトリーへ gblan-dev を追加するには、`add_gblan_dev.sh` スクリプトを使います。「`${GBLAN_DEV_DOCKER_DIR}` の VS Code のターミナル」で次のコマンドを実行します。

```console
sh /home/node/repo-gblan/script/add_gblan_dev.sh
```

Docker ホストの `docker compose exec` コマンドを使って同じスクリプトを実行することもできます。

```console
docker compose -p devnode-desktop exec devnode-desktop sh /home/node/repo-gblan/script/add_gblan_dev.sh
```

### Docker ホストに gblan-dev を用意して追加

<https://github.com/hiro345g/gblan> からファイルを入手するなどして、すでに Docker ホストに gblan のリポジトリーがある場合は、そこに含まれる 開発用のファイルである `${GBLAN_DIR}/gblan-dev` をコピーします。ここで、gblan のリポジトリーに対応するディレクトリーを `${GBLAN_DIR}` と表記しています。

`${GBLAN_DIR}` をカレントディレクトリーとして、`docker compose cp` コマンドで `gblan-dev` を `devnode-desktop:/home/node/repo/gblan/gblan-dev` へコピーし、リポジトリーへ登録します。

```console
cd ${GBLAN_DIR}
docker compose -p devnode-desktop cp ./gblan-dev devnode-desktop:/home/node/repo/gblan/
docker compose -p devnode-desktop exec devnode-desktop git -C /home/node/repo/gblan/ add .
docker compose -p devnode-desktop exec devnode-desktop git -C /home/node/repo/gblan/ commit -m "add gblan-dev"
```

## gblan のビルド

gblan-dev-docker で用意した環境を使うと、devnode-desktop コンテナー内で gblan のビルドもできます。Docker ホストが Linux の場合は、直接 gblan のビルドが確実にできますが、Windows や macOS の場合は、devnode-desktop コンテナーを使うのが確実です。デフォルトの環境で良いのであれば、`devnode-desktop:/home/node/repo/gblan/dc/gblan/build_dc/script/build.sh` にあるビルドスクリプトを devnode-desktop コンテナー内で実行するだけです。

devnode-desktop コンテナーを起動した状態で、Docker ホストで次のようにコマンドを実行します。

```console
docker compose -p devnode-desktop exec devnode-desktop sh /home/node/repo/gblan/dc/gblan/build_dc/script/build.sh
```

なお、devnode-desktop コンテナー内でコマンドを実行する場合は `docker compose -p devnode-desktop exec devnode-desktop` の部分は不要です。以降の説明で出てくるコマンドについても同様です。

```console
sh /home/node/repo/gblan/dc/gblan/build_dc/script/build.sh
```

環境をカスタマイズしたい場合は、devnode-desktop コンテナー内で `devnode-desktop:/home/node/repo/gblan/dc/gblan/build_dc/` 内のファイルを編集してからビルドします。

作成した Docker イメージ、Docker ボリューム、Docker ネットワークを削除するには、次のようにします。

```console
docker compose -p devnode-desktop exec devnode-desktop sh /home/node/repo/gblan/dc/gblan/build_dc/script/clean.sh
docker compose -p devnode-desktop exec devnode-desktop sh /home/node/repo/gblan/dc/gblan/build_dc/script/clean_sample.sh
```

## その他

`${GBLAN_DEV_DOCKER_DIR}/script/copy_from_dc.sh`、`${GBLAN_DEV_DOCKER_DIR}/script/deploy_from_dc.sh` は、手元で開発をしているときに使用したスクリプトです。 gblan-dev-docker で用意した `devnode-desktop:/home/node/repo/gblan` のファイルを `${GBLAN_DIR}` へ反映するためのものです。ファイル構成は次のようになっている前提でのスクリプトになっています。

```text
├── ${GBLAN_DIR}/
└── ${GBLAN_DEV_DOCKER_DIR}/
```
