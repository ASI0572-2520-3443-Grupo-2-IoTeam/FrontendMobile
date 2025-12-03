enum ReportType {
  daily,
  weekly,
  monthly,
  custom;

  String get displayName {
    switch (this) {
      case ReportType.daily:
        return 'Daily';
      case ReportType.weekly:
        return 'Weekly';
      case ReportType.monthly:
        return 'Monthly';
      case ReportType.custom:
        return 'Custom';
    }
  }

  static ReportType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'daily':
        return ReportType.daily;
      case 'weekly':
        return ReportType.weekly;
      case 'monthly':
        return ReportType.monthly;
      case 'custom':
        return ReportType.custom;
      default:
        return ReportType.daily;
    }
  }
}
