// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'order_bloc.dart';

enum OrderBlocStatus {
  initial,
  loading,
  success,
  failure,
}

enum CurrentOrderStatus {
  initial,
  loading,
  success,
  failure,
}

class OrderState {
  OrderBlocStatus status;
  CurrentOrderStatus currentOrderStatus;
  Order? currentOrder;
  List<Order>? orders;
  String? error;

  OrderState({
    this.status = OrderBlocStatus.initial,
    required this.currentOrderStatus,
    this.currentOrder,
    this.orders,
    this.error,
  });

  OrderState copyWith({
    OrderBlocStatus? status,
    CurrentOrderStatus? currentOrderStatus,
    Order? currentOrder,
    List<Order>? orders,
    String? error,
  }) {
    return OrderState(
      status: status ?? this.status,
      currentOrderStatus: currentOrderStatus ?? this.currentOrderStatus,
      currentOrder: currentOrder ?? this.currentOrder,
      orders: orders ?? this.orders,
      error: error ?? this.error,
    );
  }
}
