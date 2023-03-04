import 'package:auralia/logic/abstract/LocationServiceA.dart';
import 'package:geolocator/geolocator.dart';

import '../../models/regular/LocationModel.dart';

class LocationService implements LocationServiceA {
  @override
  Future<LocationModel> getCurrentLocation() async {
    Position locationData = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium);
    return LocationModel(locationData.latitude, locationData.longitude);
  }
}
