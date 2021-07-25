module CashMoney.Data.Transaction where

import Data.Time.Calendar (Day)
import Data.Text (Text)

data Transaction = Transaction
  { delta :: Float,
    category :: Text,
    description :: Text,
    day :: Day
  }
