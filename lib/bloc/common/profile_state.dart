

import '../../model/profile_model.dart';

abstract class ProfileState {}

class ProfileInitial
    extends ProfileState {}

class ProfileLoading
    extends ProfileState {}

class ProfileSuccess
    extends ProfileState {

  final InstructorProfileModel profileResponse;

  ProfileSuccess({

    required this.profileResponse,
  });
}

class ProfileFailure
    extends ProfileState {

  final String error;

  ProfileFailure(
      this.error,
      );
}