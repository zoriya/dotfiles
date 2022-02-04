{-# LANGUAGE ScopedTypeVariables #-}

module Main where

import XMonad
import XMonad.Hooks.EwmhDesktops (ewmh, ewmhFullscreen)
import XMonad.Hooks.ManageDocks (docks, avoidStruts)
import XMonad.Layout.Named (named)
import XMonad.Layout.NoBorders (noBorders)
import XMonad.Util.WorkspaceCompare (getSortByIndex)
import XMonad.Hooks.StatusBar.PP (PP(..))
import XMonad.Hooks.StatusBar (StatusBarConfig, statusBarPipe, dynamicSBs)


main :: IO ()
main = xmonad
     -- . ewmhFullscreen
     -- . ewmh
     -- . docks
     . polybarEnable
     $ xConfig

polybarEnable :: XConfig a -> XConfig a
polybarEnable = dynamicSBs barSpawner
  where
    barSpawner :: ScreenId -> IO StatusBarConfig
    barSpawner x = statusBarPipe (barScript x) (pure basicPP)

    barScript (S x) = "~/.config/polybar/launch.sh " ++ show x

basicPP :: PP
basicPP = def
  { ppSep = "  "
  , ppWsSep = " "
  , ppTitleSanitize = filter (`notElem` ['%','{','}'])
  , ppOrder = layoutFirstOrder
  , ppSort = getSortByIndex
  , ppExtras = []
  , ppOutput = const mempty
  }
  where
    layoutFirstOrder (workspaces : layout : title : extras) =
      [layout] ++ extras ++ [workspaces, title]
    layoutFirstOrder other = other

-- polyPP :: ScreenId -> X PP
-- polyPP sid = pure $ basicPP
--   { ppCurrent = lemonbarFormat [ Foreground accent, Background white, Underline magenta ]
--   , ppVisible = lemonbarFormat [ Foreground blue, Background white, Underline magenta ]
--   , ppVisibleNoWindows = Just $
--       lemonbarFormat [ Foreground blue, Background white, Underline magenta ]
--   , ppHidden = lemonbarFormat [ Foreground blue, Underline magenta ]
--   , ppHiddenNoWindows = lemonbarFormat [ Foreground magenta ]
--   , ppUrgent = lemonbarFormat [ Foreground blue, Background magenta ]
--   , ppTitle = lemonbarFormat [ Foreground blue ] . shorten 50
--   , ppLayout = lemonbarFormat [ Foreground blue ]
--   }
--   -- { ppCurrent = lemonbarFormat [Background accent]
--   -- -- , ppExtras  = [logTitlesOnScreen sid formatFocused formatUnfocused]
--   -- --, ppSep     = magenta " • "
--   -- }
--  where
--   -- formatFocused, formatUnfocused :: String -> String
--   -- formatFocused   = wrap (white    "[") (white    "]") . magenta . ppWindow
--   -- formatUnfocused = wrap (lowWhite "[") (lowWhite "]") . blue    . ppWindow

  -- -- | Windows should have *some* title, which should not not exceed a
  -- -- sane length.
  -- ppWindow :: String -> String
  -- ppWindow = xmobarRaw
  --          . (\w -> if null w then "untitled" else w)
  --          . shorten 30
  --          . xmobarStrip




xConfig = def
    { modMask = mod4Mask  -- Rebind Mod to the Super key
    , terminal = "kitty"
    , layoutHook = layouts
    }

layouts = named "[]=" (avoidStruts $ Tall nmaster delta ratio)
      ||| named "[M]" (avoidStruts $ noBorders Full)
    where
        nmaster = 1
        ratio = 50/100
        delta = 5/100

