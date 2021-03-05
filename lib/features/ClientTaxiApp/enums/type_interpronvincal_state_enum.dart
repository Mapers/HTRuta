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