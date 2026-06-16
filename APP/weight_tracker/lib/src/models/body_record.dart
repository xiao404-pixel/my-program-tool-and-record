class BodyRecord {
  final DateTime date;
  final double heightCm;
  final double weightKg;
  final double bmi;

  BodyRecord({
    required this.date,
    required this.heightCm,
    required this.weightKg,
  }) : bmi = _calculateBmiValue(heightCm, weightKg);

  // 從 JSON 還原物件的 Named Constructor
  factory BodyRecord.fromJson(Map<String, dynamic> json) {
    return BodyRecord(
      date: DateTime.parse(json['date'] as String),
      heightCm: (json['heightCm'] as num).toDouble(),
      weightKg: (json['weightKg'] as num).toDouble(),
    );
  }

  static double _calculateBmiValue(double heightCm, double weightKg) {
    double heightM = heightCm / 100;
    return weightKg / (heightM * heightM);
  }

  String getBmiStatus() {
    if (bmi < 18.5) return '過輕';
    if (bmi < 24) return '正常';
    if (bmi < 27) return '過重';
    return '肥胖';
  }

  @override
  String toString() {
    return '日期: ${date.toString().substring(0, 10)} | '
           '身高: ${heightCm}cm | 體重: ${weightKg}kg | '
           'BMI: ${bmi.toStringAsFixed(1)} ($getBmiStatus)'; // 注意：這裡簡化顏色，顏色可另建 utils
  }
  
  // 轉換為 JSON，供 StorageService 使用
  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String(),
    'heightCm': heightCm,
    'weightKg': weightKg,
    'bmi': bmi,
  };
}