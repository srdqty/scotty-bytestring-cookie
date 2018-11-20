{-# LANGUAGE OverloadedStrings #-}

module Web.Scotty.ByteString.Cookie
    ( cookie
    , cookies
    , addCookie
    , expireCookie
    ) where

import Data.ByteString (ByteString)
import Data.ByteString.Builder (toLazyByteString)
import Data.ByteString.Lazy (toStrict)
import Data.Time.Clock.POSIX (posixSecondsToUTCTime)
import Web.Cookie
    ( Cookies
    , SetCookie
    , defaultSetCookie
    , parseCookies
    , renderSetCookie
    , setCookieName
    , setCookieValue
    , setCookieExpires
    )
import Web.Scotty.Trans (ActionT, ScottyError)
import Web.Scotty.ByteString (header, addHeader)

cookie :: (ScottyError e, Monad m)
       => ByteString
       -> ActionT e m (Maybe ByteString)
cookie name = lookup name <$> cookies

-- Split the Cookie header into a list of Cookies,
-- aka [(ByteString, ByteString)]
-- The client is supposed to only send a single Cookie header, which can
-- contain multiple cookies.
cookies :: (ScottyError e, Monad m) => ActionT e m Cookies
cookies = maybe [] parseCookies <$> header "Cookie"

-- Does not do any duplicate checking.
-- Each call corresponds to adding a new Set-Cookie header
addCookie :: (Monad m, ScottyError e) => SetCookie -> ActionT e m ()
addCookie = addHeader "Set-Cookie"
          . toStrict
          . toLazyByteString
          . renderSetCookie

-- Does not do any checking for duplicates
-- This sets the cookie value to an empty string and sets the expiration date
-- to the past
expireCookie :: (Monad m, ScottyError e) => ByteString -> ActionT e m ()
expireCookie name = addCookie $ defaultSetCookie
    { setCookieName = name
    , setCookieValue = ""
    , setCookieExpires = Just (posixSecondsToUTCTime 0)
    }
