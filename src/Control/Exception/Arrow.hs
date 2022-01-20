module Control.Exception.Arrow where

import Control.Category ((>>>))
import Control.Arrow
import Control.Monad.Catch

catchA :: (MonadCatch m ,Exception e) => Kleisli m x a -> Kleisli m e a -> Kleisli m x a 
catchA (Kleisli f) (Kleisli handler) = Kleisli $ flip catch handler . f 

catchesA :: (Foldable f, MonadCatch m) =>Kleisli m x a -> f (Handler m a) -> Kleisli m x a 
catchesA (Kleisli f) handlers = Kleisli $ flip catches handlers . f

kleisliToHandler :: (MonadCatch m ,Exception e) => Kleisli m e a -> Handler m a
kleisliToHandler = Handler . runKleisli
