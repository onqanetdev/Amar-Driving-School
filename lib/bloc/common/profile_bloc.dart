

import 'package:amar_driving_school/bloc/common/profile_event.dart';
import 'package:amar_driving_school/bloc/common/profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../ApiService/profile_api_service.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {

  ProfileBloc() : super(ProfileInitial(),) {

    on<FetchProfile>(
          (event, emit) async {

        emit(
          ProfileLoading(),
        );

        try {

          final response =
          await ProfileApiService()
              .fetchProfile(

            userId:
            event.userId,
          );

          emit(
            ProfileSuccess(

              profileResponse:
              response,
            ),
          );

        } catch(e) {

          emit(
            ProfileFailure(
              e.toString(),
            ),
          );
        }
      },
    );
  }
}