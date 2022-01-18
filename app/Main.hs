{-# LANGUAGE OverloadedStrings #-}
import Test.WebDriver
import Control.Monad.IO.Class
import qualified Data.ByteString.Lazy.Char8 as B

main :: IO ()
main =
  runSession defaultConfig $ do
    openPage "http://google.co.jp/"
    screenshotWriteFile "google.png"

screenshotWriteFile::  FilePath -> WD ()
screenshotWriteFile name = do
  string <- screenshot
  liftIO . B.writeFile name  $ string