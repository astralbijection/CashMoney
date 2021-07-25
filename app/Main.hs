module Main where
  
import Options.Applicative
import CashMoney.CLI

main :: IO ()
main = do
         args <- execParser parserInfo
         run args
