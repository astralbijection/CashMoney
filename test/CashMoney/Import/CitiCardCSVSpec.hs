module CashMoney.Import.CitiCardCSVSpec where

import CashMoney.Data.Importer
import CashMoney.Import.CitiCardCSV
import Data.Time.Calendar (fromGregorian)
import System.FilePath.Glob
import Test.Hspec

spec :: Spec
spec = do
  describe "importCitiCardCSV" $ do
    it "imports from provided path" $ do
      let importer = importCitiCardCSV "coolboi" [compile "resources/test/citi-card/*"]
      result <- getTransactionsAfter importer (fromGregorian 2020 3 16)
      length result `shouldBe` (10 :: Int)
