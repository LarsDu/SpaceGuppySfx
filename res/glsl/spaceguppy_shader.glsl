---VERTEX SHADER---
#ifdef GL_ES
    precision highp float;
#endif

/* Outputs to the fragment shader */
varying vec4 frag_color;
varying vec2 tex_coord0;
varying vec4 fedge_effect_color;
varying float fedge_effect_thresh;
/*varying float fsfx_flag;*/


/* vertex attributes */
attribute vec2 pos;
attribute vec2 uvs;
attribute vec2 center;
attribute vec2 scale;
attribute float rotate;
attribute vec4  v_color;
attribute vec4  v_tint;
attribute float render_rotate;
attribute float x_trans;
attribute float y_trans;
attribute float x_shear;
attribute float y_shear;
attribute vec4  edge_effect_color;
attribute float edge_effect_thresh;
/*attribute float sfx_flag;*/


/* uniform variables */
uniform mat4       modelview_mat;
uniform mat4       projection_mat;
uniform vec4       color;
uniform float      opacity;



•••••••

void main (void) {

  frag_color = v_color * v_tint * color * vec4(1., 1., 1., opacity);
  tex_coord0 = uvs;

  /*Pass through variables to fragment shader*/
  fedge_effect_color = edge_effect_color; 
  fedge_effect_thresh = edge_effect_thresh;
  /*fsfx_flag = sfx_flag;*/

  float total_rotate = rotate+render_rotate;
  float a_sin = sin(total_rotate);
  float a_cos = cos(rotate+render_rotate);
  mat4 rot_mat = mat4(a_cos, -a_sin, 0.0, 0.0,
		      a_sin, a_cos, 0.0, 0.0,
		      0.0, 0.0, 1.0, 0.0,
		      0.0, 0.0, 0.0, 1.0 );

		      	   	     	 
  mat4 trans_mat = mat4(y_trans, x_shear,  0.0,  center.x,
			y_shear, x_trans,  0.0,  center.y,
			0.0,     0.0,      1.0,  0.0,
			0.0,     0.0,      0.0,  1.0);
  
  vec4 new_pos = vec4(pos.xy*scale.xy, 0.0, 1.0);
  vec4 trans_pos = new_pos * rot_mat * trans_mat;
  gl_Position = projection_mat * modelview_mat * trans_pos;

}


---FRAGMENT SHADER---
#ifdef GL_ES
    precision highp float;
#endif

/* Outputs from the vertex shader */
varying vec4 frag_color;
varying vec2 tex_coord0;
varying vec4 fedge_effect_color;
varying float fedge_effect_thresh;
/*varying float fsfx_flag;*/


/* uniform texture samplers */
uniform sampler2D texture0;



void main (void){

  /*Change black pixels to specified color*/
  
  vec4 pixel_color = frag_color*texture2D(texture0,tex_coord0);
  /*if (fsfx_flag>0.){}*/
  
  if (fedge_effect_thresh > 0.0){
      if (pixel_color[0] < fedge_effect_thresh &&
	  pixel_color[1] < fedge_effect_thresh &&
	  pixel_color[2] < fedge_effect_thresh){

	pixel_color[0] = fedge_effect_color[0];
	pixel_color[1] = fedge_effect_color[1];
	pixel_color[2] = fedge_effect_color[2];
    }
  }
  
  
  gl_FragColor = vec4(pixel_color[0], pixel_color[1], pixel_color[2], pixel_color[3]);
    
  
}

