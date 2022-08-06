## Установка podman на Debian 11

Настройки **Podman** в режиме совместимости с `docker compose`:
  - Версия **Podman** должна быть не ниже 3.2.0 (Для дистрибутива **Debian** нужно переключитсья на ветку не ниже `bookworm`)
  - Понадобится скрипт [Podman-compose](https://github.com/containers/podman-compose): `pip3 install podman-compose`
  - Активировать демона
    - Для **root*  режима: `sudo systemctl enable podman.socket && sudo systemctl start podman.socket && sudo systemctl status podman.socket`
    - Для **root-less* режима: `systemctl --user enable podman.socket && systemctl --user start podman.socket && systemctl --user status podman.socket`
  - Для **root-less** режима перенаправить **docker** на хост **podman**: `export DOCKER_HOST=unix:///run/user/$UID/podman/podman.sock`

Для загрузки в **Podman** образов из **DockerHub** в адреса нужно добавлять `docker.io/` (Также предварительно нужно авторизоваться `podman login docker.io`).

При появлении сообщений `User-selected graph driver “overlay” overwritten by graph driver “vfs” from database` нужно удалить директорию `rm -rf /home/userName/.local/share/containers/storage/libpod`

Проверка функционирования связки **docker-podman**: `sudo curl -H "Content-Type: application/json" --unix-socket /var/run/docker.sock http://localhost/_ping`
