module CashMoney.Import.ChaseCardCSV where

import CashMoney.Data.Importer (Importer (..))
import qualified CashMoney.Data.Transaction as Tr
import qualified Data.ByteString.Lazy as BL
import Data.Csv (FromRecord)
import qualified Data.Csv as Csv
import Data.Text (Text, unpack)
import qualified Data.Text as T
import Data.Text.Format (format)
import Data.Text.Lazy (toStrict)
import Data.Time (defaultTimeLocale, parseTimeOrError)
import qualified Data.Vector as V
import GHC.Generics (Generic)

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

readRecords :: FilePath -> IO (V.Vector Record)
readRecords path = do
  csvData <- BL.readFile path
  case Csv.decode Csv.HasHeader csvData of
    Left err -> error err
    Right rs -> return rs

importChaseCardCSV :: Text -> FilePath -> Importer
importChaseCardCSV iName path =
  Importer
    { name = iName,
      getTransactionsAfter = \earliestDay -> do
        rs <- readRecords path
        let trs = map toTransaction $ V.toList rs
        return $ filter (\tr -> earliestDay <= Tr.day tr) trs
    }
