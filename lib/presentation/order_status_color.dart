import 'package:flutter/material.dart';
import 'package:packare_manage_web/data/models/order_model.dart';

Color getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.waiting:
        return Colors.blue;
      case OrderStatus.verified:
        return Colors.green;
      case OrderStatus.declined:
        return Colors.red;
      case OrderStatus.shipperAccepted:
        return Colors.orange;
      case OrderStatus.startShipping:
        return Colors.orange;
      case OrderStatus.cancelled:
        return Colors.red;
      case OrderStatus.shipperPickedUp:
        return Colors.orange;
      case OrderStatus.delivered:
        return Colors.green;
      case OrderStatus.completed:
        return Colors.green;
      default:
        return Colors.blue;
    }
  }
