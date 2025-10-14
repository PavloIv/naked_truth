import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();

  Timer? _timer;
  String? _uid;

  Future<void> startForCurrentUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    _uid = user.uid;

    final ok = await _ensurePermissions();
    if (!ok) return;

    await _tickOnce();

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(minutes: 5), (_) => _tickOnce());
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
    _uid = null;
  }

  Future<void> _tickOnce() async {
    try {
      if (_uid == null) return;

      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      await FirebaseFirestore.instance.collection('users').doc(_uid).update({
        'location': {
          'latitude': pos.latitude,
          'longitude': pos.longitude,
          'timestamp': FieldValue.serverTimestamp(),
        },
      });
    } catch (e) {
      debugPrint('Location tick error: $e');
    }
  }

  Future<bool> _ensurePermissions() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Можеш показати тост/банер і запропонувати відкрити налаштування
      // await Geolocator.openLocationSettings();
      return false;
    }

    var perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
    }
    if (perm == LocationPermission.denied ||
        perm == LocationPermission.deniedForever) {
      return false;
    }
    return true;
  }
}
