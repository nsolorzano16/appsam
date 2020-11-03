import 'package:flutter/material.dart';

final _icons = <String, IconData>{
  'home_filled': Icons.home_filled,
  'supervised_user_circle': Icons.supervised_user_circle,
  'person': Icons.person,
  'assignment_ind': Icons.assignment_ind,
  'account_box': Icons.account_box,
  'settings': Icons.settings,
};

Icon getIcon(BuildContext context, String nombreIcono) {
  return Icon(
    _icons[nombreIcono],
    color: Theme.of(context).primaryColor,
  );
}
