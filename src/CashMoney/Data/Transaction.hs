module CashMoney.Data.Transaction where

import Data.Time.Calendar (Day)

data Transaction = Transaction
  { delta :: Float,
    transactionType :: String,
    category :: String,
    description :: String,
    day :: Day
  }
