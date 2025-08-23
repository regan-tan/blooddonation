import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../features/auth/data/auth_repository.dart';
import '../features/centres/data/centres_repository.dart';
import '../features/booking/data/booking_repository.dart';
import '../features/bloodline/data/bloodline_repository.dart';
import '../features/bloodline/data/codes_repository.dart';
import '../features/bloodline/application/streak_service.dart';
import '../features/bloodline/application/nomination_service.dart';
import '../features/notifications/local_notifications.dart';

// Auth Providers
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

final authStateProvider = StreamProvider<User?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges;
});

final currentUserProvider = StreamProvider((ref) {
  final authState = ref.watch(authStateProvider);
  final authRepository = ref.watch(authRepositoryProvider);
  
  return authState.when(
    data: (user) {
      if (user == null) return Stream.value(null);
      return authRepository.getCurrentUserProfile();
    },
    loading: () => const Stream.empty(),
    error: (_, __) => const Stream.empty(),
  );
});

// Centres Providers
final centresRepositoryProvider = Provider<CentresRepository>((ref) {
  return CentresRepository();
});

final centresListProvider = FutureProvider((ref) {
  final repository = ref.watch(centresRepositoryProvider);
  return repository.getAllCentres();
});

// Booking Providers
final bookingRepositoryProvider = Provider<BookingRepository>((ref) {
  return BookingRepository();
});

final myBookingsProvider = StreamProvider((ref) {
  final authState = ref.watch(authStateProvider);
  final repository = ref.watch(bookingRepositoryProvider);
  
  return authState.when(
    data: (user) {
      if (user == null) return const Stream.empty();
      return repository.getUserBookings(user.uid);
    },
    loading: () => const Stream.empty(),
    error: (_, __) => const Stream.empty(),
  );
});

// Bloodline Providers
final bloodlineRepositoryProvider = Provider<BloodlineRepository>((ref) {
  return BloodlineRepository();
});

final codesRepositoryProvider = Provider<CodesRepository>((ref) {
  return CodesRepository();
});

final streakServiceProvider = Provider<StreakService>((ref) {
  final bloodlineRepository = ref.watch(bloodlineRepositoryProvider);
  return StreakService(bloodlineRepository);
});

final nominationServiceProvider = Provider<NominationService>((ref) {
  final bloodlineRepository = ref.watch(bloodlineRepositoryProvider);
  return NominationService(bloodlineRepository);
});

final currentChallengeProvider = StreamProvider((ref) {
  final authState = ref.watch(authStateProvider);
  final repository = ref.watch(bloodlineRepositoryProvider);
  
  return authState.when(
    data: (user) {
      if (user == null) return const Stream.empty();
      return repository.getCurrentChallenge(user.uid);
    },
    loading: () => const Stream.empty(),
    error: (_, __) => const Stream.empty(),
  );
});

// Notifications Provider
final localNotificationsProvider = Provider<LocalNotifications>((ref) {
  return LocalNotifications();
});
