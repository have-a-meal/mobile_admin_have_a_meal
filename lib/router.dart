import 'package:admin_have_a_meal/features/account/sign_in_screen.dart';
import 'package:admin_have_a_meal/features/qr/menu_select_screen.dart';
import 'package:admin_have_a_meal/features/qr/ticket_qr_auth_screen.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: SignInScreen.routeURL,
      name: SignInScreen.routeName,
      builder: (context, state) {
        return const SignInScreen();
      },
    ),
    GoRoute(
      path: MenuSelectScreen.routeURL,
      name: MenuSelectScreen.routeName,
      builder: (context, state) => const MenuSelectScreen(),
      routes: [
        GoRoute(
          path: TicketQrAuthScreen.routeURL,
          name: TicketQrAuthScreen.routeName,
          builder: (context, state) {
            if (state.extra != null) {
              final args = state.extra as TicketQrAuthScreenArgs;
              return TicketQrAuthScreen(
                mealId: args.mealId,
              );
            }
            return const TicketQrAuthScreen(
              mealId: 1,
            );
          },
        ),
      ],
    ),
  ],
);
