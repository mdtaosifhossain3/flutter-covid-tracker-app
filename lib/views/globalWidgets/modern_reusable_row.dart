import 'package:flutter/material.dart';

class ModernReusableRow extends StatelessWidget {
  final String? title;
  final String? value;
  final IconData? icon;
  final Color? color;
  final bool isLast;

  const ModernReusableRow({
    super.key,
    this.title,
    this.value,
    this.icon,
    this.color,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: isLast ? 0 : 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color?.withOpacity(0.05) ?? Colors.grey.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color?.withOpacity(0.1) ?? Colors.grey.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Icon Container
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color?.withOpacity(0.1) ?? Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon ?? Icons.info_outline,
              size: 20,
              color: color ?? Colors.grey[600],
            ),
          ),

          const SizedBox(width: 12),

          // Title and Value
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Title
                Flexible(
                  child: Text(
                    title ?? '',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff374151),
                    ),
                  ),
                ),

                // Value
                Text(
                  _formatNumber(value ?? '0'),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: color ?? const Color(0xff1F2937),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatNumber(String number) {
    final num = int.tryParse(number) ?? 0;
    if (num >= 1000000) {
      return '${(num / 1000000).toStringAsFixed(1)}M';
    } else if (num >= 1000) {
      return '${(num / 1000).toStringAsFixed(1)}K';
    }
    return number;
  }
}

// Alternative Glass Morphism Style Row
class GlassMorphismRow extends StatelessWidget {
  final String? title;
  final String? value;
  final IconData? icon;
  final Color? color;
  final bool isLast;

  const GlassMorphismRow({
    super.key,
    this.title,
    this.value,
    this.icon,
    this.color,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: isLast ? 0 : 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
            ),
          ),
          child: Row(
            children: [
              // Animated Icon
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: const Duration(milliseconds: 800),
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            color?.withOpacity(0.3) ??
                                Colors.blue.withOpacity(0.3),
                            color?.withOpacity(0.1) ??
                                Colors.blue.withOpacity(0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        icon ?? Icons.info_outline,
                        size: 22,
                        color: color ?? Colors.blue[700],
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(width: 16),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title ?? '',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatNumber(value ?? '0'),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: color ?? const Color(0xff1F2937),
                      ),
                    ),
                  ],
                ),
              ),

              // Trend Arrow (Optional)
              Icon(
                Icons.trending_up,
                size: 16,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatNumber(String number) {
    final num = int.tryParse(number) ?? 0;
    if (num >= 1000000) {
      return '${(num / 1000000).toStringAsFixed(1)}M';
    } else if (num >= 1000) {
      return '${(num / 1000).toStringAsFixed(1)}K';
    }
    return number;
  }
}
