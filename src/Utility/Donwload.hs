{-# LANGUAGE OverloadedStrings #-}

module Utility.Donwload where
import Network.HTTP.Simple
import qualified Data.ByteString as B
import qualified Data.ByteString.Char8 as BS
import Control.Monad
import System.IO
import System.Directory
import Data.Strings

-- input url and path 
downloadVideo :: String -> String -> IO ()
downloadVideo url path = do
  let outFile = path
  b <- doesFileExist outFile
  unless b $ do
    res <- httpBS $ parseRequest_ url
    let xs = getResponseHeader "Content-Type" res
        file = getResponseBody res
        contentType = if not (null xs) then head xs else ""
    store outFile file contentType
  where
    store :: FilePath -> B.ByteString -> B.ByteString -> IO ()
    store path bs c = do
      if B.isInfixOf "video/" c 
        then do 
          putStrLn $ "status : Downloading to " ++ path
          let picType = BS.unpack $ snd $ B.splitAt (B.length "image/") c
              local = path
          fin <- openBinaryFile local WriteMode
          hPutStr fin (BS.unpack bs)
          hClose fin
          putStrLn $ "status : Success download to " ++ path
        else putStrLn "not video file"


urlToFileName :: String -> String
urlToFileName s = 
  let xs = strSplitAll "/" s
      ls = if null xs then "error" else last xs
    in ls

eliminate :: String -> String
eliminate s = 
  let xs = strSplitAll "." s
      ls = if null xs then s else head xs
    in ls

storeFromUrl :: String -> String -> IO ()
storeFromUrl tmp url = downloadVideo url (tmp <> urlToFileName url)