module CashMoney.Import.EBayCardCSV where

import CashMoney.Data.Importer (Importer (..))
import qualified CashMoney.Data.Transaction as Tr
import CashMoney.Import.Util (importTransactionCSVs, parseMDY)
import Data.Csv (FromRecord, HasHeader (HasHeader))
import Data.Text (Text)
import qualified Data.Text as T
import Data.Text.Format (format)
import Data.Text.Lazy (toStrict)
import GHC.Generics (Generic)
import System.FilePath.Glob (Pattern)

data Record = Record
  { transactionDate :: Text,
    postDate :: String,
    referenceNumber :: Text,
    amount :: Float,
    description :: Text
  }
  deriving (Generic, Show)

instance FromRecord Record

toTransaction :: Record -> Maybe Tr.Transaction
toTransaction Record {postDate, description, amount, referenceNumber} =
  let desc =
        if T.length referenceNumber > 0
          then toStrict $ format "{} ({})" (description, referenceNumber)
          else description
   in Just
        Tr.Transaction
          { Tr.day = parseMDY postDate,
            Tr.category = "Shopping",
            Tr.delta = amount,
            Tr.description = desc
          }

importEBayCardCSV :: Text -> [Pattern] -> Importer
importEBayCardCSV iName patterns =
  Importer
    { name = iName,
      getTransactionsAfter = importTransactionCSVs HasHeader toTransaction patterns
    }
