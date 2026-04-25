import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:klyx/models/dashboard_stats.dart';

final dashboardViewModelProvider = NotifierProvider<DashboardViewModel, DashboardStats>(() {
  return DashboardViewModel();
});

class DashboardViewModel extends Notifier<DashboardStats> {
  @override
  DashboardStats build() {
    return DashboardStats.mock();
  }

  Future<void> refresh() async {
    await Future.delayed(const Duration(seconds: 1));
    state = DashboardStats.mock();
  }
}
