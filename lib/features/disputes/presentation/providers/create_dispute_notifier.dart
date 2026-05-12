import 'package:flutter_riverpod/flutter_riverpod.dart';

class DisputeSession {
  const DisputeSession({required this.id, required this.label, required this.amt});
  final String id;
  final String label;
  final int amt;
}

const kDisputeSessions = [
  DisputeSession(id: 'd1', label: '18 Apr · GameZone Koramangala · RTX 4090', amt: 160),
  DisputeSession(id: 'd2', label: '12 Apr · GameZone MG Road · PS5',           amt: 90),
  DisputeSession(id: 'd3', label: '5 Apr · GameZone Koramangala · VR',         amt: 200),
];

sealed class CreateDisputeState { const CreateDisputeState(); }
class CreateDisputeEditing extends CreateDisputeState {
  const CreateDisputeEditing({
    this.sessionId = 'd1',
    this.pickerOpen = false,
    this.reason = '',
    this.amount = 160,
    this.notes = '',
  });
  final String sessionId;
  final bool pickerOpen;
  final String reason;
  final int amount;
  final String notes;

  DisputeSession get session =>
      kDisputeSessions.firstWhere((s) => s.id == sessionId);

  bool get valid =>
      reason.trim().length >= 20 && amount > 0 && amount <= session.amt;

  CreateDisputeEditing copyWith({
    String? sessionId,
    bool? pickerOpen,
    String? reason,
    int? amount,
    String? notes,
  }) {
    return CreateDisputeEditing(
      sessionId:  sessionId  ?? this.sessionId,
      pickerOpen: pickerOpen ?? this.pickerOpen,
      reason:     reason     ?? this.reason,
      amount:     amount     ?? this.amount,
      notes:      notes      ?? this.notes,
    );
  }
}
class CreateDisputeSubmitted extends CreateDisputeState {
  const CreateDisputeSubmitted({required this.refNum});
  final String refNum;
}

class CreateDisputeNotifier extends Notifier<CreateDisputeState> {
  @override
  CreateDisputeState build() => const CreateDisputeEditing();

  CreateDisputeEditing get _e => state as CreateDisputeEditing;

  void pickSession(String id) {
    final sess = kDisputeSessions.firstWhere((s) => s.id == id);
    state = _e.copyWith(sessionId: id, pickerOpen: false, amount: sess.amt);
  }

  void togglePicker() => state = _e.copyWith(pickerOpen: !_e.pickerOpen);
  void setReason(String v) => state = _e.copyWith(reason: v);
  void setAmount(int v) {
    final clamped = v.clamp(0, _e.session.amt);
    state = _e.copyWith(amount: clamped);
  }
  void setNotes(String v) => state = _e.copyWith(notes: v);
  void setFullAmount() => state = _e.copyWith(amount: _e.session.amt);

  void submit() {
    if (_e.valid) {
      state = const CreateDisputeSubmitted(refNum: '#DIS-0043');
    }
  }
}

final createDisputeProvider =
    NotifierProvider<CreateDisputeNotifier, CreateDisputeState>(
  () => CreateDisputeNotifier(),
);
