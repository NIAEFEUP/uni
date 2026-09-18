import 'package:flutter/material.dart';

class ServiceStatus {
  ServiceStatus._();
  static ({bool isOpen, String timeString})? getLiveStatus(
    List<String> openingHours,
  ) {
    if (openingHours.isEmpty) {
      return null;
    }

    final now = TimeOfDay.now();
    final nowMinutes = now.hour * 60 + now.minute;

    for (var i = 0; i < openingHours.length; i++) {
      final hours = openingHours[i];
      final parts = hours.split(' - ');
      if (parts.length != 2) {
        continue;
      }

      final openTimeStr = parts[0].replaceAll('h', '').trim();
      final closeTimeStr = parts[1].replaceAll('h', '').trim();

      final openTime = _parseTime(openTimeStr);
      final closeTime = _parseTime(closeTimeStr);

      final openMinutes = openTime.hour * 60 + openTime.minute;
      final closeMinutes = closeTime.hour * 60 + closeTime.minute;

      if (nowMinutes >= openMinutes && nowMinutes < closeMinutes) {
        return (isOpen: true, timeString: parts[1].trim());
      }

      if (nowMinutes < openMinutes) {
        return (isOpen: false, timeString: parts[0].trim());
      }
    }

    // service opens at the first interval next day
    final firstParts = openingHours[0].split(' - ');
    if (firstParts.length == 2) {
      return (isOpen: false, timeString: firstParts[0].trim());
    }

    return null;
  }

  static TimeOfDay _parseTime(String timeStr) {
    final parts = timeStr.split(':');
    if (parts.length == 2) {
      return TimeOfDay(
        hour: int.tryParse(parts[0]) ?? 0,
        minute: int.tryParse(parts[1]) ?? 0,
      );
    }
    return const TimeOfDay(hour: 0, minute: 0);
  }
}
