import 'package:flutter_riverpod/flutter_riverpod.dart';

class Observer extends ProviderObserver {
  @override
  void didAddProvider(ProviderBase<Object?> provider, Object? value,
      ProviderContainer container) {
    print(
        'Provider $provider was initialized with $value and added to the container $container');
    // TODO: implement didAddProvider
    super.didAddProvider(provider, value, container);
  }

  @override
  void didDisposeProvider(
      ProviderBase<Object?> provider, ProviderContainer container) {
    print('Provider $provider was disposed from the container $container');
    // TODO: implement didDisposeProvider
    super.didDisposeProvider(provider, container);
  }

  @override
  void didUpdateProvider(ProviderBase<Object?> provider, Object? previousValue,
      Object? newValue, ProviderContainer container) {
    print(
        'Provider $provider updated from $previousValue to $newValue in the container $container');
    // TODO: implement didUpdateProvider
    super.didUpdateProvider(provider, previousValue, newValue, container);
  }

  @override
  void providerDidFail(ProviderBase<Object?> provider, Object error,
      StackTrace stackTrace, ProviderContainer container) {
    print(
        'Provider $provider threw $error at $stackTrace in the container $container');
    // TODO: implement providerDidFail
    super.providerDidFail(provider, error, stackTrace, container);
  }
}
