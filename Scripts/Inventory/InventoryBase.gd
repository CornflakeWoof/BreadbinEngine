extends Resource
class_name ItemBase

#SHORT NAME FOR INTERNAL REFERENCE
@export var internalname : String = "unconfigureditem"
#ACTUAL NAME PRESENTED TO PLAYER IN-GAME
@export var ingamename : String = "Unconfigured Item"
#SHORT PROSE TEXT EXPLAINING WHAT ITEM DOES
@export var explanation : String = ""
#LONG PROSE TEXT WITH EXTRA INFO AND LORE
@export var lore : String = "This item lacks configuration, obscuring its purpose."

#PATH STARTS FROM res://Meshes/
@export var ItemModelScenePath : String = ""
@export_enum("LHandWeapon_AttachPoint","RHandWeapon_AttachPoint",
"Armor_HelmPoint","Armor_ChestPoint",
"Armor_LPauldronPoint","Armor_RPauldronPoint") var ItemModelAttachPoint
