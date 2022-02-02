{-# LANGUAGE ScopedTypeVariables #-}

module Main where

import Data.Maybe (mapMaybe)
import GHC.IO.Handle (hClose, hDuplicateTo, Handle)
import Data.List.Utils (split)
import System.Posix.Process (getProcessID)
import System.Posix.Types (CPid(..))
import Text.Read (readMaybe, Lexeme (String))
import Text.Printf (printf)

import Lemonbar

import XMonad
import XMonad.Actions.Navigation2D (withNavigation2DConfig)
import XMonad.Config.Dmwit (outputOf)
import XMonad.Hooks.DynamicLog (dynamicLogWithPP, PP (..), wrap, shorten)
import XMonad.Hooks.EwmhDesktops (ewmh, ewmhFullscreen)
import XMonad.Hooks.ManageDocks (docks, avoidStruts)
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP
import XMonad.Layout.Named (named)
import XMonad.Layout.NoBorders (noBorders)
import XMonad.Util.Run (spawnPipe)
import XMonad.Util.Loggers


main :: IO ()
main = xmonad
     . ewmhFullscreen
     . ewmh
     . docks
     . polybarEnable
     $ xConfig

polybarEnable :: XConfig a -> XConfig a
polybarEnable = dynamicSBs barSpawner
  where
    barSpawner :: ScreenId -> IO StatusBarConfig
    barSpawner x = statusBarPipe (barScript x) (polyPP x)

    barScript (S x) = "~/.config/polybar/launch.sh " ++ show x

polyPP :: ScreenId -> X PP
polyPP sid = pure $ def
  { ppCurrent = lemonbarFormat [Background accent]
  , ppExtras  = [logTitlesOnScreen sid formatFocused formatUnfocused]
  --, ppSep     = magenta " • "
  }
 where
  formatFocused, formatUnfocused :: String -> String
  formatFocused   = wrap (white    "[") (white    "]") . magenta . ppWindow
  formatUnfocused = wrap (lowWhite "[") (lowWhite "]") . blue    . ppWindow

  -- | Windows should have *some* title, which should not not exceed a
  -- sane length.
  ppWindow :: String -> String
  ppWindow = xmobarRaw
           . (\w -> if null w then "untitled" else w)
           . shorten 30
           . xmobarStrip




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

