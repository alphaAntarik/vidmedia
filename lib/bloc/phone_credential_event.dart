part of 'phone_credential_bloc.dart';

sealed class PhoneCredentialEvent extends Equatable {
  const PhoneCredentialEvent();

  @override
  List<Object> get props => [];
}

class PhoneCredentialReceivingEvent extends PhoneCredentialEvent {
  final credential;
  PhoneCredentialReceivingEvent({required this.credential});
  @override
  List<Object> get props => [credential];
}
