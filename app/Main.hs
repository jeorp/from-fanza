{-# LANGUAGE OverloadedStrings #-}
import Test.WebDriver
import Control.Monad.IO.Class
import Test.WebDriver.Session
import qualified Data.ByteString.Lazy.Char8 as B
import Network.HTTP.Fanza.Sample

main :: IO () -- sample
main = runNewWD $ entryFanza >> extractSampleMovieUrl "https://www.dmm.co.jp/digital/videoa/-/detail/=/cid=pppd00927/"

screenshotWriteFile::  FilePath -> WD ()
screenshotWriteFile name = do
  string <- screenshot
  liftIO . B.writeFile name  $ string