module Free.AsyncStorage.ReactNativeAsyncStorage (reactNativeAsyncStorage) where

import Prelude

import Control.Monad.Aff (Aff)
import Control.Monad.Aff.Compat (EffFnAff, fromEffFnAff)

import Data.Newtype (unwrap)
import Data.Nullable (toMaybe)

import Free.AsyncStorage (AsyncStorageF(..))

reactNativeAsyncStorage :: forall eff. AsyncStorageF ~> Aff eff
reactNativeAsyncStorage =
  case _ of
       GetItem key k -> k <<< toMaybe <$> asyncStorage "getItem" [ unwrap key ]

       SetItem key value a -> a <$ asyncStorage "setItem" [ unwrap key, unwrap value ]

       RemoveItem key a -> a <$ asyncStorage "removeItem" [ unwrap key ]

asyncStorage :: forall eff a. String -> Array String -> Aff eff a
asyncStorage fn args = fromEffFnAff (asyncStorage_ fn args)

foreign import asyncStorage_
  :: forall eff a
   . String
  -> Array String
  -> EffFnAff eff a
