
enum PlantStatus {
  HEALTHY,
  WARNING,
  DANGER,
  CRITICAL,
  UNKNOWN; 

  
  static PlantStatus fromString(String? status) {
    switch (status?.toUpperCase()) {
      case 'HEALTHY': 
        return PlantStatus.HEALTHY;
      case 'WARNING':
        return PlantStatus.WARNING;
      case 'DANGER': 
        return PlantStatus.DANGER;
      case 'CRITICAL':
        return PlantStatus.CRITICAL;
      default:
        return PlantStatus.UNKNOWN;
    }
  }
}
