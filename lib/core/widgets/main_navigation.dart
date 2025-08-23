import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/dexter_theme.dart';

class MainNavigation extends StatelessWidget {
  final Widget child;

  const MainNavigation({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: DexterTokens.dexIvory,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(DexterTokens.radiusLarge),
            topRight: Radius.circular(DexterTokens.radiusLarge),
          ),
          border: Border.all(
            color: DexterTokens.dexLeaf.withOpacity(0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: DexterTokens.dexLeaf.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -4),
              spreadRadius: 2,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(DexterTokens.radiusLarge),
            topRight: Radius.circular(DexterTokens.radiusLarge),
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent,
            elevation: 0,
            currentIndex: _getCurrentIndex(context),
            onTap: (index) => _onTabTapped(context, index),
            selectedItemColor: DexterTokens.dexGreen,
            unselectedItemColor: DexterTokens.dexForest.withOpacity(0.6),
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 11,
            ),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite_rounded, size: 26),
                activeIcon: Icon(Icons.favorite, size: 28),
                label: 'Bloodline',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.location_on_rounded, size: 26),
                activeIcon: Icon(Icons.location_on, size: 28),
                label: 'Centres',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today_rounded, size: 26),
                activeIcon: Icon(Icons.calendar_today, size: 28),
                label: 'Bookings',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_rounded, size: 26),
                activeIcon: Icon(Icons.person, size: 28),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }

  int _getCurrentIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith('/bloodline')) return 0;
    if (location.startsWith('/centres')) return 1;
    if (location.startsWith('/bookings')) return 2;
    if (location.startsWith('/profile')) return 3;
    return 0;
  }

  void _onTabTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/bloodline');
        break;
      case 1:
        context.go('/centres');
        break;
      case 2:
        context.go('/bookings');
        break;
      case 3:
        context.go('/profile');
        break;
    }
  }
}
