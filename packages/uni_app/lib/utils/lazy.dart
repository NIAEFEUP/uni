class Lazy<T> {
  Lazy(this._builder);

  final T Function() _builder;

  bool _isInitialized = false;
  late T _value;

  T get value {
    if (!_isInitialized) {
      _isInitialized = true;
      _value = _builder();
    }

    return _value;
  }
}
