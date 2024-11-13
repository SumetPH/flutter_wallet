import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_wallet/screen/provider/theme_provider.dart';
import 'package:flutter_wallet/widget/responsive_width_widget.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ตั้งค่า'),
        leading: IconButton(
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
          icon: const Icon(Icons.menu),
        ),
      ),
      body: const Center(
        child: ResponsiveWidth(
          child: SettingList(),
        ),
      ),
    );
  }
}

class SettingList extends ConsumerWidget {
  const SettingList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return Column(
      children: [
        SwitchListTile(
          title: const Text('โหมดกลางคืน'),
          value: themeMode == ThemeModeState.dark ? true : false,
          onChanged: (value) {
            ref.read(themeModeProvider.notifier).toggleTheme();
          },
        ),
      ],
    );
  }
}
