module CashMoney.Import.DiscoverCardCSVSpec where

import CashMoney.Data.Importer
import CashMoney.Import.DiscoverCardCSV
import Data.Time.Calendar (fromGregorian)
import System.FilePath.Glob
import Test.Hspec

spec :: Spec
spec = do
  describe "importDiscoverCardCSV" $ do
    it "imports from provided path" $ do
      let importer = importDiscoverCardCSV "coolboi" [compile "resources/test/discover-card/*"]
      result <- getTransactionsAfter importer (fromGregorian 2019 11 12)
      length result `shouldBe` (3 :: Int)
