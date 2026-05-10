import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/staff_bloc/staff_bloc.dart';
import '../../../config/typography.dart';
import '../../../data/models/account_model.dart';

class UserTabView extends StatefulWidget {
  const UserTabView({Key? key}) : super(key: key);

  @override
  _UserTabViewState createState() => _UserTabViewState();
}

class _UserTabViewState extends State<UserTabView> {
  List<Account> users = []; // List of users
  TextEditingController searchController = TextEditingController();
  int rowsPerPage = 10;
  int page = 1;
  String selectedRole = 'All';

  @override
  void initState() {
    super.initState();
    // Fetch all users initially
    fetchAllUsers();
  }

  void fetchAllUsers() {
    context
        .read<StaffBloc>()
        .add(FetchAllUsersEvent(limit: rowsPerPage, page: page));
  }

  void fetchUsers(String searchText) {
    // Filter users based on account ID or phone number
    final filteredUsers = users
        .where((user) =>
            user.accountId!.contains(searchText) ||
            user.user.phoneNumber.contains(searchText))
        .toList();
    setState(() {
      users = filteredUsers;
    });
  }

  void onRoleChanged(String? newRole) {
    setState(() {
      selectedRole = newRole!;
    });

    if (selectedRole == 'All') {
      fetchAllUsers();
    } else {
      // Dispatch an event to fetch users by role
      context.read<StaffBloc>().add(FetchUserByRole(
            rolename: selectedRole.toLowerCase(),
            limit: rowsPerPage,
            page: page,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final typography = AppTypography(context: context);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'User Management',
            style: typography.title1.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    labelText: 'Search',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                  onChanged: (value) {
                    fetchUsers(value);
                  },
                ),
              ),
              SizedBox(width: 16),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedRole,
                    items: [
                      DropdownMenuItem(value: 'All', child: Text('All')),
                      DropdownMenuItem(
                          value: 'Shipper', child: Text('Shippers')),
                      DropdownMenuItem(
                          value: 'User', child: Text('Users')),
                    ],
                    onChanged: onRoleChanged,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Expanded(
            child: BlocBuilder<StaffBloc, StaffState>(
              builder: (context, state) {
                if (state.userAccountListStatus ==
                    UserAccountListStatus.loading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state.userAccountListStatus ==
                    UserAccountListStatus.failed) {
                  return Center(
                    child: Text(state.error ?? 'Failed to fetch users'),
                  );
                } else {
                  users = state.userAccountList ?? [];

                  return SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: PaginatedDataTable(
                      header: Text('Users'),
                      rowsPerPage: rowsPerPage,
                      availableRowsPerPage: [10, 20, 50],
                      onRowsPerPageChanged: (newRowsPerPage) {
                        setState(() {
                          rowsPerPage = newRowsPerPage!;
                        });
                        // fetchAllUsers(); // Refetch users with new rows per page
                      },
                      onPageChanged: (newPage) {
                        setState(() {
                          page = newPage;
                        });
                        fetchAllUsers(); // Refetch users with new page
                      },
                      showCheckboxColumn: false,
                      columns: [
                        DataColumn(
                            label: Text('Account ID',
                                style: typography.heading1)),
                        DataColumn(
                            label: Text('User Name',
                                style: typography.heading1)),
                        DataColumn(
                            label: Text('Phone Number',
                                style: typography.heading1)),
                        DataColumn(
                            label: Text('Role', style: typography.heading1)),
                      ],
                      source: _UserDataSource(users, context),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _UserDataSource extends DataTableSource {
  final List<Account> _users;
  final BuildContext context;

  _UserDataSource(this._users, this.context);

  @override
  DataRow getRow(int index) {
    final user = _users[index];
    return DataRow(
      cells: [
        DataCell(Text(user.accountId!)),
        DataCell(Text(user.username)),
        DataCell(Text(user.user.phoneNumber)),
        DataCell(Text(user.rolename)),
      ],
      onSelectChanged: (_) {
        _navigateToUserDetail(user);
      },
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _users.length;

  @override
  int get selectedRowCount => 0;

  void _navigateToUserDetail(Account user) {
    Navigator.pushNamed(
      context,
      '/user/:id',
      arguments: user.accountId,
    );
  }
}
