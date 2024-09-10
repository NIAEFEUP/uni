import 'dart:async';

class Derived<I, O> {
  Derived(this._input, this.compute, {Stream<I>? inputStream})
      : _output = compute(_input) {
    if (inputStream != null) {
      inputStream.listen((value) => input = value);
    }
  }

  final StreamController<O> _controller =
      StreamController.broadcast(sync: true);
  Stream<O> get stream => _controller.stream;

  final O Function(I) compute;
  I _input;
  O _output;

  I get input => _input;
  set input(I newValue) {
    if (newValue != _input) {
      _input = newValue;
      _output = compute(_input);
      _controller.add(_output);
    }
  }

  O get output => _output;

  Derived<O, N> and<N>(N Function(O) newCompute) =>
      Derived(_output, newCompute, inputStream: stream);
}
