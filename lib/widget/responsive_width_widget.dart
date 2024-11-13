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
    final width = MediaQuery.of(context).size.width;

    return kIsWeb
        ? Center(
            child: SizedBox(
              width: 1000.0,
              child: Column(
                children: [
                  Expanded(child: child),
                  if (width < 800) const SizedBox(height: 32.0),
                ],
              ),
            ),
          )
        : child;
  }
}
