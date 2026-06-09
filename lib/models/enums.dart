enum SystemStatus { available, inUse, maintenance, offline }
enum BookingStatus { pending, confirmed, checkedIn, cancelled, noShow }
enum SessionStatus { inProgress, completed, cancelled, disputed }
enum BookingType { paid, reserved, walkIn }
enum PaymentMethod { cash, card, upi, wallet, credits }
enum PaymentStatus { pending, completed, failed, refunded }
enum PricingRuleType { base, peak, offPeak, weekend, custom }
enum OverrideType { price, duration, both }
enum AuthMethod { phoneOtp, emailPassword, googleOauth, appleOauth }
enum AdminRole { superAdmin, admin, staff }
enum SystemPlatform { pc, ps5, ps4, xbox, vr, other }
enum DisputeStatus { open, underReview, resolved, withdrawn }
enum DisputeResolution { upheld, partialRefund, fullRefund, creditIssued }
enum CampaignType { percentageOff, fixedOff, bonusMinutes, bonusCredits, happyHour, firstVisit }
enum CampaignStatus { draft, scheduled, active, paused, expired, cancelled }
enum NotificationChannel { push, sms, email, inApp }
enum NotificationStatus { pending, sent, delivered, failed, read }
enum VerificationPurpose { phoneVerification, emailVerification, passwordReset, loginOtp, phoneChange }
enum CreditTransactionType { earned, redeemed, bonus, adminAdjust, expired, refund }
enum TransactionType { topUp, refund, booking, purchase }

// Safe parsing extensions
extension ParseEnums on String {
  SystemStatus? toSystemStatus() => _parseEnum(SystemStatus.values, this);
  BookingStatus? toBookingStatus() => _parseEnum(BookingStatus.values, this);
  SessionStatus? toSessionStatus() => _parseEnum(SessionStatus.values, this);
  BookingType? toBookingType() => _parseEnum(BookingType.values, this);
  PaymentMethod? toPaymentMethod() => _parseEnum(PaymentMethod.values, this);
  PaymentStatus? toPaymentStatus() {
    switch (_normalizeEnumValue(this)) {
      case 'paid':
        return PaymentStatus.completed;
      default:
        return _parseEnum(PaymentStatus.values, this);
    }
  }
  PricingRuleType? toPricingRuleType() => _parseEnum(PricingRuleType.values, this);
  OverrideType? toOverrideType() => _parseEnum(OverrideType.values, this);
  AuthMethod? toAuthMethod() => _parseEnum(AuthMethod.values, this);
  AdminRole? toAdminRole() => _parseEnum(AdminRole.values, this);
  SystemPlatform? toSystemPlatform() => _parseEnum(SystemPlatform.values, this);
  DisputeStatus? toDisputeStatus() => _parseEnum(DisputeStatus.values, this);
  DisputeResolution? toDisputeResolution() => _parseEnum(DisputeResolution.values, this);
  CampaignType? toCampaignType() => _parseEnum(CampaignType.values, this);
  CampaignStatus? toCampaignStatus() => _parseEnum(CampaignStatus.values, this);
  NotificationChannel? toNotificationChannel() => _parseEnum(NotificationChannel.values, this);
  NotificationStatus? toNotificationStatus() => _parseEnum(NotificationStatus.values, this);
  VerificationPurpose? toVerificationPurpose() => _parseEnum(VerificationPurpose.values, this);
  CreditTransactionType? toCreditTransactionType() => _parseEnum(CreditTransactionType.values, this);
  TransactionType? toTransactionType() => _parseEnum(TransactionType.values, this);
}

T? _parseEnum<T extends Enum>(List<T> values, String raw) {
  final normalized = _normalizeEnumValue(raw);
  for (final value in values) {
    if (_normalizeEnumValue(value.name) == normalized) {
      return value;
    }
  }
  return null;
}

String _normalizeEnumValue(String raw) {
  return raw.replaceAll('_', '').replaceAll('-', '').toLowerCase();
}
