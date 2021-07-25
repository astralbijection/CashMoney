module CashMoney.Import.ChaseCardCSV where

import CashMoney.Data.Importer (Importer (..))
import qualified CashMoney.Data.Transaction as Tr
import CashMoney.Import.Util (importTransactionCSVs)
import Data.Csv (FromRecord, HasHeader(HasHeader))
import qualified Data.Csv as Csv
import Data.Text (Text)
import qualified Data.Text as T
import Data.Text.Format (format)
import Data.Text.Lazy (toStrict)
import Data.Time (defaultTimeLocale, parseTimeOrError)
import GHC.Generics (Generic)
import System.FilePath.Glob

data Record = Record
  { transactionDate :: Text,
    postDate :: String,
    description :: Text,
    category :: Text,
    tType :: Text,
    amount :: Float,
    memo :: Text
  }
  deriving (Generic, Show)

instance FromRecord Record

toTransaction :: Record -> Tr.Transaction
toTransaction (Record {postDate, description, category, amount, memo}) =
  let desc =
        if T.length memo > 0
          then toStrict $ format "{} | {}" (description, memo)
          else description
      day = parseTimeOrError True defaultTimeLocale "%m/%d/%Y" postDate
   in Tr.Transaction
        { Tr.day = day,
          Tr.category = category,
          Tr.delta = amount,
          Tr.description = desc
        }

importChaseCardCSV :: Text -> [Pattern] -> Importer
importChaseCardCSV iName patterns =
  Importer
    { name = iName,
      getTransactionsAfter = importTransactionCSVs HasHeader toTransaction patterns
    }
