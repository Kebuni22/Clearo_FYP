import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io'; // Import for File handling

class CommunitySharingScreen extends StatefulWidget {
  const CommunitySharingScreen({Key? key}) : super(key: key);

  @override
  State<CommunitySharingScreen> createState() => _CommunitySharingScreenState();
}

class _CommunitySharingScreenState extends State<CommunitySharingScreen> {
  final List<Map<String, dynamic>> _sharedItems = [
    {
      'id': 'ITEM-001',
      'title': 'Food Waste Bin',
      'description': 'A sturdy bin for Food Waste.',
      'image': 'assets/images/food_waste_bin.png',
      'status': 'Available',
      'expiration': '2 days left',
      'owner': 'John Doe',
      'icon': Icons.delete,
      'price': 'Free',
    },
    {
      'id': 'ITEM-002',
      'title': 'Plastic Waste Bin',
      'description': 'A bin for Polythene & Plastic Waste.',
      'image': 'assets/images/plastic_waste_bin.png',
      'status': 'Claimed',
      'expiration': 'Expired',
      'owner': 'Jane Smith',
      'icon': Icons.recycling,
      'price': 'Free',
    },
    {
      'id': 'ITEM-003',
      'title': 'Table',
      'description': 'A wooden table in good condition.',
      'image': 'assets/images/table.png',
      'status': 'Available',
      'expiration': '5 days left',
      'owner': 'Alice Johnson',
      'icon': Icons.table_chart,
      'price': 'Rs. 1500',
    },
    {
      'id': 'ITEM-004',
      'title': 'Computer',
      'description': 'A used desktop computer, fully functional.',
      'image': 'assets/images/computer.png',
      'status': 'Available',
      'expiration': '3 days left',
      'owner': 'Michael Brown',
      'icon': Icons.computer,
      'price': 'Rs. 8000',
    },
    {
      'id': 'ITEM-005',
      'title': 'Water Tank',
      'description': 'A 500-liter water tank in excellent condition.',
      'image': 'assets/images/water_tank.png',
      'status': 'Available',
      'expiration': '7 days left',
      'owner': 'Emily Davis',
      'icon': Icons.water,
      'price': 'Free',
    },
    {
      'id': 'ITEM-006',
      'title': 'Metal Sheet',
      'description': 'A durable metal sheet for construction.',
      'image': 'assets/images/metal_sheet.png',
      'status': 'Available',
      'expiration': '4 days left',
      'owner': 'Chris Wilson',
      'icon': Icons.construction,
      'price': 'Rs. 2500',
    },
    {
      'id': 'ITEM-007',
      'title': 'Gate',
      'description': 'A steel gate, slightly used.',
      'image': 'assets/images/gate.png',
      'status': 'Available',
      'expiration': '6 days left',
      'owner': 'Sophia Lee',
      'icon': Icons.door_front_door,
      'price': 'Rs. 5300',
    },
  ];

  final List<Map<String, dynamic>> _cartItems = []; // Cart items list
  String _searchQuery = '';
  String _selectedFilter = 'All';

