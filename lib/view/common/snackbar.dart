import 'package:flutter/material.dart';

enum SnackBarType { success, error, warning, info }

class CustomSnackbar {
  static SnackBar showErrorSnackBar({
    required String snackBarTitle,
    required String snackBarMessage,
    Duration duration = const Duration(seconds: 4),
  }) {
    return _buildSnackBar(
      title: snackBarTitle,
      message: snackBarMessage,
      type: SnackBarType.error,
      duration: duration,
    );
  }

  static SnackBar showSuccessSnackBar({
    required String snackBarTitle,
    required String snackBarMessage,
    Duration duration = const Duration(seconds: 4),
  }) {
    return _buildSnackBar(
      title: snackBarTitle,
      message: snackBarMessage,
      type: SnackBarType.success,
      duration: duration,
    );
  }

  static SnackBar showWarningSnackBar({
    required String snackBarTitle,
    required String snackBarMessage,
    Duration duration = const Duration(seconds: 4),
  }) {
    return _buildSnackBar(
      title: snackBarTitle,
      message: snackBarMessage,
      type: SnackBarType.warning,
      duration: duration,
    );
  }

  static SnackBar showInfoSnackBar({
    required String snackBarTitle,
    required String snackBarMessage,
    Duration duration = const Duration(seconds: 4),
  }) {
    return _buildSnackBar(
      title: snackBarTitle,
      message: snackBarMessage,
      type: SnackBarType.info,
      duration: duration,
    );
  }

  static SnackBar _buildSnackBar({
    required String title,
    required String message,
    required SnackBarType type,
    required Duration duration,
  }) {
    return SnackBar(
      duration: duration,
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: CustomSnackBarContent(
        title: title,
        message: message,
        type: type,
        duration: duration,
      ),
      margin: const EdgeInsets.all(16),
    );
  }
}

class CustomSnackBarContent extends StatefulWidget {
  final String title;
  final String message;
  final SnackBarType type;
  final Duration duration;

  const CustomSnackBarContent({
    super.key,
    required this.title,
    required this.message,
    required this.type,
    required this.duration,
  });

  @override
  State<CustomSnackBarContent> createState() => _CustomSnackBarContentState();
}

class _CustomSnackBarContentState extends State<CustomSnackBarContent>
    with TickerProviderStateMixin {
  late AnimationController _progressController;
  late AnimationController _slideController;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // Start the progress animation
    _progressController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _progressController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  Color _getBackgroundColor() {
    switch (widget.type) {
      case SnackBarType.success:
        return const Color(0xFF4CAF50);
      case SnackBarType.error:
        return const Color(0xFFF44336);
      case SnackBarType.warning:
        return const Color(0xFFFF9800);
      case SnackBarType.info:
        return const Color(0xFF2196F3);
    }
  }

  Color _getProgressColor() {
    switch (widget.type) {
      case SnackBarType.success:
        return const Color(0xFF2E7D32);
      case SnackBarType.error:
        return const Color(0xFFC62828);
      case SnackBarType.warning:
        return const Color(0xFFE65100);
      case SnackBarType.info:
        return const Color(0xFF1565C0);
    }
  }

  IconData _getIcon() {
    switch (widget.type) {
      case SnackBarType.success:
        return Icons.check_circle;
      case SnackBarType.error:
        return Icons.error;
      case SnackBarType.warning:
        return Icons.warning;
      case SnackBarType.info:
        return Icons.info;
    }
  }

  void _closeSnackBar() {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 1),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _slideController,
        curve: Curves.easeOutCubic,
      )),
      child: Container(
        decoration: BoxDecoration(
          color: _getBackgroundColor(),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(51),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Progress indicator at the top
            AnimatedBuilder(
              animation: _progressController,
              builder: (context, child) {
                return Container(
                  height: 4,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                  child: LinearProgressIndicator(
                    value: 1.0 - _progressController.value,
                    backgroundColor: Colors.white.withAlpha(77),
                    valueColor: AlwaysStoppedAnimation<Color>(_getProgressColor()),
                  ),
                );
              },
            ),
            // Main content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Icon
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(51),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getIcon(),
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Title and message
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.message,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Close button
                  GestureDetector(
                    onTap: _closeSnackBar,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(51),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
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