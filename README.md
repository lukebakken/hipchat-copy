hipchat-util
============

Utilities for working with HipChat

Get your HipChat API v2 token from: https://YOUR-ORG.hipchat.com/account/api

### Setup

```sh
$ echo 'YOUR_API_TOKEN' > ~/.hcapi
$ gem install hcutil
```

### `copy`

To copy text from a HipChat room:

```sh
$ hcutil help copy
$ hcutil copy 'Target HipChat Room'
$ hcutil copy 'Target HipChat Room' -n 50 -d '2014-01-31'
```

### `ping`

To ping a ticket response to a (hardcoded at this point) room:

```sh
$ hcutil help ping
$ hcutil ping 1234 my-response.txt
$ hcutil ping 1234 my-response.txt 'Response contains blah blah blah'
```

