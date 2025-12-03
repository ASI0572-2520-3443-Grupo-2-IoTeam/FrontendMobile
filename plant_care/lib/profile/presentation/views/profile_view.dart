import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:plant_care/iam/presentation/providers/auth_provider.dart';
import '../providers/profile_provider.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  ProfileProvider? _provider;
  bool _loading = true;
  String? _error;
  bool _saving = false;

  final _fullNameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _bioCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initProfile());
  }

  @override
  void dispose() {
    _fullNameCtrl.dispose();
    _phoneCtrl.dispose();
    _bioCtrl.dispose();
    _locationCtrl.dispose();
    super.dispose();
  }

  Future<void> _initProfile() async {
    final token = context.read<AuthProvider>().token;
    if (token == null) {
      setState(() {
        _error = 'No auth token found';
        _loading = false;
      });
      return;
    }

    final provider = ProfileProvider.create(); // uses default base URL
    setState(() {
      _provider = provider;
      _loading = true;
      _error = null;
    });

    try {
      await provider.loadAll(token: token);
      setState(() {
        _loading = false;
        _error = provider.error;
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _error = e.toString();
      });
    }
  }

  Future<void> _saveEdits() async {
    final token = context.read<AuthProvider>().token;
    if (token == null || _provider == null) return;

    setState(() => _saving = true);
    await _provider!.updateProfile(
      token: token,
      data: {
        'fullName': _fullNameCtrl.text,
        'phone': _phoneCtrl.text,
        'bio': _bioCtrl.text,
        'location': _locationCtrl.text,
      },
    );
    setState(() => _saving = false);
    if (mounted) Navigator.of(context).pop();
  }

  void _openEdit() {
    final profile = _provider?.profile;
    _fullNameCtrl.text = profile?.fullName ?? '';
    _phoneCtrl.text = profile?.phone ?? '';
    _bioCtrl.text = profile?.bio ?? '';
    _locationCtrl.text = profile?.location ?? '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Edit profile', style: Theme.of(context).textTheme.titleLarge),
            TextField(
              controller: _fullNameCtrl,
              decoration: const InputDecoration(labelText: 'Full name'),
            ),
            TextField(
              controller: _phoneCtrl,
              decoration: const InputDecoration(labelText: 'Phone'),
            ),
            TextField(
              controller: _bioCtrl,
              decoration: const InputDecoration(labelText: 'Bio'),
              maxLines: 3,
            ),
            TextField(
              controller: _locationCtrl,
              decoration: const InputDecoration(labelText: 'Location'),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saving ? null : _saveEdits,
                child: _saving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Save changes'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/settings'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loading ? null : _initProfile,
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? _ErrorState(error: _error!, onRetry: _initProfile)
              : _provider == null
                  ? const Center(child: Text('No profile data'))
                  : ChangeNotifierProvider.value(
                      value: _provider!,
                      child: Consumer<ProfileProvider>(
                        builder: (context, provider, _) {
                          final profile = provider.profile;
                          final stats = provider.stats;
                          final achievements = provider.achievements;
                          return RefreshIndicator(
                            onRefresh: _initProfile,
                            child: ListView(
                              padding: const EdgeInsets.all(16),
                              children: [
                                _HeaderSection(profile?.avatarUrl, profile?.fullName ?? profile?.username ?? 'User', profile?.email ?? ''),
                                const SizedBox(height: 12),
                                _InfoTile(label: 'Username', value: profile?.username ?? ''),
                                _InfoTile(label: 'Full name', value: profile?.fullName ?? '—'),
                                _InfoTile(label: 'Phone', value: profile?.phone ?? '—'),
                                _InfoTile(label: 'Bio', value: profile?.bio ?? '—'),
                                _InfoTile(label: 'Location', value: profile?.location ?? '—'),
                                _InfoTile(label: 'Join date', value: profile?.joinDate?.toIso8601String() ?? '—'),
                                _InfoTile(label: 'Last login', value: profile?.lastLogin?.toIso8601String() ?? '—'),
                                const SizedBox(height: 16),
                                if (stats != null) _StatsSection(stats),
                                const SizedBox(height: 16),
                                _AchievementsSection(achievements),
                                const SizedBox(height: 24),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed: _openEdit,
                                    icon: const Icon(Icons.edit),
                                    label: const Text('Edit profile'),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  const _HeaderSection(this.avatarUrl, this.title, this.email);

  final String? avatarUrl;
  final String title;
  final String email;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 32,
          backgroundImage: avatarUrl != null && avatarUrl!.isNotEmpty ? NetworkImage(avatarUrl!) : null,
          child: avatarUrl == null || avatarUrl!.isEmpty ? const Icon(Icons.person, size: 32) : null,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              Text(email, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatsSection extends StatelessWidget {
  const _StatsSection(this.stats);
  final dynamic stats;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Stats', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _StatChip(label: 'Plants', value: stats.totalPlants.toString()),
                _StatChip(label: 'Waterings', value: stats.wateringSessions.toString()),
                _StatChip(label: 'Success', value: '${stats.successRate}%'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: Theme.of(context).textTheme.titleMedium),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

class _AchievementsSection extends StatelessWidget {
  const _AchievementsSection(this.achievements);
  final List achievements;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Achievements', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            if (achievements.isEmpty)
              const Text('No achievements yet')
            else
              ...achievements.map((a) {
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Text(a.icon, style: const TextStyle(fontSize: 24)),
                  title: Text(a.title),
                  subtitle: Text(a.description),
                  trailing: Text(a.status),
                );
              }),
          ],
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      title: Text(label),
      subtitle: Text(value.isEmpty ? '—' : value),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.error, required this.onRetry});
  final String error;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(error, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
