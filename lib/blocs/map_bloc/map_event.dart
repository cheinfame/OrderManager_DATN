part of 'map_bloc.dart';

abstract class MapEvent {
  const MapEvent();
}

class SetMapStatusLoadingEvent extends MapEvent {}

class GetShipperRoutesEvent extends MapEvent {
  final String shipperId;

  const GetShipperRoutesEvent(this.shipperId);
}

class CreateRouteEvent extends MapEvent {
  final LatLng startCoords;
  final LatLng endCoords;
  final List<LatLng> waypoints;

  const CreateRouteEvent({
    required this.startCoords,
    required this.endCoords,
    this.waypoints = const [],
  });
}

class SaveRouteEvent extends MapEvent {
  final Route routeData;

  const SaveRouteEvent(this.routeData);
}

class GetRouteByIdEvent extends MapEvent {
  final String routeId;

  const GetRouteByIdEvent(this.routeId);
}

class UpdateRouteByIdEvent extends MapEvent {
  final String routeId;
  final Route updateData;

  const UpdateRouteByIdEvent(this.routeId, this.updateData);
}

class DeleteRouteByIdEvent extends MapEvent {
  final String routeId;

  const DeleteRouteByIdEvent(this.routeId);
}
