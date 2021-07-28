module CashMoney.Import.EBayCardCSVSpec where

import CashMoney.Data.Importer
import CashMoney.Import.EBayCardCSV
import Data.Time.Calendar (fromGregorian)
import System.FilePath.Glob
import Test.Hspec

spec :: Spec
spec = do
  describe "ChaseBankCSV" $ do
    it "imports from provided path" $ do
      let importer = importEBayCardCSV "coolboi" [compile "resources/test/ebay-card/*"]
      result <- getTransactionsAfter importer (fromGregorian 2020 3 16)
      length result `shouldBe` (4 :: Int)
