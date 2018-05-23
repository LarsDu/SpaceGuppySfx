# cython: embedsignature=True
from kivent_core.systems.staticmemgamesystem cimport StaticMemGameSystem, MemComponent
from kivy.properties import (StringProperty, NumericProperty, ListProperty,
    BooleanProperty, ObjectProperty)
from kivy.factory import Factory
from kivent_core.memory_handlers.zone cimport MemoryZone
#from nemo_sfx.sfx cimport SfxStruct2D

#from kivent_core.systems.renderers import RenderComponent
#from kivent_core.systems.rotate_systems cimport RotateComponent2D, RotateSystem2D



'''
This file contains the SfxComponent 
and the SfxSystem


Using an SfxRenderer with an SfxComponent and SfxSystem allows for control of
render_rotation,scale, x and y translation flipping, shear, 
outline (edge) thresholding/coloring, and certain flags for 
activating particular shader distortion effects. 


Note that although kivent has the option to maintain ColorSystems and ScaleSystems,
as of 2018, the ScaleSystem has not been integrated into Cymunk and for my purposes,
ColorComponent data has no utility outside of a rendering context. Therefore this 
single system will be in charge of scaling and translations (no special components or 
systems will be made for these operations!).
'''

cdef class SfxComponent(MemComponent):
    '''
    '''
    property entity_id:
        def __get__(self):
            cdef SfxStruct2D* data = <SfxStruct2D*>self.pointer
            return data.entity_id

    property scale:
        def __get__(self):
            cdef SfxStruct2D* data = <SfxStruct2D*>self.pointer
            return (data.scale[0], data.scale[1])

        def __set__(self, tuple values):
            cdef SfxStruct2D* data = <SfxStruct2D*>self.pointer
            data.scale[0] = values[0]
            data.scale[1]= values[1]

    property scale_x:
        def __get__(self):
            cdef SfxStruct2D* data = <SfxStruct2D*>self.pointer
            return data.scale[0]
        
        def __set__(self, float value):
            cdef SfxStruct2D* data = <SfxStruct2D*>self.pointer
            data.scale[0] = value

    property scale_y:
        def __get__(self):
            cdef SfxStruct2D* data = <SfxStruct2D*>self.pointer
            return data.scale[1]
        def __set__(self, float value):
            cdef SfxStruct2D* data = <SfxStruct2D*>self.pointer
            data.scale[1] = value

    property render_rotate:
        def __get__(self):
            cdef SfxStruct2D* data = <SfxStruct2D*>self.pointer
            return data.render_rotate

        def __set__(self, float value):
            cdef SfxStruct2D* data = <SfxStruct2D*>self.pointer
            data.render_rotate = value #Radians

            
    property v_color:
        def __get__(self):
            cdef SfxStruct2D* data = <SfxStruct2D*>self.pointer
            return (data.v_color[0],data.v_color[1],data.v_color[2],data.v_color[3])
        
        def __set__(self, tuple v_color):
            cdef SfxStruct2D* data = <SfxStruct2D*>self.pointer
            data.v_color[0] = v_color[0]
            data.v_color[1] = v_color[1]
            data.v_color[2] = v_color[2]
            data.v_color[3] = v_color[3]

    property v_color_r:
        def __get__(self):
            cdef SfxStruct2D* data = <SfxStruct2D*>self.pointer
            return data.v_color[0]
        
        def __set__(self, unsigned char value):
            cdef SfxStruct2D* data = <SfxStruct2D*>self.pointer
            data.v_color[0] = value

    property v_color_g:
        def __get__(self):
            cdef SfxStruct2D* data = <SfxStruct2D*>self.pointer
            return data.v_color[1]
        
        def __set__(self, unsigned char value):
            cdef SfxStruct2D* data = <SfxStruct2D*>self.pointer
            data.v_color[1] = value

    property v_color_b:
        def __get__(self):
            cdef SfxStruct2D* data = <SfxStruct2D*>self.pointer
            return data.v_color[2]
        
        def __set__(self, unsigned char value):
            cdef SfxStruct2D* data = <SfxStruct2D*>self.pointer
            data.v_color[2] = value


    property v_color_a:
        def __get__(self):
            cdef SfxStruct2D* data = <SfxStruct2D*>self.pointer
            return data.v_color[3]
        def __set__(self, unsigned char value):
            cdef SfxStruct2D* data = <SfxStruct2D*>self.pointer
            data.v_color[3] = value
            

    property x_trans:
        def __get__(self):
            cdef SfxStruct2D* data = <SfxStruct2D*>self.pointer
            return data.x_trans

        def __set__(self,float value):
            cdef SfxStruct2D* data = <SfxStruct2D*>self.pointer
            data.x_trans = value

    property y_trans:
        def __get__(self):
            cdef SfxStruct2D* data = <SfxStruct2D*>self.pointer
            return data.y_trans
        
        def __set__(self,float value):
            cdef SfxStruct2D* data = <SfxStruct2D*>self.pointer
            data.y_trans = value

    property x_shear:
        def __get__(self):
            cdef SfxStruct2D* data = <SfxStruct2D*>self.pointer
            return data.x_shear
        
        def __set__(self,float value):
            cdef SfxStruct2D* data = <SfxStruct2D*>self.pointer
            data.x_shear = value

    property y_shear:
        def __get__(self):
            cdef SfxStruct2D* data = <SfxStruct2D*>self.pointer
            return data.y_shear
        
        def __set__(self,float value):
            cdef SfxStruct2D* data = <SfxStruct2D*>self.pointer
            data.y_shear = value
            

    property edge_effect_color:
        def __get__(self):
            cdef SfxStruct2D* data = <SfxStruct2D*>self.pointer
            return (data.edge_effect_color[0],
                    data.edge_effect_color[1],
                    data.edge_effect_color[2],
                    data.edge_effect_color[3])
        
        def __set__(self, tuple edge_effect_color):
            cdef SfxStruct2D* data = <SfxStruct2D*>self.pointer
            data.edge_effect_color[0] = edge_effect_color[0]
            data.edge_effect_color[1] = edge_effect_color[1]
            data.edge_effect_color[2] = edge_effect_color[2]
            data.edge_effect_color[3] = edge_effect_color[3]

    property edge_effect_color_r:
        def __get__(self):
            cdef SfxStruct2D* data = <SfxStruct2D*>self.pointer
            return data.edge_effect_color[0]
        
        def __set__(self, unsigned char value):
            cdef SfxStruct2D* data = <SfxStruct2D*>self.pointer
            data.edge_effect_color[0] = value

    property edge_effect_color_g:
        def __get__(self):
            cdef SfxStruct2D* data = <SfxStruct2D*>self.pointer
            return data.edge_effect_color[1]
        
        def __set__(self, unsigned char value):
            cdef SfxStruct2D* data = <SfxStruct2D*>self.pointer
            data.edge_effect_color[1] = value

    property edge_effect_color_b:
        def __get__(self):
            cdef SfxStruct2D* data = <SfxStruct2D*>self.pointer
            return data.edge_effect_color[2]
        
        def __set__(self, unsigned char value):
            cdef SfxStruct2D* data = <SfxStruct2D*>self.pointer
            data.edge_effect_color[2] = value


    property edge_effect_color_a:
        def __get__(self):
            cdef SfxStruct2D* data = <SfxStruct2D*>self.pointer
            return data.edge_effect_color[3]
        def __set__(self, unsigned char value):
            cdef SfxStruct2D* data = <SfxStruct2D*>self.pointer
            data.edge_effect_color[3] = value


            
    property edge_effect_thresh:
        def __get__(self):
            cdef SfxStruct2D* data = <SfxStruct2D*>self.pointer
            return data.edge_effect_thresh
        
        def __set__(self,float value):
            cdef SfxStruct2D* data = <SfxStruct2D*>self.pointer
            data.edge_effect_thresh = value

    property sfx_flag:
        def __get__(self):
            cdef SfxStruct2D* data = <SfxStruct2D*>self.pointer
            return data.sfx_flag

        def __set__(self,float value):
            cdef SfxStruct2D* data = <SfxStruct2D*>self.pointer
            data.sfx_flag = value






