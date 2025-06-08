import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:markme/view/common/colors.dart';
import 'package:markme/view/screens/attendance_page.dart';
import 'package:markme/view/screens/todo_page.dart';
import 'package:markme/view/screens/timetable_page.dart';
import 'package:markme/view/screens/pyq_page.dart';
import 'package:markme/view/screens/bc_page.dart';
import 'package:markme/view/screens/gpa_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, int> todoStats = {'total': 0, 'completed': 0};

  @override
  void initState() {
    super.initState();
    _loadTodoStats();
  }

  Future<void> _loadTodoStats() async {
    final stats = await TodoStats.getStats();
    setState(() {
      todoStats = stats;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: _buildHomeContent(),
    );
  }

  Widget _buildHomeContent() {
    final currentDate = DateFormat('MMMM d').format(DateTime.now());

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Time and user info
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween),
            const SizedBox(height: 24),

            Text(
              "Today, $currentDate",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[500],
                fontFamily: 'Satoshi',
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              "Hey, studname",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                fontFamily: 'Satoshi',
              ),
            ),
            const SizedBox(height: 16),

            const Text(
              "Schedule for the Day",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                fontFamily: 'Satoshi',
              ),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Text(
                  "No pending tasks for today",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    fontFamily: 'Satoshi',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // First Row of Cards (Attendance and Productivity)
            GridView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1,
              ),
              children: [
                _buildStatCard(
                  title: "Attendance",
                  value: "83%",
                  subtitle: "Past 1 week",
                  icon: Icons.calendar_today,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AttendancePage())),
                ),
                _buildStatCard(
                  title: "Productivity",
                  value: "${todoStats['total']! == 0 || todoStats['total']! == todoStats['completed']! ? 100 : ((todoStats['completed']! / todoStats['total']! * 100).round())}%",
                  // on the home screen- 100% productivity will be shows in 2 cases:
                  //   a) if total number of tasks =0 OR
                  //   b) if total number of tasks==completed tasks
                  
                  subtitle: "Based on To-Do",
                  icon: Icons.check_circle_outline,
                  onTap: () async {
                    await Navigator.push(context, MaterialPageRoute(builder: (context) => const TodoPage()));
                    _loadTodoStats(); // Refresh stats when coming back
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Timetable Card
            _buildNeumorphicCard(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF0083FF),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "View TimeTable",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        fontFamily: 'Satoshi',
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "S6-CSB",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,  
                        fontFamily: 'Satoshi',
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                "Internals due in 19 days",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                  fontFamily: 'Satoshi',
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "78%",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                  fontFamily: 'Satoshi',
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.trending_up,
                            color: Colors.black,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const TimetablePage())),
            ),

            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.account_balance_wallet_outlined,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Want to explore past year questions?",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            fontFamily: 'Satoshi',
                          ),
                        ),
                        const SizedBox(height: 4),
                        GestureDetector(
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PyqPage())),
                          child: const Text(
                            "View PYQ's",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                              fontFamily: 'Satoshi',
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            
            // Second Row of Cards (Bunk Calculator and GPA Finder)
            GridView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1,
              ),
              children: [
                _buildStatCard(
                  title: "Bunk Calculator",
                  value: "—",
                  subtitle: "Bunk classes safely!",
                  icon: Icons.event_busy,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const BcPage())),
                ),
                _buildStatCard(
                  title: "GPA Finder",
                  value: "—",
                  subtitle: "Calculate your GPA",
                  icon: Icons.school,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const GpaPage())),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildNeumorphicCard({
    required Widget child,
    required VoidCallback onTap,
  }) {
    bool isPressed = false;
    
    return StatefulBuilder(
      builder: (context, setState) {
        return GestureDetector(
          onTap: onTap,
          onTapDown: (_) => setState(() => isPressed = true),
          onTapUp: (_) => setState(() => isPressed = false),
          onTapCancel: () => setState(() => isPressed = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: const Color(0xFF1E1E1E),
              boxShadow: isPressed
                  ? [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.5),
                        offset: const Offset(2, 2),
                        blurRadius: 2,
                        spreadRadius: -1,
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.5),
                        offset: const Offset(4, 4),
                        blurRadius: 8,
                        spreadRadius: 0,
                      ),
                      BoxShadow(
                        color: const Color.fromARGB(255, 115, 165, 230).withValues(alpha: 0.1),
                        offset: const Offset(-4, -4),
                        blurRadius: 8,
                        spreadRadius: 0,
                      ),
                    ],
            ),
            child: child,
          ),
        );
      },
    );
  }

  // Simplified unified card builder for all 4 cards
  Widget _buildStatCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    bool isPressed = false;
    
    return StatefulBuilder(
      builder: (context, setState) {
        return GestureDetector(
          onTap: onTap,
          onTapDown: (_) => setState(() => isPressed = true),
          onTapUp: (_) => setState(() => isPressed = false),
          onTapCancel: () => setState(() => isPressed = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: const Color(0xFF1E1E1E),
              boxShadow: isPressed
                  ? [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.5),
                        offset: const Offset(2, 2),
                        blurRadius: 2,
                        spreadRadius: -1,
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.5),
                        offset: const Offset(4, 4),
                        blurRadius: 8,
                        spreadRadius: 0,
                      ),
                      BoxShadow(
                        color: const Color.fromARGB(12, 33, 33, 33),
                        offset: const Offset(-4, -4),
                        blurRadius: 8,
                        spreadRadius: 0,
                      ),
                    ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, color: Colors.white, size: 24),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontFamily: 'Satoshi',
                  ),
                ),
                const Spacer(),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    fontFamily: 'Satoshi',
                  ),
                ),
                const Spacer(),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF757479),
                    fontFamily: 'Satoshi',
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}