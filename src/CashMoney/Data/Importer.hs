module CashMoney.Data.Importer where

import CashMoney.Data.Transaction (Transaction)
import Data.Text (Text)
import Data.Time.Calendar (Day)

data Importer = Importer
  { name :: Text,
    getTransactionsAfter :: Day -> IO [Transaction]
  }
