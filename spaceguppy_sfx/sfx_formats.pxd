from kivy.graphics.cgl cimport GLfloat, GLubyte

ctypedef struct VertexFormatSfx1:
    GLfloat[2] pos
    GLfloat[2] uvs
    GLfloat[2] center
    GLfloat[2] scale
    GLfloat rotate
    GLubyte[4] v_color
    GLfloat[4] v_tint
    GLfloat render_rotate
    GLfloat x_trans
    GLfloat y_trans
    GLfloat x_shear
    GLfloat y_shear
    GLubyte[4] edge_effect_color
    GLfloat edge_effect_thresh
    #GLfloat sfx_flag
