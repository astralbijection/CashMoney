module CashMoney.Import.Util where

import CashMoney.Data.Transaction (Transaction)
import qualified CashMoney.Data.Transaction as Tr
import qualified Data.ByteString.Lazy as BL
import Data.Csv (FromRecord, HasHeader (HasHeader), decode)
import Data.Time.Calendar (Day)
import Data.Vector (Vector)
import qualified Data.Vector as V
import System.FilePath.Glob

readGlobbedCSVs :: FromRecord a => HasHeader -> [Pattern] -> IO [Vector a]
readGlobbedCSVs hasHeader globs = do
  paths <- globDir globs "."
  let paths' = concat paths

  files <- mapM BL.readFile paths'
  let results = map (decode HasHeader) files
  return $
    let handleResult (Left err) = error err
        handleResult (Right result) = result
     in map handleResult results

importTransactionCSVs :: FromRecord a => HasHeader -> (a -> Transaction) -> [Pattern] -> Day -> IO [Transaction]
importTransactionCSVs hasHeader recordToTransaction patterns earliestDay = do
  rss <- readGlobbedCSVs hasHeader patterns
  return $ concatMap decodeTransactions rss
  where
    decodeTransactions rs =
      let trs = map recordToTransaction $ V.toList rs
       in filter (\tr -> earliestDay < Tr.day tr) trs
