import 'package:flutter/material.dart';
import 'package:plant_care/plants/domain/value_objetcs/plant_status.dart';

class PlantStatusChip extends StatelessWidget {
  final PlantStatus status;
  final bool isLarge;
  final TextStyle? textStyle;

  const PlantStatusChip({
    super.key,
    required this.status,
    this.isLarge = false,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final (label, color, icon) = _getStatusProperties(status, context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isLarge ? 16 : 12,
        vertical: isLarge ? 12 : 8,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withOpacity(0.15),
            color.withOpacity(0.08),
          ],
        ),
        borderRadius: BorderRadius.circular(isLarge ? 20 : 16),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: isLarge ? 12 : 8,
            offset: Offset(0, isLarge ? 4 : 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Ícono con container circular
          Container(
            padding: EdgeInsets.all(isLarge ? 6 : 4),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  color.withOpacity(0.25),
                  color.withOpacity(0.15),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: isLarge ? 18 : 14,
            ),
          ),
          SizedBox(width: isLarge ? 10 : 8),
          
          // Label
          Text(
            label,
            style: textStyle ??
                theme.textTheme.labelMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w700,
                  fontSize: isLarge ? 15 : 13,
                  letterSpacing: 0.3,
                ),
          ),
        ],
      ),
    );
  }

  // KISS: Lógica de presentación simple y centralizada
  (String, Color, IconData) _getStatusProperties(
    PlantStatus status,
    BuildContext context,
  ) {
    switch (status) {
      case PlantStatus.HEALTHY:
        return (
          'Healthy',
          const Color(0xFF34C759),
          Icons.check_circle_rounded,
        );
      case PlantStatus.WARNING:
        return (
          'Warning',
          const Color(0xFFFF9500),
          Icons.warning_rounded,
        );
      case PlantStatus.CRITICAL:
        return (
          'Critical',
          const Color(0xFFAF52DE),
          Icons.priority_high_rounded,
        );
      case PlantStatus.DANGER:
        return (
          'Danger',
          const Color(0xFFFF3B30),
          Icons.error_rounded,
        );
      case PlantStatus.UNKNOWN:
        return (
          'Unknown',
          const Color(0xFF8E8E93),
          Icons.help_rounded,
        );
    }
  }
}