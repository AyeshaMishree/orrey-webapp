import 'package:flutter/material.dart';
import 'package:orrey_web_app/view/home/home_view.dart';
import 'package:orrey_web_app/view/info/info.dart';
import 'package:orrey_web_app/view/orrery_view/orrery_view.dart';
import 'package:orrey_web_app/view/team/team.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:orrey_web_app/auth/login_screen.dart'; // Import your login screen

class CNavigationBar extends StatelessWidget {
  const CNavigationBar({super.key});

  // Smooth navigation with fade transition
  void _navigateTo(BuildContext context, String routeName) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            getPage(routeName),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.ease;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }

  Widget getPage(String routeName) {
    switch (routeName) {
      case '/orrery':
        return const OrreryView();
      case '/info':
        return const InfoPage();
      case '/team':
        return const TeamPage();
      default:
        return const HomeView();
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      height: 100,
      alignment: Alignment.center,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          // Logo (left)
          GestureDetector(
            onTap: () {
              _navigateTo(context, '/');
            },
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Image.asset(
                'assets/images/logo.png',
                height: 50,
              ),
            ),
          ),

          const Spacer(),

          // Center: Username/email and Logout button side by side
          if (user != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  user.displayName ?? user.email ?? '',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 16),
                TextButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'Log Out',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),

          const Spacer(),

          // Navigation items (right)
          _buildNavItem(context, 'Home', '/'),
          const SizedBox(width: 60),
          _buildNavItem(context, 'The Orrery', '/orrery'),
          const SizedBox(width: 60),
          _buildNavItem(context, 'Info', '/info'),
          const SizedBox(width: 60),
          _buildNavItem(context, 'Team', '/team'),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, String title, String route) {
    return GestureDetector(
      onTap: () {
        _navigateTo(context, route);
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          child: _NavItem(title: title),
        ),
      ),
    );
  }
}

class _NavItem extends StatefulWidget {
  final String title;

  const _NavItem({required this.title, Key? key}) : super(key: key);

  @override
  __NavItemState createState() => __NavItemState();
}

class __NavItemState extends State<_NavItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        MouseRegion(
          onEnter: (_) {
            setState(() {
              _isHovered = true;
            });
          },
          onExit: (_) {
            setState(() {
              _isHovered = false;
            });
          },
          child: Text(
            widget.title,
            style: TextStyle(
              fontFamily: 'Open_Sans',
              fontSize: 12,
              color: _isHovered ? Colors.blueAccent : Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 2,
          width: _isHovered ? 20 : 0,
          color: Colors.blueAccent,
        ),
      ],
    );
  }
}
