module CashMoney.Import.ChaseBankCSV where

import CashMoney.Data.Importer (Importer (..))
import qualified CashMoney.Data.Transaction as Tr
import CashMoney.Import.Util (importTransactionCSVs, parseMDY)
import Data.Csv (FromRecord, HasHeader (HasHeader))
import Data.Text (Text)
import Data.Text.Format (format)
import Data.Text.Lazy (toStrict)
import GHC.Generics (Generic)
import System.FilePath.Glob (Pattern)

data Record = Record
  { details :: Text,
    postDate :: String,
    description :: Text,
    amount :: Float,
    tType :: Text,
    balance :: Float,
    checkOrSlipNumber :: Text,
    _unknown :: Text -- gotta love shittily-formed data
  }
  deriving (Generic, Show)

instance FromRecord Record

toTransaction :: Record -> Maybe Tr.Transaction
toTransaction (Record {postDate, description, amount, tType, checkOrSlipNumber}) =
  let desc = toStrict $ format "{} ({})" (description, checkOrSlipNumber)
   in Just
        Tr.Transaction
          { Tr.day = parseMDY postDate,
            Tr.category = tType,
            Tr.delta = amount,
            Tr.description = desc
          }

importChaseBankCSV :: Text -> [Pattern] -> Importer
importChaseBankCSV iName patterns =
  Importer
    { name = iName,
      getTransactionsAfter = importTransactionCSVs HasHeader toTransaction patterns
    }
