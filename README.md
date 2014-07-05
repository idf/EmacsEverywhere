# Emacs Everywhere
* Provides an Emacs-like keybinding emulation mode on everyone on Windows machine.
* This emulation mode can be toggled on and off using the (ctrl + CapsLock) key.

## Environment
* Keyboard: US Keyboard.
* Platform: WinXP/Vista/Win7/Win8/Win8.1.

## Requirement
* AutoHotkey V1.x.

## Usage
* Download and install [AutoHotKey](http://www.autohotkey.com).
* Download this source and put it anywhere you like.
* Double click the script EmacsEverywhere.ahk file inside.
* Use (ctrl + CapsLock) to toggle emacs mode. (Customizable).

## Notice
* I have commented out some emacs shortcut that you may want to uncomment. 
* I disable the win-key in this script according to the Super User [thread](http://superuser.com/questions/151304/prevent-windows-key-from-opening-start-menu-in-windows-7). You may want to remove the line in the EmacsEverywhere.ahk `~LWin Up:: return`.


## Acknowledgment
A independent repo is created rather than fork since the old repo is no longer maintained.  
This script is made based on the following:
* [emacs key bindings everywhere](http://www.davesquared.net/2008/02/emacs-key-bindings-everywhere.html)
* [emacs.ahk](https://github.com/usi3/emacs.ahk) repo
* [boblu/EmacsEverywhere](https://github.com/boblu/EmacsEverywhere).