module CashMoney.CLI where

import qualified Data.Text.IO as TIO
import qualified Data.Text.Lazy as TL
import Options.Applicative
import System.Exit (ExitCode (ExitFailure), exitWith)
import Text.RawString.QQ

data RunArgs = RunArgs
  { configFile :: FilePath,
    runType :: RunType
  }
  deriving (Show)

data RunType = Load LoadOptions | Meme deriving (Show)

data LoadOptions = LoadOptions
  { clean :: Bool
  }
  deriving (Show)

parserInfo :: ParserInfo RunArgs
parserInfo =
  info
    (parser <**> helper)
    ( fullDesc
        <> header "CashMoney"
        <> progDesc "An app for managing your Cash and your Money"
    )

parser :: Parser RunArgs
parser =
  RunArgs
    <$> strOption (long "config" <> short 'c' <> help "configuration file" <> showDefault <> value "cashmoney.yaml")
    <*> (subparser loadCommand <|> easterEggParser)

run :: RunArgs -> IO ()
run args = case runType args of
  Meme -> do
    TIO.putStrLn $ TL.toStrict sayaka
    exitWith (ExitFailure 1)
  Load options -> do
    putStrLn $ "Config file " ++ configFile args
    putStrLn $ show options
    return ()

loadCommand :: Mod CommandFields RunType
loadCommand = command "load" (info loadParser (progDesc "Load data"))
  where
    loadParser =
      Load <$> LoadOptions
        <$> flag False True (long "clean" <> short 'k' <> help "Clear caches")

easterEggParser :: Parser RunType
easterEggParser =
  subparser $ memeCommand <> hidden <> internal
  where
    memeCommand =
      (command "of" (info (subparser memeSubcommand) mempty))
    memeSubcommand = command "you" (info (pure Meme) mempty)

sayaka :: TL.Text
sayaka =
  [r|
   .:/yo+++oos+++s++++++oomNNNNNmy+-o/ `sssooooo+:                              
    `o+oss+++s++o++++++++smNNNNNNNNNdhsssyhsooooo-                              
    /o/.y+++os++o:+++++++yNNNNNNNNNs:hNNNNmNmhs+o`   ``....`                    
    :` //+++oy++o::++++o+smMMMMMNd/  oNNNNNNNmy+/`-...`    `....`               
       o+///os+//+:+++/oo+:+yhhy/`  `/NNNNNNNh+o/-`             `..`            
      -s///+soo///+so///+/+`          omNMMNh+o:                   ..`          
    `-+o+/:-s+s+/++oo+/+-`:-  ,---`    `:+ds+o.                      ..         
    `` ``  `//+s/oso///y-.`` |    |     `-s+o`                        `-        
           ``:`-oo:/``o:.-:/.-----   ``.oh+o-                        .-.-       
        .-.``.---:-:.`. ``-+ys:.`.-ss/:hNo/o      That wasn't         .: :`      
      `-.         .://:-```.:-:/` -o-:ys- :/      very cash            ` .-      
    `-.          ``-::://:/:::+o. ``..`   .-      money of              `:      
 ``--`        ` ``` ``..`.--.-:+:.```     `:      you                   .-      
.--.          `   ..`` `   `..-/`  ``..    /                            :`      
..`            `:+-`            -`    ..   -.                           /       
`           `-/+:` ..:..--..--.....`   :`   -`                         -.       
         .:+os+---:.`--.--..-:```-::-`  :`   -.`                      .-        
     `:/oooyo+-:..-/+syhhys++/---//ooo+-`..   .-`                    --         
 `.:hmdo+/s+o--:/shhhhhhhhhhhhyyhhdhdhhho:--   `..`               `--`          
dNsoho/////s++ohhhhhhhhhhhhhhhhhhdhhhhyyh++//     .-..        `.--.             
Ndo++/////o+shhhhhhhhhhhhhhhhhhhhhhhhhhyhs//++`       ..-::-::.`                
o+/+++//+o+/+shhhhhhhhhhhhhhhhhhhhhhhhhhmh+/+//       `.--:..`-....-            |]
