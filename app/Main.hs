module Main where

import App.Commands
import Control.Monad
import Options.Applicative

main :: IO ()
main = join $ customExecParser
  (prefs $ showHelpOnEmpty <> showHelpOnError)
  (info (cmdOpts <**> helper) idm)
