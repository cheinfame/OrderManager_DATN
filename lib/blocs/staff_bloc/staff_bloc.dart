import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'dart:async';
import 'dart:io';

import '../../data/models/account_model.dart';
import '../../data/repositories/staff_repository_impl.dart';
import '../../data/repositories/user_repository_impl.dart';

part 'staff_event.dart';
part 'staff_state.dart';

class StaffBloc extends Bloc<StaffEvent, StaffState> {
  final StaffRepositoryImpl staffRepository;
  final UserRepositoryImpl userRepository;

  StaffBloc({
    required this.staffRepository,
    required this.userRepository,
  }) : super(StaffState(
          userAccountListStatus: UserAccountListStatus.initial,
          currentUserStatus: CurrentUserStatus.initial,
        )) {
    on<FetchAllUsersEvent>(_onFetchAllUsersEvent);
    on<FetchUserByRole>(_onFetchUserByRole);
    on<GetUserProfileEvent>(_onGetUserProfileEvent);
  }

  void _onGetUserProfileEvent(
      GetUserProfileEvent event, Emitter<StaffState> emit) async {
    emit(state.copyWith(currentUserStatus: CurrentUserStatus.loading));
    try {
      final account = await userRepository
          .getUserProfile(event.userId)
          .timeout(const Duration(seconds: 30));

      emit(state.copyWith(
          currentUserStatus: CurrentUserStatus.success, currentUser: account));
    } catch (error) {
      emit(state.copyWith(
          currentUserStatus: CurrentUserStatus.failed,
          error: (error is TimeoutException)
              ? 'The request timed out. Please check your internet connection and try again.'
              : error.toString()));
    }
  }

  void _onFetchAllUsersEvent(
      FetchAllUsersEvent event, Emitter<StaffState> emit) async {
    emit(state.copyWith(userAccountListStatus: UserAccountListStatus.loading));
    try {
      final users = await staffRepository.fetchAllUsers(
        limit: event.limit,
        page: event.page,
      );
      emit(state.copyWith(
          userAccountListStatus: UserAccountListStatus.success,
          userAccountList: users));
    } catch (error) {
      emit(state.copyWith(
          userAccountListStatus: UserAccountListStatus.failed,
          error: (error is SocketException)
              ? 'Network error occurred. Please check your internet connection and try again.'
              : 'Failed to fetch users'));
    }
  }

  void _onFetchUserByRole(
      FetchUserByRole event, Emitter<StaffState> emit) async {
    emit(state.copyWith(userAccountListStatus: UserAccountListStatus.loading));
    try {
      final users = await staffRepository.fetchUsersByRole(
        event.rolename,
        limit: event.limit,
        page: event.page,
      );
      emit(state.copyWith(
          userAccountListStatus: UserAccountListStatus.success,
          userAccountList: users));
    } catch (error) {
      emit(state.copyWith(
          userAccountListStatus: UserAccountListStatus.failed,
          error: (error is SocketException)
              ? 'Network error occurred. Please check your internet connection and try again.'
              : 'Failed to fetch shippers'));
    }
  }


}
