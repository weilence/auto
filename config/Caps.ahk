#Requires AutoHotkey v2.0

CapsLock::
{
    if (KeyWait("CapsLock", "T0.5") == 1) {
        Send "^+{Space}"
    } else {
        SetCapsLockState !GetKeyState("CapsLock", "T")
        KeyWait "CapsLock"
    }
}  
