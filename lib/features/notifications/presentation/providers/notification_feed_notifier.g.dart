// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_feed_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$unreadNotificationCountHash() =>
    r'd36e5c8fd01fbae73b83cf17ae7478fd0cffd35c';

/// See also [unreadNotificationCount].
@ProviderFor(unreadNotificationCount)
final unreadNotificationCountProvider = AutoDisposeProvider<int>.internal(
  unreadNotificationCount,
  name: r'unreadNotificationCountProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$unreadNotificationCountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UnreadNotificationCountRef = AutoDisposeProviderRef<int>;
String _$notificationFeedHash() => r'7630f3e08f87e6e62ac63da9e10488ac07144417';

/// See also [NotificationFeed].
@ProviderFor(NotificationFeed)
final notificationFeedProvider =
    AutoDisposeNotifierProvider<
      NotificationFeed,
      List<NotificationFeedItem>
    >.internal(
      NotificationFeed.new,
      name: r'notificationFeedProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$notificationFeedHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$NotificationFeed = AutoDisposeNotifier<List<NotificationFeedItem>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
