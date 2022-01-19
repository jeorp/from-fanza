{-# LANGUAGE OverloadedStrings #-}
module Test.WebDriver.Fanza.Simple where

import Test.WebDriver
import Control.Monad.IO.Class
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

sampleUrl = "https://www.dmm.co.jp/digital/videoa/-/detail/=/cid=meyd00736/?dmmref=videoa_top_pickup_pc&i3_ref=recommend&i3_ord=4"

extractSampleMovieUrl :: String -> WD T.Text
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
  mediaElem <- findElem $ ByXPath "//video"
  url_ <- attr mediaElem "src"
  let resultUrl = fromMaybe "" url_ 
  return resultUrl

extractSamplePictureSmall :: String -> WD [T.Text]
extractSamplePictureSmall url = do
  openPage url
  imageElems <- findElems (ByXPath "/html/body/table/tbody/tr/td[2]/div/table/tbody/tr/td[1]/div[6]/a/img")
  catMaybes <$> traverse (flip attr "src") imageElems

-- convert : https://....../aaaa00111-1.jpg -> https://....../aaaa000111jp-1.jpg 
getOriginalUrl :: T.Text -> T.Text
getOriginalUrl small = undefined

rankUrl = "https://www.dmm.co.jp/digital/videoa/-/list/=/device=video/sort=ranking/trans_type=st/"

extractUrls :: String -> WD [T.Text]
extractUrls url = do
  openPage url
  xs <- findElems (ByXPath "/html/body/table/tbody/tr/td[2]/div[1]/div/div[3]/div/ul/li/div/p[2]/a")
  catMaybes <$> traverse (flip attr "href") xs 


screenshotWriteFile ::  FilePath -> WD ()
screenshotWriteFile name = do
  string <- screenshot
  liftIO . B.writeFile name  $ string