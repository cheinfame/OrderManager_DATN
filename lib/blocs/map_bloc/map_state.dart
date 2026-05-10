// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'map_bloc.dart';

enum MapBlocStatus { initial, loading, success, failed }

enum LoadMapStatus { initial, loading, success, failed }

class MapState {
  final Route? currentRoute;
  final List<Route> routes;
  final MapBlocStatus status;
  final String? error;
  final LoadMapStatus? loadingMapStatus;

  MapState({
    this.currentRoute,
    required this.routes,
    required this.status,
    this.error,
    this.loadingMapStatus,
  });

  MapState copyWith({
    Route? currentRoute,
    List<Route>? routes,
    MapBlocStatus? status,
    String? error,
    LoadMapStatus? loadingMapStatus,
  }) {
    return MapState(
      currentRoute: currentRoute ?? this.currentRoute,
      routes: routes ?? this.routes,
      status: status ?? this.status,
      error: error ?? this.error,
      loadingMapStatus: loadingMapStatus ?? this.loadingMapStatus,
    );
  }
}
