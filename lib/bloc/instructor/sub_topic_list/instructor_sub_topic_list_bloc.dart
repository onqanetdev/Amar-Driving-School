

import 'package:amar_driving_school/bloc/instructor/sub_topic_list/instructor_sub_topic_list_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../ApiService/instructor_sub_topic_list_api_service.dart';
import 'instructor_sub_topic_list_state.dart';

class InstructorSubTopicListBloc extends Bloc<InstructorSubTopicListEvent, InstructorSubTopicListState> {

  InstructorSubTopicListBloc() : super(InstructorSubTopicListInitial(),) {

    on<FetchInstructorSubTopicList>(
          (event, emit) async {

        emit(
          InstructorSubTopicListLoading(),
        );

        try {

          final response =
          await InstructorSubTopicListApiService().fetchSubTopicList(

            topicId: event.topicId,
          );

          emit(
            InstructorSubTopicListSuccess(
              subTopicListResponse:
              response,
            ),
          );

        } catch(e) {

          emit(
            InstructorSubTopicListFailure(
              e.toString(),
            ),
          );
        }
      },
    );
  }
}