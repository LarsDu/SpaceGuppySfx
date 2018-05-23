# cython: embedsignature=True
from kivent_core.systems.renderers cimport RenderStruct,Renderer
from nemo_sfx.sfx_formats cimport VertexFormatSfx1
from nemo_sfx.sfx_formats import vertex_format_sfx1


from kivy.graphics.cgl cimport GLushort
from kivent_core.rendering.batching cimport BatchManager, IndexedBatch
from kivent_core.rendering.vertex_format cimport KEVertexFormat
from kivent_core.systems.position_systems cimport PositionStruct2D
from nemo_sfx.sfx cimport SfxStruct2D
#from kivent_core.systems.scale_systems cimport ScaleStruct2D
from kivent_core.systems.rotate_systems cimport RotateStruct2D
#from kivent_core.systems.color_systems cimport ColorStruct
from kivent_core.memory_handlers.block cimport MemoryBlock
from kivent_core.rendering.cmesh cimport CMesh
from kivent_core.systems.staticmemgamesystem cimport ComponentPointerAggregator
from kivent_core.rendering.model cimport VertexModel
from kivent_core.rendering.vertex_formats cimport (VertexFormat4F)
from kivent_core.rendering.vertex_formats import (vertex_format_4f )


'''
from kivent_core.rendering.vertex_formats cimport (
    VertexFormat4F, VertexFormat2F4UB, VertexFormat7F, VertexFormat4F4UB,
    VertexFormat5F4UB, VertexFormat7F4UB
    )
from kivent_core.rendering.vertex_formats import (
    vertex_format_4f, vertex_format_7f, vertex_format_4f4ub, 
    vertex_format_2f4ub, vertex_format_5f4ub, vertex_format_7f4ub
    )
'''


from kivent_core.memory_handlers.membuffer cimport Buffer
from kivy.factory import Factory
from kivy.properties import StringProperty, NumericProperty, ListProperty

