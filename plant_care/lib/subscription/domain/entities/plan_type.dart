enum PlanType {
  NONE,
  BASIC,
  PREMIUM;

  static PlanType fromString(String value) {
    switch (value.toUpperCase()) {
      case 'BASIC':
        return PlanType.BASIC;
      case 'PREMIUM':
        return PlanType.PREMIUM;
      default:
        return PlanType.NONE;
    }
  }
}