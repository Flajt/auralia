import '../../models/regular/LocationModel.dart';

abstract class LocationServiceA {
  Future<LocationModel> getCurrentLocation();
}
