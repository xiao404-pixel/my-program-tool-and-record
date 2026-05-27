import 'dart:io';
const version = '0.0.1';

void main(List<String> arguments) {

  if (arguments.isEmpty || arguments.first == 'help') {
    printUsage(); // 呼叫 printUsage() 函式程式

  } else if (arguments.first == 'version') {
    print('Dartpedia CLI version $version');

  } else if (arguments.first == 'search') {
    final inputArgs = arguments.length > 1 ? arguments.sublist(1) : null;
    searchWikipedia(inputArgs);

  } else {
    printUsage();
  }
}

void searchWikipedia(List<String>? arguments) { 
  final String articleTitle;

  if (arguments == null || arguments.isEmpty) {
    print('Please provide an article title.');

    articleTitle = stdin.readLineSync() ?? '';

  } else {
    articleTitle = arguments.join(' ');
  }

  print('Looking up articles about "$articleTitle". Please wait.');
  print('Here you go!');

  print('Current article title: $articleTitle');
}

void printUsage() { // Add this new function
  print(
    "The following commands are valid: 'help', 'version', 'search <ARTICLE-TITLE>'"
  );
}