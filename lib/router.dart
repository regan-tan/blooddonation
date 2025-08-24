import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'features/auth/presentation/sign_in_page.dart';
import 'features/auth/presentation/profile_page.dart';
import 'features/centres/presentation/centres_list_page.dart';
import 'features/centres/presentation/centre_detail_page.dart';
import 'features/booking/presentation/booking_create_page.dart';
import 'features/booking/presentation/booking_detail_page.dart';
import 'features/booking/presentation/my_bookings_page.dart';
import 'features/bloodline/presentation/bloodline_home_page.dart';
import 'features/bloodline/presentation/challenge_create_page.dart';
import 'features/bloodline/presentation/challenge_detail_page.dart';
import 'features/bloodline/presentation/code_verify_page.dart';
import 'features/friends/presentation/friends_page.dart';
import 'core/widgets/main_navigation.dart';
import 'state/providers.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);
  
  return GoRouter(
    initialLocation: '/bloodline',
    redirect: (context, state) {
      final isLoggedIn = authState.value != null;
      final isLoggingIn = state.matchedLocation == '/sign-in';
      
      if (!isLoggedIn && !isLoggingIn) {
        return '/sign-in';
      }
      
      if (isLoggedIn && isLoggingIn) {
        return '/bloodline';
      }
      
      return null;
    },
    routes: [
      GoRoute(
        path: '/sign-in',
        builder: (context, state) => const SignInPage(),
      ),
      ShellRoute(
        builder: (context, state, child) => MainNavigation(child: child),
        routes: [
          GoRoute(
            path: '/bloodline',
            builder: (context, state) => const BloodlineHomePage(),
            routes: [
              GoRoute(
                path: 'verify-code',
                builder: (context, state) => const CodeVerifyPage(),
              ),
              GoRoute(
                path: 'challenge/create',
                builder: (context, state) => const ChallengeCreatePage(),
              ),
              GoRoute(
                path: 'challenge/:id',
                builder: (context, state) => ChallengeDetailPage(
                  challengeId: state.pathParameters['id']!,
                ),
              ),
            ],
          ),
          GoRoute(
            path: '/centres',
            builder: (context, state) => const CentresListPage(),
            routes: [
              GoRoute(
                path: ':id',
                builder: (context, state) => CentreDetailPage(
                  centreId: state.pathParameters['id']!,
                ),
                routes: [
                  GoRoute(
                    path: 'book',
                    builder: (context, state) => BookingCreatePage(
                      centreId: state.pathParameters['id']!,
                    ),
                  ),
                ],
              ),
            ],
          ),
          GoRoute(
            path: '/bookings',
            builder: (context, state) => const MyBookingsPage(),
            routes: [
              GoRoute(
                path: ':id',
                builder: (context, state) => BookingDetailPage(
                  bookingId: state.pathParameters['id']!,
                ),
              ),
            ],
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfilePage(),
          ),
          GoRoute(
            path: '/friends',
            builder: (context, state) => const FriendsPage(),
          ),
        ],
      ),
    ],
  );
});
