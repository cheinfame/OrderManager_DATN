// ignore_for_file: public_member_api_docs, sort_constructors_first

part of 'account_bloc.dart';

enum AccountStatus { initial, loading, success, failed }


class AccountState {
  AccountStatus status;
  Account? account;

  String? error;

  AccountState({
    this.status = AccountStatus.initial,
    this.account,

    this.error,
  });

  AccountState copyWith({
    AccountStatus? status,
    Account? account,
    String? error,
  }) {
    return AccountState(
      status: status ?? this.status,
      account: account ?? this.account,
      error: error ?? this.error,
    );
  }
}
