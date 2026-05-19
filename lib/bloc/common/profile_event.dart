

abstract class ProfileEvent {}

class FetchProfile
    extends ProfileEvent {

  final String userId;

  FetchProfile({

    required this.userId,
  });
}