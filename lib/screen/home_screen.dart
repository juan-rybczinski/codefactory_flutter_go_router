import 'package:flutter/material.dart';
import 'package:flutter_lv2_go_router/layout/default_layout.dart';
import 'package:flutter_lv2_go_router/provider/auth_provider.dart';
import 'package:flutter_lv2_go_router/screen/three_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultLayout(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
            onPressed: () => context.go('/one'),
            child: Text('Screen One (Go)'),
          ),
          ElevatedButton(
            onPressed: () => context.goNamed(ThreeScreen.routeName),
            child: Text('Screen Three (GoNamed)'),
          ),
          ElevatedButton(
            onPressed: () => context.go('/error'),
            child: Text('Screen Error (Go)'),
          ),
          ElevatedButton(
            onPressed: () => context.go('/login'),
            child: Text('Screen Login (Go)'),
          ),
          ElevatedButton(
            onPressed: () => ref.read(userProvider.notifier).logout(),
            child: Text('Logout'),
          ),
        ],
      ),
    );
  }
}
