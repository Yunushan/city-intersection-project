# Webserver Switching

Default webserver is nginx `1.18`.

```bash
python3 scripts/configure.py --webserver nginx
python3 scripts/configure.py --webserver apache-httpd
python3 scripts/configure.py --webserver apache-tomcat
python3 scripts/configure.py --webserver traefik
make deploy
```

Profiles are in `config/webservers.yaml` and `helm/city-intersection-platform/values.yaml`.
