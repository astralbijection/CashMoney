module CashMoney.Import.ChaseCardCSV where

import CashMoney.Data.Importer (Importer (..))
import Data.Text (Text)

importChaseCardCSV :: Text -> FilePath -> Importer
importChaseCardCSV iName path =
  Importer
    { name = iName,
      getTransactionsAfter = \day -> pure []
    }
