from pythonforandroid.recipe import CythonRecipe
from os.path import join
#import sh


"""
Note for future recipe creation.

The best way to structure a project is to push add-on modules to github, 
and place setup.py in the very top directory. Setup.py should have build 
instructions for different architectures.
"""

class SpaceGuppySfxRecipe(CythonRecipe):
    version = 'master'
    version = 'v0.4.0-alpha'
    url = 'https://github.com/LarsDu/SpaceGuppySfx/archive/{version}.zip'
    name = 'spaceguppy_sfx'
    depends=['kivent_core']
    cythonize= True




    def get_recipe_env(self, arch, with_flags_in_cc=True):
        env = super(SpaceGuppySfxRecipe, self).get_recipe_env(
            arch, with_flags_in_cc=with_flags_in_cc)
        cymunk = self.get_recipe('cymunk', self.ctx).get_build_dir(arch.arch)
        env['PYTHONPATH'] = join(cymunk, 'cymunk', 'python')
        kivy = self.get_recipe('kivy', self.ctx).get_build_dir(arch.arch)
        kivent = self.get_recipe('kivent_core',
                                 self.ctx).get_build_dir(arch.arch, sub=True)
        env['CYTHONPATH'] = ':'.join((kivy, kivent))


        return env
    




recipe = SpaceGuppySfxRecipe()
