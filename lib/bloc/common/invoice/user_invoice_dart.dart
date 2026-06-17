

import 'package:amar_driving_school/bloc/common/invoice/user_invoice_event.dart';
import 'package:amar_driving_school/bloc/common/invoice/user_invoice_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../ApiService/invoice_api_service.dart';

class UserInvoiceBloc extends Bloc<UserInvoiceEvent, UserInvoiceState> {

  UserInvoiceBloc()
      : super(
    UserInvoiceInitial(),
  ) {

    on<UserInvoiceTapped>(
          (event, emit) async {

        emit(
          UserInvoiceLoading(),
        );

        try {

          final response = await InvoiceApiService().exportUserInvoice(
            stdId: event.stdId,
          );

          emit(
            UserInvoiceSuccess(
              userInvoiceResponse: response,
            ),
          );

        } catch (e) {

          emit(
            UserInvoiceFailure(
              e.toString().replaceFirst(
                'Exception: ',
                '',
              ),
            ),
          );
        }
      },
    );
  }
}