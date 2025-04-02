import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_page.dart';
// Import each screen directly to avoid issues with the screens.dart export file
import 'screens/collection_schedule_screen.dart';
import 'screens/bin_status_screen.dart';
import 'screens/recycling_info_screen.dart';
import 'screens/report_issue_screen.dart';
import 'screens/community_sharing_screen.dart'; // Import the new screen

class DashboardPage extends StatefulWidget {
  final String userName;
  final bool showLoginMessage;

  const DashboardPage({
    super.key,
    required this.userName,
    this.showLoginMessage = false,
  });

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String _formattedDate;

  @override
  void initState() {
    super.initState();
    _formattedDate = _getFormattedDate();

    if (widget.showLoginMessage) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login successful. Welcome, ${widget.userName}!'),
            backgroundColor: const Color.fromARGB(255, 158, 225, 160),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 3),
          ),
        );
      });
    }
  }

  // Format date without using the intl package
  String _getFormattedDate() {
    final now = DateTime.now();
    final weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    final weekday = weekdays[now.weekday - 1]; // weekday is 1-7 in DateTime
    final month = months[now.month - 1]; // month is 1-12 in DateTime
    final day = now.day;
    final year = now.year;

    return '$weekday, $month $day, $year';
  }

  void _signOut() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: const Color(
              0xFFEFFAF1,
            ), // Very light green background
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                const Icon(Icons.logout, color: Colors.red),
                const SizedBox(width: 8),
                const Text(
                  'Confirm Logout',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            content: const Text(
              'Are you sure you want to log out?',
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            actions: [
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceEvenly, // Align buttons evenly
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.black54,
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Logout'),
                  ),
                ],
              ),
            ],
          ),
    );

    if (shouldLogout == true) {
      await _auth.signOut();
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFFAF1), // Very light green background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 60,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.menu, color: Colors.black87),
              tooltip: 'Menu',
              onPressed: () {
                _showMenuBar();
              },
            ),
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.red),
              tooltip: 'Logout',
              onPressed: _signOut,
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshDashboard,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildModernWelcomeSection(),
              const SizedBox(height: 24),
              const Text(
                'Smart Garbage System',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.1,
                children: [
                  _buildDashboardItem(
                    title: 'Collection Schedule',
                    icon: Icons.calendar_today,
                    color: Colors.blue,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder:
                              (context) => const CollectionScheduleScreen(),
                        ),
                      );
                    },
                  ),
                  _buildDashboardItem(
                    title: 'Bin Status',
                    icon: Icons.delete,
                    color: Colors.orange,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const BinStatusScreen(),
                        ),
                      );
                    },
                  ),
                  _buildDashboardItem(
                    title: 'Immediate Pickup',
                    icon: Icons.local_shipping,
                    color: Colors.purple,
                    onTap: _showImmediatePickupDialog,
                  ),
                  _buildDashboardItem(
                    title: 'Community Sharing',
                    icon: Icons.recycling,
                    color: Colors.teal,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const CommunitySharingScreen(),
                        ),
                      );
                    },
                  ),
                  _buildDashboardItem(
                    title: 'Recycling Info',
                    icon: Icons.refresh,
                    color: Colors.green,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const RecyclingInfoScreen(),
                        ),
                      );
                    },
                  ),
                  _buildDashboardItem(
                    title: 'Report Issue',
                    icon: Icons.report_problem,
                    color: Colors.red,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const ReportIssueScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildRecentActivitySection(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showQuickActionMenu,
        backgroundColor: const Color.fromARGB(255, 162, 217, 164),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showMenuBar() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const ListTile(
                title: Text(
                  'Menu',
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.settings, color: Colors.blue),
                title: const Text('Settings'),
                onTap: () {
                  Navigator.pop(context); // Close the menu
                  // Navigate to settings screen (if implemented)
                },
              ),
              ListTile(
                leading: const Icon(Icons.help_outline, color: Colors.orange),
                title: const Text('Help & Support'),
                onTap: () {
                  Navigator.pop(context); // Close the menu
                  // Navigate to help screen (if implemented)
                },
              ),
              ListTile(
                leading: const Icon(Icons.info_outline, color: Colors.green),
                title: const Text('About'),
                onTap: () {
                  Navigator.pop(context); // Close the menu
                  // Navigate to about screen (if implemented)
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
    );
  }

  /// Refresh functionality placeholder
  Future<void> _refreshDashboard() async {
    await Future.delayed(const Duration(seconds: 1));
    // Add actual refresh logic if needed
    setState(() {
      _formattedDate = _getFormattedDate();
    });
  }

  /// Modern welcome section with date
  Widget _buildModernWelcomeSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.green, Colors.teal],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.4),
            blurRadius: 8,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome, ${widget.userName}!',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Today is $_formattedDate',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 18,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  /// Welcome card with date
  Widget _buildWelcomeCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 174, 215, 175).withOpacity(0.4),
            blurRadius: 8,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome, ${widget.userName}!',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Today is $_formattedDate',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  /// Dashboard item builder
  Widget _buildDashboardItem({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 6,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.2),
              radius: 28,
              child: Icon(icon, color: color, size: 30),
            ),
            const SizedBox(height: 14),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Stat indicator for welcome card
  Widget _buildStatIndicator({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Expanded(
      child: Row(
        children: [
          Icon(icon, color: Colors.white70, size: 20),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Recent activity section
  Widget _buildRecentActivitySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recent Activity',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            TextButton(
              onPressed: () {
                // View all activities
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Activity history coming soon'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildActivityItem(
          title: 'Bin 1 Collection',
          subtitle: 'Today, 09:30 AM',
          icon: Icons.delete_outline,
          color: Colors.blue,
          onTap:
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CollectionScheduleScreen(),
                ),
              ),
        ),
        _buildActivityItem(
          title: 'Recycling Completed',
          subtitle: 'Yesterday, 02:15 PM',
          icon: Icons.recycling,
          color: Colors.green,
          onTap:
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RecyclingInfoScreen(),
                ),
              ),
        ),
        _buildActivityItem(
          title: 'Bin 2 Almost Full',
          subtitle: '2 days ago, 11:20 AM',
          icon: Icons.warning_amber_rounded,
          color: Colors.orange,
          onTap:
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BinStatusScreen(),
                ),
              ),
        ),
      ],
    );
  }

  /// Activity item for recent activity section
  Widget _buildActivityItem({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.2),
              radius: 20,
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  // Show quick action menu for the floating action button
  void _showQuickActionMenu() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const ListTile(
                title: Text(
                  'Quick Actions',
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.calendar_today, color: Colors.blue),
                title: const Text('Schedule Collection'),
                onTap: () {
                  Navigator.pop(context); // Close the bottom sheet
                  debugPrint(
                    'Navigating to Collection Schedule from quick action',
                  );
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const CollectionScheduleScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.add_circle_outline,
                  color: Colors.orange,
                ),
                title: const Text('Add New Bin'),
                onTap: () {
                  Navigator.pop(context); // Close the bottom sheet
                  debugPrint('Navigating to Bin Status from quick action');
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const BinStatusScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.report_problem_outlined,
                  color: Colors.red,
                ),
                title: const Text('Report Issue'),
                onTap: () {
                  Navigator.pop(context); // Close the bottom sheet
                  debugPrint('Navigating to Report Issue from quick action');
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const ReportIssueScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
    );
  }

  void _showImmediatePickupDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Request Immediate Pickup'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Select the bin for immediate pickup:'),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Bin ID',
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    DropdownMenuItem(
                      value: 'BIN-1001',
                      child: Text('BIN-1001'),
                    ),
                    DropdownMenuItem(
                      value: 'BIN-1002',
                      child: Text('BIN-1002'),
                    ),
                    DropdownMenuItem(
                      value: 'BIN-1003',
                      child: Text('BIN-1003'),
                    ),
                  ],
                  onChanged: (value) {},
                ),
                const SizedBox(height: 16),
                const Text('Any special instructions?'),
                const SizedBox(height: 8),
                const TextField(
                  decoration: InputDecoration(
                    hintText: 'E.g., Pickup urgently before 5 PM',
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
                      content: Text(
                        'Immediate pickup request submitted successfully',
                      ),
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
}
