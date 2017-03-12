# Building Manually

There are DNS problems when running containers in *Ubuntu* within the *TCD
network*. This can be resolved while on the TCD network by editing the Docker
DNS config.

```bash
$ echo '{"dns": ["134.226.251.200", "134.226.251.100"]}' | sudo tee -a /etc/docker/daemon.json
$ sudo service docker restart
```

You should revert these settings when leaving the TCD network by running

```bash
$ sudo rm /etc/docker/daemon.json
$ sudo service docker restart
```

1. Clone the Repo

 ```bash
 $ git clone https://github.com/tom-and-the-toothfairies/pathways.git
 ```

2. Build with Docker

 ```bash
 $ cd pathways
 $ sudo docker build -t tomtoothfairies/asclepius asclepius
 $ sudo docker build -t tomtoothfairies/panacea panacea
 $ sudo docker build -t tomtoothfairies/chiron chiron
 ```

3. Run the tests

 ```bash
 $ sudo docker run -t -e "MIX_ENV=test" tomtoothfairies/panacea mix test
 $ sudo docker run -t tomtoothfairies/asclepius pytest
 ```
