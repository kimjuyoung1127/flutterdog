import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/data/item_database.dart';
import 'package:myapp/data/material_database.dart';
import 'package:myapp/models/dog_model.dart';
import 'package:myapp/models/item_model.dart';

class InventoryPage extends StatefulWidget {
  final Dog dog;

  const InventoryPage({super.key, required this.dog});

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Dog _currentDog;
  final DogService _dogService = DogService();
  dynamic _selectedObject; // Can be an Item or a Material

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _currentDog = widget.dog;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // --- UI Building Methods ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inventory', style: GoogleFonts.pressStart2p()),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Equipment'),
            Tab(text: 'Materials'),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildEquipmentGrid(),
                _buildMaterialGrid(),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            flex: 1,
            child: _buildDetailsPane(),
          ),
        ],
      ),
    );
  }

  Widget _buildEquipmentGrid() {
    final equipment = _getInventoryItems<Item>(ItemDatabase.items);
    if (equipment.isEmpty) return const Center(child: Text("No equipment found."));

    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
        itemCount: equipment.length,
        itemBuilder: (context, index) {
          final item = equipment[index];
          final isSelected = _selectedObject is Item && _selectedObject.id == item.id;
          return InkWell(
            onTap: () => setState(() => _selectedObject = item),
            child: Card(
              color: isSelected ? Colors.blue.shade100 : null,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(Icons.shield, color: Colors.grey), // Placeholder
                  Positioned(
                    bottom: 2,
                    right: 2,
                    child: Text("x${_currentDog.inventory[item.id] ?? 0}", style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget _buildMaterialGrid() {
    final materials = _getInventoryItems<dynamic>(MaterialDatabase.materials);
     if (materials.isEmpty) return const Center(child: Text("No materials found."));

    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
        itemCount: materials.length,
        itemBuilder: (context, index) {
          final material = materials[index];
           final isSelected = _selectedObject is Material && _selectedObject.id == material.id;
          return InkWell(
            onTap: () => setState(() => _selectedObject = material),
             child: Card(
              color: isSelected ? Colors.blue.shade100 : null,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(Icons.build, color: Colors.grey), // Placeholder
                  Positioned(
                    bottom: 2,
                    right: 2,
                    child: Text("x${_currentDog.inventory[material.id] ?? 0}", style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          );
        });
  }
  
  Widget _buildDetailsPane() {
    if (_selectedObject == null) {
      return const Center(child: Text('Select an item or material to see details.'));
    }
    
    final name = _selectedObject.name;
    final description = _selectedObject.description;
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(name, style: GoogleFonts.pressStart2p(fontSize: 20)),
          const Divider(),
          Text(description),
          // Add equip button only if the selected object is an Item
          if (_selectedObject is Item) ...[
            const Spacer(),
            ElevatedButton(
              onPressed: () { /* Equip logic here */ },
              child: const Text('Equip Item'),
            )
          ]
        ],
      ),
    );
  }

  // --- Helper Methods ---

  List<T> _getInventoryItems<T>(Map<String, T> database) {
    return _currentDog.inventory.keys
        .where((itemId) => database.containsKey(itemId))
        .map((itemId) => database[itemId]!)
        .toList();
  }
}
