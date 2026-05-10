// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'order_bloc.dart';

abstract class OrderEvent {}

class OrderStateLoadingEvent extends OrderEvent {}

class GetAllOrdersEvent extends OrderEvent {
  final int page;
  final int limit;

  GetAllOrdersEvent({required this.page, required this.limit});
}

class GetOrdersByStatusEvent extends OrderEvent {
  final OrderStatus status;
  final int page;
  final int limit;

  GetOrdersByStatusEvent({
    required this.status,
    required this.page,
    required this.limit,
  });
}

class GetOrderByIdEvent extends OrderEvent {
  final String orderId;

  GetOrderByIdEvent({required this.orderId});
}

class GetOrdersByUserEvent extends OrderEvent {
  final String userId;

  GetOrdersByUserEvent({required this.userId});
}

class VerifyOrderEvent extends OrderEvent {
  final String orderId;

  VerifyOrderEvent({required this.orderId});
}

class DeclineOrderEvent extends OrderEvent {
  final String orderId;

  DeclineOrderEvent({required this.orderId});
}

class GetOrderPackages extends OrderEvent {
  final String orderId;

  GetOrderPackages({required this.orderId});
}

class UpdatePackageEvent extends OrderEvent {
  final String orderId;
  final String packageId;
  final Package package;

  UpdatePackageEvent(
      {required this.orderId, required this.packageId, required this.package});
}

class DeletePackageEvent extends OrderEvent {
  final String orderId;
  final String packageId;

  DeletePackageEvent({required this.orderId, required this.packageId});
}
