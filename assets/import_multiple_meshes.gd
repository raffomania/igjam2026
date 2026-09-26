@tool
extends EditorScenePostImport

const FOLDER_PATH = "res://assets/separated/"
const FILE_TEMPLATE = FOLDER_PATH + "%s.tscn"


func _post_import(scene):
    DirAccess.make_dir_recursive_absolute(FOLDER_PATH)
    for child in scene.get_children():
        save_node_and_children(child)
    return scene


func save_node_and_children(node: Node):
    var packed_scene: PackedScene = PackedScene.new()
    set_owner_for_all_children(node, node)
    packed_scene.pack(node)
    ResourceSaver.save(packed_scene, FILE_TEMPLATE % node.name)


func set_owner_for_all_children(parent, root):
    for child in parent.get_children():
        child.owner = root
        set_owner_for_all_children(child, root)
