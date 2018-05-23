from toolchain import CythonRecipe,shprint
from os.path import join
from os import chdir

import sh


class SpaceGuppySfxRecipe(CythonRecipe):
    version = 'master'
    url = 'https://github.com/LarsDu/SpaceGuppySfx/archive/{version}.zip'
    name = 'spaceguppy_sfx'
    depends=['kivent_core','kivy']
    cythonize= True

    def get_recipe_env(self, arch):
        env = super(SpaceGuppySfxRecipe,self).get_recipe_env(arch)
        env['CYTHONPATH'] = self.get_recipe(
            'kivy', self.ctx).get_build_dir(arch.arch)
        dest_dir = join (self.ctx.dist_dir, "root", "python")
        env['PYTHONPATH'] = join(dest_dir, 'lib', 'python2.7', 'site-packages')

        #Add arch specific kivy to path
        arch_kivy_path = self.get_recipe('kivy', self.ctx).get_build_dir(arch.arch)
        env['PYTHONPATH'] = join( env['PYTHONPATH'],':',arch_kivy_path)
        return env



    
    def install(self):
        """
        The call to setup.py is made here.
        This method is called by build_all() in toolchain.py
        """
        arch = list(self.filtered_archs)[0]

        build_dir = self.get_build_dir(arch.arch)
        print "Building kivent_core {} in {}".format(arch.arch,build_dir)
        chdir(build_dir)
        hostpython = sh.Command(self.ctx.hostpython)
        #build_env = arch.get_env()
        build_env = self.get_recipe_env(arch)

        dest_dir = join (self.ctx.dist_dir, "root", "python")

        subdir_path = self.get_build_dir(str(arch))
        setup_path = join(subdir_path,"setup.py")
        
        shprint(hostpython, setup_path, "build_ext", "install", _env=build_env)

    
recipe = SpaceGuppySfxRecipe()

