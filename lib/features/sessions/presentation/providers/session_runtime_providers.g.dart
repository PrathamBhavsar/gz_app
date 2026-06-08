// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_runtime_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$sessionsHubHash() => r'bd32ffc84e1682452dbc671a86eea5cec576c6ad';

/// See also [SessionsHub].
@ProviderFor(SessionsHub)
final sessionsHubProvider =
    NotifierProvider<SessionsHub, SessionsHubState>.internal(
      SessionsHub.new,
      name: r'sessionsHubProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$sessionsHubHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SessionsHub = Notifier<SessionsHubState>;
String _$bookingDetailStateNotifierHash() =>
    r'9414ba45535bc0a531e83db67cf7f3d5b38f00e0';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$BookingDetailStateNotifier
    extends BuildlessNotifier<BookingDetailState> {
  late final String id;

  BookingDetailState build(String id);
}

/// See also [BookingDetailStateNotifier].
@ProviderFor(BookingDetailStateNotifier)
const bookingDetailStateNotifierProvider = BookingDetailStateNotifierFamily();

/// See also [BookingDetailStateNotifier].
class BookingDetailStateNotifierFamily extends Family<BookingDetailState> {
  /// See also [BookingDetailStateNotifier].
  const BookingDetailStateNotifierFamily();

  /// See also [BookingDetailStateNotifier].
  BookingDetailStateNotifierProvider call(String id) {
    return BookingDetailStateNotifierProvider(id);
  }

  @override
  BookingDetailStateNotifierProvider getProviderOverride(
    covariant BookingDetailStateNotifierProvider provider,
  ) {
    return call(provider.id);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'bookingDetailStateNotifierProvider';
}

/// See also [BookingDetailStateNotifier].
class BookingDetailStateNotifierProvider
    extends
        NotifierProviderImpl<BookingDetailStateNotifier, BookingDetailState> {
  /// See also [BookingDetailStateNotifier].
  BookingDetailStateNotifierProvider(String id)
    : this._internal(
        () => BookingDetailStateNotifier()..id = id,
        from: bookingDetailStateNotifierProvider,
        name: r'bookingDetailStateNotifierProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$bookingDetailStateNotifierHash,
        dependencies: BookingDetailStateNotifierFamily._dependencies,
        allTransitiveDependencies:
            BookingDetailStateNotifierFamily._allTransitiveDependencies,
        id: id,
      );

  BookingDetailStateNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final String id;

  @override
  BookingDetailState runNotifierBuild(
    covariant BookingDetailStateNotifier notifier,
  ) {
    return notifier.build(id);
  }

  @override
  Override overrideWith(BookingDetailStateNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: BookingDetailStateNotifierProvider._internal(
        () => create()..id = id,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  NotifierProviderElement<BookingDetailStateNotifier, BookingDetailState>
  createElement() {
    return _BookingDetailStateNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is BookingDetailStateNotifierProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin BookingDetailStateNotifierRef on NotifierProviderRef<BookingDetailState> {
  /// The parameter `id` of this provider.
  String get id;
}

class _BookingDetailStateNotifierProviderElement
    extends
        NotifierProviderElement<BookingDetailStateNotifier, BookingDetailState>
    with BookingDetailStateNotifierRef {
  _BookingDetailStateNotifierProviderElement(super.provider);

  @override
  String get id => (origin as BookingDetailStateNotifierProvider).id;
}

String _$activeSessionDetailStateNotifierHash() =>
    r'0dd3eae4b6a96b6f7b338dbe87fe077afb0a3380';

abstract class _$ActiveSessionDetailStateNotifier
    extends BuildlessNotifier<ActiveSessionDetailState> {
  late final String id;

  ActiveSessionDetailState build(String id);
}

/// See also [ActiveSessionDetailStateNotifier].
@ProviderFor(ActiveSessionDetailStateNotifier)
const activeSessionDetailStateNotifierProvider =
    ActiveSessionDetailStateNotifierFamily();

/// See also [ActiveSessionDetailStateNotifier].
class ActiveSessionDetailStateNotifierFamily
    extends Family<ActiveSessionDetailState> {
  /// See also [ActiveSessionDetailStateNotifier].
  const ActiveSessionDetailStateNotifierFamily();

  /// See also [ActiveSessionDetailStateNotifier].
  ActiveSessionDetailStateNotifierProvider call(String id) {
    return ActiveSessionDetailStateNotifierProvider(id);
  }

  @override
  ActiveSessionDetailStateNotifierProvider getProviderOverride(
    covariant ActiveSessionDetailStateNotifierProvider provider,
  ) {
    return call(provider.id);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'activeSessionDetailStateNotifierProvider';
}

/// See also [ActiveSessionDetailStateNotifier].
class ActiveSessionDetailStateNotifierProvider
    extends
        NotifierProviderImpl<
          ActiveSessionDetailStateNotifier,
          ActiveSessionDetailState
        > {
  /// See also [ActiveSessionDetailStateNotifier].
  ActiveSessionDetailStateNotifierProvider(String id)
    : this._internal(
        () => ActiveSessionDetailStateNotifier()..id = id,
        from: activeSessionDetailStateNotifierProvider,
        name: r'activeSessionDetailStateNotifierProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$activeSessionDetailStateNotifierHash,
        dependencies: ActiveSessionDetailStateNotifierFamily._dependencies,
        allTransitiveDependencies:
            ActiveSessionDetailStateNotifierFamily._allTransitiveDependencies,
        id: id,
      );

  ActiveSessionDetailStateNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final String id;

  @override
  ActiveSessionDetailState runNotifierBuild(
    covariant ActiveSessionDetailStateNotifier notifier,
  ) {
    return notifier.build(id);
  }

  @override
  Override overrideWith(ActiveSessionDetailStateNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: ActiveSessionDetailStateNotifierProvider._internal(
        () => create()..id = id,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  NotifierProviderElement<
    ActiveSessionDetailStateNotifier,
    ActiveSessionDetailState
  >
  createElement() {
    return _ActiveSessionDetailStateNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ActiveSessionDetailStateNotifierProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ActiveSessionDetailStateNotifierRef
    on NotifierProviderRef<ActiveSessionDetailState> {
  /// The parameter `id` of this provider.
  String get id;
}

class _ActiveSessionDetailStateNotifierProviderElement
    extends
        NotifierProviderElement<
          ActiveSessionDetailStateNotifier,
          ActiveSessionDetailState
        >
    with ActiveSessionDetailStateNotifierRef {
  _ActiveSessionDetailStateNotifierProviderElement(super.provider);

  @override
  String get id => (origin as ActiveSessionDetailStateNotifierProvider).id;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
