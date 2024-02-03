///Abstraction for Networking Service, which handles everything http related
abstract class NetworkingServiceA {
  Future<List<String>> getGenreRecommendation(
      {required double lat,
      required double long,
      required int activity,
      required int dateTimeInMis});

  //TODO: Implement other class related networking stuff here, like oauth refresh and sending data to db!!!!
}
