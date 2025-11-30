import 'package:flutter/material.dart';

class KpiCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final double titleSize;
  final double valueSize;
  final bool? isPlus;

  const KpiCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.titleSize,
    required this.valueSize,
    this.isPlus,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color:  Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Icon Section
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                size: 32,
                color: Colors.black54,
              ),
            ),
            const SizedBox(width: 16),
            // Text Section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: titleSize,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: valueSize,
                      fontWeight: FontWeight.bold,
                      color: (isPlus == true) ? Colors.green : Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}