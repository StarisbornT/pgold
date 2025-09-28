import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pgold/lib/provider/user_provider.dart';
import 'package:pgold/screens/dashboard/rates.dart';
import 'package:pgold/utils/appcolors.dart';

import 'home.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  static const String id = '/dashboard';
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() =>
      _CustomerDashboardScreenState();
}

class _CustomerDashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  void initState() {
    super.initState();
  }

  final bottomNavigationProvider = StateProvider<int>((ref) => 0);

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userProvider);
    final selectedIndex = ref.watch(bottomNavigationProvider);

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F7F7),
        body: SafeArea(
          child: userState.when(
            data: (user) {
              final List<Widget> pages = [
                HomeScreen(user: user),
                const Placeholder(),
                const Placeholder(),
                const Rates(),
                const Placeholder(),
              ];
              return pages[selectedIndex];
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) {
              print("Error loading profile: $error");
              return Center(
                  child: Text("Error loading profile: ${error.toString()}"));
            },
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedIndex,
          selectedItemColor: AppColors.PRIMARYCOLOR,
          unselectedItemColor: Colors.grey.shade600,
          type: BottomNavigationBarType.fixed,
          onTap: (index) =>
              ref.read(bottomNavigationProvider.notifier).state = index,
          items: [
            const BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            const BottomNavigationBarItem(icon: Icon(Icons.menu), label: "History"),
            BottomNavigationBarItem(
              icon: DiagonalCreditCardIcon(
                color: selectedIndex == 2
                    ? AppColors.PRIMARYCOLOR
                    : Colors.grey.shade600,
              ),
              label: "Cards",
            ),
            const BottomNavigationBarItem(
                icon: Icon(Icons.currency_exchange), label: "Rates"),
            const BottomNavigationBarItem(
                icon: Icon(Icons.person_pin), label: "Profile"),
          ],
        ),
      ),
    );
  }
}
class DiagonalCreditCardIcon extends StatelessWidget {
  const DiagonalCreditCardIcon({super.key, required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -20 * (3.1415926535 / 180),
      origin:
          const Offset(0, 4),
      child: Icon(
        Icons.credit_card,
        color: color,
      ),
    );
  }
}
