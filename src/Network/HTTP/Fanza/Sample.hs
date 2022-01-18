{-# LANGUAGE OverloadedStrings #-}
module Network.HTTP.Fanza.Sample where

import Test.WebDriver
import Control.Monad.IO.Class
import Test.WebDriver.Session
import Data.Aeson 
import Data.Maybe 
import qualified Data.Text as T
import qualified Data.ByteString.Lazy.Char8 as B

fanzaUrl = "https://www.dmm.co.jp/top/"


runNewWD :: WD a -> IO a
runNewWD = runSession defaultConfig


entryFanza :: WD ()
entryFanza = do
 openPage fanzaUrl
 setImplicitWait 2000
 noren <- findElem (ByCSS "a[class='ageCheck__link ageCheck__link--r18']")
 click noren 

extractSampleMovieUrl :: String -> WD ()
extractSampleMovieUrl url = do
  openPage url
  setImplicitWait 1000
  playBtn <- findElem (ByXPath "//*[@id='detail-sample-movie']/div/a")
  jsFunction <- attr playBtn "onclick"
  liftIO $ print jsFunction
  let buttonJs = fromMaybe "" jsFunction
  executeJS [] buttonJs :: WD Value
  setPageLoadTimeout 4000
  mediaElem <- findElem (ByXPath "//*[@id='DMMSample_player_now']")
  playerUrl <- attr mediaElem "src"
  let frameDocument = fromMaybe "" playerUrl
  openPage $ T.unpack frameDocument
  mediaElem <- findElem $ ByXPath "/html/body/div[1]/div/div/section/main/video"
  url_ <- attr mediaElem "src"
  let resultUrl = fromMaybe "" url_ 
  liftIO $ print resultUrl


