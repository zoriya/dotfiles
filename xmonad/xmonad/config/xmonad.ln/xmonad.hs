import XMonad
import XMonad.Actions.Navigation2D (withNavigation2DConfig)
import XMonad.Hooks.DynamicLog (dynamicLogWithPP, PP (..), wrap, shorten)
import XMonad.Hooks.EwmhDesktops (ewmh, ewmhFullscreen)
import XMonad.Hooks.ManageDocks (docks, avoidStruts)
import XMonad.Layout.Named (named)
import XMonad.Layout.NoBorders (noBorders)

import qualified DBus as D
import qualified DBus.Client as D
import qualified Codec.Binary.UTF8.String as UTF8

main :: IO ()
main = xmonad
     . ewmhFullscreen
     . ewmh
     . docks
   =<< dbusLog
       xConfig

fg        = "#ebdbb2"
bg        = "#282828"
gray      = "#a89984"
bg1       = "#3c3836"
bg2       = "#504945"
bg3       = "#665c54"
bg4       = "#7c6f64"

green     = "#b8bb26"
darkgreen = "#98971a"
red       = "#fb4934"
darkred   = "#cc241d"
yellow    = "#fabd2f"
blue      = "#83a598"
purple    = "#d3869b"
aqua      = "#8ec07c"

dbusLog :: XConfig a -> IO (XConfig a)
dbusLog c = do
    dbus <- D.connectSession
    D.requestName dbus (D.busName_ "org.xmonad.Log")
        [D.nameAllowReplacement, D.nameReplaceExisting, D.nameDoNotQueue]
    return $ withNavigation2DConfig def c
        { logHook = dynamicLogWithPP (logHook dbus)
        }
    where
        logHook :: D.Client -> PP
        logHook dbus = def
            { ppOutput = dbusOutput dbus
            , ppCurrent = wrap ("%{B" ++ bg2 ++ "} ") " %{B-}"
            , ppVisible = wrap ("%{B" ++ bg1 ++ "} ") " %{B-}"
            , ppUrgent = wrap ("%{F" ++ red ++ "} ") " %{F-}"
            , ppHidden = wrap " " " "
            , ppWsSep = ""
            , ppSep = " : "
            , ppTitle = shorten 40
            }

        dbusOutput :: D.Client -> String -> IO ()
        dbusOutput dbus str = do
            let signal = (D.signal objectPath interfaceName memberName) {
                    D.signalBody = [D.toVariant $ UTF8.decodeString str]
                }
            D.emit dbus signal
          where
            objectPath = D.objectPath_ "/org/xmonad/Log"
            interfaceName = D.interfaceName_ "org.xmonad.Log"
            memberName = D.memberName_ "Update"


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

