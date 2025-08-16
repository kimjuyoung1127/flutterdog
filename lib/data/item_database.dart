import 'package:myapp/models/item_model.dart';

// This file acts as a local, static database for all items available in the game.

class ItemDatabase {
  static final Map<String, Item> items = {
    // === 🛡️ GUARDIAN CLASS REWARDS ===
    'item_fluffy_cushion': const Item(
      id: 'item_fluffy_cushion',
      name: '푹신한 방석',
      description: '하우스 훈련의 달인에게 주어지는 보상. 편안함은 인내심을 길러줍니다.',
      iconAsset: 'assets/icons/items/cushion.png',
      slot: ItemSlot.accessory,
      stats: {'patience': 2},
    ),
    'item_golden_pad': const Item(
      id: 'item_golden_pad',
      name: '황금 배변패드',
      description: '실수 없는 배변 능력의 증표. 어떤 상황에서도 평정심을 잃지 않게 됩니다.',
      iconAsset: 'assets/icons/items/pad.png',
      slot: ItemSlot.accessory,
      stats: {'special_resistance': 5},
    ),
     'item_tug_toy': const Item(
      id: 'item_tug_toy',
      name: '즐거운 터그 장난감',
      description: '올바른 방법으로 에너지를 표출하는 법을 배운 강아지의 상징입니다.',
      iconAsset: 'assets/icons/items/tug_toy.png',
      slot: ItemSlot.accessory,
      stats: {'attack': 3},
    ),
    'item_sturdy_harness': const Item(
      id: 'item_sturdy_harness',
      name: '튼튼한 하네스',
      description: '산책 예절을 마스터한 강아지에게 주어지는 품격있는 하네스입니다.',
      iconAsset: 'assets/icons/items/harness.png',
      slot: ItemSlot.body,
      stats: {'defense': 5},
    ),
    // ... other items for all classes will be added here ...
  };

  static Item? getItemById(String id) {
    return items[id];
  }
}
