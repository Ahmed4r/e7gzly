import 'package:e7gzly/core/app_colors.dart';
import 'package:e7gzly/features/bookments/booking_page.dart';
import 'package:e7gzly/features/location/location_page.dart';
import 'package:e7gzly/features/profile/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:e7gzly/features/home/presentation/home_page.dart';

class MainWrapperScreen extends StatefulWidget {
  const MainWrapperScreen({super.key});

  @override
  State<MainWrapperScreen> createState() => _MainWrapperScreenState();
}

class _MainWrapperScreenState extends State<MainWrapperScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomeScreen(),
    LocationScreen(),
    MyBookingsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,

        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        
      ),
    );
  }
}

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> iconPaths = [
      'assets/icons/home.png',
      'assets/icons/location.png',
      'assets/icons/calendar.png',
      'assets/icons/profile.png',
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFF1F5F9))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(iconPaths.length, (index) {
          final bool isSelected = currentIndex == index;

          return GestureDetector(
            onTap: () => onTap(index),       
            behavior: HitTestBehavior.opaque,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.iconColor
                    : const Color.fromARGB(255, 255, 255, 255),

                shape: BoxShape.circle,
              ),
              child: Image.asset(
                color: isSelected
                    ? AppColors.whiteColor
                    : const Color.fromARGB(255, 0, 0, 0),
                iconPaths[index],
                width: 24,
                height: 24,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.broken_image, size: 24);
                },
              ),
            ),
          );
        }),
      ),
    );
  }
}

// class LocationScreen extends StatelessWidget {
//   const LocationScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(body: Center(child: Text('Location Screen')));
//   }
// }

// class CalendarScreen extends StatelessWidget {
//   const CalendarScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(body: Center(child: Text('Calendar Screen')));
//   }
// }

// class ProfileScreen extends StatelessWidget {
//   const ProfileScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(body: Center(child: Text('Profile Screen')));
//   }
// }
