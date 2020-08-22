# Transmission BT 3.00 for Ubuntu 20.04

## Information
This builds the latest version of Transmission BT on Ubuntu 20.04. It requires libevent so I compile that as an included dependency. Everything gets installed to `/opt`

Wherever you run this command from you will get debian package to install on at least 20.04, other versions may work though I have not tested it.

## Usage
```
packer build -var TRANSMISSION_VERSION=3.00 Packerfile.json
docker run -v `pwd`:/work -it chuy08/focal-build-transmission:3.00
```

# Guarantees
I guarantee it won't eat your cat as mine is sitting next to me :-)