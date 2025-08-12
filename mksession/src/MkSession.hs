{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}

module MkSession where

import Data.Aeson.TH (deriveToJSON)
import GHC.Generics (Generic)
import MkSessionUtils
import System.FilePath (takeBaseName)

data Session = Session
    { session_name :: String
    , windows :: [Window]
    }
    deriving (Show, Generic)

data Window = Window
    { window_name :: String
    , layout :: String
    , panes :: Maybe [Pane]
    , shell_command_before :: Maybe [String]
    , options :: Maybe WindowOptions
    }
    deriving (Show, Generic)

newtype Pane = Pane
    {shell_command :: [String]}
    deriving (Show, Generic)

newtype WindowOptions = WindowOptions
    { main_pane_width :: Int
    }
    deriving (Show, Generic)

deriveToJSON (opts True) ''WindowOptions
deriveToJSON (opts False) ''Pane
deriveToJSON (opts False) ''Window
deriveToJSON (opts False) ''Session

-- currently I just use session with a latex and haskell pane.
-- Adjust this accordingly when requirements change
defaultSession :: FilePath -> Session
defaultSession fp =
    Session
        { session_name = takeBaseName fp
        , windows =
            [ Window
                { window_name = "haskell"
                , layout = "main-vertical"
                , panes =
                    Just
                        [Pane{shell_command = ["cd " ++ fp]}]
                , shell_command_before = Nothing
                , options = Just (WindowOptions 80)
                }
            , Window
                { window_name = "latex"
                , layout = "tiled"
                , panes = Nothing
                , shell_command_before = Just ["cd " ++ fp ++ " && git status"]
                , options = Nothing
                }
            ]
        }
