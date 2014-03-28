hipchat-util
============

Utilities for working with HipChat

### `copy`

Copy text from a HipChat room

Get your HipChat API v2 token from: https://basho.hipchat.com/account/api

To use:

```sh
$ echo 'YOUR_API_TOKEN' > ~/.hcapi
$ bundle install
$ ./hcutil help copy
$ ./hcutil copy --room='XXX' -n 50 -d '2014-01-31'
```
