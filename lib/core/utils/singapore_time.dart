import 'package:flutter/foundation.dart';
import '../../features/centres/domain/donation_centre.dart';

/// Utility class for handling Singapore time consistently across the app
class SingaporeTime {
  /// Get current Singapore time (UTC+8)
  static DateTime now() {
    final utcNow = DateTime.now().toUtc();
    return utcNow.add(const Duration(hours: 8));
  }
  
  /// Get current Singapore time as formatted string for debugging
  static String getCurrentTimeString() {
    final singaporeTime = now();
    return '${singaporeTime.hour.toString().padLeft(2, '0')}:${singaporeTime.minute.toString().padLeft(2, '0')}';
  }
  
  /// Get current day of week in format used by opening hours
  static String getCurrentDay() {
    final singaporeTime = now();
    return _getDayName(singaporeTime.weekday);
  }
  
  /// Check if a centre is currently open based on opening hours
  static bool isCurrentlyOpen(Map<String, dynamic> openingHours) {
    final singaporeTime = now();
    final currentDay = _getDayName(singaporeTime.weekday);
    final currentMinutes = singaporeTime.hour * 60 + singaporeTime.minute;
    
    // Get today's hours
    final todayHours = openingHours[currentDay] as List<dynamic>?;
    
    // Debug logging
    if (kDebugMode) {
      print('Singapore Time: ${singaporeTime.toString()}');
      print('Current Day: $currentDay');
      print('Current Minutes: $currentMinutes');
      print('Today Hours: $todayHours');
    }
    
    if (todayHours == null || todayHours.isEmpty) {
      if (kDebugMode) {
        print('Centre is closed today (no hours)');
      }
      return false;
    }
    
    // Check each time period for today
    for (final period in todayHours) {
      final startTime = period['start'] as String;
      final endTime = period['end'] as String;
      
      final startMinutes = _timeToMinutes(startTime);
      final endMinutes = _timeToMinutes(endTime);
      
      if (kDebugMode) {
        print('Checking period: $startTime-$endTime (${startMinutes}-${endMinutes})');
      }
      
      if (currentMinutes >= startMinutes && currentMinutes < endMinutes) {
        if (kDebugMode) {
          print('Centre is OPEN (within hours)');
        }
        return true;
      }
    }
    
    if (kDebugMode) {
      print('Centre is CLOSED (outside hours)');
    }
    return false;
  }
  
  /// Format today's opening hours for display
  static String formatTodaysHours(Map<String, dynamic> openingHours) {
    final currentDay = getCurrentDay();
    final todayHours = openingHours[currentDay] as List<dynamic>?;
    
    if (todayHours == null || todayHours.isEmpty) {
      return 'Closed';
    }
    
    // Format multiple periods (if any)
    final periods = todayHours.map((period) {
      final start = period['start'] as String;
      final end = period['end'] as String;
      return '$start-$end';
    }).join(', ');
    
    return periods;
  }
  
  /// Format any day's opening hours for display
  static String formatDayHours(List<dynamic> dayHours) {
    if (dayHours.isEmpty) {
      return 'Closed';
    }
    
    // Format multiple periods (if any)
    final periods = dayHours.map((period) {
      final start = period['start'] as String;
      final end = period['end'] as String;
      return '$start-$end';
    }).join(', ');
    
    return periods;
  }
  
  static String _getDayName(int weekday) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[weekday - 1];
  }
  
  static int _timeToMinutes(String time) {
    final parts = time.split(':');
    return int.parse(parts[0]) * 60 + int.parse(parts[1]);
  }
  
  /// Test method to check if a specific time would be open
  static bool testTime(String timeString, Map<String, dynamic> openingHours) {
    final testTime = _timeToMinutes(timeString);
    final currentDay = getCurrentDay();
    final todayHours = openingHours[currentDay] as List<dynamic>?;
    
    if (todayHours == null || todayHours.isEmpty) {
      return false;
    }
    
    for (final period in todayHours) {
      final startTime = period['start'] as String;
      final endTime = period['end'] as String;
      
      final startMinutes = _timeToMinutes(startTime);
      final endMinutes = _timeToMinutes(endTime);
      
      if (testTime >= startMinutes && testTime < endMinutes) {
        return true;
      }
    }
    
    return false;
  }
}
