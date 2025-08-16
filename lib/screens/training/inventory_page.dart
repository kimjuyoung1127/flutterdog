import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/data/item_database.dart';
import 'package:myapp/models/dog_model.dart';
import 'package:myapp/models/item_model.dart';
import 'package:myapp/services/dog_service.dart';

class InventoryPage extends StatefulWidget {
  final Dog dog;

  const InventoryPage({super.key, required this.dog});

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  late Dog _currentDog;
  final DogService _dogService = DogService();
  Item? _selectedItem;

  @override
  void initState() {
    super.initState();
    _currentDog = widget.dog;
  }

  void _onInventoryItemTap(Item item) {
    setState(() {
      _selectedItem = item;
    });
  }

  void _onEquippedItemTap(ItemSlot slot) async {
    final equippedItemId = _currentDog.equippedItems[slot.name];
    if (equippedItemId == null || _currentDog.id == null) return;

    final scaffoldMessenger = ScaffoldMessenger.of(context);
    try {
      await _dogService.unequipItem(_currentDog.id!, slot.name);
      final newEquippedItems = Map<String, String>.from(_currentDog.equippedItems)..remove(slot.name);
      
      if(mounted) {
        setState(() {
          _currentDog = _currentDog.copyWith(equippedItems: newEquippedItems);
          _selectedItem = null;
        });
        scaffoldMessenger.showSnackBar(
          const SnackBar(content: Text('Item unequipped!'), backgroundColor: Colors.blue),
        );
      }
    } catch (e) {
      if(mounted) {
        scaffoldMessenger.showSnackBar(
          SnackBar(content: Text('Failed to unequip item: ${e.toString()}'), backgroundColor: Colors.red),
        );
      }
    }
  }

  void _equipSelectedItem() async {
    if (_selectedItem == null || _currentDog.id == null) return;
    
    final itemToEquip = _selectedItem!;
    final slotName = itemToEquip.slot.name;
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      await _dogService.equipItem(_currentDog.id!, itemToEquip.id, slotName);
      final newEquippedItems = Map<String, String>.from(_currentDog.equippedItems);
      newEquippedItems[slotName] = itemToEquip.id;

      if(mounted) {
        setState(() {
          _currentDog = _currentDog.copyWith(equippedItems: newEquippedItems);
          _selectedItem = null;
        });
         scaffoldMessenger.showSnackBar(
          SnackBar(content: Text('${itemToEquip.name} equipped!'), backgroundColor: Colors.green),
        );
      }
    } catch(e) {
       if(mounted) {
        scaffoldMessenger.showSnackBar(
          SnackBar(content: Text('Failed to equip item: ${e.toString()}'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inventory', style: GoogleFonts.pressStart2p()),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Expanded(flex: 2, child: _buildEquipmentSlots()),
                const VerticalDivider(),
                Expanded(flex: 3, child: _buildInventoryGrid()),
              ],
            ),
          ),
          const Divider(),
          Expanded(flex: 2, child: _buildItemDetails()),
        ],
      ),
    );
  }

  Widget _buildEquipmentSlots() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Equipment", style: GoogleFonts.pressStart2p(fontSize: 18)),
          const Divider(),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: ItemSlot.values.map((slot) {
                final equippedItemId = _currentDog.equippedItems[slot.name];
                final equippedItem = equippedItemId != null ? ItemDatabase.getItemById(equippedItemId) : null;
                return _buildSingleSlot(slot, equippedItem);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSingleSlot(ItemSlot slot, Item? item) {
    final bool isSelected = _selectedItem != null && _selectedItem!.slot == slot;
    return GestureDetector(
      onTap: () => _onEquippedItemTap(slot),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: isSelected ? Colors.green : Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(_getIconForSlot(slot), size: 32, color: Colors.grey.shade700),
            const SizedBox(width: 12),
            Expanded(
              child: item != null
                  ? Text(item.name, overflow: TextOverflow.ellipsis)
                  : Text('Empty', style: TextStyle(color: Colors.grey.shade500, fontStyle: FontStyle.italic)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInventoryGrid() {
    final inventoryItems = _currentDog.inventory
        .map((itemId) => ItemDatabase.getItemById(itemId))
        .where((item) => item != null).cast<Item>().toList();

    if (inventoryItems.isEmpty) {
      return const Center(child: Text("Inventory is empty."));
    }

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, mainAxisSpacing: 4, crossAxisSpacing: 4),
      padding: const EdgeInsets.all(8),
      itemCount: inventoryItems.length,
      itemBuilder: (context, index) {
        final item = inventoryItems[index];
        final isSelected = _selectedItem?.id == item.id;
        return GestureDetector(
          onTap: () => _onInventoryItemTap(item),
          child: Card(
            color: isSelected ? Colors.blue.shade100 : null,
            child: const Center(child: Icon(Icons.help_outline, color: Colors.grey)),
          ),
        );
      },
    );
  }

  Widget _buildItemDetails() {
    if (_selectedItem == null) {
      return const Center(child: Text('Select an item to see details.'));
    }
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(_selectedItem!.name, style: GoogleFonts.pressStart2p(fontSize: 20)),
          Text('Slot: ${_selectedItem!.slot.name}', style: const TextStyle(fontStyle: FontStyle.italic)),
          const Divider(),
          Text(_selectedItem!.description),
          const SizedBox(height: 8),
          Text('Stats: ${_selectedItem!.stats}'),
          const Spacer(),
          ElevatedButton(
            onPressed: _equipSelectedItem,
            child: const Text('Equip Item'),
          ),
        ],
      ),
    );
  }
  
  IconData _getIconForSlot(ItemSlot slot) {
    switch (slot) {
      case ItemSlot.head: return Icons.person_outline; // Corrected icon
      case ItemSlot.body: return Icons.shield_outlined;
      case ItemSlot.feet: return Icons.directions_walk;
      case ItemSlot.accessory: return Icons.star_outline;
    }
  }
}
