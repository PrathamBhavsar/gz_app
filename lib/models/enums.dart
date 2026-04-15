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
  SystemStatus? toSystemStatus() => SystemStatus.values.cast<SystemStatus?>().firstWhere((e) => e.toString().split('.').last == this, orElse: () => null);
  BookingStatus? toBookingStatus() => BookingStatus.values.cast<BookingStatus?>().firstWhere((e) => e.toString().split('.').last == this, orElse: () => null);
  SessionStatus? toSessionStatus() => SessionStatus.values.cast<SessionStatus?>().firstWhere((e) => e.toString().split('.').last == this, orElse: () => null);
  BookingType? toBookingType() => BookingType.values.cast<BookingType?>().firstWhere((e) => e.toString().split('.').last == this, orElse: () => null);
  PaymentMethod? toPaymentMethod() => PaymentMethod.values.cast<PaymentMethod?>().firstWhere((e) => e.toString().split('.').last == this, orElse: () => null);
  PaymentStatus? toPaymentStatus() => PaymentStatus.values.cast<PaymentStatus?>().firstWhere((e) => e.toString().split('.').last == this, orElse: () => null);
  PricingRuleType? toPricingRuleType() => PricingRuleType.values.cast<PricingRuleType?>().firstWhere((e) => e.toString().split('.').last == this, orElse: () => null);
  OverrideType? toOverrideType() => OverrideType.values.cast<OverrideType?>().firstWhere((e) => e.toString().split('.').last == this, orElse: () => null);
  AuthMethod? toAuthMethod() => AuthMethod.values.cast<AuthMethod?>().firstWhere((e) => e.toString().split('.').last == this, orElse: () => null);
  AdminRole? toAdminRole() => AdminRole.values.cast<AdminRole?>().firstWhere((e) => e.toString().split('.').last == this, orElse: () => null);
  SystemPlatform? toSystemPlatform() => SystemPlatform.values.cast<SystemPlatform?>().firstWhere((e) => e.toString().split('.').last == this, orElse: () => null);
  DisputeStatus? toDisputeStatus() => DisputeStatus.values.cast<DisputeStatus?>().firstWhere((e) => e.toString().split('.').last == this, orElse: () => null);
  DisputeResolution? toDisputeResolution() => DisputeResolution.values.cast<DisputeResolution?>().firstWhere((e) => e.toString().split('.').last == this, orElse: () => null);
  CampaignType? toCampaignType() => CampaignType.values.cast<CampaignType?>().firstWhere((e) => e.toString().split('.').last == this, orElse: () => null);
  CampaignStatus? toCampaignStatus() => CampaignStatus.values.cast<CampaignStatus?>().firstWhere((e) => e.toString().split('.').last == this, orElse: () => null);
  NotificationChannel? toNotificationChannel() => NotificationChannel.values.cast<NotificationChannel?>().firstWhere((e) => e.toString().split('.').last == this, orElse: () => null);
  NotificationStatus? toNotificationStatus() => NotificationStatus.values.cast<NotificationStatus?>().firstWhere((e) => e.toString().split('.').last == this, orElse: () => null);
  VerificationPurpose? toVerificationPurpose() => VerificationPurpose.values.cast<VerificationPurpose?>().firstWhere((e) => e.toString().split('.').last == this, orElse: () => null);
  CreditTransactionType? toCreditTransactionType() => CreditTransactionType.values.cast<CreditTransactionType?>().firstWhere((e) => e.toString().split('.').last == this, orElse: () => null);
  TransactionType? toTransactionType() => TransactionType.values.cast<TransactionType?>().firstWhere((e) => e.toString().split('.').last == this, orElse: () => null);
}
