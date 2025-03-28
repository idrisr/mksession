module Main where

import Data.List.NonEmpty
import Data.Text
import NeatInterpolation
import Options.Applicative
import System.FilePath
import Turtle hiding (header)
import Prelude hiding (writeFile)

opts :: ParserInfo ()
opts =
    info
        (pure () <**> helper)
        ( fullDesc
            <> progDesc
                "make tmuxp session file based on name of current working directory"
            <> header "make tmuxp session file"
        )

newtype Directory = Directory Text
newtype Session = Session Text

main :: IO ()
main = execParser opts >> sh writeFile

writeFile :: Shell ()
writeFile = do
    dir <- pwd
    output (dir </> "session.yaml") $ select . toList . textToLines $ mkSession (dirName dir) (sessionName dir)

sessionName :: FilePath -> Session
sessionName = Session . pack . takeFileName

dirName :: FilePath -> Directory
dirName = Directory . pack

mkSession :: Directory -> Session -> Text
mkSession (Directory dir) (Session session) =
    [trimming|
session_name: $session
windows:
  - window_name: haskell
    layout: main-vertical
    panes:
      - shell_command:
        - cd $dir
    options:
      main-pane-width: 80

  - window_name: latex
    layout: tiled
    shell_command_before:
      - cd $dir/doc && git status
  |]
