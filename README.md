hipchat-util
============

Utilities for working with HipChat

### `copy`

Copy text from a HipChat room

Get your HipChat API v2 token from: https://YOUR-ORG.hipchat.com/account/api

To use:

```sh
$ echo 'YOUR_API_TOKEN' > ~/.hcapi
$ bundle install
$ ./hcutil help copy
$ ./hcutil copy 'Target HipChat Room'
$ ./hcutil copy 'Target HipChat Room' -n 50 -d '2014-01-31'
```
