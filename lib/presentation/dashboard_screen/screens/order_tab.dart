import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart'; // Added this import
import 'package:intl/intl.dart'; // Added for date and currency formatting
import '../../../blocs/order_bloc/order_bloc.dart';
import '../../../config/typography.dart';
import '../../../data/models/order_model.dart';
import '../../order_status_color.dart';

class OrderTabView extends StatefulWidget {
  const OrderTabView({Key? key}) : super(key: key);

  @override
  _OrderTabViewState createState() => _OrderTabViewState();
}

class _OrderTabViewState extends State<OrderTabView> {
  List<Order> orders = [];
  TextEditingController searchController = TextEditingController();
  int rowsPerPage = 10;
  int page = 1;
  String selectedStatus = 'All';

  @override
  void initState() {
    super.initState();
    fetchAllOrders();
  }

  void fetchAllOrders() {
    context.read<OrderBloc>().add(GetAllOrdersEvent(
          limit: rowsPerPage,
          page: page,
        ));
  }

  void fetchOrders(String searchText) {
    final filteredOrders = orders
        .where((order) =>
            order.orderId.contains(searchText) ||
            order.senderId.contains(searchText) ||
            order.receiverName.contains(searchText))
        .toList();
    setState(() {
      orders = filteredOrders;
    });
  }

  OrderStatus orderStatusFromString(String status) {
    switch (status) {
      case 'Waiting':
        return OrderStatus.waiting;
      case 'Verified':
        return OrderStatus.verified;
      case 'Declined':
        return OrderStatus.declined;
      case 'Shipper Accepted':
        return OrderStatus.shipperAccepted;
      case 'Start Shipping':
        return OrderStatus.startShipping;
      case 'Cancelled':
        return OrderStatus.cancelled;
      case 'Shipper Picked Up':
        return OrderStatus.shipperPickedUp;
      case 'Delivered':
        return OrderStatus.delivered;
      case 'Completed':
        return OrderStatus.completed;
      default:
        return OrderStatus.waiting;
    }
  }

  void onStatusChanged(String? newStatus) {
    setState(() {
      selectedStatus = newStatus!;
    });

    if (selectedStatus == 'All') {
      fetchAllOrders();
    } else {
      context.read<OrderBloc>().add(GetOrdersByStatusEvent(
            status: orderStatusFromString(selectedStatus),
            limit: rowsPerPage,
            page: page,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final typography = AppTypography(context: context);
    final currencyFormatter =
        NumberFormat.currency(symbol: '₫', decimalDigits: 0);
    final dateFormatter = DateFormat('yyyy-MM-dd HH:mm:ss');

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Order Management',
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
                    fetchOrders(value);
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
                    value: selectedStatus,
                    items: const [
                      DropdownMenuItem(value: 'All', child: Text('All')),
                      DropdownMenuItem(
                          value: 'Waiting', child: Text('Waiting')),
                      DropdownMenuItem(
                          value: 'Verified', child: Text('Verified')),
                      DropdownMenuItem(
                          value: 'Declined', child: Text('Declined')),
                      DropdownMenuItem(
                          value: 'Shipper Accepted',
                          child: Text('Shipper Accepted')),
                      DropdownMenuItem(
                          value: 'Start Shipping',
                          child: Text('Start Shipping')),
                      DropdownMenuItem(
                          value: 'Cancelled', child: Text('Cancelled')),
                      DropdownMenuItem(
                          value: 'Shipper Picked Up',
                          child: Text('Shipper Picked Up')),
                      DropdownMenuItem(
                          value: 'Delivered', child: Text('Delivered')),
                      DropdownMenuItem(
                          value: 'Completed', child: Text('Completed')),
                    ],
                    onChanged: onStatusChanged,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Expanded(
            child: BlocBuilder<OrderBloc, OrderState>(
              builder: (context, state) {
                if (state.status == OrderBlocStatus.loading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state.status == OrderBlocStatus.failure) {
                  return Center(
                    child: Text(state.error ?? 'Failed to fetch orders'),
                  );
                } else {
                  orders = state.orders ?? [];

                  return SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: PaginatedDataTable(
                      header: Text('Orders'),
                      rowsPerPage: rowsPerPage,
                      availableRowsPerPage: [10, 20, 50],
                      onRowsPerPageChanged: (newRowsPerPage) {
                        setState(() {
                          rowsPerPage = newRowsPerPage!;
                        });
                        fetchAllOrders(); // Fetch orders with the new rowsPerPage value
                      },
                      showCheckboxColumn: false,
                      showFirstLastButtons: true,
                      onPageChanged: (newPage) {
                        setState(() {
                          page = newPage;
                        });
                        fetchAllOrders();
                      },
                      columns: [
                        DataColumn(
                          label: Text('Order ID', style: typography.heading1),
                        ),
                        DataColumn(
                          label: Text('Sender ID', style: typography.heading1),
                        ),
                        DataColumn(
                          label: Text('Created At', style: typography.heading1),
                        ),
                        DataColumn(
                          label: Text('Shipper ID', style: typography.heading1),
                        ),
                        DataColumn(
                          label: Text('Shipping Price',
                              style: typography.heading1),
                        ),
                        DataColumn(
                          label:
                              Text('Sender Paid', style: typography.heading1),
                        ),
                        DataColumn(
                          label: Text(
                            'Status',
                            style: typography.heading1,
                          ),
                        ),
                      ],
                      source: _OrderDataSource(
                          orders, context, currencyFormatter, dateFormatter),
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

class _OrderDataSource extends DataTableSource {
  final List<Order> _orders;
  final BuildContext context;
  final NumberFormat currencyFormatter;
  final DateFormat dateFormatter;

  _OrderDataSource(
      this._orders, this.context, this.currencyFormatter, this.dateFormatter);

  @override
  DataRow getRow(int index) {
    final order = _orders[index];
    return DataRow(
      cells: [
        DataCell(Text(order.orderId)),
        DataCell(Text(order.senderId)),
        DataCell(Text(dateFormatter.format(order.createTime!))),
        DataCell(Text(order.shipperId ?? 'N/A')),
        DataCell(Text(currencyFormatter.format(order.shippingPrice))),
        DataCell(
          Text(currencyFormatter.format(order.senderPaid)),
        ),
        DataCell(Container(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          decoration: BoxDecoration(
            color: getStatusColor(
                order.status), // Function to get color based on status
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            orderStatusMapping(order.status), // Function to get status string
            style: TextStyle(color: Colors.white),
          ),
        )),
      ],
      onSelectChanged: (_) {
        _navigateToOrderDetail(order);
      },
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _orders.length;

  @override
  int get selectedRowCount => 0;

  void _navigateToOrderDetail(Order order) {
    Navigator.pushNamed(
      context,
      '/order/:id',
      arguments: order.orderId,
    );
  }
}