cdef class SfxSystem(StaticMemGameSystem):
    """
    A GameSystem for managing SFX components
    """

    type_size = NumericProperty(sizeof(SfxStruct2D))
    component_type = ObjectProperty(SfxComponent)
    system_id = StringProperty('sfx')
    default_args = {
        "scale":(1.,1.),
        "render_rotate":0.,
        "v_color": (255,255,255,255),
        "x_trans": 1.,
        "y_trans": 1.,
        "x_shear": 0.,
        "y_shear": 0.,
        "edge_effect_color": (255,255,255,255),
        "edge_effect_thresh":0.,
        "sfx_flag": 1.
    }


    def init_component(self, unsigned int component_index, unsigned int entity_id, str zone, args):
        #Start with default arguments and replace entries with user defined args
        # on initialization (pre-filtering)
        
        cargs = SfxSystem.default_args.copy() #combined args
        for key,value in cargs.items():
            new_val = args.get(key,False)
            if new_val:
                cargs[key] = new_val
        
        cdef MemoryZone memory_zone = self.imz_components.memory_zone
        cdef SfxStruct2D* component = <SfxStruct2D*>(
            memory_zone.get_pointer(component_index))
        component.entity_id = entity_id
        component.scale[0] = cargs['scale'][0]
        component.scale[1] = cargs['scale'][1]
        component.render_rotate = cargs['render_rotate']
        component.v_color[0] =  int(cargs['v_color'][0])
        component.v_color[1] =  int(cargs['v_color'][1])
        component.v_color[2] =  int(cargs['v_color'][2])
        component.v_color[3] =  int(cargs['v_color'][3])
        component.x_trans =  float(cargs['x_trans'])
        component.y_trans =  float(cargs['y_trans'])
        component.x_shear =  float(cargs['x_shear'])
        component.y_shear =  float(cargs['y_shear'])
        component.edge_effect_color[0] = int(cargs['edge_effect_color'][0])
        component.edge_effect_color[1] = int(cargs['edge_effect_color'][1])
        component.edge_effect_color[2] = int(cargs['edge_effect_color'][2])
        component.edge_effect_color[3] = int(cargs['edge_effect_color'][3])
        component.edge_effect_thresh = float(cargs['edge_effect_thresh'])
        component.sfx_flag =  float(cargs['sfx_flag'])
        
        #super(DefaultGameSystem,self).init_component(component_index,entity_id,zone,combined_args)
        #self.create_sys_entity(component_index,entity_id,zone,args)


    
    def clear_component(self, unsigned int component_index):
        cdef MemoryZone memory_zone = self.imz_components.memory_zone
        cdef SfxStruct2D* pointer = <SfxStruct2D*>(
            memory_zone.get_pointer(component_index))
        pointer.entity_id = -1
        pointer.render_rotate = 0.
        pointer.v_color[0] = 255
        pointer.v_color[1]= 255
        pointer.v_color[2] = 255
        pointer.v_color[3] = 255
        pointer.x_trans = 1.
        pointer.y_trans = 1.
        pointer.x_shear = 1.
        pointer.y_shear = 1.
        pointer.edge_effect_color[0] = 255
        pointer.edge_effect_color[1] = 255
        pointer.edge_effect_color[2]= 255
        pointer.edge_effect_color[3] = 255
        pointer.sfx_flag = 0.

Factory.register('SfxSystem', cls=SfxSystem)


