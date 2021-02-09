String getImageSteps(var steps) {
  switch (steps) {
    case "turn-left":
      return 'assets/image/directions/left.png';
      break;
    case "turn-slight-left":
      return 'assets/image/directions/slightly_left.png';
      break;
    case "turn-sharp-left":
      return 'assets/image/directions/hard_left.png';
      break;
    case "uturn-left":
      return 'assets/image/directions/uturn_left.png';
      break;
    case "turn-slight-right":
      return 'assets/image/directions/slightly_right.png';
      break;
    case "turn-sharp-right":
      return 'assets/image/directions/hard_right.png';
      break;
    case "uturn-right":
      return 'assets/image/directions/uturn_right.png';
      break;
    case "turn-right":
      return 'assets/image/directions/right.png';
      break;
    case "straight":
      return 'assets/image/directions/continue.png';
      break;
    case "ramp-left":
      return 'assets/image/directions/ramp-left.png';
      break;
    case "ramp-right":
      return 'assets/image/directions/ramp-right.png';
      break;
    case "merge":
      return 'assets/image/directions/merge.png';
      break;
    case "fork-left":
      return 'assets/image/directions/fork-left.png';
      break;
    case "fork-right":
      return 'assets/image/directions/fork-right.png';
      break;
    case "roundabout-left":
      return 'assets/image/directions/roundabout-left.png';
      break;
    case "roundabout-right":
      return 'assets/image/directions/fork-right.png';
      break;
    case "roundabout-right":
      return 'assets/image/directions/roundabout-right.png';
      break;
    default:
      return "assets/image/directions/map-marker.png";
      break;
  }
}
