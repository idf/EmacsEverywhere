;
; AutoHotkey Version: 1.x
; Language:         English
; Platform:         WinNT
; Script Function:
;   Provides an Emacs-like keybinding emulation mode that can be toggled on and off using
;   the ctrl+` key.
;

;==========================
;Initialization
;==========================
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
SetCapsLockState, AlwaysOff ; diable the CapsLock key

#InstallKeybdHook
#UseHook

enabledIcon := "EmacsEverywhere_on.ico"
disabledIcon := "EmacsEverywhere_off.ico"
; C-x status
is_pre_x = 0
; C-Space status
is_pre_spc = 0
EmacsModeStat := false
SetEmacsMode(true)

;==========================
;Timer Subroutine
;==========================
KeyX:
  SetTimer, KeyX, off
  global is_pre_x = 0
  return

;==========================
;Bind Caps to RCtrl
;==========================
CapsLock::RCtrl

;==========================
;Emacs mode toggle
;==========================
^`::
  SetEmacsMode(!EmacsModeStat)

return

SetEmacsMode(toActive) {
  local iconFile := toActive ? enabledIcon : disabledIcon
  local state := toActive ? "ON" : "OFF"

  EmacsModeStat := toActive
  ;TrayTip, Emacs Everywhere, Emacs mode is %state%, 10, 1
  Menu, Tray, Icon, %iconFile%,
  Menu, Tray, Tip, Emacs Everywhere`nEmacs mode is %state%

  Send {Shift Up}
}


;==========================
; temp 
;==========================
>^<^!C::ToggleCapsLock()
ToggleCapsLock() {
SetCapsLockState, AlwaysOff ; diable the CapsLock key
}

;==========================
;is target
; WinActive("ahk_class Chrome_WidgetWin_1") ||
;==========================
is_target() {
  ; force on for rider and clion (ahk_class is SunAwtFrame)
  if (WinActive("ahk_exe rider64.exe") || WinActive("ahk_exe clion64.exe")) {
    return true
  }
  ; force off for various programs, mainly emacs
  if (WinActive("ahk_class Emacs") || WinActive("ahk_class Console_2_Main") || WinActive("ahk_class PuTTY") || WinActive("ahk_class SunAwtFrame") || WinActive("ahk_class VirtualConsoleClass")) {
    return false
  }
  ; default to true
  return true
}

IsInEmacsMode() {
  global EmacsModeStat
if (EmacsModeStat && is_target()) {
    return true
  } else {
    return false
  }
}

;==========================
;Action Functions
;==========================
delete_char() {
  Send {Del}
  global is_pre_spc = 0
  Return
}

delete_backward_char() {
  Send {BS}
  global is_pre_spc = 0
  Return
}

kill_line() {
  Send {ShiftDown}{END}{SHIFTUP}
  Sleep 10 ;[ms]
  Send ^x
  ;if (RegExMatch(clipboard, "aa") > 0)
  ;{
  ;  Send ^o
  ;}


  global is_pre_spc = 0
  Return
}

open_line() {
  Send {END}{Enter}{Up}
  global is_pre_spc = 0
  Return
}

quit() {
  Send {ESC}
  global is_pre_spc = 0
  Return
}

newline() {
  Send {Enter}
  global is_pre_spc = 0
  Return
}

indent_for_tab_command() {
  Send {Tab}
  global is_pre_spc = 0
  Return
}

newline_and_indent() {
  Send {Enter}{Tab}
  global is_pre_spc = 0
  Return
}

isearch_forward() {
  Send ^f
  global is_pre_spc = 0
  Return
}

isearch_backward() {
  Send ^f
  global is_pre_spc = 0
  Return
}

kill_region() {
  Send ^x
  global is_pre_spc = 0
  Return
}

kill_ring_save() {
  Send ^c
  global is_pre_spc = 0
  Return
}

yank() {
  Send ^v
  global is_pre_spc = 0
  Return
}

undo() {
  Send ^z
  global is_pre_spc = 0
  Return
}

find_file() {
  Send ^o
  global is_pre_x = 0
  Return
}

save_buffer() {
  Send, ^s
  global is_pre_x = 0
  Return
}

kill_emacs() {
  Send !{F4}
  global is_pre_x = 0
  Return
}

move_beginning_of_line() {
  global
  if is_pre_spc
    Send +{HOME}
  Else
    Send {HOME}
  Return
}

move_end_of_line() {
  global
  if is_pre_spc
    Send +{END}
  Else
    Send {END}
  Return
}

previous_line() {
  global
  if is_pre_spc
    Send +{Up}
  Else
    Send {Up}
  Return
}

next_line() {
  global
  if is_pre_spc
    Send +{Down}
  Else
    Send {Down}
  Return
}

backward_char() {
  global
  if is_pre_spc
    Send +{Left}
  Else
    Send {Left}
  Return
}

scroll_up() {
  global
  if is_pre_spc
    Send +{PgUp}
  Else
    Send {PgUp}
  Return
}

scroll_down() {
  global
  if is_pre_spc
    Send +{PgDn}
  Else
    Send {PgDn}
  Return
}

backward_word() {
  global
  if is_pre_spc
    Send +^{Left}
  Else
    Send ^{Left}
  Return
}

forward_word() {
  global
  if is_pre_spc
    Send +^{Right}
  Else
    Send ^{Left}
  Return
}

singleLetterFallbackToDefault() {
  state := GetKeyState("Capslock", "T")
  If(state)
  {
    Send +%A_ThisHotkey%  ; + for upper case
  }
  Else
  {
    StringReplace, hotkey, A_ThisHotkey, >
    Send %hotkey%
  }
}

;==========================
;Keybindings
;==========================
>^x::
  If IsInEmacsMode() {
    global is_pre_x = 1
    SetTimer, KeyX, 1000
  }
  Else
  {
    StringReplace, hotkey, A_ThisHotkey, >
    Send %hotkey%
  }
  Return

h::
  If (IsInEmacsMode() && is_pre_x) {
    Send ^a  ; select all
    global is_pre_x = 0
  }
  Else
    singleLetterFallbackToDefault()
  Return

>^f::
  If IsInEmacsMode()
  {
    If is_pre_x {
      Send ^o
      global is_pre_x = 0
    } Else {
      if is_pre_spc
        Send +{Right}
      Else
        Send {Right}
    }
  }
  Else
  {
    StringReplace, hotkey, A_ThisHotkey, >
    Send %hotkey%
  }
  Return

+>^f::
  If IsInEmacsMode()
      Send +{Right}
  Else
  {
    StringReplace, hotkey, A_ThisHotkey, >
    Send %hotkey%
  }
  Return

>^d::
  If IsInEmacsMode()
    delete_char()
  Else
  {
    StringReplace, hotkey, A_ThisHotkey, >
    Send %hotkey%
  }
  Return
>^k::
  If IsInEmacsMode()
    kill_line()
  Else
  {
    StringReplace, hotkey, A_ThisHotkey, >
    Send %hotkey%
  }
  Return
>^o::
  If IsInEmacsMode()
    open_line()
  Else
  {
    StringReplace, hotkey, A_ThisHotkey, >
    Send %hotkey%
  }
  Return
>^g::
  If IsInEmacsMode()
    quit()
  Else
  {
    StringReplace, hotkey, A_ThisHotkey, >
    Send %hotkey%
  }
  Return
>^j::
  If IsInEmacsMode()
    newline_and_indent()
  Else
  {
    StringReplace, hotkey, A_ThisHotkey, >
    Send %hotkey%
  }
  Return
>^m::
  If IsInEmacsMode()
    newline()
  Else
  {
    StringReplace, hotkey, A_ThisHotkey, >
    Send %hotkey%
  }
  Return
>^i::
  If IsInEmacsMode()
    indent_for_tab_command()
  Else
  {
    StringReplace, hotkey, A_ThisHotkey, >
    Send %hotkey%
  }
  Return
>^s::
  If IsInEmacsMode()
  {
    If is_pre_x
      save_buffer()
    Else
      isearch_forward()
  }
  Else
  {
    StringReplace, hotkey, A_ThisHotkey, >
    Send %hotkey%
  }
  Return
>^r::
  If IsInEmacsMode()
    isearch_backward()
  Else
  {
    StringReplace, hotkey, A_ThisHotkey, >
    Send %hotkey%
  }
  Return
>^w::
  If IsInEmacsMode()
    kill_region()
  Else
  {
    StringReplace, hotkey, A_ThisHotkey, >
    Send %hotkey%
  }
  Return
>^y::
  If IsInEmacsMode()
    yank()
  Else
  {
    StringReplace, hotkey, A_ThisHotkey, >
    Send %hotkey%
  }
  Return
>^/::
  If IsInEmacsMode()
    undo()
  Else
  {
    StringReplace, hotkey, A_ThisHotkey, >
    Send %hotkey%
  }
  Return
>^Space::
  If IsInEmacsMode()
  {
    If is_pre_spc
      is_pre_spc = 0
    Else
      is_pre_spc = 1
  }
  Else
  {
    StringReplace, hotkey, A_ThisHotkey, >
    Send ^{Space}
  }
  Return
>^a::
  If IsInEmacsMode()
    move_beginning_of_line()
  Else
  {
    StringReplace, hotkey, A_ThisHotkey, >
    Send %hotkey%
  }
  Return
+>^a::
  If IsInEmacsMode()
  {
    is_pre_spc = 1
    move_beginning_of_line()
    is_pre_spc = 0
  }
  Else
  {
    StringReplace, hotkey, A_ThisHotkey, >
    Send %hotkey%
  }
  Return
>^e::
  If IsInEmacsMode()
    move_end_of_line()
  Else
  {
    StringReplace, hotkey, A_ThisHotkey, >
    Send %hotkey%
  }
  Return
+>^e::
  If IsInEmacsMode()
  {
    is_pre_spc = 1
    move_end_of_line()
    is_pre_spc = 0
  }
  Else
  {
    StringReplace, hotkey, A_ThisHotkey, >
    Send %hotkey%
  }
  Return
>^p::
  If IsInEmacsMode()
    previous_line()
  Else
  {
    StringReplace, hotkey, A_ThisHotkey, >
    Send %hotkey%
  }
  Return
+>^p::
  If IsInEmacsMode()
  {
    is_pre_spc = 1
    previous_line()
    is_pre_spc = 0
  }
  Else
  {
    StringReplace, hotkey, A_ThisHotkey, >
    Send %hotkey%
  }
  Return
>^n::
  If IsInEmacsMode()
    next_line()
  Else
  {
    StringReplace, hotkey, A_ThisHotkey, >
    Send %hotkey%
  }
  Return
+>^n::
  If IsInEmacsMode()
  {
    is_pre_spc = 1
    next_line()
    is_pre_spc = 0
  }
  Else
  {
    StringReplace, hotkey, A_ThisHotkey, >
    Send %hotkey%
  }
  Return
>^b::
  If IsInEmacsMode()
    backward_char()
  Else
  {
    StringReplace, hotkey, A_ThisHotkey, >
    Send %hotkey%
  }
  Return
+>^b::
  If IsInEmacsMode()
  {
    is_pre_spc = 1
    backward_char()
    is_pre_spc = 0
  }
  Else
  {
    StringReplace, hotkey, A_ThisHotkey, >
    Send %hotkey%
  }
  Return
>^!w::
  If IsInEmacsMode()
    kill_ring_save()
  Else
  {
    StringReplace, hotkey, A_ThisHotkey, >
    Send %hotkey%
  }
  Return

; page scroll are commented out
>^v::
  If IsInEmacsMode()
   scroll_down()
  Else
  {
    StringReplace, hotkey, A_ThisHotkey, >
    Send %hotkey%
  }
  Return

>^!v::
  If IsInEmacsMode()
   scroll_up()
  Else
  {
    StringReplace, hotkey, A_ThisHotkey, >
    Send %hotkey%
  }
  Return

>^!f::
  If IsInEmacsMode()
   forward_word()
  Else
  {
    StringReplace, hotkey, A_ThisHotkey, >
    Send %hotkey%
  }
  Return

+>^!f::
  If IsInEmacsMode()
  {
   is_pre_spc=1
   forward_word()
   is_pre_spc=0
  }
  Else
  {
   StringReplace, hotkey, A_ThisHotkey, >
   Send %hotkey%
  }
  Return

>^!b::
  If IsInEmacsMode()
    backward_word()
  Else
  {
    StringReplace, hotkey, A_ThisHotkey, >
    Send %hotkey%
  }
  Return

+>^!b::
  If IsInEmacsMode()
  {
    is_pre_spc = 1
    backward_word()
    is_pre_spc = 0
  }
  Else
  {
    StringReplace, hotkey, A_ThisHotkey, >
    Send %hotkey%
  }
  Return

;==========================
;Original
;==========================
SendCommand(emacsKey, translationToWindowsKeystrokes, secondWindowsKeystroke="") {
  if (IsInEmacsMode()) {
    Send, %translationToWindowsKeystrokes%
    if (secondWindowsKeystroke<>"") {
      Send, %secondWindowsKeystroke%
    }
  } else {
    Send, %emacsKey% ;passthrough original keystroke
  }
  return
}
;==========================
;Word Navigation
;==========================

;$>^!p::SendCommand("!p","^{Up}")

;$>^!n::SendCommand("!n","^{Down}")

;$>^!f::SendCommand("!f","^{Right}")

;$+>^!f::SendCommand("+!f","+^{Right}")

;$>^!b::SendCommand("!b","^{Left}")

;$+>^!b::SendCommand("+!b","+^{Left}")

;==========================
;Page Navigation
;==========================
$>^!<::SendCommand("!<","^{Home}")

$>^!>::SendCommand("!>","^{End}")

;==========================
;Undo
;==========================

$>^_::SendCommand("^_","^z")

;==========================
;Delete
;==========================
$>^!d::SendCommand("!d","^+{Right}","{Delete}")



;==========================
;Disable Win Key but not its combinations
;==========================
; ~LWin Up:: return

;==========================
;Auto Save
;==========================
;Toggle = 0
;#MaxThreadsPerHotkey 2
;$F8::              ;hit F8 to toggle script on and off.
;  Toggle := !Toggle
;  While Toggle{
;    if (WinActive("ahk_class classFoxitReader")) {
;      Send, ^s
;    }
;    Sleep, 60*1000 ; in ms
;  }
;return


;==========================
; Mac Key bindings
;==========================
; !w::Send {LCtrl Down}{w}{LCtrl Up}  ; emacs kill_ring_save()
; !t::Send {LCtrl Down}{t}{LCtrl Up}
; !c::Send {LCtrl Down}{c}{LCtrl Up}
; !v::Send {LCtrl Down}{v}{LCtrl Up}
; !l::Send {LCtrl Down}{l}{LCtrl Up}
; !q::Send {LAlt Down}{f4}{LAlt Up}
; !a::Send {LCtrl Down}{a}{LCtrl Up}
; !s::Send {LCtrl Down}{s}{LCtrl Up}
; !z::Send {LCtrl Down}{z}{LCtrl Up}
; !r::Send {LCtrl Down}{r}{LCtrl Up}
; !LButton::Send {LCtrl Down}{LButton}{LCtrl Up}
; !RButton::Send {LCtrl Down}{RButton}{LCtrl Up}
