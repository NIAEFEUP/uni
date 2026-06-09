import 'dart:math' as math;
import 'package:latlong2/latlong.dart';

class RoomLabelInfo {
  RoomLabelInfo({
    required this.center,
    required this.angle,
    required this.fontSize,
  });

  final LatLng center;
  final double angle;
  final double fontSize;
}

RoomLabelInfo getRoomLabelInfo(List<LatLng> polygon, String text, double zoom) {
  if (polygon.isEmpty || text.isEmpty) {
    return RoomLabelInfo(center: const LatLng(0, 0), angle: 0, fontSize: 6);
  }

  final originLat = polygon.first.latitude;
  final cosLat = math.cos(originLat * math.pi / 180.0);

  var maxDistSq = -1.0;
  var bestAngle = 0.0;

  for (var i = 0; i < polygon.length; i++) {
    final p1 = polygon[i];
    final p2 = polygon[(i + 1) % polygon.length];

    final dLat = p2.latitude - p1.latitude;
    final dLng = (p2.longitude - p1.longitude) * cosLat;
    final distSq = dLat * dLat + dLng * dLng;

    if (distSq > maxDistSq) {
      maxDistSq = distSq;
      bestAngle = math.atan2(-dLat, dLng);
    }
  }

  while (bestAngle > math.pi / 2.0) {
    bestAngle -= math.pi;
  }
  while (bestAngle < -math.pi / 2.0) {
    bestAngle += math.pi;
  }

  double minLocalX = double.infinity;
  double maxLocalX = -double.infinity;
  double minLocalY = double.infinity;
  double maxLocalY = -double.infinity;

  var pts = polygon;
  if (pts.length > 1 &&
      pts.first.latitude == pts.last.latitude &&
      pts.first.longitude == pts.last.longitude) {
    pts = pts.sublist(0, pts.length - 1);
  }

  for (final p in pts) {
    final dx = (p.longitude - polygon.first.longitude) * cosLat;
    final dy = -(p.latitude - originLat);

    final rx = dx * math.cos(-bestAngle) - dy * math.sin(-bestAngle);
    final ry = dx * math.sin(-bestAngle) + dy * math.cos(-bestAngle);

    if (rx < minLocalX) {
      minLocalX = rx;
    }
    if (rx > maxLocalX) {
      maxLocalX = rx;
    }
    if (ry < minLocalY) {
      minLocalY = ry;
    }
    if (ry > maxLocalY) {
      maxLocalY = ry;
    }
  }

  final centerRx = (minLocalX + maxLocalX) / 2.0;
  final centerRy = (minLocalY + maxLocalY) / 2.0;

  final cdx = centerRx * math.cos(bestAngle) - centerRy * math.sin(bestAngle);
  final cdy = centerRx * math.sin(bestAngle) + centerRy * math.cos(bestAngle);

  final centerLat = originLat - cdy;
  final centerLng = (cdx / cosLat) + polygon.first.longitude;
  final finalCenter = LatLng(centerLat, centerLng);

  final double scale = (256.0 * math.pow(2, zoom)) / 360.0;
  final double widthPx = (maxLocalX - minLocalX).abs() * scale;
  final double heightPx = (maxLocalY - minLocalY).abs() * scale;

  const charWidthFactor = 0.55;
  final double maxFontSizeByWidth = widthPx / (text.length * charWidthFactor);
  final double maxFontSizeByHeight = heightPx * 0.85;

  final double optimalSize =
      math.min(maxFontSizeByWidth, maxFontSizeByHeight) * 0.70;

  return RoomLabelInfo(
    center: finalCenter,
    angle: bestAngle,
    fontSize: optimalSize.clamp(2.0, 10.0),
  );
}
