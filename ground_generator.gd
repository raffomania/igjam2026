extends Node

var resolution = 20 # vertex per meter in all directions
var size = 10 # meters

func _ready():
    var surface_array = []
    surface_array.resize(Mesh.ARRAY_MAX)

    # PackedVector**Arrays for mesh construction.
    var verts = PackedVector3Array()
    var uvs = PackedVector2Array()
    var normals = PackedVector3Array()
    var indices = PackedInt32Array()

    verts = PackedVector3Array([
        Vector3(0, 0, 0),
        Vector3(0, 0, 1),
        Vector3(1, 0, 0),
        Vector3(1, 0, 1),
    ])
    uvs = PackedVector2Array([
        Vector2(0, 0),
        Vector2(1, 0),
        Vector2(0, 1),
        Vector2(1, 1),
    ])
    normals = PackedVector3Array([
        Vector3.UP,
        Vector3.UP,
        Vector3.UP,
        Vector3.UP,
    ])
    indices = PackedInt32Array([
        0, 2, 1, # Draw the first triangle.
        2, 3, 1, # Draw the second triangle.
    ])
    # Assign arrays to surface array.
    surface_array[Mesh.ARRAY_VERTEX] = verts
    surface_array[Mesh.ARRAY_TEX_UV] = uvs
    surface_array[Mesh.ARRAY_NORMAL] = normals
    surface_array[Mesh.ARRAY_INDEX] = indices

    # Create mesh surface from mesh array.
    # No blendshapes, lods, or compression used.
    var array_mesh = ArrayMesh.new()
    array_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, surface_array)
    var m = MeshInstance3D.new()
    m.mesh = array_mesh
    add_child(m)

# var ground_vertices = PackedVector3Array()
#
# func _init() -> void:
# 	print("lol")
#
# 	for x in range(size):
# 		for z in range(size):
# 			#TODO: calculate y based on sin functions
# 			var y = 0
# 			var vertex_position = Vector3(x,y,z)
# 			ground_vertices.push_back(vertex_position)
#
# 	print("finished")
# 	var arr_mesh = ArrayMesh.new()
# 	var arrays = []
# 	arrays.resize(Mesh.ARRAY_MAX)
# 	arrays[Mesh.ARRAY_VERTEX] = ground_vertices
#
# # Create the Mesh.
# 	arr_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
# 	var m = MeshInstance3D.new()
# 	m.mesh = arr_mesh
# 	add_child(m)
#
#
