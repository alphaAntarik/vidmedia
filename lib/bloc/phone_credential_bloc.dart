import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'phone_credential_event.dart';
part 'phone_credential_state.dart';

class PhoneCredentialBloc
    extends Bloc<PhoneCredentialEvent, PhoneCredentialState> {
  PhoneCredentialBloc() : super(PhoneCredentialInitial()) {
    on<PhoneCredentialReceivingEvent>((event, emit) {
      emit(PhoneCredentialloaded(credential: event.credential));
      // TODO: implement event handler
    });
  }
}
