import '../../../../models/domain_admin.dart';

sealed class AdminAuthState {
  const AdminAuthState();
}

class AdminAuthInitial extends AdminAuthState {
  const AdminAuthInitial();
}

class AdminAuthLoading extends AdminAuthState {
  const AdminAuthLoading();
}

class AdminAuthAuthenticated extends AdminAuthState {
  final AdminAuthModel admin;
  const AdminAuthAuthenticated(this.admin);
}

class AdminAuthUnauthenticated extends AdminAuthState {
  const AdminAuthUnauthenticated();
}

class AdminAuthError extends AdminAuthState {
  final Object error;
  const AdminAuthError(this.error);
}
