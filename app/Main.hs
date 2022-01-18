{-# LANGUAGE OverloadedStrings #-}
import Test.WebDriver
import Control.Monad.IO.Class
import Test.WebDriver.Session
import qualified Data.ByteString.Lazy.Char8 as B

main :: IO ()
main =
  runSession defaultConfig $ do
    --getSession >>= liftIO . print
    openPage "http://google.co.jp/"
    --screenshotWriteFile "google.png"

screenshotWriteFile::  FilePath -> WD ()
screenshotWriteFile name = do
  string <- screenshot
  liftIO . B.writeFile name  $ string