hipchat-copy
============

Copy text from a HipChat room

Get your HipChat API v2 token from: https://basho.hipchat.com/account/api

To use:

```sh
$ echo 'YOUR_API_TOKEN' > ~/.hcapi
$ gem install rest_client
$ ./hccopy --help
$ ./hccopy --room='XXX' -n 50 -d '2014-01-31'
```
