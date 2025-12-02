import 'dart:async';
import 'package:flutter/material.dart';

class NotificationCard extends StatefulWidget {
  final String title;
  final String message;
  final bool isSuccess; // true = success, false = error
  final Duration duration;

  const NotificationCard({
    Key? key,
    required this.title,
    required this.message,
    this.isSuccess = true,
    this.duration = const Duration(seconds: 3),
  }) : super(key: key);

  @override
  State<NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Auto-hide setelah durasi
    _timer = Timer(widget.duration, () {
      if (mounted) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = widget.isSuccess 
        ? const Color(0xFF2196F3) // Biru untuk success
        : const Color(0xFFF44336); // Merah untuk error
    
    final IconData icon = widget.isSuccess 
        ? Icons.check_circle_outlined 
        : Icons.error_outline;
    
    final String title = widget.isSuccess ? 'Berhasil!' : 'Gagal';

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.all(24),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              spreadRadius: 0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 32,
                  color: primaryColor,
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Title
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              
              const SizedBox(height: 8),
              
              // Message
              Text(
                widget.message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black54,
                  height: 1.4,
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Close button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('OK'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Fungsi helper untuk menampilkan notifikasi
void showNotification({
  required BuildContext context,
  required String message,
  bool isSuccess = true,
  String title = '',
  Duration duration = const Duration(seconds: 3),
}) {
  showDialog(
    context: context,
    barrierColor: Colors.black.withOpacity(0.4),
    barrierDismissible: true,
    builder: (context) => NotificationCard(
      title: title.isEmpty ? (isSuccess ? 'Berhasil!' : 'Gagal') : title,
      message: message,
      isSuccess: isSuccess,
      duration: duration,
    ),
  );
}