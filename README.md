# scotty-bytestring-cookie

[![Build Status](https://travis-ci.org/srdqty/scotty-bytestring-cookie.svg?branch=master)](https://travis-ci.org/srdqty/scotty-bytestring-cookie)

Functions for reading and writing HTTP cookies with Scotty. The inputs and
outputs uses ByteStrings instead of Text.

## Example

We expose four functions: `cookie`, `cookies`, `addCookie, and `expireCookie`.

```
{-# LANGUAGE OverloadedStrings #-}

import Web.Cookie
    ( defaultSetCookie
    , setCookieName
    , setCookieValue
    )
import Web.Scotty
import Web.Scotty.ByteString.Cookie (cookie, cookies, addcookie, expireCookie)

import Data.Monoid (mconcat)

main = scotty 3000 $
  get "/:word" $ do
    beam <- param "word"

    maybeCookie <- cookie "SOME-COOKIE"

    cs <- cookies

    addCookie $ defaultSetCookie
        { setCookieName = "cookie0"
        , setCookieValue = "value0"
        }

    expireCookie "mah-cookie"

    html $ mconcat ["<h1>Scotty, ", beam, " me up!</h1>"]
```



## Development

I mostly use nix + cabal. I have tried nix + stack, and it worked on my
machine. Same with cabal new-\*. I haven't tested stack without nix, because
stack forces nix integration on NixOS.

### Nix + Cabal

See [nix/README.md](nix/README.md)

### Nix + Stack

```
stack build
stack test
```

### Cabal new-\*

```
cabal new-build
cabal new-test
```
### Stack

```
stack --no-nix build
stack --no-nix test
```
