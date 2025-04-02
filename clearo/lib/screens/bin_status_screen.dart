import 'package:flutter/material.dart';
import 'dart:math' as math;

class BinStatusScreen extends StatefulWidget {
  const BinStatusScreen({Key? key}) : super(key: key);

  @override
  State<BinStatusScreen> createState() => _BinStatusScreenState();
}

class _BinStatusScreenState extends State<BinStatusScreen> {
  final List<Map<String, dynamic>> _bins = [
    {
      'id': 'BIN-1001',
      'location': 'Food Waste',
      'type': 'Food Waste',
      'capacity': 120,
      'fillLevel': 0.75,
      'lastEmptied': '2 days ago',
      'status': 'Normal',
    },
    {
      'id': 'BIN-1002',
      'location': 'Polythene & Plastic Waste',
      'type': 'Polythene & Plastic Waste',
      'capacity': 90,
      'fillLevel': 0.45,
      'lastEmptied': '3 days ago',
      'status': 'Normal',
    },
    {
      'id': 'BIN-1003',
      'location': 'Other Waste',
      'type': 'Other Waste',
      'capacity': 60,
      'fillLevel': 0.92,
      'lastEmptied': '5 days ago',
      'status': 'Almost Full',
    },
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bin Status'),
        backgroundColor: Colors.green,
      ),
      body: _buildOverviewTab(), // Directly show the overview tab
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddBinDialog();
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
        tooltip: 'Add New Bin',
      ),
    );
  }

  Widget _buildOverviewTab() {
    return Column(
      children: [
        _buildStatusSummary(),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _bins.length,
            itemBuilder: (context, index) {
              final bin = _bins[index];
              return _buildBinCard(bin);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStatusSummary() {
    // Calculate stats
    int totalBins = _bins.length;
    int normalBins = _bins.where((bin) => bin['status'] == 'Normal').length;
    int warningBins =
        _bins.where((bin) => bin['status'] == 'Almost Full').length;
    int alertBins = _bins.where((bin) => bin['status'] == 'Full').length;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Bin Status Summary',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildStatusIndicator('Total', totalBins, Colors.blue),
              _buildStatusIndicator('Normal', normalBins, Colors.green),
              _buildStatusIndicator('Warning', warningBins, Colors.orange),
              _buildStatusIndicator('Full', alertBins, Colors.red),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusIndicator(String label, int count, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Text(
              count.toString(),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              label,
              style: TextStyle(fontSize: 12, color: color.withOpacity(0.8)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBinCard(Map<String, dynamic> bin) {
    Color statusColor;
    if (bin['status'] == 'Normal') {
      statusColor = Colors.green;
    } else if (bin['status'] == 'Almost Full') {
      statusColor = Colors.orange;
    } else {
      statusColor = Colors.red;
    }

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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bin['location'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'ID: ${bin['id']} • ${bin['type']}',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: statusColor.withOpacity(0.3)),
                  ),
                  child: Text(
                    bin['status'],
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                // Fill level visualizer
                SizedBox(
                  width: 120,
                  height: 120,
                  child: _buildFillLevelIndicator(bin['fillLevel']),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailRow('Capacity', '${bin['capacity']} liters'),
                      const SizedBox(height: 8),
                      _buildDetailRow(
                        'Fill Level',
                        '${(bin['fillLevel'] * 100).toInt()}%',
                      ),
                      const SizedBox(height: 8),
                      _buildDetailRow('Last Emptied', bin['lastEmptied']),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton.icon(
                  onPressed: () {
                    _showBinDetailsDialog(bin);
                  },
                  icon: const Icon(Icons.info_outline, size: 18),
                  label: const Text('Details'),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () {
                    _showRequestEmptyingDialog(bin);
                  },
                  icon: const Icon(Icons.calendar_today, size: 18),
                  label: const Text('Request Emptying'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFillLevelIndicator(double fillLevel) {
    return CustomPaint(
      painter: _FillLevelPainter(
        fillLevel: fillLevel,
        fillColor: _getFillLevelColor(fillLevel),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${(fillLevel * 100).toInt()}%',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: _getFillLevelColor(fillLevel),
              ),
            ),
            const Text(
              'Full',
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }

  Color _getFillLevelColor(double fillLevel) {
    if (fillLevel < 0.5) {
      return Colors.green;
    } else if (fillLevel < 0.8) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 90,
          child: Text(
            '$label:',
            style: const TextStyle(
              color: Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  void _showBinDetailsDialog(Map<String, dynamic> bin) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Bin Details: ${bin['id']}'),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildDetailItem('ID', bin['id']),
                  _buildDetailItem('Location', bin['location']),
                  _buildDetailItem('Type', bin['type']),
                  _buildDetailItem('Capacity', '${bin['capacity']} liters'),
                  _buildDetailItem(
                    'Fill Level',
                    '${(bin['fillLevel'] * 100).toInt()}%',
                  ),
                  _buildDetailItem('Status', bin['status']),
                  _buildDetailItem('Last Emptied', bin['lastEmptied']),
                  _buildDetailItem('Next Collection', 'Scheduled in 2 days'),
                  _buildDetailItem('Installation Date', '10 Jan 2023'),
                  _buildDetailItem('Waste Type', bin['type']),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _showRequestEmptyingDialog(bin);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: const Text('Request Emptying'),
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

  void _showRequestEmptyingDialog(Map<String, dynamic> bin) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Request Bin Emptying'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Bin ID: ${bin['id']}'),
                Text('Location: ${bin['location']}'),
                Text('Type: ${bin['type']}'),
                const SizedBox(height: 16),
                const Text('Select preferred date:'),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () {
                    // Show date picker
                    showDatePicker(
                      context: context,
                      initialDate: DateTime.now().add(const Duration(days: 1)),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 14)),
                    );
                  },
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Preferred Date',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    child: const Text('Select Date'),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Any special instructions?'),
                const SizedBox(height: 8),
                const TextField(
                  decoration: InputDecoration(
                    hintText: 'E.g., Please empty before 9 AM',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Emptying request submitted successfully'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: const Text('Submit Request'),
              ),
            ],
          ),
    );
  }

  void _showAddBinDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Add New Bin'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const TextField(
                    decoration: InputDecoration(
                      labelText: 'Location',
                      hintText: 'e.g., Front Yard, Back Yard',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Bin Type',
                      border: OutlineInputBorder(),
                    ),
                    value: 'Food Waste',
                    items: const [
                      DropdownMenuItem(
                        value: 'Food Waste',
                        child: Text('Food Waste'),
                      ),
                      DropdownMenuItem(
                        value: 'Polythene & Plastic Waste',
                        child: Text('Polythene & Plastic Waste'),
                      ),
                      DropdownMenuItem(
                        value: 'Other Waste',
                        child: Text('Other Waste'),
                      ),
                    ],
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Capacity',
                      border: OutlineInputBorder(),
                    ),
                    value: '120 liters',
                    items: const [
                      DropdownMenuItem(
                        value: '30 liters',
                        child: Text('30 liters'),
                      ),
                      DropdownMenuItem(
                        value: '60 liters',
                        child: Text('60 liters'),
                      ),
                      DropdownMenuItem(
                        value: '90 liters',
                        child: Text('90 liters'),
                      ),
                      DropdownMenuItem(
                        value: '120 liters',
                        child: Text('120 liters'),
                      ),
                      DropdownMenuItem(
                        value: '240 liters',
                        child: Text('240 liters'),
                      ),
                    ],
                    onChanged: (value) {},
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
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('New bin added successfully'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: const Text('Add Bin'),
              ),
            ],
          ),
    );
  }
}

// Custom painter for the fill level indicator
class _FillLevelPainter extends CustomPainter {
  final double fillLevel;
  final Color fillColor;

  _FillLevelPainter({required this.fillLevel, required this.fillColor});

  @override
  void paint(Canvas canvas, Size size) {
    // Draw outline circle
    final paintOutline =
        Paint()
          ..color = Colors.grey.withOpacity(0.3)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 10.0;

    // Draw filled portion
    final paintFill =
        Paint()
          ..color = fillColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 10.0;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;

    canvas.drawCircle(center, radius, paintOutline);

    // Draw arc for fill level
    final rect = Rect.fromCircle(center: center, radius: radius);
    canvas.drawArc(
      rect,
      -math.pi / 2, // Start at the top
      2 * math.pi * fillLevel, // Fill based on fill level
      false,
      paintFill,
    );
  }

  @override
  bool shouldRepaint(_FillLevelPainter oldDelegate) =>
      oldDelegate.fillLevel != fillLevel || oldDelegate.fillColor != fillColor;
}
