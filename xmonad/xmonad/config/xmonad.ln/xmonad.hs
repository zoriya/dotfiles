{-# LANGUAGE ScopedTypeVariables #-}

import Data.Maybe (mapMaybe)
import GHC.IO.Handle (hClose, hDuplicateTo, Handle)
import Data.List.Utils (split)
import System.Posix.Process (getProcessID)
import System.Posix.Types (CPid(..))
import Text.Read (readMaybe, Lexeme (String))
import Text.Printf (printf)

import XMonad
import XMonad.Actions.Navigation2D (withNavigation2DConfig)
import XMonad.Config.Dmwit (outputOf)
-- import XMonad.Hooks.DynamicBars (dynStatusBarStartup, dynStatusBarEventHook)
import XMonad.Hooks.DynamicLog (dynamicLogWithPP, PP (..), wrap, shorten)
import XMonad.Hooks.EwmhDesktops (ewmh, ewmhFullscreen)
import XMonad.Hooks.ManageDocks (docks, avoidStruts)
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP
import XMonad.Layout.Named (named)
import XMonad.Layout.NoBorders (noBorders)
import XMonad.Util.Run (spawnPipe)


main :: IO ()
main = xmonad
     . ewmhFullscreen
     . ewmh
     . docks
     . polybarEnable
     $ xConfig

monitorIds :: IO [(ScreenId, String)]
monitorIds = do
  output <- outputOf "xrandr --listactivemonitors 2>/dev/null | awk '{print $1 $4}'"
  return $ mapMaybe parseMonitor . drop 1 $ lines output
  where
    parseMonitor :: String -> Maybe (ScreenId, String)
    parseMonitor text =
      case split ":" text of
        [idText, monitor] -> do
          id <- readMaybe idText
          return (S id, monitor)
        _ -> Nothing

polybarStartup :: ScreenId -> IO Handle
polybarStartup screenId = do
  monitors <- monitorIds
  case lookup screenId monitors of
    Just monitor -> spawnPipe $ "bin/polybar-start-monitor.sh " <> monitor
    Nothing -> error $ "No monitor tound for " ++ show screenId ++ " in " ++ show monitors

polybarCleanup :: IO ()
polybarCleanup = do
  (CPid pid) <- getProcessID
  spawn $ printf "pkill --parent %d bin/polybar-start-monitor.sh" pid

polybarEnable :: XConfig a -> XConfig a
polybarEnable = dynamicSBs barSpawner
  where
    barSpawner :: ScreenId -> IO StatusBarConfig
    barSpawner (S x) = statusBarPipe (barScript x) (pure xmobarPP)

    barScript x = "~/.config/polybar/launch.sh " ++ show x

  -- case layoutHook of
  --   Layout layout ->
  --     config
  --       { startupHook     = startupHook      <+> dynStatusBarStartup polybarStartup polybarCleanup
  --       , handleEventHook = handleEventHook  <+> dynStatusBarEventHook polybarStartup polybarCleanup
  --       , logHook         = logHook          <+> multiPP' chosenPP
  --       , layoutHook      = Layout $ avoidStruts layout
  --       }
  --       where multiPP' (pp1, pp2) = join $ multiPP <$> pp1 <*> pp2

colorBg       :: String = "#282A36"
colorBlue     :: String = "#bd93f9"
colorCyan     :: String = "#8be9fd"
colorFg       :: String = "#f8f8f2"
colorLowWhite :: String = "#bbbbbb"
colorMagenta  :: String = "#ff79c6"
colorRed      :: String = "#ff5555"
colorYellow   :: String = "#f1fa8c"

-- | Set the status bar colours based the ones defined above.
-- @ xmobarColor "foreground colour" "background colour" @
blue, lowWhite, magenta, red, white, yellow :: String -> String
magenta  = xmobarColor colorMagenta  ""
blue     = xmobarColor colorBlue     ""
white    = xmobarColor colorFg       ""
yellow   = xmobarColor colorYellow   ""
red      = xmobarColor colorRed      ""
lowWhite = xmobarColor colorLowWhite ""



-- -- | Building my own pretty-printer.
-- xmobarPP :: ScreenId -> X PP
-- xmobarPP sid = pure $ def
--   { ppSep     = magenta " • "
--   , ppCurrent = wrap " " "" . xmobarBorder "Top" colorCyan 2
--   , ppHidden  = white . wrap " " ""
--   , ppUrgent  = red   . wrap (yellow "!") (yellow "!")
--   , ppOrder   = \[ws, l, _, wins] -> [ws, l, wins]
--   , ppExtras  = [logTitlesOnScreen sid formatFocused formatUnfocused]
--   }
--  where
--   formatFocused, formatUnfocused :: String -> String
--   formatFocused   = wrap (white    "[") (white    "]") . magenta . ppWindow
--   formatUnfocused = wrap (lowWhite "[") (lowWhite "]") . blue    . ppWindow

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

