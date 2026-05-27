// lib/screens/history_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/bmi_record.dart';
import '../services/storage_service.dart';
import '../theme.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
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
    setState(() {
      _records = records;
      _loading = false;
    });
  }

  Future<void> _delete(BmiRecord record) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.cardBg,
        title: const Text('確認刪除',
            style: TextStyle(color: AppTheme.textPrimary)),
        content: Text(
          '刪除 ${DateFormat('MM月dd日').format(record.date)} 的記錄？',
          style: const TextStyle(color: AppTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('取消',
                style: TextStyle(color: AppTheme.textSecondary)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('刪除',
                style: TextStyle(color: AppTheme.highlight)),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await _storage.deleteRecord(record.id);
      _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_records.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined,
                size: 72, color: AppTheme.textSecondary.withOpacity(0.5)),
            const SizedBox(height: 16),
            const Text(
              '尚無記錄',
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 18),
            ),
            const SizedBox(height: 8),
            const Text(
              '回到首頁計算並儲存你的 BMI',
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _load,
      color: AppTheme.highlight,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _records.length,
        itemBuilder: (context, index) {
          final record = _records[index];
          return _RecordCard(
            record: record,
            onDelete: () => _delete(record),
          );
        },
      ),
    );
  }
}

class _RecordCard extends StatelessWidget {
  final BmiRecord record;
  final VoidCallback onDelete;

  const _RecordCard({required this.record, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final color = AppTheme.bmiColor(record.bmi);
    final dateFmt = DateFormat('yyyy年MM月dd日');
    final timeFmt = DateFormat('HH:mm');

    return Dismissible(
      key: Key(record.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppTheme.highlight.withOpacity(0.2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_outline, color: AppTheme.highlight),
      ),
      confirmDismiss: (_) async {
        onDelete();
        return false; // Let _delete handle it
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // BMI circle
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: color.withOpacity(0.15),
                        border: Border.all(color: color, width: 2),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        record.bmi.toStringAsFixed(1),
                        style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            dateFmt.format(record.date),
                            style: const TextStyle(
                              color: AppTheme.textPrimary,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            timeFmt.format(record.date),
                            style: const TextStyle(
                                color: AppTheme.textSecondary, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        record.category,
                        style: TextStyle(
                            color: color,
                            fontSize: 12,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                const Divider(color: AppTheme.divider, height: 1),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _info('身高', '${record.height.toStringAsFixed(0)} cm',
                        Icons.height),
                    _vDivider(),
                    _info('體重', '${record.weight.toStringAsFixed(1)} kg',
                        Icons.monitor_weight_outlined),
                    _vDivider(),
                    _info('BMI', record.bmi.toStringAsFixed(2),
                        Icons.analytics_outlined),
                  ],
                ),
                if (record.note.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppTheme.surface,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.note_outlined,
                            size: 14, color: AppTheme.textSecondary),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            record.note,
                            style: const TextStyle(
                                color: AppTheme.textSecondary, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: onDelete,
                      icon: const Icon(Icons.delete_outline,
                          size: 15, color: AppTheme.highlight),
                      label: const Text('刪除',
                          style: TextStyle(
                              color: AppTheme.highlight, fontSize: 12)),
                      style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 8)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _info(String label, String value, IconData icon) => Column(
        children: [
          Icon(icon, size: 16, color: AppTheme.textSecondary),
          const SizedBox(height: 4),
          Text(value,
              style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: 14)),
          Text(label,
              style: const TextStyle(
                  color: AppTheme.textSecondary, fontSize: 11)),
        ],
      );

  Widget _vDivider() => Container(
      width: 1, height: 48, color: AppTheme.divider);
}
