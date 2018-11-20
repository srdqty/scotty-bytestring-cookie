{-# LANGUAGE OverloadedStrings #-}

module Web.Scotty.ByteString.CookieSpec (main, spec) where

import qualified Data.ByteString as BS (ByteString)
import qualified Data.ByteString.Lazy as BL (ByteString)
import Data.Text.Lazy (Text)
import Network.HTTP.Types (HeaderName)
import Network.Wai (Application)
import Test.Hspec
    ( Spec
    , SpecWith
    , hspec
    , describe
    , it
    )
import Test.Hspec.Wai
    ( WaiExpectation
    , get
    , matchHeaders
    , shouldRespondWith
    , with
    , (<:>)
    )
import Web.Cookie
    ( defaultSetCookie
    , setCookieName
    , setCookieValue
    )
import qualified Web.Scotty.Trans as ScottyT (ActionT, scottyAppT, get)

import Web.Scotty.ByteString (html)
import Web.Scotty.ByteString.Cookie (addCookie, expireCookie)

main :: IO ()
main = hspec spec

spec :: Spec
spec = do
    addCookieSpec
    expireCookieSpec

addCookieSpec :: Spec
addCookieSpec = describe "addCookie" $ withApp app $ do
    it "adds cookie" $
        shouldRespondWithHeader "Set-Cookie" "cookie0=value0"

    it "adds other cookie" $
        shouldRespondWithHeader "Set-Cookie" "cookie1=value1"

    it "adds duplicate cookie" $
        shouldRespondWithHeader "Set-Cookie" "cookie0=value2"
  where
    app = do
        addCookie $ defaultSetCookie
            { setCookieName = "cookie0"
            , setCookieValue = "value0"
            }
        addCookie $ defaultSetCookie
            { setCookieName = "cookie1"
            , setCookieValue = "value1"
            }
        addCookie $ defaultSetCookie
            { setCookieName = "cookie0"
            , setCookieValue = "value2"
            }

expireCookieSpec :: Spec
expireCookieSpec = describe "addCookie" $ withApp app $ do
    it "adds cookie" $
        shouldRespondWithHeader "Set-Cookie" "cookie0=value0"

    it "expires that cookie" $
        shouldRespondWithHeader
            "Set-Cookie"
            "cookie0=; Expires=Thu, 01-Jan-1970 00:00:00 GMT"

    it "expires other cookie" $
        shouldRespondWithHeader
            "Set-Cookie"
            "cookie1=; Expires=Thu, 01-Jan-1970 00:00:00 GMT"
  where
    app = do
        addCookie $ defaultSetCookie
            { setCookieName = "cookie0"
            , setCookieValue = "value0"
            }
        expireCookie "cookie0"
        expireCookie "cookie1"

withApp :: ScottyT.ActionT Text IO () -> SpecWith Application -> Spec
withApp = with
        . ScottyT.scottyAppT id
        . ScottyT.get "/"
        . (<*) (html ("hello-world" :: BL.ByteString))

shouldRespondWithHeader :: HeaderName -> BS.ByteString -> WaiExpectation
shouldRespondWithHeader name value =
    shouldRespondWith
        (get "/")
        "hello-world" { matchHeaders = [name <:> value] }
