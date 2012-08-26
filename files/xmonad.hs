import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.SetWMName
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Layout.Circle
import XMonad.Layout.Fullscreen
import XMonad.Layout.NoBorders
import XMonad.Layout.Spiral
import XMonad.Layout.Tabbed
import System.IO
import System.Exit


myManageHook = composeAll
    [ className =? "Gimp"      --> doFloat
    , className =? "Vncviewer" --> doFloat
    , resource  =? "wireshark" --> doFloat
    ]


myLayout = avoidStruts (
    Tall 1 (3/100) (1/2) |||
    Mirror (Tall 1 (3/100) (1/2)) |||
    tabbed shrinkText tabConfig |||
    Full |||
    spiral (6/7)) |||
    noBorders (fullscreenFull Full)


-- Colors for text and backgrounds of each tab when in "Tabbed" layout.
tabConfig = defaultTheme {
    activeBorderColor = "#7C7C7C",
    activeTextColor = "#CEFFAC",
    activeColor = "#000000",
    inactiveBorderColor = "#7C7C7C",
    inactiveTextColor = "#EEEEEE",
    inactiveColor = "#000000"
}
 

main = do
    xmproc <- spawnPipe "/usr/bin/xmobar /root/.xmobarrc"
    
    xmonad $ defaultConfig
        { 
        --, layoutHook = avoidStruts $ Circle ||| layoutHook defaultConfig
        terminal="gnome-terminal",
        manageHook = manageDocks <+> myManageHook <+> manageHook defaultConfig
        -- , layoutHook = avoidStruts  $  layoutHook defaultConfig
        , layoutHook = smartBorders $ myLayout
        , logHook = dynamicLogWithPP xmobarPP
                        { ppOutput = hPutStrLn xmproc
                        , ppTitle = xmobarColor "lightblue" "" . shorten 50
                        }
        , borderWidth=4
        , normalBorderColor = "black"
        , focusedBorderColor = "lightblue"
        } 
