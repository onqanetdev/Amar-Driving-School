

import 'package:amar_driving_school/bloc/instructor/termsandConditions/terms_and_conditions_event.dart';
import 'package:amar_driving_school/bloc/instructor/termsandConditions/terms_and_conditions_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../ApiService/terms_and_conditions_api_service/terms_and_conditions_api_service.dart';

class TermsConditionsBloc extends Bloc<TermsConditionsEvent, TermsConditionsState> {

  TermsConditionsBloc()
      : super(
    TermsConditionsInitial(),
  ) {

    on<FetchTermsConditions>(
          (event, emit) async {

        emit(
          TermsConditionsLoading(),
        );

        try {

          final response =
          await TermsAndConditionsApiService()
              .fetchTermsAndConditions(

            pageTitle:
            event.pageTitle,
          );

          emit(
            TermsConditionsSuccess(

              termsResponse:
              response,
            ),
          );

        } catch(e) {

          emit(
            TermsConditionsFailure(
              e.toString(),
            ),
          );
        }
      },
    );
  }
}