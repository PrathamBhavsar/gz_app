import '../../../../core/errors/app_exception.dart';

sealed class AdminCommandState {
  const AdminCommandState();
}

class AdminCommandInitial extends AdminCommandState {
  const AdminCommandInitial();
}

class AdminCommandLoading extends AdminCommandState {
  const AdminCommandLoading();
}

class AdminCommandSuccess extends AdminCommandState {
  const AdminCommandSuccess(this.message);

  final String message;
}

class AdminCommandError extends AdminCommandState {
  const AdminCommandError(this.message);

  final String message;
}

String adminCommandMessage(Object error) => AppPageError.from(error).message;
