# prunednode.today

A website and sync script for prunednode.today.

## How to set up:

- download and install latest bitcoin core from [bitcoincore.org](https://bitcoincore.org/en/download/)
- copy [bitcoin.conf](./bitcoin.conf) to your `~/.bitcoin` folder (create if not present) - it is set up to use `prune=550` flag.
- start `bitcoind --daemon` and wait for full sync
- install `nginx` and copy content of the [`html`](./html/) folder to `/var/www/html/`
- create the first snapshot (see below)
- adjust `index.html` - update the author, url to 

## Nginx configuration

Add the following lines to the server block of nginx, so `latest.zip` and `latest.signed.txt` redirect to the latest snapshot:

```
server{
	# ...
	rewrite ^/latest.zip$ /snapshot221003.zip redirect;
	rewrite ^/latest.signed.txt$ /snapshot221003.signed.txt redirect;
	# ...
}
```

You will need to update it every time you create a new snapshot and reload nginx (`nginx -s reload`)

## Creating a snapshot

1. Run [`zipit.sh`](./zipit.sh) script, it will:
	- stop bitcoind and wait for 1 minute
	- copy bitcoin files to a separate folder
	- start bitcoind again to continue syncing
	- zip the content of the folder to a `snapshot<date>.zip`
	- create a `snapshot<date>.txt` with sha256 of the file
	- move it to the `/var/www/html/` folder
2. Sign the `snapshot<date>.txt` with your pgp key using `gpg --output snapshot<date>.signed.txt --clearsign snapshot<date>.txt` and place it next to the snapshot zip file
3. Update:
	- nginx config file to use new snapshot for redirects
	- `/var/www/html/latest.txt` so it contains the name of the latest snapshot zip file
	- `/var/www/html/index.html` so it has correct date in the description

It is not necessary to run the node on the same machine where the snapshots are hosted, you can always create a snapshot on another machine and rsync files to the host.
