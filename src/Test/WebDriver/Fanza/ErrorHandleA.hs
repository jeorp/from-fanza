module Test.WebDriver.Fanza.ErrorHandleA where

import Control.Category ((>>>))
import Control.Arrow
import Control.Monad.IO.Class
import Control.Monad.Catch
import Test.WebDriver (WD)
import Test.WebDriver.Exceptions
import Control.Exception.Arrow
import Test.WebDriver.Arrow

-- sample Handling ...

invalidURLA :: WDA InvalidURL ()
invalidURLA = Kleisli $ \_ -> liftIO $ print "InvalidURL"

noSessionIdA :: WDA NoSessionId ()
noSessionIdA = Kleisli $ \_ -> liftIO $ print "NoSessionId"

badJSONA :: WDA BadJSON ()
badJSONA = Kleisli $ \_ -> liftIO $ print "BadJSON"

hTTPStatusUnknownA :: WDA HTTPStatusUnknown ()
hTTPStatusUnknownA = Kleisli $ \_ -> liftIO $ print "HTTPStatusUnknown"

hTTPConnErrorA :: WDA HTTPConnError ()
hTTPConnErrorA = Kleisli $ \_ -> liftIO $ print "HTTPConnError"

unknownCommandA :: WDA UnknownCommand ()
unknownCommandA = Kleisli $ \_ -> liftIO $ print "UnknownCommand"

serverErrorA :: WDA ServerError ()
serverErrorA = Kleisli $ \_ -> liftIO $ print "ServerError"

failedCommandA :: WDA FailedCommand ()
failedCommandA = Kleisli $ \_ -> liftIO $ print "FailedCommand"
