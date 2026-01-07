import 'package:flutter_bloc/flutter_bloc.dart';
import './dashboard_state.dart';
import '../../services/dashboard.dart';

class DashboardCubit extends Cubit<DashboardState>{
  final DashboardService service;

  DashboardCubit(this.service) : super(DashboardInitial());

  Future<void> loadData({bool forceReload = false})async{
    emit(DashboardLoading());
    try {
      final dashboardData = await service.getDashboardData();
      emit(DashboardLoaded(dashboardData: [dashboardData.customerCount, dashboardData.stok]));
    } catch (e) {
      emit(DashboardError(message: e.toString()));
    }
  }
} 