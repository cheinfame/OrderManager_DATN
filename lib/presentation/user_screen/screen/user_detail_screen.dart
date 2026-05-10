import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../blocs/staff_bloc/staff_bloc.dart';
import '../../../config/typography.dart';

class UserDetailScreen extends StatefulWidget {
  final String accountId;

  const UserDetailScreen({
    Key? key,
    required this.accountId,
  }) : super(key: key);

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<StaffBloc>().add(GetUserProfileEvent(userId: widget.accountId));
  }

  @override
  Widget build(BuildContext context) {
    final typography = AppTypography(context: context);

    return Scaffold(
      appBar: AppBar(
        title: Text('User Details', style: typography.title1),
        centerTitle: true,
        automaticallyImplyLeading: false, // Remove back button
      ),
      body: BlocBuilder<StaffBloc, StaffState>(
        builder: (context, state) {
          if (state.currentUserStatus == CurrentUserStatus.success) {
            final user = state.currentUser!;
            final createdAtFormatted = DateFormat('dd/MM/yyyy HH:mm:ss').format(user.createdAt!);
            final balanceFormatted = NumberFormat.currency(locale: 'vi_VN', symbol: '₫').format(user.wallet.balance);

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Personal Information', typography),
                  _buildDetailItem('First Name', user.user.firstName, typography),
                  _buildDetailItem('Last Name', user.user.lastName, typography),
                  _buildDetailItem('Phone Number', user.user.phoneNumber, typography),
                  _buildDetailItem('Username', user.username, typography),
                  _buildDetailItem('Account ID', user.accountId!, typography),
                  _buildDetailItem('Role', user.rolename, typography),
                  _buildDetailItem('Created At', createdAtFormatted, typography), // Formatted createdAt
                  _buildDetailItem('Balance', balanceFormatted, typography), // Formatted balance
                  _buildDetailItem('Transaction History', user.wallet.transactionHistory.join(', '), typography),
                  if (user.shipper != null) ...[
                    _buildSectionTitle('Shipper Information', typography),
                    _buildDetailItem('Shipper ID', user.shipper!.shipperId, typography),
                    _buildDetailItem('Shipped Orders', user.shipper!.shippedOrders.join(', '), typography),
                    _buildDetailItem('Current Orders', user.shipper!.currentOrders.join(', '), typography),
                    _buildDetailItem('Routes', user.shipper!.routes.join(', '), typography),
                    _buildDetailItem('Max Distance Allowance', user.shipper!.maxDistanceAllowance.toString(), typography),
                  ],
                ],
              ),
            );
          } else if (state.currentUserStatus == CurrentUserStatus.failed) {
            return Center(
              child: Text('Error: ${state.error}', style: typography.bodyText),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title, AppTypography typography) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        title,
        style: typography.title2.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildDetailItem(
      String title, String value, AppTypography typography) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120, // Fixed width for titles
            child: Text(
              title + ':',
              style: typography.footnote.copyWith(color: Colors.grey[600], fontWeight: FontWeight.w600),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: SelectableText(
              value,
              style: typography.bodyText,
            ),
          ),
        ],
      ),
    );
  }
}
