import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    this.title,
    this.showBackButton = false,
    this.leadingIcon,
    this.actions,
    this.leadingOnPressed,
    this.automaticallyImplyLeading = false,
  });

  final Widget? title;
  final bool showBackButton;
  final IconData? leadingIcon;
  final List<Widget>? actions;
  final VoidCallback? leadingOnPressed;
  final bool automaticallyImplyLeading;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFFFFFAFA), // Updated to match the scaffold background color
      automaticallyImplyLeading: automaticallyImplyLeading,
      leading: showBackButton
          ? IconButton(
              onPressed: () => Get.back(),
              icon: Icon(Icons.arrow_back, color: Colors.grey[600]), // Ensure the icon color matches your theme
            )
          : leadingIcon != null
              ? IconButton(
                  onPressed: leadingOnPressed, 
                  icon: Icon(leadingIcon, color: Colors.grey[600]), // Match icon color to the theme
                ) 
              : null,
      title: title != null ? DefaultTextStyle(style: TextStyle(color: Colors.black), child: title!) : null, // Ensure title color matches
      actions: <Widget>[
        if (actions != null) ...actions!,
        Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.person, color: Colors.grey[600]), // Match icon color
            onPressed: () => Scaffold.of(context).openEndDrawer(), // Correctly opens the end drawer
          ),
        ),
      ],
      elevation: 0, // Adjust to match the shadow of TravelCard
      shadowColor: Colors.black.withOpacity(0.1), // Soften the shadow to match the card's aesthetic
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(1.0),
        child: Container(
          color: Colors.grey[300], // Color of the bottom line to match the card border
          height: 0, // Corrected the thickness of the bottom line to be visible
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1); // Adjust the height to include the bottom line
}
