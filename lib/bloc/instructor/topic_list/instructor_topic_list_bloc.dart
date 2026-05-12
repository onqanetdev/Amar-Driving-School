

import 'package:amar_driving_school/bloc/instructor/topic_list/instructor_topic_list_event.dart';
import 'package:amar_driving_school/bloc/instructor/topic_list/instructor_topic_list_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../ApiService/Instructor_Topic_list_Api_Service.dart';

class InstructorTopicListBloc extends Bloc<InstructorTopicListEvent, InstructorTopicListState> {

  InstructorTopicListBloc() : super(InstructorTopicListInitial(),) {

    on<FetchInstructorTopicList>(
          (event, emit) async {

        emit(
          InstructorTopicListLoading(),
        );

        try {

          final response =
          await InstructorTopicListApiService()
              .fetchTopicList();

          emit(
            InstructorTopicListSuccess(
              topicListResponse:
              response,
            ),
          );

        } catch(e) {

          emit(
            InstructorTopicListFailure(
              e.toString(),
            ),
          );
        }
      },
    );
  }
}