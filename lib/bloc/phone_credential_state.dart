part of 'phone_credential_bloc.dart';

sealed class PhoneCredentialState extends Equatable {
  const PhoneCredentialState();

  @override
  List<Object> get props => [];
}

final class PhoneCredentialInitial extends PhoneCredentialState {}

final class PhoneCredentialloaded extends PhoneCredentialState {
  final credential;
  PhoneCredentialloaded({required this.credential});
  @override
  List<Object> get props => [credential];
}
