import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medcon/app/authentication/presentation/cubits/auth_cubit.dart';
import 'package:medcon/app/profile/presentation/screens/profile_screen.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Drawer(
      // Using a Container to allow for background styling if needed
      child: Column(
        children: [
          // 1. Custom Header
          _buildHeader(context),

          // 2. Navigation Items (Wrapped in Expanded to push footer down)
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(
                  context,
                  icon: Icons.person_outline,
                  title: "Profile",
                  onTap: () {
                    Navigator.pop(context); // Close drawer

                    // get current user uid
                    final _currentUser = context.read<AuthCubit>().currentUser;
                    String? uid = _currentUser!.uid;
                    // Navigate logic here
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileScreen(uid: uid),
                      ),
                    );
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.cases_outlined,
                  title: "Cases",
                  onTap: () {
                    // Navigator.pop(context);
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => const CasesScreen(),
                    //   ),
                    // );
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.dashboard_outlined,
                  title: "MedNews",
                  onTap: () {},
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.bookmark_border_outlined,
                  title: "Bookmarks",
                  onTap: () {},
                ),
                const Divider(indent: 16, endIndent: 16), // Subtle divider
                _buildDrawerItem(
                  context,
                  icon: Icons.settings_rounded,
                  title: "Settings",
                  onTap: () {},
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.privacy_tip_outlined,
                  title: "Privacy Policy",
                  onTap: () {},
                ),
              ],
            ),
          ),
          const Divider(),

          // 3. Sticky Footer (Logout)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.pop(context); // Close drawer
                  _showLogoutDialog(context);
                },
                icon: const Icon(Icons.logout_rounded),
                label: const Text("Log Out"),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  side: BorderSide(color: colorScheme.error),
                  foregroundColor: colorScheme.error,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        24,
        64,
        24,
        24,
      ), // Top padding handles status bar
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: const BorderRadius.only(
          bottomRight: Radius.circular(32), // Stylish curve
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.2),
            ),
            child: const CircleAvatar(
              radius: 32,
              backgroundImage: NetworkImage(
                'https://ui-avatars.com/api/?name=John+Doe&background=random',
              ),
              backgroundColor: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          // Name
          const Text(
            "John Doe",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          // Email
          const Text(
            "john.doe@example.com",
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      leading: Icon(icon, color: colorScheme.onSurfaceVariant),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: colorScheme.onSurface,
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      onTap: onTap,
      hoverColor: colorScheme.primaryContainer.withOpacity(0.2),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.logout_rounded, color: Colors.red, size: 32),
        ),
        title: const Text('Logout'),
        content: const Text(
          'Are you sure you want to logout from your account?',
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              // auth Cubit - logout
              context.read<AuthCubit>().logoutCubit();
            },
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
