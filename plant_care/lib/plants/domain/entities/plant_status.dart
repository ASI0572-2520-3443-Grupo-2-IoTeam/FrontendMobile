class PlantStatus {
  final String name;
  const PlantStatus._(this.name);

  static const healthy = PlantStatus._('healthy');
  static const warning = PlantStatus._('warning');
  static const critical = PlantStatus._('critical');

  static PlantStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'healthy':
        return healthy;
      case 'warning':
        return warning;
      case 'critical':
        return critical;
      default:
        throw Exception('Unknown PlantStatus: $status');
    }
  }
}