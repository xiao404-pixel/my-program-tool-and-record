import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:command_runner/command_runner.dart';

  // 將 main() 函式修改成 async 非同步運作方式
void main(List<String> arguments) async {

  // 建立 CommandRunner 實例物件
  var runner = CommandRunner(); 

  // 呼叫 runner 實例內的 run() 函式
  await runner.run(arguments);

}