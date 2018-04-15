module Free.AsyncStorage
  ( AsyncStorage
  , AsyncStorageF(..)

  , getItem
  , setItem
  , removeItem

  , getItemRep
  , setItemRep
  ) where

import Prelude

import Control.Monad.Free (Free, liftF)

import Data.Argonaut.Core (stringify) as Argonaut
import Data.Argonaut.Parser (jsonParser) as Argonaut
import Data.Argonaut.Decode.Generic.Rep (class DecodeRep)
import Data.Argonaut.Decode.Generic.Rep (genericDecodeJson) as Argonaut
import Data.Argonaut.Encode.Generic.Rep (class EncodeRep)
import Data.Argonaut.Encode.Generic.Rep (genericEncodeJson) as Argonaut
import Data.AsyncStorage.Key (Key)
import Data.AsyncStorage.Value (Value)
import Data.Either (Either)
import Data.Generic.Rep (class Generic)
import Data.Maybe (Maybe)
import Data.Newtype (wrap, unwrap)
import Data.Traversable (sequence)

type AsyncStorage = Free AsyncStorageF

data AsyncStorageF a
  = GetItem Key (Maybe Value -> a)
  | SetItem Key Value a
  | RemoveItem Key a

derive instance functorAsyncStorageF :: Functor AsyncStorageF

getItem :: Key -> AsyncStorage (Maybe Value)
getItem key = liftF (GetItem key id)

setItem :: Key -> Value -> AsyncStorage Unit
setItem key value = liftF (SetItem key value unit)

removeItem :: Key -> AsyncStorage Unit
removeItem key = liftF (RemoveItem key unit)

getItemRep :: forall r a. Generic a r => DecodeRep r => Key -> AsyncStorage (Either String (Maybe a))
getItemRep key = sequence <<< map (Argonaut.jsonParser <<< unwrap >=> Argonaut.genericDecodeJson) <$> getItem key

setItemRep :: forall r a. Generic a r => EncodeRep r => Key -> a -> AsyncStorage Unit
setItemRep key = setItem key <<< wrap <<< Argonaut.stringify <<< Argonaut.genericEncodeJson
