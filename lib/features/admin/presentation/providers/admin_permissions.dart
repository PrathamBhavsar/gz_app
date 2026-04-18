import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'admin_auth_provider.dart';

// ============================================================
// Role-based permission flags — derived from the admin's role.
// Maps directly to the Role Permission Matrix (§8).
// Used by UI for conditional rendering (show/hide buttons, tiles).
// ============================================================

/// Holds all permission flags for the current admin session.
class AdminPermissions {
  // Operations
  final bool canStartEndSessions;
  final bool canPauseResumeSessions;
  final bool canExtendSessions;
  final bool canManualSystemOverride;

  // Bookings
  final bool canViewSchedule;
  final bool canCheckInPlayer;
  final bool canCancelBooking;

  // Analytics
  final bool canViewRevenueTotals;
  final bool canViewOccupancyStats;
  final bool canExportFinancialReports;

  // Finance
  final bool canBillingOverride;
  final bool canProcessRefunds;
  final bool canManagePricingRules;

  // Loyalty
  final bool canViewUserCredits;
  final bool canAdjustCreditBalance;
  final bool canResolveDisputes;

  // Config
  final bool canManageStaff;
  final bool canUpdateStoreConfig;
  final bool canSendGlobalNotifications;

  const AdminPermissions({
    // Operations — all roles can start/end
    this.canStartEndSessions = true,
    this.canPauseResumeSessions = false,
    this.canExtendSessions = false,
    this.canManualSystemOverride = false,
    // Bookings — all roles can view & check-in
    this.canViewSchedule = true,
    this.canCheckInPlayer = true,
    this.canCancelBooking = false,
    // Analytics
    this.canViewRevenueTotals = false,
    this.canViewOccupancyStats = true,
    this.canExportFinancialReports = false,
    // Finance
    this.canBillingOverride = false,
    this.canProcessRefunds = false,
    this.canManagePricingRules = false,
    // Loyalty
    this.canViewUserCredits = true,
    this.canAdjustCreditBalance = false,
    this.canResolveDisputes = false,
    // Config
    this.canManageStaff = false,
    this.canUpdateStoreConfig = false,
    this.canSendGlobalNotifications = false,
  });

  /// Permissions for Super Admin — everything enabled.
  static const superAdmin = AdminPermissions(
    canStartEndSessions: true,
    canPauseResumeSessions: true,
    canExtendSessions: true,
    canManualSystemOverride: true,
    canViewSchedule: true,
    canCheckInPlayer: true,
    canCancelBooking: true,
    canViewRevenueTotals: true,
    canViewOccupancyStats: true,
    canExportFinancialReports: true,
    canBillingOverride: true,
    canProcessRefunds: true,
    canManagePricingRules: true,
    canViewUserCredits: true,
    canAdjustCreditBalance: true,
    canResolveDisputes: true,
    canManageStaff: true,
    canUpdateStoreConfig: true,
    canSendGlobalNotifications: true,
  );

  /// Permissions for Admin — most things except billing override,
  /// refunds, staff management, and store config.
  static const admin = AdminPermissions(
    canStartEndSessions: true,
    canPauseResumeSessions: true,
    canExtendSessions: true,
    canManualSystemOverride: true,
    canViewSchedule: true,
    canCheckInPlayer: true,
    canCancelBooking: true,
    canViewRevenueTotals: true,
    canViewOccupancyStats: true,
    canExportFinancialReports: true,
    canBillingOverride: false,
    canProcessRefunds: false,
    canManagePricingRules: true,
    canViewUserCredits: true,
    canAdjustCreditBalance: true,
    canResolveDisputes: true,
    canManageStaff: false,
    canUpdateStoreConfig: false,
    canSendGlobalNotifications: true,
  );

  /// Permissions for Staff — view-only for most things.
  /// Can start/end sessions, check-in players, view occupancy.
  static const staff = AdminPermissions(
    canStartEndSessions: true,
    canPauseResumeSessions: false,
    canExtendSessions: false,
    canManualSystemOverride: false,
    canViewSchedule: true,
    canCheckInPlayer: true,
    canCancelBooking: false,
    canViewRevenueTotals: false,
    canViewOccupancyStats: true,
    canExportFinancialReports: false,
    canBillingOverride: false,
    canProcessRefunds: false,
    canManagePricingRules: false,
    canViewUserCredits: true,
    canAdjustCreditBalance: false,
    canResolveDisputes: false,
    canManageStaff: false,
    canUpdateStoreConfig: false,
    canSendGlobalNotifications: false,
  );
}

/// Provider that resolves the current admin's permissions based on role.
/// Falls back to most-restrictive (staff) if role is unknown.
final adminPermissionsProvider = Provider<AdminPermissions>((ref) {
  final role = ref.watch(adminRoleProvider);
  return switch (role) {
    'super_admin' => AdminPermissions.superAdmin,
    'admin' => AdminPermissions.admin,
    'staff' => AdminPermissions.staff,
    _ => AdminPermissions.staff, // Default: most restrictive
  };
});
