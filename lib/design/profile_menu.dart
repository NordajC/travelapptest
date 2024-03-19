import 'package:flutter/material.dart';

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({
    super.key,
    required this.theme,
    required this.title,
    required this.value,
    this.icon = Icons.edit,
    required this.onPressed,
  });

  final ThemeData theme;
  final String title, value;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
    
      Expanded(flex:3, child: Text(title, style: TextStyle(fontWeight: FontWeight.bold),)),
    
      Expanded(flex:5, child: Text(value, style: TextStyle(fontSize: 16))),
    
      Expanded(child: IconButton(icon: Icon(icon, color: theme.primaryColor, size: 16,), onPressed: onPressed, ))
    
    ],);
  }
}
