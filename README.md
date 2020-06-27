# docker-fluentd-logging

## Why
As a Developer,
I want to forward all my logs to fluentd,
In order to centralize them.

## How

### Build a sample server

We need a sample server that can produce logs. This example is written in go.
```bash
$ docker build -t alextanhongpin/go-fluent
```

### Run the docker-compose

The docker-compose contains two services:
1. the go server, dockerized
2. the official fluentd docker container

The `golang` server will forward the logs to the `fluentd` through the driver.

Run the docker-compose:
```bash
$ docker-compose up -d
```

Verify the services running:

```bash
$ docker ps -a
```

Output:

```bash
CONTAINER ID        IMAGE                        COMMAND                  CREATED             STATUS              PORTS                                                              NAMES
9b41b868ecd2        alextanhongpin/go-fluent     "./app"                  46 seconds ago      Up 44 seconds       127.0.0.1:8080->8080/tcp                                           fluentd-starter_server_1
8278e740f9e3        fluent/fluentd:v1.11.0-1.0   "tini -- /bin/entryp…"   2 minutes ago       Up 2 minutes        5140/tcp, 127.0.0.1:24224->24224/tcp, 127.0.0.1:24224->24224/udp   fluentd-starter_fluentd_1
```

Call the endpoint to produce logs:

```bash
$ curl localhost:8080
```

Output:
```
hello world
```

Check fluentd logs (**827** is the short id of the container):
```bash
$ docker logs 827
```

You should see the `hello world <timestamp>` from our golang handler appearing in the logs.

Output:
```bash
2020-06-27 04:24:15 +0000 [info]: parsing config file is succeeded path="/fluentd/etc/fluentd.conf"
2020-06-27 04:24:15 +0000 [info]: gem 'fluentd' version '1.11.0'
2020-06-27 04:24:15 +0000 [info]: using configuration file: <ROOT>
  <source>
    @type forward
  </source>
  <match *>
    @type stdout
  </match>
</ROOT>
2020-06-27 04:24:15 +0000 [info]: starting fluentd-1.11.0 pid=7 ruby="2.5.8"
2020-06-27 04:24:15 +0000 [info]: spawn command to main:  cmdline=["/usr/bin/ruby", "-Eascii-8bit:ascii-8bit", "/usr/bin/fluentd", "-c", "/fluentd/etc/fluentd.conf", "-p", "/fluentd/plugins", "--under-supervisor"]
2020-06-27 04:24:15 +0000 [info]: adding match pattern="*" type="stdout"
2020-06-27 04:24:15 +0000 [info]: adding source type="forward"
2020-06-27 04:24:15 +0000 [info]: #0 starting fluentd worker pid=21 ppid=7 worker=0
2020-06-27 04:24:15 +0000 [info]: #0 listening port port=24224 bind="0.0.0.0"
2020-06-27 04:24:15 +0000 [info]: #0 fluentd worker is now running worker=0
2020-06-27 04:25:19.000000000 +0000 f11065903cac: {"container_id":"f11065903cac1fc0789dacaf47e286c94246de90578953e4f610cf07963b06b1","container_name":"/fluentd-starter_server_1","source":"stderr","log":"2020/06/27 04:25:19 listening to port *:8080. press ctrl + c to cancel"}
2020-06-27 04:26:01.000000000 +0000 9b41b868ecd2: {"container_name":"/fluentd-starter_server_1","source":"stderr","log":"2020/06/27 04:26:01 listening to port *:8080. press ctrl + c to cancel","container_id":"9b41b868ecd2b3b5b5325eb07c9271ebc7017b85bb1a6160de632816232bac83"}
2020-06-27 04:26:06.000000000 +0000 9b41b868ecd2: {"container_name":"/fluentd-starter_server_1","source":"stderr","log":"2020/06/27 04:26:06 hello world 2020-06-27 04:26:06.6233777 +0000 UTC m=+5.161164901","container_id":"9b41b868ecd2b3b5b5325eb07c9271ebc7017b85bb1a6160de632816232bac83"}
2020-06-27 04:26:08.000000000 +0000 9b41b868ecd2: {"container_id":"9b41b868ecd2b3b5b5325eb07c9271ebc7017b85bb1a6160de632816232bac83","container_name":"/fluentd-starter_server_1","source":"stderr","log":"2020/06/27 04:26:08 hello world 2020-06-27 04:26:08.049848 +0000 UTC m=+6.587638301"}
2020-06-27 04:28:03.000000000 +0000 9b41b868ecd2: {"source":"stderr","log":"2020/06/27 04:28:03 hello world 2020-06-27 04:28:03.4928536 +0000 UTC m=+122.134394801","container_id":"9b41b868ecd2b3b5b5325eb07c9271ebc7017b85bb1a6160de632816232bac83","container_name":"/fluentd-starter_server_1"}
```
