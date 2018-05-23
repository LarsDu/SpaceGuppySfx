from math import radians

import kivy
from kivy.app import App
from kivy.uix.widget import Widget
from kivy.clock import Clock
from kivy.core.window import Window
from random import randint, choice
import kivent_core
from kivent_core.gameworld import GameWorld
from kivent_core.systems.position_systems import PositionSystem2D
from kivent_core.systems.renderers import Renderer # RotateRenderer
from kivent_core.managers.resource_managers import texture_manager
from kivy.properties import StringProperty
from os.path import dirname, join, abspath
from kivent_core.systems.rotate_systems import RotateSystem2D
#from kivent_core.systems.scale_systems import ScaleSystem2D


""" Load custom Sfx renderer """
from spaceguppy_sfx.sfx import SfxComponent,SfxSystem
from spaceguppy_sfx.sfx_renderer import SfxRenderer


test_image = abspath(join('..','..','res','img','wip','aster1.png'))
texture_manager.load_image(test_image)


class TestGame(Widget):
    def __init__(self, **kwargs):
        super(TestGame, self).__init__(**kwargs)
        self.gameworld.init_gameworld(
            ['position', 'rotate','sfx', 'sfx_renderer'],
            callback=self.init_game)

    def init_game(self):
        self.setup_states()
        self.set_state()
        self.load_models()
        self.draw_some_stuff()

    def load_models(self):
        model_manager = self.gameworld.model_manager
        model_manager.load_textured_rectangle('vertex_format_4f', 
                                              50., 50., 'aster1', 'aster1_mod')

        '''
        '''

    def draw_some_stuff(self):
        init_entity = self.gameworld.init_entity
        model_key = 'aster1_mod'
        create_dict = {
            'position': (50.,50.),
            'rotate': 0.,
            'sfx':{
                "scale":(1.,1.),
                "render_rotate":0.,
                "v_color": (200,20,20,255),
                "x_trans": 1.,
                "y_trans": 1.,
                "x_shear": .4,
                "y_shear": .2,
                "edge_effect_color": (255,255,255,255),
                "edge_effect_thresh":.1,
                "sfx_flag": 0.
            },

            'sfx_renderer': {
                'texture': 'aster1',
                'model_key': 'aster1_mod',
                'size': (100, 100),
                'render':True
            },
        }
        ent = init_entity(create_dict, [ 'position','rotate','sfx','sfx_renderer'])

        entity = self.gameworld.entities[ent]
        print entity
        print entity.load_order
        print entity.entity_id
        #If you do not set Renderer.force_update to True, call update_trigger
        #self.ids.renderer.update_trigger()


    def setup_states(self):
        self.gameworld.add_state(state_name='main',
            systems_added=['sfx','sfx_renderer'],
            systems_removed=[], systems_paused=[],
            systems_unpaused=['sfx','sfx_renderer'],
            screenmanager_screen='main')

    def set_state(self):
        self.gameworld.state = 'main'


class DebugPanel(Widget):
    fps = StringProperty(None)

    def __init__(self, **kwargs):
        super(DebugPanel, self).__init__(**kwargs)
        Clock.schedule_once(self.update_fps)

    def update_fps(self,dt):
        self.fps = str(int(Clock.get_fps()))
        Clock.schedule_once(self.update_fps, .05)


class YourAppNameApp(App):
    def build(self):
        Window.clearcolor = (0, 0, 0, 1.)

if __name__ == '__main__':
    YourAppNameApp().run()
