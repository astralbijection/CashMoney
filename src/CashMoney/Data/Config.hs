module CashMoney.Data.Config where

import Data.Text (Text)
import GHC.Generics (Generic)
import Data.Map (Map)

data ConfigFile = ConfigFile
  { sources :: [Source]
  }
  deriving (Generic, Show)

data Source = Source
  { provider :: Text,
    name :: Text,
    params :: Map Text Text
  }
  deriving (Generic, Show)
