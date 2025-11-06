import 'package:plant_care/subscription/domain/entities/plan_type.dart';

class Subscription {
  final String id;
  final String userId;
  final PlanType planType;
  final String status; // ACTIVE / CANCELLED
  final DateTime? startDate;
  final DateTime? endDate;
  final DateTime? nextBillingDate;

  Subscription({
    required this.id,
    required this.userId,
    required this.planType,
    required this.status,
    this.startDate,
    this.endDate,
    this.nextBillingDate,
  });
}
