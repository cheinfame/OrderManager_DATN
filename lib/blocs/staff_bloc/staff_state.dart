// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'staff_bloc.dart';

enum UserAccountListStatus { initial, loading, success, failed }

enum CurrentUserStatus { initial, loading, success, failed }

class StaffState {
  List<Account>? userAccountList;
  UserAccountListStatus userAccountListStatus;
  CurrentUserStatus currentUserStatus;
  Account? currentUser;
  String? error;

  StaffState({
    this.userAccountList,
    required this.userAccountListStatus,
    required this.currentUserStatus,
    this.currentUser,
    this.error,
  });

  StaffState copyWith({
    List<Account>? userAccountList,
    UserAccountListStatus? userAccountListStatus,
    CurrentUserStatus? currentUserStatus,
    Account? currentUser,
    String? error,
  }) {
    return StaffState(
      userAccountList: userAccountList ?? this.userAccountList,
      userAccountListStatus: userAccountListStatus ?? this.userAccountListStatus,
      currentUserStatus: currentUserStatus ?? this.currentUserStatus,
      currentUser: currentUser ?? this.currentUser,
      error: error ?? this.error,
    );
  }
}
