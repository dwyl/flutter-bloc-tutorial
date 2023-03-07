// Stopwatch wrapper that allows timer to be restarted
// Check https://github.com/dwyl/flutter-stopwatch-tutorial#persisting-between-sessions-and-extending-stopwatch-capabilities.
class StopwatchEx {
  final Stopwatch _stopWatch = Stopwatch();
  
  Duration _initialOffset;

  StopwatchEx({Duration initialOffset = Duration.zero}) : _initialOffset = initialOffset;

  start() => _stopWatch.start();

  stop() => _stopWatch.stop();

  reset({Duration? newInitialOffset}) {
    _stopWatch.reset();
    _initialOffset = newInitialOffset ?? const Duration();
  }

  bool get isRunning => _stopWatch.isRunning;

  Duration get elapsed => _stopWatch.elapsed + _initialOffset;

  int get elapsedMilliseconds => _stopWatch.elapsedMilliseconds + _initialOffset.inMilliseconds;
}
