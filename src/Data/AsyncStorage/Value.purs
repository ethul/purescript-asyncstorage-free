module Data.AsyncStorage.Value where

import Prelude

import Data.Monoid (class Monoid)
import Data.Newtype (class Newtype)

newtype Value = Value String

derive instance eqValue :: Eq Value

derive instance ordValue :: Ord Value

derive instance newtypeValue :: Newtype Value _

derive newtype instance semigroupValue :: Semigroup Value

derive newtype instance monoidValue :: Monoid Value
