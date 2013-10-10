plack: start_server --pid-file var/run/starlet.pid --port 8888 --signal-on-hup USR1 -- plackup -E deployment -s Starlet --max-workers 3 --spawn-interval 1
redis: start_server --pid-file var/run/redis.pid -- redis-server --unixsocket var/run/redis.socket --port 0
