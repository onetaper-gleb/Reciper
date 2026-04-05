import 'package:equatable/equatable.dart';

import 'package:client/domain/models/profile.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

final class ProfileLoadRequested extends ProfileEvent {
  const ProfileLoadRequested();
}

final class ProfileUpdated extends ProfileEvent {
  const ProfileUpdated(this.profile);

  final Profile profile;

  @override
  List<Object?> get props => [profile];
}
