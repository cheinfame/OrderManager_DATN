import 'package:packare_manage_web/data/models/order_model.dart';

import '../models/account_model.dart';

abstract class StaffRepository {
  Future<List<Order>> fetchAllOrders({int? limit, int? page});
  Future<List<Account>> fetchAllUsers({int? limit, int? page});
  Future<List<Account>> fetchUsersByRole(String role, {int? limit, int? page});
  Future<List<Order>> fetchOrdersByStatus(OrderStatus status,
      {int? limit, int? page});
}
