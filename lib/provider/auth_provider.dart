import 'package:flutter/cupertino.dart';
import 'package:flutter_lv2_go_router/model/user_model.dart';
import 'package:flutter_lv2_go_router/screen/error_screen.dart';
import 'package:flutter_lv2_go_router/screen/home_screen.dart';
import 'package:flutter_lv2_go_router/screen/login_screen.dart';
import 'package:flutter_lv2_go_router/screen/one_screen.dart';
import 'package:flutter_lv2_go_router/screen/three_screen.dart';
import 'package:flutter_lv2_go_router/screen/two_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final routeProvider = Provider<GoRouter>((ref) {
  final authNotifier = AuthNotifier(ref: ref);

  return GoRouter(
    initialLocation: '/login',
    errorBuilder: (context, state) =>
        ErrorScreen(error: state.error.toString()),
    routes: authNotifier._routes,
    redirect: authNotifier._redirectLogic,
    refreshListenable: authNotifier,
  );
});

class AuthNotifier extends ChangeNotifier {
  final Ref ref;

  AuthNotifier({
    required this.ref,
  }) {
    ref.listen(
      userProvider,
      (previous, next) => previous != next ? notifyListeners() : null,
    );
  }

  String? _redirectLogic(_, GoRouterState state) {
    final user = ref.read(userProvider);

    final loggingIn = state.location == '/login';

    if (user == null) {
      return loggingIn ? null : '/login';
    }

    if (loggingIn) {
      return '/';
    }

    return null;
  }

  List<GoRoute> get _routes => [
        GoRoute(
          path: '/',
          builder: (_, state) => HomeScreen(),
          routes: [
            GoRoute(
              path: 'one',
              builder: (_, state) => OneScreen(),
              routes: [
                GoRoute(
                    path: 'two',
                    builder: (_, state) => TwoScreen(),
                    routes: [
                      GoRoute(
                        path: 'three',
                        name: ThreeScreen.routeName,
                        builder: (_, state) => ThreeScreen(),
                      )
                    ])
              ],
            ),
          ],
        ),
        GoRoute(
          path: '/login',
          builder: (_, state) => LoginScreen(),
        ),
      ];
}

final userProvider = StateNotifierProvider<UserStateNotifier, UserModel?>(
  (ref) => UserStateNotifier(),
);

class UserStateNotifier extends StateNotifier<UserModel?> {
  UserStateNotifier() : super(null);

  void login({
    required String name,
  }) {
    state = UserModel(
      name: name,
    );
  }

  void logout() {
    state = null;
  }
}
