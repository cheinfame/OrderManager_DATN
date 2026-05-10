import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../config/typography.dart';
import '../../../data/models/order_model.dart';
import '../../../blocs/order_bloc/order_bloc.dart';
import '../../../data/models/package_model.dart';
import '../../order_status_color.dart';

class OrderDetailScreen extends StatefulWidget {
  final String orderId;

  const OrderDetailScreen({
    Key? key,
    required this.orderId,
  }) : super(key: key);

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<OrderBloc>().add(GetOrderByIdEvent(
        orderId: widget.orderId)); // Trigger the event to fetch order details
  }

  @override
  Widget build(BuildContext context) {
    final typography = AppTypography(context: context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details', style: typography.title1),
        centerTitle: true,
        automaticallyImplyLeading: false, // Remove back button
      ),
      body: SingleChildScrollView(
        child: BlocBuilder<OrderBloc, OrderState>(
          builder: (context, state) {
            if (state.currentOrderStatus == CurrentOrderStatus.loading) {
              return Center(child: CircularProgressIndicator());
            } else if (state.currentOrderStatus == CurrentOrderStatus.success) {

              return _buildOrderDetails(state.currentOrder!,
                  typography); // Build UI with the loaded order
            } else if (state.currentOrderStatus == CurrentOrderStatus.failure) {
              return Center(child: Text('Error: ${state.error}'));
            } else {
              return Container(); // Placeholder widget
            }
          },
        ),
      ),
    );
  }

  Widget _buildOrderDetails(Order order, AppTypography typography) {
    final currencyFormatter =
        NumberFormat.currency(symbol: '₫', decimalDigits: 0);
    final dateFormatter = DateFormat('yyyy-MM-dd HH:mm:ss');

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SelectableText(
                'Order ID: ',
                style: typography.title3.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                order.orderId,
                style: typography.title3,
              ),
              const Spacer(),
              if (order.status == OrderStatus.waiting)
                OutlinedButton(
                  onPressed: () {
                    context
                        .read<OrderBloc>()
                        .add(DeclineOrderEvent(orderId: order.orderId));
                  },
                  child: Text(
                    'Decline',
                  ),
                  style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red[300]),
                ),
              const SizedBox(
                width: 8,
              ),
              if (order.status == OrderStatus.waiting)
                OutlinedButton(
                  onPressed: () {context
                        .read<OrderBloc>()
                        .add(VerifyOrderEvent(orderId: order.orderId));},
                  child: Text('Verify'),
                  style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.green[300]),
                ),
            ],
          ),
          SizedBox(height: 16),
          _buildStatusCapsule(order.status, typography),
          SizedBox(height: 16),
          Text(
            'Packages',
            style: typography.title3.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          _buildPackagesList(order.packages),
          SizedBox(height: 16),
          Text(
            'Sender Information',
            style: typography.title3.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          _buildSenderDetails(order, typography),
          if (order.shipperId != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16),
                Text(
                  'Shipper Information',
                  style:
                      typography.title3.copyWith(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                _buildShipperDetails(order, typography),
              ],
            ),
          SizedBox(height: 16),
          Text(
            'Order Information',
            style: typography.title3.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          _buildOrderInfo(order, currencyFormatter, dateFormatter, typography),
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required String title,
    required String value,
    required AppTypography typography,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Text(
              title + ':',
              style: typography.footnote.copyWith(
                  color: Colors.grey[600], fontWeight: FontWeight.w600),
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: SelectableText(
              value,
              style: typography.bodyText.copyWith(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCapsule(OrderStatus status, AppTypography typography) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: getStatusColor(status),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        orderStatusMapping(status),
        style: typography.title3.copyWith(color: Colors.white),
      ),
    );
  }

  Widget _buildSenderDetails(Order order, AppTypography typography) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailRow(
          title: 'Sender ID',
          value: order.senderId,
          typography: typography,
        ),
        _buildDetailRow(
          title: 'Sender Name',
          value: order.sender!.user.firstName,
          typography: typography,
        ),
        _buildDetailRow(
          title: 'Sender Phone',
          value: order.sender!.user.phoneNumber,
          typography: typography,
        ),
      ],
    );
  }

  Widget _buildShipperDetails(Order order, AppTypography typography) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailRow(
          title: 'Shipper ID',
          value: order.shipperId!,
          typography: typography,
        ),
        _buildDetailRow(
          title: 'Shipper Name',
          value: order.shipper!.user.firstName,
          typography: typography,
        ),
        _buildDetailRow(
          title: 'Shipper Phone',
          value: order.shipper!.user.phoneNumber,
          typography: typography,
        ),
      ],
    );
  }

  Widget _buildOrderInfo(Order order, NumberFormat currencyFormatter,
      DateFormat dateFormatter, AppTypography typography) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailRow(
          title: 'Receiver Name',
          value: order.receiverName,
          typography: typography,
        ),
        _buildDetailRow(
          title: 'Receiver Phone',
          value: order.receiverPhone,
          typography: typography,
        ),
        _buildDetailRow(
          title: 'Shipping Price',
          value: currencyFormatter.format(order.shippingPrice ?? 0),
          typography: typography,
        ),
        _buildDetailRow(
          title: 'Sender Paid',
          value: currencyFormatter.format(order.senderPaid ?? 0),
          typography: typography,
        ),
        _buildDetailRow(
          title: 'Send Address',
          value: order.sendAddress,
          typography: typography,
        ),
        _buildDetailRow(
          title: 'Delivery Address',
          value: order.deliveryAddress,
          typography: typography,
        ),
        _buildDetailRow(
          title: 'Created At',
          value: dateFormatter.format(order.createTime!),
          typography: typography,
        ),
        _buildDetailRow(
          title: 'Status',
          value: orderStatusMapping(order.status),
          typography: typography,
        ),
      ],
    );
  }

  Widget _buildPackagesList(List<Package> packages) {
    final currencyFormatter =
        NumberFormat.currency(symbol: '₫', decimalDigits: 0);
    return ListView.builder(
      shrinkWrap: true,
      itemCount: packages.length,
      itemBuilder: (context, index) {
        final package = packages[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text(
                package.packageName,
                style: AppTypography(context: context).bodyText,
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    package.packageDescription ?? 'No description',
                    style: AppTypography(context: context).bodyText,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Holding Fee: ${currencyFormatter.format(package.packagePrice)}',
                    style: AppTypography(context: context).bodyText,
                  ),
                ],
              ),
              trailing: IconButton(
                onPressed: () {
                  package.packageImageUrl != null
                      ? _showPackageImage(context, package.packageImageUrl)
                      : null;
                },
                icon: const Icon(Icons.picture_as_pdf),
                color: Colors.blue,
                disabledColor: Colors.grey
              ),
            ),
            const Divider(),
          ],
        );
      },
    );
  }

  void _showPackageImage(BuildContext context, String? imageUrl) {
    if (imageUrl != null && imageUrl.isNotEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Image.network(
              imageUrl,
              scale: 0.5,
              fit: BoxFit.fill,
            ),
          );
        },
      );
    }
  }
}
