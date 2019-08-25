![](https://i.goopics.net/nI.png)

### What is this ?

Rainloop is a simple, modern & fast web-based client. More details on the [official website](http://www.rainloop.net/).

### Features

- Lightweight image
- Based on Alpine
- Latest Rainloop **Community Edition** (stable)
- With Nginx and PHP7

### Build-time variables

- **GPG_FINGERPRINT** : fingerprint of signing key

### Ports

- **8888**

### Environment variables

| Variable | Description | Type | Default value |
| -------- | ----------- | ---- | ------------- |
| **UPLOAD_MAX_SIZE** | Attachment size limit | *optional* | 25M
| **LOG_TO_STDOUT** | Enable nginx and php error logs to stdout | *optional* | false
| **MEMORY_LIMIT** | PHP memory limit | *optional* | 128M

#### How to setup

When starting the container, make sure to map its /data to a persistent
directory. The Rainloop configuration will be stored there.

Rainloop offers a web-based configuration utility at `http://<host>:8888/?admin`.
