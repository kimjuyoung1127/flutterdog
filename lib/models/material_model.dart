/// Represents a crafting or training material obtained from quests.
/// Unlike Items, Materials are typically stackable and used as currency or ingredients.
class Material {
  final String id;
  final String name;
  final String description;
  final String iconAsset;

  const Material({
    required this.id,
    required this.name,
    required this.description,
    required this.iconAsset,
  });
}
