uniform mat4 u_model;
uniform mat4 u_view;
uniform mat4 u_mvp;
uniform mat4 u_mv;
uniform mat4 u_mv_it;

layout(location = 0) in vec3 a_position;
layout(location = 1) in vec2 a_texcoord;
layout(location = 2) in vec3 a_normal;

#ifdef HAS_VertexSkinShader
uniform mat4 u_bone_matrix[50];
in vec4 a_bone_weights;
in ivec4 a_bone_indices;
#endif

#ifdef HAS_VertexNormalShader
in vec3 a_tangent;
in vec3 a_bitangent;
#endif

out vec2 diffuse_coord;
out vec3 view_direction;
out vec3 viewspace_position;
out vec3 viewspace_normal;
out vec4 local_position;

struct Vertex
{
	vec4 local_position;
	vec4 local_normal;
	vec3 viewspace_position;
	vec3 viewspace_normal;
	vec3 view_direction;
};

#ifdef HAS_LIGHTSOURCES
	@LIGHTSOURCES
#endif
	
void main() {
	Vertex vertex;

	vertex.local_position = vec4(a_position.xyz, 1.0);
	vertex.local_normal = vec4(0.0, 0.0, 1.0, 0.0);
	@VertexShader
#ifdef HAS_VertexSkinShader
	@VertexSkinShader
#endif
#ifdef HAS_VertexNormalShader
	@VertexNormalShader
#endif
#ifdef HAS_LIGHTSOURCES
	LightVertex(vertex);
#endif
	viewspace_position = vertex.viewspace_position;
	viewspace_normal = vertex.viewspace_normal;
	view_direction = vertex.view_direction;
	gl_Position = u_mvp * vertex.local_position;	
}