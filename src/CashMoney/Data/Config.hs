module CashMoney.Data.Config where

import Data.Map (Map)
import Data.Text (Text)
import GHC.Generics (Generic)

data ConfigFile = ConfigFile
  { sources :: [Source],
    output :: String
  }
  deriving (Generic, Show)

data Source = Source
  { provider :: Text,
    name :: Text,
    params :: Map Text Text
  }
  deriving (Generic, Show)
