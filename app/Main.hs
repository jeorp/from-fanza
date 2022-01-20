{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE Arrows #-}
import Utility.Donwload
import Test.WebDriver.Arrow
import Test.WebDriver.Fanza.SimpleA
import Control.Exception.Arrow
import Test.WebDriver.Fanza.ErrorHandleA
import Control.Category ((>>>))
import Control.Arrow
import qualified Data.Text as T

storeDir = "temp/"

sampleUrl = "https://www.dmm.co.jp/digital/videoa/-/detail/=/cid=mide00872/?dmmref=recommend13_top_2d&i3_ref=recommend&i3_ord=4"

main :: IO ()
main = do 
  flip runNewWDA fanzaUrlA $ -- runNewWDA :: Kleisli WD a b -> a -> IO b
    entryFanzaA   -- fist, you should enter r-18 area.
    >>> pathA sampleUrl -- latter, you can get sample movie url . 
    >>> extractSampleMovieUrlA
  >>= (storeFromUrl storeDir . T.unpack)

