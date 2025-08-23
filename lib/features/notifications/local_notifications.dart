// Simplified mock notifications service (without flutter_local_notifications)
// This is a placeholder to make the app compile and run

class LocalNotifications {
  static bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;
    
    print('Mock LocalNotifications initialized');
    _initialized = true;
  }

  Future<bool> requestPermissions() async {
    print('Mock notification permissions granted');
    return true;
  }

  Future<void> scheduleBookingReminders({
    required String bookingId,
    required DateTime bookingDateTime,
    required String centreName,
  }) async {
    print('Mock booking reminders scheduled for $centreName at $bookingDateTime');
    // TODO: Implement actual notifications when ready
  }

  Future<void> scheduleStreakReminder({
    required String challengeId,
    required int daysRemaining,
  }) async {
    print('Mock streak reminder scheduled: $daysRemaining days remaining for challenge $challengeId');
    // TODO: Implement actual notifications when ready
  }

  Future<void> showImmediateNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    print('Mock notification: $title - $body');
    // TODO: Implement actual notifications when ready
  }

  Future<void> cancelNotification(int id) async {
    print('Mock notification $id cancelled');
    // TODO: Implement actual notifications when ready
  }

  Future<void> cancelAllNotifications() async {
    print('All mock notifications cancelled');
    // TODO: Implement actual notifications when ready
  }
}