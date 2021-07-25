module CashMoney.Import.ChaseBankCSV where

import CashMoney.Data.Importer (Importer (..))
import qualified CashMoney.Data.Transaction as Tr
import CashMoney.Import.Util (importTransactionCSVs)
import Data.Csv (FromRecord, HasHeader (HasHeader))
import Data.Text (Text)
import Data.Text.Format (format)
import Data.Text.Lazy (toStrict)
import Data.Time (defaultTimeLocale, parseTimeOrError)
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
    _unknown :: Text  -- gotta love shittily-formed data
  }
  deriving (Generic, Show)

instance FromRecord Record

toTransaction :: Record -> Tr.Transaction
toTransaction (Record {postDate, description, amount, tType, checkOrSlipNumber}) =
  let desc = toStrict $ format "{} ({})" (description, checkOrSlipNumber)
      day = parseTimeOrError True defaultTimeLocale "%m/%d/%Y" postDate
   in Tr.Transaction
        { Tr.day = day,
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
