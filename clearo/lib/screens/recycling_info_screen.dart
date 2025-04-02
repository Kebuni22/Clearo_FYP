import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class RecyclingInfoScreen extends StatefulWidget {
  const RecyclingInfoScreen({Key? key}) : super(key: key);

  @override
  State<RecyclingInfoScreen> createState() => _RecyclingInfoScreenState();
}

class _RecyclingInfoScreenState extends State<RecyclingInfoScreen> {
  final List<Map<String, dynamic>> _recyclingCategories = [
    {
      'name': 'Plastic',
      'icon': Icons.local_drink,
      'color': Colors.blue,
      'items': [
        'Water bottles',
        'Plastic containers',
        'Milk jugs',
        'Detergent bottles',
        'Shampoo bottles',
      ],
      'tips': 'Rinse containers before recycling. Remove and discard caps.',
    },
    {
      'name': 'Paper',
      'icon': Icons.article,
      'color': Colors.amber,
      'items': [
        'Newspaper',
        'Magazines',
        'Office paper',
        'Envelopes',
        'Cardboard boxes',
      ],
      'tips':
          'Keep paper dry and clean. Remove plastic windows from envelopes.',
    },
    {
      'name': 'Glass',
      'icon': Icons.wine_bar,
      'color': Colors.green,
      'items': ['Bottles (any color)', 'Jars', 'Food containers'],
      'tips': 'Rinse containers. Remove lids and recycle separately.',
    },
    {
      'name': 'Metal',
      'icon': Icons.psychology_alt,
      'color': Colors.blueGrey,
      'items': [
        'Aluminum cans',
        'Steel cans',
        'Metal lids',
        'Aluminum foil (clean)',
        'Metal bottle caps',
      ],
      'tips': 'Rinse cans and containers. Crush if possible to save space.',
    },
    {
      'name': 'Electronics',
      'icon': Icons.devices,
      'color': Colors.purple,
      'items': [
        'Old phones',
        'Computers',
        'Cables',
        'Batteries',
        'Small appliances',
      ],
      'tips':
          'Remove batteries before recycling. Wipe personal data from devices.',
    },
    {
      'name': 'Organic',
      'icon': Icons.compost,
      'color': Colors.brown,
      'items': [
        'Food scraps',
        'Yard waste',
        'Coffee grounds',
        'Tea bags',
        'Plant trimmings',
      ],
      'tips': 'Do not include meat, dairy, or oils in home compost.',
    },
  ];

  final List<Map<String, dynamic>> _recyclingCenters = [
    {
      'name': 'Colombo Recycling Center',
      'address': '123 Main Street, Colombo 01, Sri Lanka',
      'distance': '1.2 km',
      'rating': 4.5,
      'hours': '8AM - 6PM',
      'latitude': 6.9271,
      'longitude': 79.8612,
    },
    {
      'name': 'Eco Friends Recycling',
      'address': '45 Green Road, Colombo 05, Sri Lanka',
      'distance': '3.5 km',
      'rating': 4.2,
      'hours': '9AM - 5PM',
      'latitude': 6.8941,
      'longitude': 79.8762,
    },
    {
      'name': 'Clean Lanka Recycling',
      'address': '78 Eco Lane, Colombo 07, Sri Lanka',
      'distance': '5.8 km',
      'rating': 4.0,
      'hours': '24 hours',
      'latitude': 6.9061,
      'longitude': 79.8706,
    },
    {
      'name': 'Scarp Metal Recycling Centre',
      'address': '230/6 Sedawatta - Ambatale Rd, Wellampitiya 10600, Sri Lanka',
      'distance': '6.0 km',
      'rating': 4.3,
      'hours': '8AM - 8PM',
      'latitude': 6.8983231,
      'longitude': 79.8927558,
    },
  ];

  final List<String> _motivations = [
    'Recycling reduces waste sent to landfills and incinerators.',
    'It conserves natural resources like timber, water, and minerals.',
    'Recycling saves energy and reduces greenhouse gas emissions.',
    'It helps create jobs in the recycling and manufacturing industries.',
    'Every small effort contributes to a cleaner and greener planet.',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recycling Information'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Recycling Categories'),
            const SizedBox(height: 8),
            _buildRecyclingCategories(),
            const SizedBox(height: 24),
            _buildSectionTitle('Motivations to Recycle'),
            const SizedBox(height: 8),
            _buildMotivations(),
            const SizedBox(height: 24),
            _buildSectionTitle('Nearest Recycling Centers'),
            const SizedBox(height: 8),
            _buildRecyclingCentersList(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildRecyclingCategories() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.2,
      ),
      itemCount: _recyclingCategories.length,
      itemBuilder: (context, index) {
        final category = _recyclingCategories[index];
        return _buildCategoryCard(category);
      },
    );
  }

  Widget _buildCategoryCard(Map<String, dynamic> category) {
    return InkWell(
      onTap: () {
        _showCategoryDetailsDialog(category);
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: (category['color'] as Color).withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: (category['color'] as Color).withOpacity(0.3),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              category['icon'] as IconData,
              size: 40,
              color: category['color'] as Color,
            ),
            const SizedBox(height: 12),
            Text(
              category['name'],
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMotivations() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          _motivations
              .map(
                (motivation) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      const Icon(Icons.star, color: Colors.orange, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          motivation,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
    );
  }

  Widget _buildRecyclingCentersList() {
    return Column(
      children:
          _recyclingCenters.map((center) {
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(12),
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.location_on, color: Colors.green),
                ),
                title: Text(
                  center['name'] as String,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(center['address'] as String),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text('${center['distance']} away'),
                        const SizedBox(width: 8),
                        const Icon(Icons.star, color: Colors.amber, size: 14),
                        Text('${center['rating']}'),
                        const Spacer(),
                        const Icon(Icons.access_time, size: 14),
                        const SizedBox(width: 4),
                        Text(center['hours'] as String),
                      ],
                    ),
                  ],
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  _showCenterDetailsDialog(center);
                },
              ),
            );
          }).toList(),
    );
  }

  void _showCategoryDetailsDialog(Map<String, dynamic> category) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Row(
              children: [
                Icon(
                  category['icon'] as IconData,
                  color: category['color'] as Color,
                ),
                const SizedBox(width: 8),
                Text('${category['name']} Recycling'),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Recyclable Items:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ...List.generate(
                    (category['items'] as List).length,
                    (index) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Text(category['items'][index] as String),
                        ],
                      ),
                    ),
                  ),
                  const Divider(),
                  const Text(
                    'Tips:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(category['tips'] as String),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ],
          ),
    );
  }

  void _showCenterDetailsDialog(Map<String, dynamic> center) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(center['name'] as String),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailItem('Address', center['address'] as String),
                _buildDetailItem('Distance', center['distance'] as String),
                _buildDetailItem('Operating Hours', center['hours'] as String),
                _buildDetailItem('Rating', '${center['rating']} / 5.0'),
                const SizedBox(height: 16),
                const Text(
                  'Accepted Materials:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    Chip(label: Text('Paper')),
                    Chip(label: Text('Plastic')),
                    Chip(label: Text('Glass')),
                    Chip(label: Text('Metal')),
                    Chip(label: Text('Electronics')),
                    Chip(label: Text('Batteries')),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  _openMap(center['latitude'], center['longitude']);
                },
                icon: const Icon(Icons.directions),
                label: const Text('Get Directions'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              ),
            ],
          ),
    );
  }

  Widget _buildDetailItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$title:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openMap(double latitude, double longitude) async {
    final googleMapsUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
      await launchUrl(Uri.parse(googleMapsUrl));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not open Google Maps'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
