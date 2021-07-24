module CashMoney.Data.Importer where

import CashMoney.Data.Transaction (Transaction)
import Data.Csv (FromRecord)
import Data.Text (Text)
import Data.Time.Calendar (Day)
import GHC.Generics (Generic)

data Record = Record
  { transactionDate :: Text,
    postDate :: Text,
    description :: Text,
    category :: Text,
    tType :: Text,
    amount :: Float,
    memo :: Text
  }
  deriving (Generic, Show)

instance FromRecord Record

data Importer = Importer
  { name :: Text,
    getTransactionsAfter :: Day -> IO [Transaction]
  }
