import 'package:flutter/material.dart';

class FloatingButtonWidget extends StatelessWidget {
  final VoidCallback onClicked;

  FloatingButtonWidget({
    required this.onClicked,
  });

  @override
  Widget build(BuildContext context) => FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(
          side: BorderSide(
              width: 2, color: Theme.of(context).colorScheme.secondary),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(Icons.add, color: Theme.of(context).colorScheme.secondary),
        onPressed: onClicked,
      );
}
