abstract class BehaviourUploadServiceA {
  Future<int?> get recentUploadTime;
  Future<void> setRecentUploadTime(DateTime recentUploadTime);
  Future<bool> uploadSongs();
}
