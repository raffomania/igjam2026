extends Node

var height_scale = 3 # meters
var lowest_ground_frequency = 1.0 / 200.0 # repetitions per meter
var texture_size = 20 # repetitions per meter
var sand_texture_path = "res://assets/sand.png"
# var sand_texture_path = "res://assets/Grass_01_basecolor.png"
# TODO: import height and normal map as well?

var water_height = -50

var resolution = 0.25 # vertex per meter per directions
var size = 700 # meters
var vertices_per_dimension = resolution * size # number of vertices for the whole chunk
var grid_vertex_distance = float(size) / (vertices_per_dimension - 1) #meters

var center_point = Vector2.ZERO

signal water_hit

func _ready():
    generate_sand()
    generate_water()

    # water_hit.connect(func():print("heyo"))

func generate_sand():
    var surface_array = []
    surface_array.resize(Mesh.ARRAY_MAX)

    var verts = PackedVector3Array()
    # var uvs = PackedVector2Array()
    var normals = PackedVector3Array()
    var indices = PackedInt32Array()

    verts = create_grid_vertices()
    indices = create_grid_indices()
    normals = create_normals()
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
    mesh_instace.position = Vector3.ONE * -0.5 * size
    mesh_instace.position.y = -10
    mesh_instace.material_override = get_sand_material()
    # print("position", mesh_instace.position)

    # set collider
    $SandCollisionShape.shape = array_mesh.create_trimesh_shape()
    # $CollisionShape3D.scale = mesh_instace.scale
    $SandCollisionShape.position = mesh_instace.position

    add_child(mesh_instace)

func generate_water():
    var mesh_instace = MeshInstance3D.new()
    mesh_instace.mesh = PlaneMesh.new()
    mesh_instace.scale = Vector3.ONE * size * 20
    mesh_instace.position.y = water_height
    mesh_instace.material_override = get_water_material()

    add_child(mesh_instace)
    # collider
    $WaterArea.find_child("WaterCollisionShape").position.y = water_height
    $WaterArea.connect("body_entered",func (_b): water_hit.emit())


func create_grid_vertices():
    var grid_vertices = PackedVector3Array()
    for x in range(vertices_per_dimension):
        for z in range(vertices_per_dimension):
            #TODO: calculate y based on sin functions
            var x_pos = x * grid_vertex_distance
            var z_pos = z * grid_vertex_distance
            var y = calculate_ground_height(x_pos, z_pos)
            var vertex_position = Vector3(x_pos, y, z_pos)
            grid_vertices.push_back(vertex_position)
    # print("grid_vertices", len(grid_vertices))
    assert(len(grid_vertices) == (resolution * size) ** 2)
    return grid_vertices


func create_grid_indices():
    var indices = PackedInt32Array()
    var i = 0
    for x in range(vertices_per_dimension - 1):
        for z in range(vertices_per_dimension - 1):
            indices.push_back(i + vertices_per_dimension)
            indices.push_back(i + 1)
            indices.push_back(i)
            indices.push_back(i + vertices_per_dimension)
            indices.push_back(i + vertices_per_dimension + 1)
            indices.push_back(i + 1)
            i += 1
        i += 1
    # print("indices", len(indices))
    return indices


func create_normals():
    #TODO: needs to depend on sin functions
    var normals = PackedVector3Array()
    for n in range((vertices_per_dimension) * (vertices_per_dimension)):
        normals.push_back(Vector3.UP)
    return normals


func get_sand_material():
    var material = StandardMaterial3D.new()
    var texture = load(sand_texture_path)
    material.albedo_texture = texture
    material.uv1_triplanar = true
    material.uv1_world_triplanar = true
    material.uv1_scale = Vector3.ONE * 1.0 / float(texture_size)
    material.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
    return material

func get_water_material():
    var material = StandardMaterial3D.new()
    material.albedo_color= Color.AQUAMARINE
    material.uv1_triplanar = true
    material.uv1_world_triplanar = true
    material.uv1_scale = Vector3.ONE * 1.0 / float(texture_size)
    material.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
    return material

func is_water(x,z):
    return Vector2(x,z).distance_to(center_point)>(float(size)/2)

func is_near_water(x,z):
    return Vector2(x,z).distance_to(center_point)> (float(size)/2 - 20)

func get_lerp_water_param(x,z):
    return 1 - ((Vector2(x,z).distance_to(center_point) - (float(size)/2 - 20))/20)

func calculate_ground_height(x, z):
    # move coordinates, as the whole mesh is moved as well so player spawns in the middle
    x = x - 0.5 * size
    z = z - 0.5 * size
    if (is_water(x,z)):
        return water_height-1
    var water_param = 1
    if (is_near_water(x,z)):
         water_param = get_lerp_water_param(x,z)
    
    var coefficients = [
        [10, 25],
        [30, 3],
        [2, 80],
        [60, 1],
        [8, 6],
        [1, 5],
        [6, 1],
        [3, 9],
        [2, 0],
        [8, 1],
        [1, 1],
        [8, 0],
        [1, 8],
        [1, 8],
        [20, 1],
        [2, 22],
        [2, 8],
        [8, 1],
        [8, 8],
        [0, 1],
        [1, 8],
        [2, 0],
        [30, 1],
        [20, 2],
        [2, 8],
        [1, 8],
        [20, 1],
        [2, 18],
    ]

    var levels = range(len(coefficients))

    var y = 0
    for i in levels:
        y = y + sin(x * i * lowest_ground_frequency) * coefficients[i][0]
        y = y + sin(z * i * lowest_ground_frequency) * coefficients[i][1]

    y = y / len(coefficients)
    y = y * height_scale

    #lerp with water
    y = y * water_param + water_height * (1-water_param)

    return y
