{-# LANGUAGE OverloadedStrings #-}
module Test.WebDriver.Arrow where

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

openPageA_ :: String -> WDA a ()
openPageA_ url = Kleisli $ const $ openPage url

forwardA :: WDA a ()
forwardA = Kleisli $ const forward

backA :: WDA a ()
backA = Kleisli $ const back

refreshA :: WDA a ()
refreshA = Kleisli $ const refresh

getCurrentURLA :: WDA a String
getCurrentURLA = Kleisli $ const getCurrentURL

getSourceA :: WDA a T.Text
getSourceA = Kleisli $ const getSource

getTitleA :: WDA a T.Text
getTitleA = Kleisli $ const getTitle

saveScreenshotA :: WDA FilePath () 
saveScreenshotA = Kleisli saveScreenshot

saveScreenshotA_ :: FilePath -> WDA a () 
saveScreenshotA_ path = Kleisli $ const $ saveScreenshot path

screenshotA :: WDA a B.ByteString 
screenshotA = Kleisli $ const screenshot

screenshotBase64A :: WDA a B.ByteString 
screenshotBase64A = Kleisli $ const screenshotBase64


setImplicitWaitA :: Integer -> WDA a ()
setImplicitWaitA n = Kleisli $ const $ setImplicitWait n

setScriptTimeoutA :: Integer -> WDA a ()
setScriptTimeoutA n = Kleisli $ const $ setScriptTimeout n

setPageLoadTimeoutA :: Integer -> WDA a ()
setPageLoadTimeoutA n = Kleisli $ const $ setPageLoadTimeout n


findElemA :: Selector -> WDA a Element
findElemA selector = Kleisli $ const $ findElem selector

findElemsA :: Selector -> WDA a [Element]
findElemsA selector = Kleisli $ const $ findElems selector

findElemFromA :: Selector -> WDA Element Element
findElemFromA selector = Kleisli $ flip findElemFrom selector

findElemsFromA :: Selector -> WDA Element [Element]
findElemsFromA selector = Kleisli $ flip findElemsFrom selector


clickA :: WDA Element ()
clickA = Kleisli click

submitA :: WDA Element ()
submitA = Kleisli submit

getTextA :: WDA Element T.Text
getTextA = Kleisli getText

sendKeysA :: T.Text -> WDA Element () 
sendKeysA text = Kleisli $ sendKeys text




attrA :: T.Text -> WDA Element (Maybe T.Text)
attrA text = Kleisli $ flip attr text

executeJSA :: (Foldable f, FromJSON b) =>
  f JSArg -> WDA T.Text b
executeJSA jsa = Kleisli $ executeJS jsa