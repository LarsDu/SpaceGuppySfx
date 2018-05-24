# SpaceGuppySfx
Special Kivent RendererSystem and SfxComponent used by the game SpaceGuppy for
Kivent game engine.

Enables certain GLSL fragment shader based effects such as thresholded color replacement using
a fragment shader and shearing.

Requires kivent_core and kivy to be installed.

To install this module to your python's site-packages directory

```
python setup.py built_ext install
```


To run the example:
```
cd examples
python main.py
```


To compile for android, copy recipes/android/spaceguppy_sfx to your pythonforandroid/recipes folder (may be located somewhere in .buildozer folder in your apps build directory.

To compile for ios, copy recipes/ios/spaceguppy_sfx to your kivy-ios/recipes folder
