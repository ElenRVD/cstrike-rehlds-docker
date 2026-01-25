FROM cm2network/steamcmd
# Задаем переменные окружения
ENV SERVER_IP=0.0.0.0
ENV SERVER_PORT=27015
ENV SERVER_MAXPLAYERS=20
ENV SERVER_MAP=de_dust2
ENV SERVER_HOSTNAME="CS 1.6 Docker Server"
ENV SERVER_RCON_PASSWORD=changeme
ENV SERVER_PASSWORD=""
# Переключаемся на пользователя steam
USER steam
# Скачиваем базовый HLDS через SteamCMD
RUN ./steamcmd.sh +login anonymous +force_install_dir /home/steam/server/hlds +app_update 90 -beta steam_legacy validate +quit
# Подключаем Metamod-R
RUN sed -i 's|gamedll_linux "dlls/cs.so"|gamedll_linux "addons/metamod/metamod_i386.so"|g' cstrike/liblist.gam
# Копируем конфигурационные файлы с правами steam
COPY --chown=steam:steam hlds/ /home/steam/server/hlds/
# Устанавливаем рабочую директорию
WORKDIR /home/steam/server/hlds
# Экспортируем порты
EXPOSE ${SERVER_PORT}/tcp ${SERVER_PORT}/udp
# Команда запуска
CMD exec ./hlds_run -game cstrike \
    +ip ${SERVER_IP} \
    +port ${SERVER_PORT} \
    +maxplayers ${SERVER_MAXPLAYERS} \
    +map ${SERVER_MAP} \
    +hostname "${SERVER_HOSTNAME}" \
    +rcon_password ${SERVER_RCON_PASSWORD} \
    +sv_password "${SERVER_PASSWORD}" \
    +sys_ticrate 1000 \
    +secure 0 \
    +sv_oldphys 1 \
    +sv_allow_upload 0 \
    +log on \
    +mp_logecho 1