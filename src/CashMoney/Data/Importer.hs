module CashMoney.Data.Importer where

import CashMoney.Data.Transaction (Transaction)
import Data.Csv (FromRecord)
import Data.Text (Text)
import Data.Time.Calendar (Day)
import GHC.Generics (Generic)

data Importer = Importer
  { name :: Text,
    getTransactionsAfter :: Day -> IO [Transaction]
  }
