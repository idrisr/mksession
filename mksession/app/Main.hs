{-# LANGUAGE OverloadedStrings #-}

module Main where

import Data.Yaml (encodeFile)
import MkSession
import Options.Applicative
import System.Directory (getCurrentDirectory)
import System.FilePath

opts :: ParserInfo ()
opts =
    info
        (pure () <**> helper)
        ( fullDesc
            <> progDesc
                "make tmuxp session file based on name of current working directory"
            <> header "make tmuxp session file"
        )

main :: IO ()
main = do
    execParser opts
    pwd <- getCurrentDirectory
    encodeFile (pwd </> "session.yaml") (defaultSession pwd)
