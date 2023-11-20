import '../env.dart';
import 'package:logger/logger.dart';

class CustomizedLogger extends Logger {
  final String printTag;
  CustomizedLogger({
    this.printTag = '',
    bool color = true,
    bool printTime = true,
    bool noBoxingByDefault = false,
  }) : super(
          printer: PrefixPrinter(
            PrettyPrinter(
              colors: color,
              printEmojis: false,
              printTime: printTime,
              noBoxingByDefault: noBoxingByDefault,
              stackTraceLevel: Level.error,
              printTag: printTag,
              lineLength: 50,
            ),
          ),
          output: _ConsoleOutput(),
        );
}

class _ConsoleOutput extends LogOutput {
  @override
  void output(OutputEvent event) {
    event.lines.forEach(logIt);
  }
}
