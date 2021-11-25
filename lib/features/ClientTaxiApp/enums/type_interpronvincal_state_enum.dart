enum InterprovincialStatus {
  loading, notEstablished, onWhereabouts, inRoute,
}

String toStringFirebaseInterprovincialStatus(InterprovincialStatus status){
  switch (status) {
    case InterprovincialStatus.onWhereabouts:
      return 'ON_WHEREABOUTS';
    case InterprovincialStatus.inRoute:
      return 'IN_ROUTE';
    default:
  }
  return null;
}
String toStringFirebaseIntHumanStatus(InterprovincialStatus status){
  switch (status) {
    case InterprovincialStatus.onWhereabouts:
      return 'En paradero';
    case InterprovincialStatus.inRoute:
      return 'En ruta';
    default:
  }
  return null;
}

InterprovincialStatus toInterprovincialStatusFromString(String status){
  switch (status) {
    case 'ON_WHEREABOUTS':
      return InterprovincialStatus.onWhereabouts;
    case 'IN_ROUTE':
      return InterprovincialStatus.inRoute;
    default:
  }
  return null;
}