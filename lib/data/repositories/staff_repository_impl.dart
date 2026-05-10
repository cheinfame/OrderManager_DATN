import 'dart:io';
import 'package:flutter/services.dart';
import '../models/account_model.dart';
import '../models/order_model.dart';
import '../services/shared_preferences_service.dart';
import '../services/staff_service.dart';
import 'staff_repository.dart';

class StaffRepositoryImpl implements StaffRepository {
  final StaffService _staffService;
  final SharedPreferencesService _sharedPreferencesService;

  StaffRepositoryImpl({
    required StaffService staffService,
    required SharedPreferencesService sharedPreferencesService,
  })  : _staffService = staffService,
        _sharedPreferencesService = sharedPreferencesService;

  @override
  Future<List<Order>> fetchAllOrders({int? limit, int? page}) async {
    try {
      final token = _sharedPreferencesService.getStringValue('token') ?? 'a';
      if (token == null) {
        throw Exception('Token not found');
      }

      final response =
          await _staffService.fetchAllOrders(token, limit: limit, page: page);

      final List<Order> orders = [];
      for (var orderJson in response['data']) {
        orders.add(Order.fromJson(orderJson));
      }

      return orders;
    } catch (error) {
      print('Error getting all orders: $error');
      if (error is SocketException) {
        throw PlatformException(
            code: 'NETWORK_ERROR', message: 'Network error occurred.');
      }
      rethrow;
    }
  }

  @override
  Future<List<Order>> fetchOrdersByStatus(OrderStatus status,
      {int? limit, int? page}) async {
    try {
      final token = _sharedPreferencesService.getStringValue('token') ?? 'a';
      if (token == null) {
        throw Exception('Token not found');
      }

      final response = await _staffService.fetchOrdersByStatus(
          token, _getStatusString(status),
          limit: limit, page: page);

      final List<Order> orders = [];
      for (var orderJson in response['data']) {
        orders.add(Order.fromJson(orderJson));
      }

      return orders;
    } catch (error) {
      print('Error getting orders by status: $error');
      if (error is SocketException) {
        throw PlatformException(
            code: 'NETWORK_ERROR', message: 'Network error occurred.');
      }
      rethrow;
    }
  }

  @override
  Future<List<Account>> fetchAllUsers({int? limit, int? page}) async {
    try {
      final token = _sharedPreferencesService.getStringValue('token') ?? 'a';
      if (token == null) {
        throw Exception('Token not found');
      }

      final response =
          await _staffService.fetchAllUsers(token, limit: limit, page: page);

      final List<Account> users = [];
      for (var userJson in response['data']) {
        users.add(Account.fromJson(userJson));
      }

      return users;
    } catch (error) {
      print('Error getting all users: $error');
      if (error is SocketException) {
        throw PlatformException(
            code: 'NETWORK_ERROR', message: 'Network error occurred.');
      }
      rethrow;
    }
  }

  @override
  Future<List<Account>> fetchUsersByRole(String role,
      {int? limit, int? page}) async {
    try {
      final token = _sharedPreferencesService.getStringValue('token') ?? 'a';
      if (token == null) {
        throw Exception('Token not found');
      }

      final response = await _staffService.fetchUsersByRole(token, role,
          limit: limit, page: page);

      final List<Account> users = [];
      for (var userJson in response['data']) {
        users.add(Account.fromJson(userJson));
      }

      return users;
    } catch (error) {
      print('Error getting users by role: $error');
      if (error is SocketException) {
        throw PlatformException(
            code: 'NETWORK_ERROR', message: 'Network error occurred.');
      }
      rethrow;
    }
  }

  String _getStatusString(OrderStatus status) {
    switch (status) {
      case OrderStatus.waiting:
        return 'waiting';
      case OrderStatus.verified:
        return 'verified';
      case OrderStatus.declined:
        return 'declined';
      case OrderStatus.shipperAccepted:
        return 'shipper_accepted';
      case OrderStatus.startShipping:
        return 'start_shipping';
      case OrderStatus.cancelled:
        return 'cancelled';
      case OrderStatus.shipperPickedUp:
        return 'shipper_picked_up';
      case OrderStatus.delivered:
        return 'delivered';
      case OrderStatus.completed:
        return 'completed';
      default:
        return 'waiting';
    }
  }
}
