import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:klyx/models/dashboard_stats.dart';
import 'package:klyx/features/auth/auth_provider.dart';

final dashboardViewModelProvider = NotifierProvider<DashboardViewModel, DashboardStats>(() {
  return DashboardViewModel();
});

class DashboardViewModel extends Notifier<DashboardStats> {
  @override
  DashboardStats build() {
    final authState = ref.watch(authNotifierProvider);
    final profile = authState.value;

    // If user skipped login (empty profile) or no profile, show empty stats
    if (profile == null || profile.isEmpty) {
      return DashboardStats.empty();
    }

    // If user has connected platforms, show mock for now (real API later)
    return DashboardStats.mock();
  }

  Future<void> refresh() async {
    await Future.delayed(const Duration(seconds: 1));
    final authState = ref.read(authNotifierProvider);
    final profile = authState.value;
    if (profile == null || profile.isEmpty) {
      state = DashboardStats.empty();
    } else {
      state = DashboardStats.mock();
    }
  }
}
