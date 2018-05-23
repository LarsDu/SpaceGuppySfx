from toolchain import CythonRecipe, #shprint
from os.path import join
#import sh

class SpaceGuppySfxRecipe(CythonRecipe):
    version = 'master'
    url = 'https://github.com/LarsDu/SpaceGuppySfx/archive/{version}.zip'
    name = 'spaceguppy_sfx'
    depends=['kivent_core']
    cythonize= True

    def prepare_build_dir(self, arch):
        '''No need to prepare '''
        return

recipe = SpaceGuppySfxRecipe()
