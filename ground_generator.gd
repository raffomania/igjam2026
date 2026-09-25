extends Node

var resolution = 4 # vertex per meter per directions
var size = 2 # meters
var vertices_per_dimension = resolution * size 
var grid_vertex_distance = 1.0 / (vertices_per_dimension - 1) #meters

func _ready():
    var surface_array = []
    surface_array.resize(Mesh.ARRAY_MAX)

    var verts = PackedVector3Array()
    # var uvs = PackedVector2Array()
    var normals = PackedVector3Array()
    var indices = PackedInt32Array()

    verts = create_grid_vertices()
    indices = create_grid_indices()
    normals =  create_normals()
    # uvs = PackedVector2Array([
    #     Vector2(0, 0),
    #     Vector2(1, 0),
    #     Vector2(0, 1),
    #     Vector2(1, 1),
    # ])

    surface_array[Mesh.ARRAY_VERTEX] = verts
    # surface_array[Mesh.ARRAY_TEX_UV] = uvs
    surface_array[Mesh.ARRAY_NORMAL] = normals
    surface_array[Mesh.ARRAY_INDEX] = indices

    var array_mesh = ArrayMesh.new()
    array_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, surface_array)
    var m = MeshInstance3D.new()
    m.mesh = array_mesh
    m.scale = Vector3.ONE * size 
    add_child(m)

func create_grid_vertices():
    var grid_vertices = PackedVector3Array()
    for x in range(vertices_per_dimension):
        for z in range(vertices_per_dimension):
            #TODO: calculate y based on sin functions
            var y = 0 + randf() * 0.1
            var vertex_position = Vector3(x*grid_vertex_distance,y,z*grid_vertex_distance)
            grid_vertices.push_back(vertex_position)
    # print("grid_vertices", grid_vertices, len(grid_vertices))
    return grid_vertices

func create_grid_indices():
    var indices = PackedInt32Array()
    var i = 0
    for x in range(vertices_per_dimension-1):
        for z in range(vertices_per_dimension-1):
            indices.push_back(i+vertices_per_dimension)
            indices.push_back(i+1)
            indices.push_back(i)
            indices.push_back(i+vertices_per_dimension)
            indices.push_back(i+vertices_per_dimension+1)
            indices.push_back(i+1)
            i += 1
        i += 1
    # print("indices", indices, len(indices))
    return indices

func create_normals():
    #TODO: need to depend on sin functions
    var normals = PackedVector3Array()
    for n in range((vertices_per_dimension)*(vertices_per_dimension)):
        normals.push_back(Vector3.UP)
    return normals
