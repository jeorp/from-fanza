{-# LANGUAGE OverloadedStrings #-}

import Utility.Donwload
import Test.WebDriver.Fanza.Arrow
import Test.WebDriver
import Control.Category ((>>>))
import Control.Arrow
import qualified Data.Text as T

storeDir = "temp"

sampleUrl = "https://www.dmm.co.jp/digital/videoa/-/detail/=/cid=mide00872/?dmmref=recommend13_top_2d&i3_ref=recommend&i3_ord=4"

main :: IO ()
main = do 
  flip runNewWDA fanzaUrlA $
    entryFanzaA
    >>> arr (const sampleUrl)
    >>> extractSampleMovieUrlA
  >>= (storeFromUrl storeDir . T.unpack)

