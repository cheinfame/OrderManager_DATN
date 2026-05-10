// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'staff_bloc.dart';

abstract class StaffEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchAllUsersEvent extends StaffEvent {
  final int? limit;
  final int? page;

  FetchAllUsersEvent({this.limit, this.page});

  @override
  List<Object?> get props => [limit, page];
}

class FetchUserByRole extends StaffEvent {
  final String rolename;
  final int? limit;
  final int? page;

  FetchUserByRole({
    required this.rolename,
    this.limit,
    this.page,
  });

  @override
  List<Object?> get props => [limit, page];
}

class GetUserProfileEvent extends StaffEvent {
  final String userId;

  GetUserProfileEvent({required this.userId});

  @override
  List<Object?> get props => [userId];
}
