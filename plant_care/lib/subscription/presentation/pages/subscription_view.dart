import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:plant_care/shared/presentation/theme/theme.dart';
import 'package:plant_care/subscription/infrastructure/repositories/subscription_repository_impl.dart';
import 'package:plant_care/subscription/domain/entities/plan_type.dart';
import 'package:plant_care/subscription/domain/entities/subscription.dart';
import 'package:provider/provider.dart';
import 'package:plant_care/iam/presentation/providers/auth_provider.dart';

class SubscriptionView extends StatefulWidget {
  const SubscriptionView({super.key});

  @override
  State<SubscriptionView> createState() => _SubscriptionViewState();
}

class _SubscriptionViewState extends State<SubscriptionView> {
  Subscription? currentSub;
  bool loading = true;
  bool processing = false;

  late final SubscriptionRepositoryImpl repo;

  @override
  void initState() {
    super.initState();
    repo = SubscriptionRepositoryImpl(
        baseUrl: "https://plantcare-awcchhb2bfg3hxgf.canadacentral-01.azurewebsites.net/api/v1"
    );
    _loadSubscription();
  }

  String _formatDate(DateTime? date) {
    if (date == null) return "-";
    final local = date.toLocal();
    final months = [
      "Jan", "Feb", "Mar", "Apr", "May", "Jun",
      "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ];
    final monthName = months[local.month - 1];
    return "${local.day} $monthName ${local.year}";
  }

  Future<void> _loadSubscription() async {
    final userId = context.read<AuthProvider>().currentUser?.id;
    if (userId == null) return;

    setState(() => loading = true);
    try {
      final sub = await repo.getUserSubscription(userId);
      setState(() {
        currentSub = sub;
        loading = false;
      });
    } catch (e) {
      debugPrint("Error loading subscription: $e");
      setState(() => loading = false);
    }
  }

  Future<void> _simulatePayment(PlanType planType) async {
    setState(() => processing = true);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text("Processing payment..."),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            SizedBox(height: 16),
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text("Please wait a moment."),
          ],
        ),
      ),
    );

    await Future.delayed(const Duration(seconds: 2));

    if (context.mounted) Navigator.of(context, rootNavigator: true).pop();

    setState(() => processing = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('✅ Payment successfully simulated for ${planType.name}')),
    );
  }

  Future<void> _changePlan(PlanType planType) async {
    final userId = context.read<AuthProvider>().currentUser?.id;
    if (userId == null) return;

    try {
      await _simulatePayment(planType);
      final updated = await repo.changePlan(userId, planType);
      setState(() => currentSub = updated);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('✅ Subscription changed to ${planType.name}')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('❌ Error: $e')));
    }
  }

  Future<void> _cancelSubscription() async {
    final userId = context.read<AuthProvider>().currentUser?.id;
    if (userId == null) return;

    try {
      final cancelled = await repo.cancelSubscription(userId);
      setState(() => currentSub = cancelled);

      final endDate = cancelled.endDate != null
          ? _formatDate(cancelled.endDate)
          : "the current date";

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('⚠️ You’ll keep benefits until $endDate')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('❌ Error: $e')));
    }
  }

  Future<void> _activateSubscription() async {
    final userId = context.read<AuthProvider>().currentUser?.id;
    if (userId == null) return;

    try {
      await _simulatePayment(currentSub?.planType ?? PlanType.BASIC);
      final reactivated = await repo.activateSubscription(userId);
      setState(() => currentSub = reactivated);

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('✅ Subscription reactivated')));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('❌ Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final rawPlan = currentSub?.planType.name ?? "NONE";
    final currentPlan = rawPlan == "NONE" ? "Free Plan" : rawPlan;
    final isActive = currentSub?.status == "ACTIVE";
    final isCancelled = currentSub?.status == "CANCELLED";

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("My Subscription"),
        centerTitle: true,
        backgroundColor: AppTheme.primaryGreen,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.go('/settings'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: ListTile(
                leading: const Icon(Icons.card_membership, color: AppTheme.primaryGreen),
                title: Text("Current Plan: $currentPlan"),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isActive ? "Status: Active" : "Status: Inactive",
                      style: TextStyle(
                        color: isActive ? Colors.green : Colors.redAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (isCancelled && currentSub?.endDate != null)
                      Text(
                        "You’ll keep benefits until ${_formatDate(currentSub!.endDate)}",
                        style: const TextStyle(color: Colors.orange),
                      )
                    else if (isActive) ...[
                      if (currentSub?.startDate != null)
                        Text("Start date: ${_formatDate(currentSub!.startDate)}"),
                      if (currentSub?.nextBillingDate != null)
                        Text("Next billing: ${_formatDate(currentSub!.nextBillingDate)}"),
                      if (currentSub?.endDate != null)
                        Text("End date: ${_formatDate(currentSub!.endDate)}"),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Available plans
            ...[
              {"name": "BASIC", "price": "S/25.00", "type": PlanType.BASIC},
              {"name": "PREMIUM", "price": "S/50.00", "type": PlanType.PREMIUM},
            ].map((plan) => Card(
              child: ListTile(
                title: Text(plan["name"]?.toString() ?? ''),
                subtitle: Text("Price: ${plan["price"]}"),
                trailing: ElevatedButton(
                  onPressed: processing
                      ? null
                      : () => _changePlan(plan["type"] as PlanType),
                  child: const Text("Subscribe"),
                ),
              ),
            )),

            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: isActive && !processing ? _cancelSubscription : null,
              icon: const Icon(Icons.cancel),
              label: const Text("Cancel subscription"),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.criticalColor,
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: !isActive && !processing ? _activateSubscription : null,
              icon: const Icon(Icons.replay),
              label: const Text("Reactivate subscription"),
            ),
          ],
        ),
      ),
    );
  }
}