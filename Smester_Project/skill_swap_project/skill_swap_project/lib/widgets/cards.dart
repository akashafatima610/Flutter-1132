import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../constants/app_colors.dart';
import '../constants/app_fonts.dart';
import '../models/models.dart';
import 'buttons.dart';

// ─── Skill Card ────────────────────────────────────────────
class SkillCard extends StatelessWidget {
  final SkillModel skill;
  final VoidCallback onRequestSwap;
  final VoidCallback? onTap;

  const SkillCard({
    super.key,
    required this.skill,
    required this.onRequestSwap,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User info row
              Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: AppColors.primaryLight,
                    child: Text(
                      skill.userName.isNotEmpty ? skill.userName[0].toUpperCase() : 'U',
                      style: AppTextStyles.h5.copyWith(color: AppColors.primary),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(skill.userName, style: AppTextStyles.h5),
                        Row(
                          children: [
                            RatingBarIndicator(
                              rating: skill.rating,
                              itemBuilder: (context, _) => const Icon(Icons.star, color: AppColors.star),
                              itemCount: 5,
                              itemSize: 12,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${skill.rating} (${skill.reviewCount})',
                              style: AppTextStyles.caption,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      skill.category,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              const Divider(color: AppColors.divider, height: 1),
              const SizedBox(height: 14),

              // Skill swap info
              Row(
                children: [
                  Expanded(
                    child: _SkillBadge(
                      label: 'Offers',
                      skill: skill.skillOffered,
                      color: AppColors.secondary,
                      bgColor: AppColors.secondaryLight,
                      icon: Icons.arrow_upward_rounded,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.swap_horiz_rounded,
                        color: AppColors.textSecondary, size: 16),
                  ),
                  Expanded(
                    child: _SkillBadge(
                      label: 'Wants',
                      skill: skill.skillWanted,
                      color: AppColors.primary,
                      bgColor: AppColors.primaryLight,
                      icon: Icons.arrow_downward_rounded,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Description
              if (skill.description.isNotEmpty) ...[
                Text(skill.description, style: AppTextStyles.bodySmall),
                const SizedBox(height: 14),
              ],

              // Request button
              PrimaryButton(
                label: 'Request Swap',
                onPressed: onRequestSwap,
                icon: Icons.handshake_outlined,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SkillBadge extends StatelessWidget {
  final String label;
  final String skill;
  final Color color;
  final Color bgColor;
  final IconData icon;

  const _SkillBadge({
    required this.label,
    required this.skill,
    required this.color,
    required this.bgColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 12, color: color),
              const SizedBox(width: 4),
              Text(label, style: AppTextStyles.caption.copyWith(color: color, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 4),
          Text(skill, style: AppTextStyles.bodySmall.copyWith(color: color, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

// ─── Request Card ────────────────────────────────────────────
class RequestCard extends StatelessWidget {
  final RequestModel request;
  final bool isSent;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;

  const RequestCard({
    super.key,
    required this.request,
    this.isSent = false,
    this.onAccept,
    this.onReject,
  });

  Color get _statusColor {
    switch (request.status) {
      case RequestStatus.pending: return AppColors.warning;
      case RequestStatus.accepted: return AppColors.success;
      case RequestStatus.completed: return AppColors.primary;
      case RequestStatus.rejected: return AppColors.error;
    }
  }

  String get _statusText {
    switch (request.status) {
      case RequestStatus.pending: return 'Pending';
      case RequestStatus.accepted: return 'Accepted';
      case RequestStatus.completed: return 'Completed';
      case RequestStatus.rejected: return 'Rejected';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isSent ? 'To: ${request.toUserName}' : 'From: ${request.fromUserName}',
                style: AppTextStyles.h5,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _statusText,
                  style: AppTextStyles.caption.copyWith(
                    color: _statusColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _SwapInfo(label: 'Offering', value: request.skillOffered, color: AppColors.secondary),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Icon(Icons.swap_horiz, color: AppColors.textHint, size: 18),
              ),
              _SwapInfo(label: 'Requesting', value: request.skillRequested, color: AppColors.primary),
            ],
          ),
          if (request.message.isNotEmpty) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text('"${request.message}"', style: AppTextStyles.bodySmall.copyWith(fontStyle: FontStyle.italic)),
            ),
          ],
          if (!isSent && request.status == RequestStatus.pending) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: SecondaryButton(
                    label: 'Decline',
                    onPressed: onReject ?? () {},
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: PrimaryButton(
                    label: 'Accept',
                    onPressed: onAccept ?? () {},
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _SwapInfo extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _SwapInfo({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.caption),
        Text(value, style: AppTextStyles.bodySmall.copyWith(color: color, fontWeight: FontWeight.w600)),
      ],
    );
  }
}