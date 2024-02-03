abstract class PlayerEvent {}

class Play extends PlayerEvent {}

class Stop extends PlayerEvent {}

class SkipForward extends PlayerEvent {}

class SkipBackwards extends PlayerEvent {}

class InitPlayer extends PlayerEvent {}

class IRestart extends PlayerEvent {}
