// lib/screens/chart_screen.dart

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../models/bmi_record.dart';
import '../services/storage_service.dart';
import '../theme.dart';

class ChartScreen extends StatefulWidget {
  const ChartScreen({super.key});

  @override
  State<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  final _storage = StorageService();
  List<BmiRecord> _records = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final records = await _storage.loadRecords();
    records.sort((a, b) => a.date.compareTo(b.date));
    setState(() {
      _records = records;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          if (_records.length >= 2) ...[
            _buildBmiChart(),
            const SizedBox(height: 16),
            _buildWeightChart(),
            const SizedBox(height: 16),
          ],
          _buildStats(),
          const SizedBox(height: 16),
          if (_records.length < 2)
            _buildNoDataMsg(),
        ],
      ),
    );
  }

  Widget _buildNoDataMsg() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(Icons.show_chart,
                size: 56, color: AppTheme.textSecondary.withOpacity(0.4)),
            const SizedBox(height: 12),
            const Text(
              '需要至少 2 筆記錄才能顯示趨勢圖',
              style: TextStyle(color: AppTheme.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBmiChart() {
    final spots = _records.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), e.value.bmi);
    }).toList();

    final minBmi =
        _records.map((r) => r.bmi).reduce((a, b) => a < b ? a : b) - 2;
    final maxBmi =
        _records.map((r) => r.bmi).reduce((a, b) => a > b ? a : b) + 2;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'BMI 趨勢',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 3,
                    getDrawingHorizontalLine: (_) => const FlLine(
                      color: AppTheme.divider,
                      strokeWidth: 1,
                    ),
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 36,
                        getTitlesWidget: (v, _) => Text(
                          v.toStringAsFixed(0),
                          style: const TextStyle(
                              color: AppTheme.textSecondary, fontSize: 11),
                        ),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval: (_records.length / 4).ceilToDouble(),
                        getTitlesWidget: (v, _) {
                          final idx = v.toInt();
                          if (idx < 0 || idx >= _records.length) {
                            return const SizedBox.shrink();
                          }
                          return Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              DateFormat('M/d').format(_records[idx].date),
                              style: const TextStyle(
                                  color: AppTheme.textSecondary, fontSize: 10),
                            ),
                          );
                        },
                      ),
                    ),
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  minY: minBmi,
                  maxY: maxBmi,
                  lineBarsData: [
                    // Normal zone
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      curveSmoothness: 0.3,
                      color: AppTheme.highlight,
                      barWidth: 2.5,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, _, __, ___) =>
                            FlDotCirclePainter(
                          radius: 4,
                          color: AppTheme.bmiColor(spot.y),
                          strokeWidth: 2,
                          strokeColor: AppTheme.cardBg,
                        ),
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            AppTheme.highlight.withOpacity(0.2),
                            AppTheme.highlight.withOpacity(0.0),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ],
                  // Horizontal reference lines for BMI ranges
                  extraLinesData: ExtraLinesData(
                    horizontalLines: [
                      HorizontalLine(
                        y: 18.5,
                        color: AppTheme.underweight.withOpacity(0.5),
                        strokeWidth: 1,
                        dashArray: [4, 4],
                        label: HorizontalLineLabel(
                          show: true,
                          labelResolver: (_) => '18.5',
                          style: const TextStyle(
                              color: AppTheme.underweight, fontSize: 10),
                        ),
                      ),
                      HorizontalLine(
                        y: 24.0,
                        color: AppTheme.normal.withOpacity(0.5),
                        strokeWidth: 1,
                        dashArray: [4, 4],
                        label: HorizontalLineLabel(
                          show: true,
                          labelResolver: (_) => '24.0',
                          style: const TextStyle(
                              color: AppTheme.normal, fontSize: 10),
                        ),
                      ),
                      HorizontalLine(
                        y: 27.0,
                        color: AppTheme.overweight.withOpacity(0.5),
                        strokeWidth: 1,
                        dashArray: [4, 4],
                        label: HorizontalLineLabel(
                          show: true,
                          labelResolver: (_) => '27.0',
                          style: const TextStyle(
                              color: AppTheme.overweight, fontSize: 10),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeightChart() {
    final spots = _records.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), e.value.weight);
    }).toList();

    final minW =
        _records.map((r) => r.weight).reduce((a, b) => a < b ? a : b) - 2;
    final maxW =
        _records.map((r) => r.weight).reduce((a, b) => a > b ? a : b) + 2;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '體重趨勢 (kg)',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 180,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (_) => const FlLine(
                      color: AppTheme.divider,
                      strokeWidth: 1,
                    ),
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 36,
                        getTitlesWidget: (v, _) => Text(
                          v.toStringAsFixed(0),
                          style: const TextStyle(
                              color: AppTheme.textSecondary, fontSize: 11),
                        ),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval: (_records.length / 4).ceilToDouble(),
                        getTitlesWidget: (v, _) {
                          final idx = v.toInt();
                          if (idx < 0 || idx >= _records.length) {
                            return const SizedBox.shrink();
                          }
                          return Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              DateFormat('M/d').format(_records[idx].date),
                              style: const TextStyle(
                                  color: AppTheme.textSecondary, fontSize: 10),
                            ),
                          );
                        },
                      ),
                    ),
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  minY: minW,
                  maxY: maxW,
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      curveSmoothness: 0.3,
                      color: const Color(0xFF4FC3F7),
                      barWidth: 2.5,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (_, __, ___, ____) =>
                            FlDotCirclePainter(
                          radius: 4,
                          color: const Color(0xFF4FC3F7),
                          strokeWidth: 2,
                          strokeColor: AppTheme.cardBg,
                        ),
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFF4FC3F7).withOpacity(0.2),
                            const Color(0xFF4FC3F7).withOpacity(0.0),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStats() {
    if (_records.isEmpty) {
      return const SizedBox.shrink();
    }

    final latestBmi = _records.last.bmi;
    final avgBmi =
        _records.map((r) => r.bmi).reduce((a, b) => a + b) / _records.length;
    final minBmi =
        _records.map((r) => r.bmi).reduce((a, b) => a < b ? a : b);
    final maxBmi =
        _records.map((r) => r.bmi).reduce((a, b) => a > b ? a : b);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '統計摘要',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                    child: _statCard('最新 BMI',
                        latestBmi.toStringAsFixed(2), AppTheme.highlight)),
                const SizedBox(width: 10),
                Expanded(
                    child: _statCard('平均 BMI', avgBmi.toStringAsFixed(2),
                        AppTheme.normal)),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                    child: _statCard('最低 BMI', minBmi.toStringAsFixed(2),
                        AppTheme.underweight)),
                const SizedBox(width: 10),
                Expanded(
                    child: _statCard('最高 BMI', maxBmi.toStringAsFixed(2),
                        AppTheme.obese1)),
              ],
            ),
            const SizedBox(height: 10),
            _statCard(
                '總記錄筆數', '${_records.length} 筆', AppTheme.textSecondary),
          ],
        ),
      ),
    );
  }

  Widget _statCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  color: AppTheme.textSecondary, fontSize: 12)),
          const SizedBox(height: 4),
          Text(value,
              style: TextStyle(
                  color: color,
                  fontSize: 18,
                  fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
