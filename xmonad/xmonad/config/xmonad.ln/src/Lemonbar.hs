module Lemonbar where
import Data.List.Utils (replace)
import XMonad.Hooks.DynamicLog (wrap)

type Color = String

data MouseButton
    = LeftClick
    | MiddleClick
    | RightClick
    | ScrollUp
    | ScrollDown
    | DoubleLeftClick
    | DoubleMiddleClick
    | DoubleRightClick
    deriving (Eq, Ord, Show, Enum)

fromMouseButton :: MouseButton -> Int
fromMouseButton = succ . fromEnum

data LemonbarFormatting
    = Foreground Color
    | Background Color
    | Reverse
    | Underline Color
    | Overline Color
    | Font Int
    | Offset Int
    | Action MouseButton String
    deriving (Eq, Show)

lemonbarFormatOne :: LemonbarFormatting -> String -> String
lemonbarFormatOne fmt = case fmt of
    (Foreground color)      -> wrap (bracket $ "F" <> color) (bracket "F-")
    (Background color)      -> wrap (bracket $ "B" <> color) (bracket "B-")
    Reverse                 -> wrap (bracket "R") (bracket "R")
    (Underline color)       -> wrap (bracket ("u" <> color) <> bracket "+u") (bracket "-u")
    (Overline color)        -> wrap (bracket ("o" <> color) <> bracket "+o") (bracket "-o")
    (Font index)            -> wrap (bracket ("T" <> show index)) (bracket "T-")
    (Offset size)           -> (bracket ("O" <> show size) <>)
    (Action button cmd)     -> wrap (bracket (format "A{}:{}:" (fromMouseButton button, escape ':' cmd)))
                                    (bracket "A")
    where
        escape :: Char -> String -> String
        escape char = replace [char] ('\\':[char])

        bracket :: String -> String
        bracket = wrap "%{" "}"

lemonbarFormat :: [LemonbarFormatting] -> String -> String
lemonbarFormat fmts = foldr (.) id (lemonbarFormatOne <$> fmts)