  final List<String> _filters = [
    'All',
    'Free',
    'Rs. 0 - Rs. 2000',
    'Rs. 2000+',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Community Sharing'),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: _showCartDialog, // Show cart dialog
            tooltip: 'View Cart',
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchAndFilterBar(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _getFilteredItems().length,
              itemBuilder: (context, index) {
                final item = _getFilteredItems()[index];
                return _buildSharedItemCard(item);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddItemDialog,
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add),
        tooltip: 'Add New Item',
      ),
    );
  }

  Widget _buildSearchAndFilterBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
              decoration: InputDecoration(
                hintText: 'Search items...',
                prefixIcon: const Icon(Icons.search, color: Colors.teal),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          DropdownButton<String>(
            value: _selectedFilter,
            items:
                _filters
                    .map(
                      (filter) =>
                          DropdownMenuItem(value: filter, child: Text(filter)),
                    )
                    .toList(),
            onChanged: (value) {
              setState(() {
                _selectedFilter = value!;
              });
            },
            underline: const SizedBox(),
            icon: const Icon(Icons.filter_list, color: Colors.teal),
            style: const TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getFilteredItems() {
    return _sharedItems.where((item) {
      final matchesSearch =
          item['title'].toString().toLowerCase().contains(_searchQuery) ||
          item['description'].toString().toLowerCase().contains(_searchQuery);

      final matchesFilter =
          _selectedFilter == 'All' ||
          (_selectedFilter == 'Free' && item['price'] == 'Free') ||
          (_selectedFilter == 'Rs. 0 - Rs. 2000' &&
              item['price'] != 'Free' &&
              int.tryParse(item['price'].replaceAll(RegExp(r'[^\d]'), ''))! <=
                  2000) ||
          (_selectedFilter == 'Rs. 2000+' &&
              item['price'] != 'Free' &&
              int.tryParse(item['price'].replaceAll(RegExp(r'[^\d]'), ''))! >
                  2000);

      return matchesSearch && matchesFilter;
    }).toList();
  }

  Widget _buildSharedItemCard(Map<String, dynamic> item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.teal.withOpacity(0.1),
                  child: Icon(item['icon'], color: Colors.teal),
                  radius: 30,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['title'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        item['description'],
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Chip(
                  label: Text(item['price']),
                  backgroundColor:
                      item['price'] == 'Free'
                          ? Colors.green.withOpacity(0.2)
                          : Colors.blue.withOpacity(0.2),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Expires in: ${item['expiration']}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        _addToCart(item);
                      },
                      icon: const Icon(Icons.add_shopping_cart, size: 18),
                      label: const Text('Add to Cart'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: () {
                        _showChatDialog(item['owner']);
                      },
                      icon: const Icon(Icons.message, size: 18),
                      label: const Text('Chat'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _addToCart(Map<String, dynamic> item) {
    setState(() {
      _cartItems.add(item);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item['title']} added to cart'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showCartDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Cart'),
            content:
                _cartItems.isEmpty
                    ? const Text('Your cart is empty.')
                    : Column(
                      mainAxisSize: MainAxisSize.min,
                      children:
                          _cartItems.map((item) {
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.teal.withOpacity(0.1),
                                child: Icon(item['icon'], color: Colors.teal),
                              ),
                              title: Text(item['title']),
                              subtitle: Text(item['price']),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.remove_circle,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _cartItems.remove(item);
                                  });
                                  Navigator.of(context).pop();
                                  _showCartDialog();
                                },
                              ),
                            );
                          }).toList(),
                    ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
              if (_cartItems.isNotEmpty)
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _cartItems.clear();
                    });
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Purchase completed successfully'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                  child: const Text('Checkout'),
                ),
            ],
          ),
    );
  }

  void _showAddItemDialog() {
    final ImagePicker _picker = ImagePicker();
    XFile? _selectedImage;
    final TextEditingController _titleController = TextEditingController();
    final TextEditingController _descriptionController =
        TextEditingController();
    final TextEditingController _expirationController = TextEditingController();

    Future<void> _pickImage(ImageSource source) async {
      try {
        final pickedImage = await _picker.pickImage(source: source);
        if (pickedImage != null) {
          setState(() {
            _selectedImage = pickedImage;
          });
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error picking image: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    showDialog(
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder:
                (context, setState) => AlertDialog(
                  title: const Text('Add New Item'),
                  content: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            showModalBottomSheet(
                              context: context,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20),
                                ),
                              ),
                              builder:
                                  (context) => Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ListTile(
                                        leading: const Icon(Icons.camera_alt),
                                        title: const Text('Take a Photo'),
                                        onTap: () {
                                          Navigator.pop(context);
                                          _pickImage(ImageSource.camera);
                                        },
                                      ),
                                      ListTile(
                                        leading: const Icon(
                                          Icons.photo_library,
                                        ),
                                        title: const Text(
                                          'Choose from Gallery',
                                        ),
                                        onTap: () {
                                          Navigator.pop(context);
                                          _pickImage(ImageSource.gallery);
                                        },
                                      ),
                                    ],
                                  ),
                            );
                          },
                          child: Container(
                            height: 150,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child:
                                _selectedImage == null
                                    ? const Center(
                                      child: Text(
                                        'Tap to select an image',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    )
                                    : ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.file(
                                        File(_selectedImage!.path),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _titleController,
                          decoration: const InputDecoration(
                            labelText: 'Title',
                            hintText: 'Enter item title',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _descriptionController,
                          decoration: const InputDecoration(
                            labelText: 'Description',
                            hintText: 'Enter item description',
                            border: OutlineInputBorder(),
                          ),
                          maxLines: 3,
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _expirationController,
                          decoration: const InputDecoration(
                            labelText: 'Expiration Time',
                            hintText: 'E.g., 2 days',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_selectedImage == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please select an image'),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }
                        if (_titleController.text.isEmpty ||
                            _descriptionController.text.isEmpty ||
                            _expirationController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please fill in all fields'),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        setState(() {
                          _sharedItems.add({
                            'id': 'ITEM-${_sharedItems.length + 1}',
                            'title': _titleController.text,
                            'description': _descriptionController.text,
                            'image': _selectedImage!.path,
                            'status': 'Available',
                            'expiration': _expirationController.text,
                            'owner': 'You',
                            'icon': Icons.add,
                          });
                        });

                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Item added successfully'),
                            backgroundColor: Colors.teal,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                      ),
                      child: const Text('Add Item'),
                    ),
                  ],
                ),
          ),
    );
  }

  void _showChatDialog(String owner) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Chat with $owner'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const TextField(
                  decoration: InputDecoration(
                    hintText: 'Type your message...',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Message sent successfully'),
                        backgroundColor: Colors.teal,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                  child: const Text('Send'),
                ),
              ],
            ),
          ),
    );
  }
}
