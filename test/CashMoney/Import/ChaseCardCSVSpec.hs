module CashMoney.Import.ChaseCardCSVSpec where

import CashMoney.Data.Importer
import CashMoney.Import.ChaseCardCSV
import Data.Time.Calendar (fromGregorian)
import System.FilePath.Glob
import Test.Hspec

spec :: Spec
spec = do
  describe "importChaseCardCSV" $ do
    it "imports from provided path" $ do
      let importer = importChaseCardCSV "coolboi" [compile "resources/test/chase-cred/MyCard1.csv"]
      result <- (getTransactionsAfter importer) (fromGregorian 2021 7 5)
      length result `shouldBe` (4 :: Int)
