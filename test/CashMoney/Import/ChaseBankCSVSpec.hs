module CashMoney.Import.ChaseBankCSVSpec where

import CashMoney.Data.Importer
import CashMoney.Import.ChaseBankCSV
import Data.Time.Calendar (fromGregorian)
import System.FilePath.Glob
import Test.Hspec

spec :: Spec
spec = do
  describe "ChaseBankCSV" $ do
    it "imports bank CSVs" $ do
      let importer = importChaseBankCSV "coolboi" [compile "resources/test/chase-bank/CheckingAccount.csv"]
      result <- (getTransactionsAfter importer) (fromGregorian 2020 3 16)
      length result `shouldBe` (5 :: Int)
