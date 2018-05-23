from cython cimport Py_ssize_t
cdef extern from "Python.h":
    ctypedef int Py_intptr_t
from kivent_core.rendering.vertex_formats cimport format_registrar

cdef VertexFormatSfx1* tmp_var1 = <VertexFormatSfx1*>NULL
pos_offset = <Py_ssize_t> (<Py_intptr_t>(tmp_var1.pos) - <Py_intptr_t>(tmp_var1))
uvs_offset = <Py_ssize_t> (<Py_intptr_t>(tmp_var1.uvs) - <Py_intptr_t>(tmp_var1))
center_offset = <Py_ssize_t> (<Py_intptr_t>(tmp_var1.center) - <Py_intptr_t>(tmp_var1))
rot_offset = <Py_ssize_t> (<Py_intptr_t>(&tmp_var1.rotate) - <Py_intptr_t>(tmp_var1))
scale_offset = <Py_ssize_t> (<Py_intptr_t>(tmp_var1.scale) - <Py_intptr_t>(tmp_var1))
render_rot_offset = <Py_ssize_t> (<Py_intptr_t>(&tmp_var1.render_rotate) - <Py_intptr_t>(tmp_var1))
color_offset = <Py_ssize_t> (<Py_intptr_t>(tmp_var1.v_color) - <Py_intptr_t>(tmp_var1))
x_trans_offset = <Py_ssize_t> (<Py_intptr_t>(&tmp_var1.x_trans) - <Py_intptr_t>(tmp_var1))#
y_trans_offset = <Py_ssize_t> (<Py_intptr_t>(&tmp_var1.y_trans) - <Py_intptr_t>(tmp_var1))#
x_shear_offset = <Py_ssize_t> (<Py_intptr_t>(&tmp_var1.x_shear) - <Py_intptr_t>(tmp_var1))#
y_shear_offset = <Py_ssize_t> (<Py_intptr_t>(&tmp_var1.y_shear) - <Py_intptr_t>(tmp_var1))#
ee_color_offset = <Py_ssize_t> (<Py_intptr_t>(tmp_var1.edge_effect_color) - <Py_intptr_t>(tmp_var1))
ee_thresh_offset = <Py_ssize_t> (<Py_intptr_t>(&tmp_var1.edge_effect_thresh) - <Py_intptr_t>(tmp_var1))
#sfx_flag_offset = <Py_ssize_t> (<Py_intptr_t>(&tmp_var1.sfx_flag) - <Py_intptr_t>(tmp_var1))

vertex_format_sfx1 = [
    (b'pos', 2, b'float', pos_offset,False),
    (b'uvs', 2, b'float', uvs_offset,False),
    (b'center', 2, b'float', center_offset,False),
    (b'scale', 2, b'float', scale_offset,False),
    (b'rotate', 1, b'float', rot_offset,False),
    (b'render_rotate', 1, b'float', render_rot_offset,False),
    (b'v_color', 4, b'ubyte', color_offset,True),
    (b'x_trans', 1, b'float', x_trans_offset,False),
    (b'y_trans', 1, b'float',  y_trans_offset,False),
    (b'x_shear', 1, b'float', x_shear_offset,False),
    (b'y_shear', 1, b'float', y_shear_offset,False),
    (b'edge_effect_color', 4, b'ubyte', ee_color_offset,True),
    (b'edge_effect_thresh', 1, b'float', ee_thresh_offset,False),
#    (b'sfx_flag', 1, b'float', sfx_flag_offset,False),
    ]

format_registrar.register_vertex_format('vertex_format_sfx1', 
	vertex_format_sfx1, sizeof(VertexFormatSfx1))
