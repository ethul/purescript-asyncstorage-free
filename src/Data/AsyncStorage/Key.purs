module Data.AsyncStorage.Key where

import Prelude

import Data.Monoid (class Monoid)
import Data.Newtype (class Newtype)

newtype Key = Key String

derive instance eqKey :: Eq Key

derive instance ordKey :: Ord Key

derive instance newtypeKey :: Newtype Key _

derive newtype instance semigroupKey :: Semigroup Key

derive newtype instance monoidKey :: Monoid Key
