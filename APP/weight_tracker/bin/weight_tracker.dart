import 'dart:io';
import 'package:weight_tracker/weight_tracker.dart';

class WeightTrackerApp {
  final StorageService _storageService;
  List<BodyRecord> _records = [];

  WeightTrackerApp(this._storageService);

  Future<void> initialize() async {
    print('🔄 正在載入歷史資料...');
    _records = await _storageService.loadRecords();
    if (_records.isNotEmpty) {
      print('✅ 成功載入 ${_records.length} 筆歷史紀錄。\n');
    } else {
      print('ℹ️ 尚未找到紀錄檔案，將從空白開始。\n');
    }
  }

  Future<void> runBmiCommand() async {
    print('=== BMI 計算與紀錄 ===');
    try {
      double height = await _promptForDouble('請輸入身高 (公分, 例如 170): ');
      double weight = await _promptForDouble('請輸入體重 (公斤, 例如 65): ');

      final newRecord = BodyRecord(
        date: DateTime.now(),
        heightCm: height,
        weightKg: weight,
      );

      _records.add(newRecord);
      await _storageService.saveRecords(_records); 
      
      print('\n✅ 計算並儲存成功！');
      print(newRecord.toString());
      
    } on FormatException {
      print('\n❌ 輸入錯誤: 請輸入有效的數字。');
    } catch (e) {
      print('\n❌ 發生未知錯誤: $e');
    }
  }

  void runHistoryCommand() {
    print('\n=== 身體數值追蹤紀錄 ===');
    if (_records.isEmpty) {
      print('目前尚無紀錄，請先使用 bmi 指令進行計算。');
      return;
    }

    for (int i = 0; i < _records.length; i++) {
      print('${i + 1}. ${_records[i].toString()}');
    }
  }

  Future<double> _promptForDouble(String prompt) async {
    stdout.write(prompt);
    String? input = stdin.readLineSync();
    if (input == null || input.trim().isEmpty) {
      throw FormatException('輸入不能為空');
    }
    return double.parse(input.trim());
  }
}

void main(List<String> arguments) async {
  final storage = StorageService(filePath: 'records.json');
  final app = WeightTrackerApp(storage);

  print('========================================');
  print('       歡迎使用 Dart 減重輔助程式       ');
  print('========================================');
  
  await app.initialize();
  
  print('可用指令: bmi, history, exit');
  print('========================================\n');

  while (true) {
    stdout.write('請輸入指令 > ');
    String? command = stdin.readLineSync()?.trim().toLowerCase();

    if (command == 'exit' || command == 'quit') {
      print('感謝使用，祝您減重順利！');
      break;
    } else if (command == 'bmi') {
      await app.runBmiCommand();
    } else if (command == 'history') {
      app.runHistoryCommand();
    } else {
      print('未知的指令，請重新輸入。');
    }
    print(''); 
  }
}