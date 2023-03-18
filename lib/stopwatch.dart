// Stopwatch wrapper that allows timer to be restarted
// Check https://github.com/dwyl/flutter-stopwatch-tutorial#persisting-between-sessions-and-extending-stopwatch-capabilities.
class StopwatchEx {
  final Stopwatch _stopWatch = Stopwatch();

  Duration _initialOffset;

  StopwatchEx({Duration initialOffset = Duration.zero}) : _initialOffset = initialOffset;

  start() => _stopWatch.start();

  stop() => _stopWatch.stop();

  bool get isRunning => _stopWatch.isRunning;

  int get elapsedMilliseconds => _stopWatch.elapsedMilliseconds + _initialOffset.inMilliseconds;
}
