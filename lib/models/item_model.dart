enum ItemSlot { head, body, feet, accessory }

class Item {
  final String id;
  final String name;
  final String description;
  final String iconAsset;
  final ItemSlot slot; // Which part of the digital ID card the item can be equipped to
  // Defines the stat boosts this item provides, e.g., {'patience': 2, 'attack': 1}
  final Map<String, int> stats;

  const Item({
    required this.id,
    required this.name,
    required this.description,
    required this.iconAsset,
    required this.slot,
    required this.stats,
  });
}
