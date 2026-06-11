import '../../../../models/domain_admin.dart';
import '../../../../models/domain_systems.dart';

class AdminSystemsOverviewData {
  const AdminSystemsOverviewData({
    required this.systems,
    required this.systemTypes,
    required this.loadedAt,
  });

  final List<SystemModel> systems;
  final List<SystemTypeModel> systemTypes;
  final DateTime loadedAt;

  int get totalCount => systems.length;
  int get inUseCount =>
      systems.where((item) => item.status?.name == 'inUse').length;
  int get maintenanceCount =>
      systems.where((item) => item.status?.name == 'maintenance').length;
}

class AdminSystemDetailData {
  const AdminSystemDetailData({required this.system, this.liveStatus});

  final SystemModel system;
  final LiveSystemStatusModel? liveStatus;
}
