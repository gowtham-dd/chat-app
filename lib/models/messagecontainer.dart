import 'package:flutter/material.dart';
class MessageContainer extends StatelessWidget {
  final bool isSelected;
  final Widget child;

  const MessageContainer({
    Key? key,
    required this.isSelected,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isSelected ? Colors.blue.withOpacity(0.3) : null,
      child: child,
    );
  }
}