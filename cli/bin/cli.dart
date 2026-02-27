import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:command_runner/command_runner.dart';

void main(List<String> arguments) async { // main is now async and awaits the runner
  var runner = CommandRunner(); // Create an instance of your new CommandRunner
  await runner.run(arguments); // Call its run method, awaiting its Future<void>
}

void searchWikipedia(List<String>? arguments) async {
  final String? articleTitle;

  if (arguments == null || arguments.isEmpty) {
    print('Please provide a title for your article.');
    final inputFromStdin = stdin.readLineSync();
    if (inputFromStdin == null || inputFromStdin.isEmpty) {
      print('No article title provided.');
      return;
    }

    articleTitle = inputFromStdin;
  } else {
    articleTitle = arguments.join(' ');
  }

  print('Looking up articles about "$articleTitle". Please wait.');

  var content = await getWikipediaArticle(articleTitle);
  print(content);
}

void printUsage() {
  print(
    "The following commands are valid: 'help', 'version', 'search <ARTICLE-TITLE>'",
  );
}

Future<String> getWikipediaArticle(String articleTitle) async {
  final url = Uri.https(
    'en.wikipedia.org',
    '/api/rest_v1/page/summary/$articleTitle',
  );

  final response = await http.get(url);

  if (response.statusCode == 200) {
    return response.body;
  } else {
    return 'Error: Failed to fetch article "$articleTitle". Status code: ${response.statusCode}';
  }
}
