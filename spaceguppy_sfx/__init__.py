import os

__VERSION__ = '0.4.0'

if 'KIVENT_PREVENT_INIT' not in os.environ:
    from spaceguppy_sfx import sfx_renderer
    from spaceguppy_sfx import sfx_formats
    from spaceguppy_sfx import sfx
