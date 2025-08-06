module MkSessionUtils where

import Data.Aeson (fieldLabelModifier, omitNothingFields)
import Data.Aeson.TH (Options, defaultOptions)

-- Convert snake_case → kebab-case
kebabify :: String -> String
kebabify = map (\c -> if c == '_' then '-' else c)

opts :: Bool -> Options
opts b =
    defaultOptions
        { fieldLabelModifier = if b then kebabify else id
        , omitNothingFields = True
        }
