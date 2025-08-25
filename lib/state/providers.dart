import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../features/auth/data/auth_repository.dart';
import '../features/centres/data/centres_repository.dart';
import '../features/booking/data/booking_repository.dart';
import '../features/bloodline/data/bloodline_repository.dart';
import '../features/bloodline/data/codes_repository.dart';
import '../features/bloodline/application/streak_service.dart';
import '../features/bloodline/application/nomination_service.dart';
import '../features/friends/data/friends_repository.dart';
import '../features/notifications/local_notifications.dart';

// Test provider to verify Riverpod is working
final testProvider = Provider<String>((ref) {
  print('Creating test provider');
  return 'Test Provider Working!';
});

// Auth Providers
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  print('Creating AuthRepository provider');
  final authRepo = AuthRepository();
  print('AuthRepository created successfully: $authRepo');
  return authRepo;
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

// Provider to manually trigger profile refresh
final profileRefreshProvider = StateProvider<int>((ref) => 0);

// Combined provider that refreshes when triggered
final refreshedUserProfileProvider = StreamProvider((ref) {
  final authState = ref.watch(authStateProvider);
  final authRepository = ref.watch(authRepositoryProvider);
  final refreshTrigger = ref.watch(profileRefreshProvider);
  
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

// StreakService provider - moved to the end to ensure proper initialization order
final streakServiceProvider = Provider<StreakService>((ref) {
  print('Creating StreakService provider');
  
  try {
    // Ensure AuthRepository is created first
    final authRepository = ref.watch(authRepositoryProvider);
    print('AuthRepository obtained: $authRepository');
    
    if (authRepository == null) {
      print('ERROR: AuthRepository is null!');
      throw Exception('AuthRepository is null');
    }
    
    final bloodlineRepository = ref.watch(bloodlineRepositoryProvider);
    print('BloodlineRepository obtained: $bloodlineRepository');
    
    if (bloodlineRepository == null) {
      print('ERROR: BloodlineRepository is null!');
      throw Exception('BloodlineRepository is null');
    }
    
    print('About to create StreakService with:');
    print('  - BloodlineRepository: $bloodlineRepository');
    print('  - AuthRepository: $authRepository');
    
    final streakService = StreakService(bloodlineRepository, authRepository);
    print('StreakService created successfully: $streakService');
    return streakService;
  } catch (e) {
    print('ERROR creating StreakService: $e');
    print('Stack trace: ${StackTrace.current}');
    rethrow;
  }
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

// Friends Providers
final friendsRepositoryProvider = Provider<FriendsRepository>((ref) {
  return FriendsRepository();
});

final userFriendsProvider = StreamProvider<List<dynamic>>((ref) {
  final authState = ref.watch(authStateProvider);
  final repository = ref.watch(friendsRepositoryProvider);
  
  return authState.when(
    data: (user) {
      if (user == null) return Stream.value(<dynamic>[]);
      return Stream.fromFuture(repository.getUserFriends()).handleError((error) {
        // Convert any error to a stream error for better handling
        throw error;
      });
    },
    loading: () => Stream.value(<dynamic>[]),
    error: (error, stack) => Stream.error(error, stack),
  );
});

// Notifications Provider
final localNotificationsProvider = Provider<LocalNotifications>((ref) {
  return LocalNotifications();
});
