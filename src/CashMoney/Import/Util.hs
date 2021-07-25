module CashMoney.Import.Util where

import qualified Data.ByteString.Lazy as BL
import Data.Csv (FromRecord, HasHeader (HasHeader), decode)
import Data.Text (pack)
import Data.Vector (Vector)
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
