import 'package:bloc/bloc.dart';
import 'package:geolocator/geolocator.dart';

enum LocationStatus {
  unknown,
  requesting,
  granted,
  denied,
  deniedForever,
  servicesDisabled,
}

class LocationState {
  final LocationStatus status;
  final String? error;
  const LocationState({this.status = LocationStatus.unknown, this.error});

  LocationState copyWith({LocationStatus? status, String? error}) =>
      LocationState(status: status ?? this.status, error: error);
}

class LocationCubit extends Cubit<LocationState> {
  LocationCubit() : super(const LocationState());

  bool _busy = false;

  Future<void> check() async {
    if (_busy) return;
    _busy = true;
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        emit(state.copyWith(status: LocationStatus.servicesDisabled, error: null));
        return;
      }
      final perm = await Geolocator.checkPermission();
      emit(state.copyWith(status: _statusFrom(perm), error: null));
    } catch (e) {
      emit(state.copyWith(status: LocationStatus.denied, error: '$e'));
    } finally {
      _busy = false;
    }
  }

  Future<void> request() async {
    if (_busy) return;
    _busy = true;
    emit(state.copyWith(status: LocationStatus.requesting, error: null));
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        emit(state.copyWith(status: LocationStatus.servicesDisabled, error: null));
        return;
      }

      var perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
      }

      emit(state.copyWith(status: _statusFrom(perm), error: null));
    } catch (e) {
      emit(state.copyWith(status: LocationStatus.denied, error: '$e'));
    } finally {
      _busy = false;
    }
  }

  Future<void> ensurePermission({bool requestIfDenied = false}) async {
    await check();
    if (requestIfDenied && state.status == LocationStatus.denied) {
      await request();
    }
  }

  Future<void> openLocationSettings() => Geolocator.openLocationSettings();
  Future<void> openAppSettings() => Geolocator.openAppSettings();

  LocationStatus _statusFrom(LocationPermission perm) {
    switch (perm) {
      case LocationPermission.always:
      case LocationPermission.whileInUse:
        return LocationStatus.granted;
      case LocationPermission.denied:
        return LocationStatus.denied;
      case LocationPermission.deniedForever:
        return LocationStatus.deniedForever;
      default:
        return LocationStatus.denied;
    }
  }
}