cdef class SfxRenderer(Renderer):
    '''
    Processing Depends On: SfxSystem, PositionSystem2D, 
    RotateSystem2D

    The renderer draws with the VertexFormatSfx1:

    .. code-block:: cython

        ctypedef struct VertexFormatSfx1:
            GLfloat[2] pos
            GLfloat[2] uvs
            GLfloat[2] center
            GLubyte[4] v_color
            #TODO rewrite comments

    '''
    system_names = ListProperty(['sfx_renderer', 'position', 
                                 'rotate','sfx'])
    system_id = StringProperty('sfx_renderer')
    #size_of_batches = NumericProperty(512) #default 256

    #Note: These values all default of VertexFormat4F
    #model_format = StringProperty('vertex_format_sfx1')
    #vertex_format_size = NumericProperty(sizeof(VertexFormatSfx1))
    #vertex_format_size = NumericProperty(sizeof(VertexFormat4F))

    cdef void* setup_batch_manager(self, Buffer master_buffer) except NULL:
        cdef KEVertexFormat batch_vertex_format = KEVertexFormat(
            sizeof(VertexFormatSfx1), *vertex_format_sfx1)
        self.batch_manager = BatchManager(
            self.size_of_batches, self.max_batches, self.frame_count, 
            batch_vertex_format, master_buffer, 'triangles', self.canvas,
            [x for x in self.system_names], 
            self.smallest_vertex_count, self.gameworld)
        return <void*>self.batch_manager


    def update(self, force_update, dt):
        cdef IndexedBatch batch
        cdef list batches
        cdef unsigned int batch_key
        cdef unsigned int index_offset, vert_offset
        cdef RenderStruct* render_comp
        cdef PositionStruct2D* pos_comp
        cdef RotateStruct2D* rot_comp
        cdef SfxStruct2D* sfx_comp
        #cdef ColorStruct* color_comp
        #cdef ScaleStruct2D* scale_comp
        cdef VertexFormatSfx1* frame_data
        cdef GLushort* frame_indices
        cdef VertexFormatSfx1* vertex
        cdef VertexModel model
        cdef GLushort* model_indices
        #cdef VertexFormatSfx1* model_vertices
        #cdef VertexFormatSfx1 model_vertex
        cdef VertexFormat4F* model_vertices
        cdef VertexFormat4F model_vertex
        
        cdef unsigned int used, i, real_index, component_count, n, c
        cdef ComponentPointerAggregator entity_components
        cdef BatchManager batch_manager = self.batch_manager
        cdef dict batch_groups = batch_manager.batch_groups
        cdef CMesh mesh_instruction
        cdef MemoryBlock components_block
        cdef void** component_data
        cdef bint static_rendering = self.static_rendering
        
        for batch_key in batch_groups:
            batches = batch_groups[batch_key]
            for batch in batches:
                if not static_rendering or force_update:
                    entity_components = batch.entity_components
                    components_block = entity_components.memory_block
                    used = components_block.used_count
                    component_count = entity_components.count
                    component_data = <void**>components_block.data
                    frame_data = <VertexFormatSfx1*>(
                        batch.get_vbo_frame_to_draw())
                    frame_indices = <GLushort*>batch.get_indices_frame_to_draw()
                    index_offset = 0
                    for c in range(used):
                        real_index = c * component_count
                        if component_data[real_index] == NULL:
                            continue
                        render_comp = <RenderStruct*>component_data[
                            real_index+0]
                        vert_offset = render_comp.vert_index
                        model = <VertexModel>render_comp.model
                        if render_comp.render:
                            pos_comp = <PositionStruct2D*>component_data[
                                real_index+1]
                            rot_comp = <RotateStruct2D*>component_data[
                                real_index+2]
                            sfx_comp = <SfxStruct2D*>component_data[
                                real_index+3]
                            model_vertices = <VertexFormat4F*>(
                                model.vertices_block.data)
                            #model_vertices = <VertexFormatSfx1*>(
                            #    model.vertices_block.data)
                            
                            model_indices = <GLushort*>model.indices_block.data
                            for i in range(model._index_count):
                                frame_indices[i+index_offset] = (
                                    model_indices[i] + vert_offset)
                            for n in range(model._vertex_count):
                                vertex = &frame_data[n + vert_offset]
                                model_vertex = model_vertices[n]
                                vertex.pos[0] = model_vertex.pos[0]
                                vertex.pos[1] = model_vertex.pos[1]
                                vertex.uvs[0] = model_vertex.uvs[0]
                                vertex.uvs[1] = model_vertex.uvs[1]
                                vertex.rotate = rot_comp.r
                                vertex.center[0] = pos_comp.x#*sfx_comp.scale[0]
                                vertex.center[1] = pos_comp.y#*sfx_comp.scale[1]
                                vertex.scale[0] = sfx_comp.scale[0]
                                vertex.scale[1] = sfx_comp.scale[1]
                                #vertex.scale[0] = 1.
                                #vertex.scale[1] = 1.

                                for i in range(4):
                                    vertex.v_color[i] = sfx_comp.v_color[i]
                                vertex.render_rotate = sfx_comp.render_rotate
                                vertex.x_trans = sfx_comp.x_trans
                                vertex.y_trans = sfx_comp.y_trans
                                vertex.x_shear = sfx_comp.x_shear
                                vertex.y_shear = sfx_comp.y_shear
                                for i in range(4):
                                    vertex.edge_effect_color[i] = sfx_comp.edge_effect_color[i]
                                vertex.edge_effect_thresh = sfx_comp.edge_effect_thresh
                                #vertex.sfx_flag = sfx_comp.sfx_flag
                                
                                #print "scale",sfx_comp.scale,sfx_comp.scale[0],sfx_comp.scale[1]
                                #print "sfx_flag",sfx_comp.sfx_flag
                                '''
                                print "v_color",int(sfx_comp.v_color[0])
                                
                                print "x_trans",sfx_comp.x_trans
                                print "y_trans",sfx_comp.y_trans
                                print "x_shear",sfx_comp.x_shear
                                print "y_shear",sfx_comp.y_shear
                                
                                print "edge_effect_color",sfx_comp.edge_effect_color
                                print "edge_effect_thresh",sfx_comp.edge_effect_thresh
                                print "sfx_flag",sfx_comp.sfx_flag
                                '''
                                
                            index_offset += model._index_count
                    batch.set_index_count_for_frame(index_offset)
                mesh_instruction = batch.mesh_instruction
                mesh_instruction.flag_update()

cdef unsigned char blend_integer_colors(unsigned char color1,
                                        unsigned char color2):
    return <unsigned char>((<float>color1 / 255.) * (
        <float>color2 / 255.) * 255)



                

Factory.register('SfxRenderer', cls=SfxRenderer)
