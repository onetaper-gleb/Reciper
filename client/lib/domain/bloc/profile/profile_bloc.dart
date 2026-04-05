import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:client/core/utils/app_logger.dart';
import 'package:client/data/repository/profile_repository.dart';
import 'package:client/domain/bloc/profile/profile_event.dart';
import 'package:client/domain/bloc/profile/profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc(this._repository) : super(const ProfileInitial()) {
    on<ProfileLoadRequested>(_onLoadRequested);
    on<ProfileUpdated>(_onUpdated);
  }

  final ProfileRepository _repository;

  Future<void> _onLoadRequested(
    ProfileLoadRequested event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      AppLogger.info('ProfileBloc: ProfileLoadRequested');
      final profile = await _repository.getProfile();
      if (profile == null) {
        if (state is ProfileLoaded || state is ProfileError) {
          emit(const ProfileInitial());
        }
      } else {
        emit(ProfileLoaded(profile));
      }
    } catch (e, st) {
      AppLogger.warning('ProfileBloc: load failed', e, st);
      emit(ProfileError('$e'));
    }
  }

  Future<void> _onUpdated(
    ProfileUpdated event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      AppLogger.info('ProfileBloc: ProfileUpdated');
      final existing = await _repository.getProfile();
      if (existing == null) {
        await _repository.saveProfile(event.profile);
      } else {
        await _repository.updateProfile(event.profile);
      }
      final updated = await _repository.getProfile();
      if (updated != null) {
        emit(ProfileLoaded(updated));
      } else {
        emit(const ProfileInitial());
      }
    } catch (e, st) {
      AppLogger.warning('ProfileBloc: update failed', e, st);
      emit(ProfileError('$e'));
    }
  }
}
