# Elasticsearch backup and restore

### Prerequisites
- elasticdump

### Install Node.js and npm

```sh
curl -fsSL  https://deb.nodesource.com/setup_18.x | bash -
apt-get install -y nodejs
```

### Install elasticdump

```sh
npm install elasticdump -g
```

### Run the backup script

```
bash backup.sh
```

### Run the restore script

```
bash restore.sh
```
