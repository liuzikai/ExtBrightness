ExtBrightness: macOS tool to control brightness of external monitor
---
This is an experimental tool to control external monitors through DDC/CI for macOS.

It will create a popover on status bar, where you can adjust brightness of external monitor(s) by sliding.

![ScreenShot](Resource/ScreenShot.png)

In some conditions, DDC/CI can only apply parameters but can't retrieve their values from monitors. For example, my current configuration (MacBook Pro 17 + LG 27UK850W, using USB-C). In this case, brightness values are stored in the program.

Using code from [kfix/ddcctl](https://github.com/kfix/ddcctl) for low-level communication.