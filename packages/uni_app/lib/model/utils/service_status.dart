class ServiceStatus {
  ServiceStatus._();

  static ({bool isOpen, String timeString})? getLiveStatus(
    List<String> openingHours, {
    DateTime? now,
  }) {
    if (openingHours.isEmpty) {
      return null;
    }

    now ??= DateTime.now();
    final nowMinutes = now.hour * 60 + now.minute;
    final isWeekend =
        now.weekday == DateTime.saturday || now.weekday == DateTime.sunday;

    if (!isWeekend) {
      for (final hours in openingHours) {
        final parts = hours.split(' - ');
        if (parts.length != 2) {
          continue;
        }

        final openMinutes = _toMinutes(parts[0]);
        final closeMinutes = _toMinutes(parts[1]);

        if (nowMinutes >= openMinutes && nowMinutes < closeMinutes) {
          return (isOpen: true, timeString: parts[1].trim());
        }

        if (nowMinutes < openMinutes) {
          return (isOpen: false, timeString: parts[0].trim());
        }
      }
    }

    // service opens at the first interval of the next working day
    final firstParts = openingHours[0].split(' - ');
    if (firstParts.length == 2) {
      return (isOpen: false, timeString: firstParts[0].trim());
    }

    return null;
  }

  static int _toMinutes(String time) {
    final parts = time.replaceAll('h', '').trim().split(':');
    if (parts.length != 2) {
      return 0;
    }
    return (int.tryParse(parts[0]) ?? 0) * 60 + (int.tryParse(parts[1]) ?? 0);
  }
}
