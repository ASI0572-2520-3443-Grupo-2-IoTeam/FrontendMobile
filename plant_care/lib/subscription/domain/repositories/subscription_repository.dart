import '../entities/plan_type.dart';
import '../entities/subscription.dart';

abstract class SubscriptionRepository {
  Future<Subscription?> getUserSubscription(String userId);
  Future<Subscription> changePlan(String userId, PlanType planType);
  Future<Subscription> cancelSubscription(String userId);
  Future<Subscription> activateSubscription(String userId);
}
