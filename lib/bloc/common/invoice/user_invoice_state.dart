
import '../../../model/InvoiceModel.dart';

abstract class UserInvoiceState {}

class UserInvoiceInitial
    extends UserInvoiceState {}

class UserInvoiceLoading
    extends UserInvoiceState {}

class UserInvoiceSuccess
    extends UserInvoiceState {

  final InvoiceModel userInvoiceResponse;

  UserInvoiceSuccess({

    required this.userInvoiceResponse,
  });
}

class UserInvoiceFailure
    extends UserInvoiceState {

  final String error;

  UserInvoiceFailure(
      this.error,
      );
}