import 'package:admin_have_a_meal/features/account/sign_in_screen.dart';
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
      path: TicketQrAuthScreen.routeURL,
      name: TicketQrAuthScreen.routeName,
      builder: (context, state) {
        return const TicketQrAuthScreen();
      },
    ),
  ],
);
