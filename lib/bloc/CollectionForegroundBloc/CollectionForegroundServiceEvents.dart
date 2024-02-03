abstract class CollectionForegroundServiceEvent {}

class CollectionStartForegroundService
    extends CollectionForegroundServiceEvent {}

class StopCollectionForegroundService
    extends CollectionForegroundServiceEvent {}

class RestartCollectionForegroundService
    extends CollectionForegroundServiceEvent {}

class IsCollectionForegroundServiceRunning
    extends CollectionForegroundServiceEvent {}

class StartCollectionForegroundService
    extends CollectionForegroundServiceEvent {}
