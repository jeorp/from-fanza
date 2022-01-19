{-# LANGUAGE OverloadedStrings #-}
module Test.WebDriver.Fanza.Arrow where

import Test.WebDriver
import Control.Category ((>>>))
import Control.Arrow
import Control.Monad.IO.Class
import Data.Aeson 
import Data.Maybe 
import qualified Data.Text as T
import qualified Data.ByteString.Lazy.Char8 as B

type WDA a b = Kleisli WD a b 

runNewWDA :: WDA a b -> a -> IO b
runNewWDA wda = runSession defaultConfig . runKleisli wda

openPageA :: WDA String ()
openPageA = Kleisli openPage

setImplicitWaitA :: Integer -> WDA a ()
setImplicitWaitA n = Kleisli $ const $ setImplicitWait n

setPageLoadTimeoutA :: Integer -> WDA a ()
setPageLoadTimeoutA n = Kleisli $ const $ setPageLoadTimeout n

findElemA :: Selector -> WDA a Element
findElemA selector = Kleisli $ const $ findElem selector

clickA :: WDA Element ()
clickA = Kleisli click

attrA :: T.Text -> WDA Element (Maybe T.Text)
attrA text = Kleisli $ flip attr text

executeJSA :: (Foldable f, FromJSON b) =>
  f JSArg -> WDA T.Text b
executeJSA jsa = Kleisli $ executeJS jsa

fanzaUrl = "https://www.dmm.co.jp/top/"

entryFanza :: WDA String ()
entryFanza = do
  openPageA
  >>> setImplicitWaitA 2000
  >>> findElemA (ByCSS "a[class='ageCheck__link ageCheck__link--r18']") 
  >>> clickA

extractSampleMovieUrl :: WDA String T.Text
extractSampleMovieUrl = do
  openPageA
  >>> setImplicitWaitA 1000
  >>> findElemA (ByXPath "//*[@id='detail-sample-movie']/div/a")
  >>> attrA "onclick"
  >>> arr (fromMaybe "")
  >>> (executeJSA [] :: WDA T.Text Value)
  >>> setPageLoadTimeoutA 4000
  >>> findElemA (ByXPath "//*[@id='DMMSample_player_now']")
  >>> attrA "src"
  >>> arr (T.unpack . fromMaybe "")
  >>> openPageA
  >>> findElemA (ByXPath "//video")
  >>> attrA "src"
  >>> arr (fromMaybe "")