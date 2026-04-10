import 'package:equatable/equatable.dart';

import 'package:client/domain/models/profile.dart';

sealed class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

final class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

final class ProfileLoaded extends ProfileState {
  const ProfileLoaded(this.profile);

  final Profile profile;

  @override
  List<Object?> get props => [profile];
}

final class ProfileError extends ProfileState {
  const ProfileError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
