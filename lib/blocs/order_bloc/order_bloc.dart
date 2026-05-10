// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:bloc/bloc.dart';

import 'package:packare_manage_web/data/repositories/staff_repository_impl.dart';
import 'package:packare_manage_web/data/repositories/user_repository_impl.dart';

import '../../data/models/order_model.dart';
import '../../data/models/package_model.dart';
import '../../data/repositories/order_repository_impl.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderRepositoryImpl orderRepository;
  final UserRepositoryImpl userRepositoryImpl;
  final StaffRepositoryImpl staffRepositoryImpl;

  OrderBloc({
    required this.orderRepository,
    required this.userRepositoryImpl,
    required this.staffRepositoryImpl,
  }) : super(OrderState(
            status: OrderBlocStatus.initial,
            orders: [],
            currentOrderStatus: CurrentOrderStatus.initial)) {
    on<GetOrderByIdEvent>(_onGetOrderById);
    on<GetAllOrdersEvent>(_onGetAllOrdersEvent);
    on<GetOrdersByStatusEvent>(_onGetOrdersByStatusEvent);
    on<GetOrdersByUserEvent>(_onGetOrdersByUser);
    on<VerifyOrderEvent>(_onVerifyOrder);
    on<DeclineOrderEvent>(_onDeclineOrder);
    on<GetOrderPackages>(_onGetOrderPackages);
    on<UpdatePackageEvent>(_onUpdatePackage);
    on<DeletePackageEvent>(_onDeletePackage);
    on<OrderStateLoadingEvent>(_onOrderStateLoadingEvent);
  }

  void _onGetAllOrdersEvent(
      GetAllOrdersEvent event, Emitter<OrderState> emit) async {
    emit(state.copyWith(status: OrderBlocStatus.loading));
    try {
      final orders = await staffRepositoryImpl.fetchAllOrders(
        limit: event.limit,
        page: event.page,
      );
      emit(state.copyWith(
        status: OrderBlocStatus.success,
        orders: orders,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: OrderBlocStatus.failure,
        error: (error is SocketException)
            ? 'Network error occurred. Please check your internet connection and try again.'
            : error.toString(),
      ));
    }
  }

  void _onGetOrdersByStatusEvent(
      GetOrdersByStatusEvent event, Emitter<OrderState> emit) async {
    emit(state.copyWith(status: OrderBlocStatus.loading));
    try {
      final orders = await staffRepositoryImpl.fetchOrdersByStatus(
        event.status,
        limit: event.limit,
        page: event.page,
      );
      emit(state.copyWith(
        status: OrderBlocStatus.success,
        orders: orders,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: OrderBlocStatus.failure,
        error: (error is SocketException)
            ? 'Network error occurred. Please check your internet connection and try again.'
            : error.toString(),
      ));
    }
  }

  void _onOrderStateLoadingEvent(
      OrderStateLoadingEvent event, Emitter<OrderState> emit) {
    emit(state.copyWith(status: OrderBlocStatus.loading));
  }

  void _onGetOrderById(
      GetOrderByIdEvent event, Emitter<OrderState> emit) async {
    emit(state.copyWith(currentOrderStatus: CurrentOrderStatus.loading));
    try {
      Order currentOrder = await orderRepository
          .getOrderById(event.orderId)
          .timeout(const Duration(seconds: 30));

      final sender =
          await userRepositoryImpl.getUserProfile(currentOrder.senderId);

      if (currentOrder.shipperId != null) {
        final shipper =
            await userRepositoryImpl.getUserProfile(currentOrder.shipperId!);
        currentOrder = currentOrder.copyWith(sender: sender, shipper: shipper);
      } else {
        currentOrder = currentOrder.copyWith(sender: sender);
      }

      emit(state.copyWith(
          currentOrderStatus: CurrentOrderStatus.success,
          currentOrder: currentOrder));
    } catch (error) {
      emit(state.copyWith(
          currentOrderStatus: CurrentOrderStatus.failure,
          error: (error is SocketException)
              ? 'Network error occurred. Please check your internet connection and try again.'
              : error.toString()));
    }
  }

  void _onGetOrdersByUser(
      GetOrdersByUserEvent event, Emitter<OrderState> emit) async {
    emit(state.copyWith(status: OrderBlocStatus.loading));
    try {
      // Call the getUncompletedOrdersByUser method from OrderRepository
      final List<Order> orders = await orderRepository
          .getOrdersByUser(event.userId)
          .timeout(const Duration(seconds: 30));

      emit(state.copyWith(status: OrderBlocStatus.success, orders: orders));
    } catch (error) {
      emit(state.copyWith(
          status: OrderBlocStatus.failure,
          error: (error is SocketException)
              ? 'Network error occurred. Please check your internet connection and try again.'
              : error.toString()));
    }
  }

  void _onVerifyOrder(VerifyOrderEvent event, Emitter<OrderState> emit) async {
    emit(state.copyWith(currentOrderStatus: CurrentOrderStatus.loading));
    try {
      await orderRepository
          .verifyOrder(event.orderId)
          .timeout(const Duration(seconds: 30));
      Order currentOrder = state.currentOrder!;
      currentOrder.status = OrderStatus.verified;
      currentOrder.statusChangeTime = DateTime.now();
      emit(state.copyWith(
          currentOrderStatus: CurrentOrderStatus.success,
          currentOrder: currentOrder));
    } catch (error) {
      emit(state.copyWith(
          currentOrderStatus: CurrentOrderStatus.failure,
          error: (error is SocketException)
              ? 'Network error occurred. Please check your internet connection and try again.'
              : error.toString()));
    }
  }

  void _onDeclineOrder(
      DeclineOrderEvent event, Emitter<OrderState> emit) async {
    emit(state.copyWith(currentOrderStatus: CurrentOrderStatus.loading));
    try {
      await orderRepository
          .declineOrder(event.orderId)
          .timeout(const Duration(seconds: 30));
     Order currentOrder = state.currentOrder!;
      currentOrder.status = OrderStatus.declined;
      currentOrder.statusChangeTime = DateTime.now();
      emit(state.copyWith(
          currentOrderStatus: CurrentOrderStatus.success,
          currentOrder: currentOrder));
    } catch (error) {
      emit(state.copyWith(
          currentOrderStatus: CurrentOrderStatus.failure,
          error: (error is SocketException)
              ? 'Network error occurred. Please check your internet connection and try again.'
              : error.toString()));
    }
  }

  void _onGetOrderPackages(
      GetOrderPackages event, Emitter<OrderState> emit) async {
    emit(state.copyWith(status: OrderBlocStatus.loading));
    try {
      final packages = await orderRepository
          .getOrderPackages(event.orderId)
          .timeout(const Duration(seconds: 30));
      if (state.currentOrder != null) {
        emit(state.copyWith(
            status: OrderBlocStatus.success,
            currentOrder: state.currentOrder!.copyWith(packages: packages)));
      } else {
        throw ('Current order not found, please try again');
      }
    } catch (error) {
      emit(state.copyWith(
          status: OrderBlocStatus.failure,
          error: (error is SocketException)
              ? 'Network error occurred. Please check your internet connection and try again.'
              : error.toString()));
    }
  }

  void _onUpdatePackage(
      UpdatePackageEvent event, Emitter<OrderState> emit) async {
    emit(state.copyWith(status: OrderBlocStatus.loading));
    try {
      await orderRepository
          .updatePackage(event.orderId, event.packageId, event.package)
          .timeout(const Duration(seconds: 30));
      emit(state.copyWith(status: OrderBlocStatus.success));
    } catch (error) {
      emit(state.copyWith(
          status: OrderBlocStatus.failure,
          error: (error is SocketException)
              ? 'Network error occurred. Please check your internet connection and try again.'
              : error.toString()));
    }
  }

  void _onDeletePackage(
      DeletePackageEvent event, Emitter<OrderState> emit) async {
    emit(state.copyWith(status: OrderBlocStatus.loading));
    try {
      await orderRepository
          .deletePackage(event.orderId, event.packageId)
          .timeout(const Duration(seconds: 30));
      emit(state.copyWith(status: OrderBlocStatus.success));
    } catch (error) {
      emit(state.copyWith(
          status: OrderBlocStatus.failure,
          error: (error is SocketException)
              ? 'Network error occurred. Please check your internet connection and try again.'
              : error.toString()));
    }
  }
}
