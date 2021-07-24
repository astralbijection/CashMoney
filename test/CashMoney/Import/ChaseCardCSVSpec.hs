module CashMoney.Import.ChaseCardCSVSpec where

import Data.Time.Calendar (fromGregorian)
import Test.Hspec
import CashMoney.Data.Importer
import CashMoney.Import.ChaseCardCSV


spec :: Spec
spec = do
  describe "ChaseCardCSV" $ do
    it "imports credit card CSVs" $ do
      let importer = importChaseCardCSV "coolboi" "resources/test/chase-cred/MyCard1.csv"
      result <- (getTransactionsAfter importer) (fromGregorian 2021 7 5)
      length result `shouldBe` (5 :: Int)
