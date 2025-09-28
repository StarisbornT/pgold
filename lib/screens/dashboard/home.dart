import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../model/user_model.dart';
import '../../utils/appcolors.dart';

class QuickActionItem {
  final IconData icon;
  final String label;
  final Color backgroundColor;
  final Color iconColor;

  QuickActionItem(this.icon, this.label, this.backgroundColor, this.iconColor);
}
final List<QuickActionItem> quickActions = [
  QuickActionItem(Icons.currency_bitcoin, 'Crypto', const Color(0xFFF7F4FA), const Color(0xFF09311C)),
  QuickActionItem(Icons.card_giftcard, 'Giftcards', const Color(0xFFF7F4FA), const Color(0xFF8038E8)),
  QuickActionItem(Icons.add, 'Top Up',  const Color.fromRGBO(247, 86, 7, 0.08), const Color(0xFFF75607)),
  QuickActionItem(Icons.tv, 'Cable TV', const Color.fromRGBO(58, 130, 255, 0.08), const Color(0xFF3A82FF)),
  QuickActionItem(Icons.lightbulb_outline, 'Electricity', const Color.fromRGBO(255, 0, 110, 0.08), const Color(0xFFFF006E)),
  QuickActionItem(Icons.sports_basketball, 'Betting', const Color(0xFFF7F4FA), const Color(0xFF784CFC)),
  QuickActionItem(Icons.airplanemode_active, 'Flight', const Color.fromRGBO(50, 199, 235, 0.08), const Color(0xFF31C8EC)),
  QuickActionItem(Icons.star_border, 'User Rank', const Color.fromRGBO(247, 86, 7, 0.08), const Color(0xFFF75607)),
];
class HomeScreen extends ConsumerWidget {
  final User user;
  const HomeScreen({super.key, required this.user});

  Widget _buildQuickAction(QuickActionItem item) {
    Color finalIconColor = item.iconColor;


    return Column(
      children: [
        Container(
          height: 56,
          width: 56,
          decoration: BoxDecoration(
            color: item.backgroundColor,
            borderRadius: BorderRadius.circular(28),
          ),
          child: Icon(
            item.icon,
            color: finalIconColor,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          item.label,
          style:  TextStyle(
            fontSize: 14,
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }

  // Utility method to build the balance action buttons (Withdraw/Deposit)
  Widget _buildBalanceActionButton(
      IconData icon, String label) {
    return SizedBox(
      width: 120,
      height: 44,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFAFAFA),
          foregroundColor: AppColors.PRIMARYCOLOR,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
            side: const BorderSide(
              color: Color(0x540052FF), // #0052FF54 (border with opacity)
              width: 1,
            ),
          ),
          elevation: 0,
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 19.5,
              height: 19.5,
              decoration:  const BoxDecoration(
                color: AppColors.PRIMARYCOLOR, // background for icon
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  icon,
                  size: 14,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 6),
            Text(label),
          ],
        ),
      ),
    );
  }



  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: 300, // Extend the gradient below the balance section
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF003199),
                  Color(0xFF0440BF),

                ],
              ),
            ),
          ),

          // 2. Main Scrollable Content
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 20,
                          backgroundImage: NetworkImage(
                            "https://i.pravatar.cc/150?img=3",
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hello ${user.fullName.split(' ').first} 👋',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Text(
                              'Top of the morning to you ',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w600
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        // Chat Icon
                        InkWell(
                          onTap: () {},
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(CupertinoIcons.chat_bubble_2,
                                color: Colors.white, size: 21),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Notification Icon
                        InkWell(
                          onTap: () {},
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.notifications_none,
                                color: Colors.white, size: 21),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            const Text(
                              'Wallet Balance',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Color(0xFFF0F1F2),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.remove_red_eye_outlined,
                                  color: Color.fromRGBO(0, 82, 255, 0.33), size: 11),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                 Image.asset('images/logo2.png'),
                                  const SizedBox(width: 4),
                                  const Text(
                                    'NGP',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 10),
                                  ),
                                  const Icon(Icons.keyboard_arrow_down,
                                      color: Colors.black, size: 8),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '₦7,0127,237.00',
                          style: GoogleFonts.roboto(
                            textStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            )
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildBalanceActionButton(
                              Icons.south_west,
                              'Withdraw'
                            ),
                            const SizedBox(width: 10,),
                            _buildBalanceActionButton(
                              Icons.north_east,
                              'Deposit'
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // --- Quick Action Section ---
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Quick Action',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              TextButton(
                                onPressed: () {},
                                child:  const Row(
                                  children: [
                                    Text(
                                      'More',
                                      style: TextStyle(
                                          color:
                                          AppColors.PRIMARYCOLOR,
                                        fontSize: 14
                                      ),
                                    ),
                                    Icon(Icons.arrow_forward_ios,
                                        color: AppColors.PRIMARYCOLOR, size: 14),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // Quick Action Grid
                          GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              childAspectRatio: 0.8,
                              mainAxisSpacing: 16,
                              crossAxisSpacing: 8,
                            ),
                            itemCount: quickActions.length,
                            itemBuilder: (context, index) {
                              return _buildQuickAction(quickActions[index]);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                    child: Image.asset(
                      'images/banner.png',
                      fit: BoxFit.contain,
                    ),
                  ),

                  // Padding to show the bottom of the screen content
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- Example User Model (for testing/completeness) ---
/*
// You likely already have this, but for completeness:
class User {
  final String name;
  final String balance;

  User({required this.name, required this.balance});
}

// Example usage in a parent widget:
class ParentWidget extends StatelessWidget {
  const ParentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Data extracted from the image
    final bafrkaUser = User(name: 'Bafreka', balance: '7,0127,237.00');

    return MaterialApp(
      home: Scaffold(
        body: HomeScreen(user: bafrkaUser),
        bottomNavigationBar: const BottomNavBar(), // Your Bottom Nav
      ),
    );
  }
}
*/