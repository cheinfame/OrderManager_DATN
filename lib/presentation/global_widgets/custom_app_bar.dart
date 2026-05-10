import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:packare_manage_web/blocs/account_bloc/account_bloc.dart';
import 'package:packare_manage_web/config/path.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback onMenuPressed;

  const CustomAppBar({
    Key? key,
    required this.title,
    required this.onMenuPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 16,
      title: Row(
        children: [
          SvgPicture.asset(packare_logo_path, width: 24,),
          const SizedBox(width: 4,),
          Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ],
      ),
      leading: IconButton(
        icon: Icon(Icons.menu),
        onPressed: onMenuPressed,
      ),
      actions: [
        IconButton.outlined(
          onPressed: () {},
          icon: const Icon(Icons.notifications),
        ),
        const SizedBox(width: 8),
        _buildProfilePopupMenu(context), // Add PopupMenuButton here
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.025,
        )
      ],
    );
  }

  PopupMenuButton<int> _buildProfilePopupMenu(BuildContext context) {
    return PopupMenuButton<int>(
      icon: CircleAvatar(
        backgroundColor: Colors.transparent,
        child: SvgPicture.asset(staff_avatar),
      ),
      itemBuilder: (context) => [
        PopupMenuItem<int>(
          value: 1,
          child: ListTile(
            leading: Icon(Icons.person),
            title: Text('User Profile'),
          ),
        ),
        PopupMenuItem<int>(
          value: 2,
          child: ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
          ),
        ),
      ],
      onSelected: (value) {
        if (value == 1) {
          // Handle User Profile
        } else if (value == 2) {
          context.read<AccountBloc>().add(LogoutEvent());
        }
      },
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
