import 'package:flutter/material.dart';
import 'package:padlock_tablet/models/students/titmetable_item.dart';
import 'package:padlock_tablet/widgets/common/card_container.dart';

class TimetableCard extends StatelessWidget {
  final List<TimeTableItem> timeTable;
  final VoidCallback? onViewAll;

  const TimetableCard({
    super.key,
    required this.timeTable,
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    return CardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '오늘의 시간표',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: timeTable.length,
              itemBuilder: (context, index) {
                final item = timeTable[index];
                return _buildTimeTableItem(item);
              },
            ),
          ),
          if (onViewAll != null)
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: onViewAll,
                child: const Text('전체보기'),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTimeTableItem(TimeTableItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              item.period,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            item.subject,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
