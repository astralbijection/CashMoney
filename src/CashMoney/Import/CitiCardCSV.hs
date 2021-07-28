module CashMoney.Import.CitiCardCSV where

import CashMoney.Data.Importer (Importer (..))
import qualified CashMoney.Data.Transaction as Tr
import CashMoney.Import.Util (importTransactionCSVs, parseMDY)
import Data.Csv (FromRecord, HasHeader (HasHeader))
import Data.Text (Text)
import GHC.Generics (Generic)
import System.FilePath.Glob (Pattern)
import Data.Maybe (fromMaybe)

data Record = Record
  { status :: Text,
    date :: String,
    description :: Text,
    debit :: Maybe Float,
    credit :: Maybe Float
  }
  deriving (Generic, Show)

instance FromRecord Record

toTransaction :: Record -> Maybe Tr.Transaction
toTransaction Record {status, date, description, credit, debit} =
  if status /= "Cleared"
    then Nothing
    else
      Just
        Tr.Transaction
          { Tr.day = parseMDY date,
            Tr.category = "TODO",
            Tr.delta = fromMaybe 0 credit + fromMaybe 0 debit,
            Tr.description = description
          }

importCitiCardCSV :: Text -> [Pattern] -> Importer
importCitiCardCSV iName patterns =
  Importer
    { name = iName,
      getTransactionsAfter = importTransactionCSVs HasHeader toTransaction patterns
    }
