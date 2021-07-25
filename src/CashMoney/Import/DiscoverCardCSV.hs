module CashMoney.Import.DiscoverCardCSV where

import CashMoney.Data.Importer (Importer (..))
import qualified CashMoney.Data.Transaction as Tr
import CashMoney.Import.Util (importTransactionCSVs, parseMDY)
import Data.Csv (FromRecord, HasHeader (HasHeader))
import Data.Text (Text)
import GHC.Generics (Generic)
import System.FilePath.Glob (Pattern)

data Record = Record
  { transactionDate :: Text,
    postDate :: String,
    description :: Text,
    amount :: Float,
    category :: Text
  }
  deriving (Generic, Show)

instance FromRecord Record

toTransaction :: Record -> Maybe Tr.Transaction
toTransaction (Record {postDate, description, category, amount}) =
  Just
    Tr.Transaction
      { Tr.day = parseMDY postDate,
        Tr.category = category,
        Tr.delta = amount,
        Tr.description = description
      }

importDiscoverCardCSV :: Text -> [Pattern] -> Importer
importDiscoverCardCSV iName patterns =
  Importer
    { name = iName,
      getTransactionsAfter = importTransactionCSVs HasHeader toTransaction patterns
    }
