
abstract class UserInvoiceEvent {}

class UserInvoiceTapped
    extends UserInvoiceEvent {

  final String stdId;

  UserInvoiceTapped({

    required this.stdId,
  });
}