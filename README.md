ExtBrightness: macOS tool to control display brightness
---
This is a tool to control both build-in and external displays for macOS

It will create a popover on status bar, where you can adjust brightness by with sliders.

![ScreenShot](Resource/ScreenShot.png)

Note: 'Ext' used to means 'external'. However, this program now supports build-in display. You can interpret it as 'extraordinary' or so. QwQ

# Usage
Download and compile the project.

# For Build-In Display
This program use Cocoa APIs to control build-in display.

Using code from [Brightness Menulet](http://www.alecjacobson.com/weblog/?p=1127).

Note: Currently brightness value for build-in display can't get synced with that on TouchBar Control Strip for unknown reason.

# For External Displays

This program use DDC/CI to control build-in display.

Note: In some conditions, DDC/CI can only apply parameters but can't retrieve their values from monitors. For example, my current configuration (MacBook Pro 2017 + LG 27UK850W, using USB-C). In this case, brightness values are stored in the program, and won't get synced.

Using code from [kfix/ddcctl](https://github.com/kfix/ddcctl) for low-level communication.