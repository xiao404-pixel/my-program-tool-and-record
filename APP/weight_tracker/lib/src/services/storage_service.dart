import 'dart:io';
import 'dart:convert';
import '../models/body_record.dart';

class StorageService {
  final File _storageFile;

  // 建構子允許傳入檔案路徑，預設為專案根目錄的 records.json
  StorageService({String filePath = 'records.json'}) 
      : _storageFile = File(filePath);

  /// 非同步載入歷史紀錄
  Future<List<BodyRecord>> loadRecords() async {
    try {
      if (await _storageFile.exists()) {
        final jsonString = await _storageFile.readAsString();
        final List<dynamic> jsonList = jsonDecode(jsonString);
        return jsonList.map((json) => BodyRecord.fromJson(json)).toList();
      }
      return []; // 如果檔案不存在，回傳空列表
    } catch (e) {
      print('⚠️ 讀取紀錄檔案時發生錯誤: $e');
      return [];
    }
  }

  /// 非同步儲存紀錄到檔案
  Future<void> saveRecords(List<BodyRecord> records) async {
    try {
      // 將 List<BodyRecord> 轉為 List<Map>，再編碼為 JSON 字串
      final jsonList = records.map((record) => record.toJson()).toList();
      // withIndent 讓生成的 JSON 檔案具有漂亮的縮排，方便人類閱讀
      final jsonString = const JsonEncoder.withIndent('  ').convert(jsonList);
      
      await _storageFile.writeAsString(jsonString);
    } catch (e) {
      print('❌ 儲存紀錄失敗: $e');
      rethrow; // 將錯誤向上拋出，讓呼叫者知道儲存失敗
    }
  }
}