extends Node

var height_scale = 5 # meters
var lowest_ground_frequency = 1.0/100.0 # repetitions per meter

var resolution = 0.5 # vertex per meter per directions
var size = 1000 # meters
var vertices_per_dimension = resolution * size # number of vertices for the whole chunk
var grid_vertex_distance = float(size) / (vertices_per_dimension - 1) #meters

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

    var mesh_instace = MeshInstance3D.new()
    mesh_instace.mesh = array_mesh
    # mesh_instace.scale = Vector3.ONE * size 
    # mesh_instace.scale.y = 1.0
    mesh_instace.position = Vector3.ONE * -0.5 * size
    mesh_instace.position.y = -10

    # set collider
    $CollisionShape3D.shape = array_mesh.create_trimesh_shape()
    # $CollisionShape3D.scale = mesh_instace.scale
    $CollisionShape3D.position = mesh_instace.position

    add_child(mesh_instace)

func create_grid_vertices():
    var grid_vertices = PackedVector3Array()
    for x in range(vertices_per_dimension):
        for z in range(vertices_per_dimension):
            #TODO: calculate y based on sin functions
            var x_pos = x*grid_vertex_distance
            var z_pos = z*grid_vertex_distance
            var y = calculate_ground_height(x_pos,z_pos)
            var vertex_position = Vector3(x_pos,y,z_pos)
            grid_vertices.push_back(vertex_position)
    # print("grid_vertices", len(grid_vertices))
    assert(len(grid_vertices) == (resolution * size)**2)
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
    # print("indices", len(indices))
    return indices

func create_normals():
    #TODO: needs to depend on sin functions
    var normals = PackedVector3Array()
    for n in range((vertices_per_dimension)*(vertices_per_dimension)):
        normals.push_back(Vector3.UP)
    return normals


func calculate_ground_height(x,z):
    var coefficients = [[1,2],[3,1],[2,8],[6,1],[8,6],[1,5],[6,1],[3,1],[2,12],[8,1],[10,1],[1,1],[1,20],[1,8],[1,1],[2,12]]
    var levels = range(len(coefficients))

    var y = 0
    for i in levels:
        y = y + sin(x*i*lowest_ground_frequency) * coefficients[i][0] 
        y = y + sin(z*i*lowest_ground_frequency) * coefficients[i][1]

    y = y/len(coefficients)
    y = y * height_scale
        
    return y

