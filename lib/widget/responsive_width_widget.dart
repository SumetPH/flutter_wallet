import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ResponsiveWidth extends StatelessWidget {
  final Widget child;
  const ResponsiveWidth({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return kIsWeb
        ? Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainer,
            ),
            child: Center(
              child: ClipRRect(
                child: SizedBox(
                  width: 1200,
                  child: child,
                ),
              ),
            ),
          )
        : child;
  }
}
