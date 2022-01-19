{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE Arrows #-}
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

pathA :: b -> WDA a b
pathA = arr . const   

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

sendRawkeysA :: T.Text -> WDA a () 
sendRawkeysA text = Kleisli $ const $ sendRawKeys text

clearInputA :: WDA Element () 
clearInputA = Kleisli clearInput

attrA :: T.Text -> WDA Element (Maybe T.Text)
attrA text = Kleisli $ flip attr text

cssPropA :: T.Text -> WDA Element (Maybe T.Text) 
cssPropA = Kleisli . flip cssProp

elemPosA :: WDA Element (Float, Float) 
elemPosA = Kleisli elemPos

elemSizeA :: WDA Element (Float, Float) 
elemSizeA = Kleisli elemSize

isSelectedA :: WDA Element Bool
isSelectedA = Kleisli isSelected

isEnabledA :: WDA Element Bool
isEnabledA = Kleisli isEnabled

isDisplayedA :: WDA Element Bool
isDisplayedA = Kleisli isDisplayed

tagNameA :: WDA Element T.Text
tagNameA = Kleisli tagName

activeElemA :: WDA a Element
activeElemA = Kleisli $ const activeElem


executeJSA :: (Foldable f, FromJSON b) =>
  f JSArg -> WDA T.Text b
executeJSA jsa = Kleisli $ executeJS jsa

asyncJSA :: (Foldable f, FromJSON b) =>
  f JSArg -> WDA T.Text (Maybe b)
asyncJSA jsa = Kleisli $ asyncJS jsa

getCurrentWindowA :: WDA a WindowHandle
getCurrentWindowA = Kleisli $ const getCurrentWindow

closeWindowA :: WDA WindowHandle ()
closeWindowA = Kleisli closeWindow

windowsA :: WDA a [WindowHandle]
windowsA = Kleisli $ const windows

focusWindowA :: WDA WindowHandle ()
focusWindowA = Kleisli focusWindow

maximizeA :: WDA a () 
maximizeA = Kleisli $ const maximize

getWindowSizeA :: WDA a (Word, Word)
getWindowSizeA = Kleisli $ const getWindowSize

setWindowSizeA :: WDA (Word, Word) ()
setWindowSizeA = Kleisli setWindowSize

setWindowSizeA_ :: (Word, Word) -> WDA a ()
setWindowSizeA_ = Kleisli . const . setWindowSize

getWindowPosA :: WDA a (Int, Int)
getWindowPosA = Kleisli $ const getWindowPos

setWindowPosA_ :: (Int, Int) -> WDA a () 
setWindowPosA_ = Kleisli . const . setWindowPos

focusFrameA :: WDA FrameSelector ()
focusFrameA = Kleisli focusFrame

cookiesA :: WDA a [Cookie]
cookiesA = Kleisli $ const cookies

moveToA :: WDA (Int, Int) ()
moveToA = Kleisli moveTo

moveToA_ :: (Int, Int) -> WDA a ()
moveToA_ = Kleisli . const . moveTo

moveToCenterA :: WDA Element () 
moveToCenterA = Kleisli moveToCenter

moveToFromA :: (Int, Int) -> WDA Element ()
moveToFromA = Kleisli . moveToFrom

clickWithA :: WDA MouseButton ()
clickWithA = Kleisli clickWith


mouseDownA :: WDA a () 
mouseDownA = Kleisli $ const mouseDown

mouseUpA :: WDA a () 
mouseUpA = Kleisli $ const mouseUp

doubleClickA :: WDA a ()
doubleClickA = Kleisli $ const doubleClick

storageSizeA :: WDA WebStorageType Integer
storageSizeA = Kleisli storageSize

storageSizeA_ :: WebStorageType -> WDA a Integer
storageSizeA_ = Kleisli . const . storageSize

uploadFileA :: FilePath -> WDA a ()
uploadFileA = Kleisli . const . uploadFile

