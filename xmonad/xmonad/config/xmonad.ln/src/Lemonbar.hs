module Lemonbar where

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
    (Foreground color)      -> wrap (bracket $ format1 "F{}" color) (bracket "F-")
    (Background color)      -> wrap (bracket $ format1 "B{}" color) (bracket "B-")
    (Reverse)               -> wrap (bracket "R") (bracket "R")
    (Underline color)       -> wrap (bracket (format1 "u{}" color) <> bracket "+u") (bracket "-u")
    (Overline color)        -> wrap (bracket (format1 "o{}" color) <> bracket "+o") (bracket "-o")
    (Font index)            -> wrap (bracket (format1 "T{}" index)) (bracket "T-")
    (Offset size)           -> (bracket (format1 "O{}" size) <>)
    (Action button cmd)     -> wrap (bracket (format "A{}:{}:" (fromMouseButton button, (escape ':' cmd))))
                                    (bracket "A")
    where
        bracket = wrap "%{" "}"
        escape char =
            let charT = T.singleton char in
            T.replace charT (T.cons '\\' charT)

lemonbarFormat :: [LemonbarFormatting] -> String -> String
lemonbarFormat fmts = foldr (.) id (lemonbarFormatOne <$> fmts)
