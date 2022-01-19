{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE Arrows #-}
module Test.WebDriver.Fanza.SimpleA where

import Test.WebDriver
import Test.WebDriver.Arrow
import Control.Category ((>>>))
import Control.Arrow
import Control.Monad.IO.Class
import Data.Aeson 
import Data.Maybe 
import qualified Data.Text as T
import qualified Data.ByteString.Lazy.Char8 as B



fanzaUrlA = "https://www.dmm.co.jp/top/"

entryFanzaA :: WDA String ()
entryFanzaA = do
  openPageA
  >>> setImplicitWaitA 2000
  >>> findElemA (ByCSS "a[class='ageCheck__link ageCheck__link--r18']") 
  >>> clickA

extractSampleMovieUrlA :: WDA String T.Text
extractSampleMovieUrlA = do
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

extractSamplePictureSmallA :: WDA String [T.Text]
extractSamplePictureSmallA = do
  openPageA
  >>> findElemsA (ByXPath "/html/body/table/tbody/tr/td[2]/div/table/tbody/tr/td[1]/div[6]/a/img")
  >>> Kleisli (fmap catMaybes . traverse (flip attr "src"))


-- use extract urls from ranking .. 
extractUrlsA :: WDA String [T.Text]
extractUrlsA = do
  openPageA
  >>> findElemsA (ByXPath "/html/body/table/tbody/tr/td[2]/div[1]/div/div[3]/div/ul/li/div/p[2]/a")
  >>> Kleisli (fmap catMaybes . traverse (flip attr "href"))
  
