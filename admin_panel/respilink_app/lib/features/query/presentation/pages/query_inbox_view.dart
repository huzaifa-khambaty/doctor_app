import 'package:flutter/material.dart';
import 'package:respilink_app/core/theme/app_colors.dart';

class QueryInboxContent extends StatefulWidget {
  const QueryInboxContent({super.key});

  @override
  State<QueryInboxContent> createState() => _QueryInboxContentState();
}

class _QueryInboxContentState extends State<QueryInboxContent> {
  int _selectedQueryIndex = 0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool useSinglePaneLayout = false;
        // Fall back to screen height minus AppBar if constraints are unbounded
        final double height = constraints.maxHeight.isFinite
            ? constraints.maxHeight
            : MediaQuery.of(context).size.height - kToolbarHeight;

        return SizedBox(
          height: height,
          child: _buildBody(useSinglePaneLayout),
        );
      },
    );
  }

  Widget _buildBody(bool useSinglePaneLayout) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Header Row
          Row(
            children: [
              const Text(
                'Queries',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: SizedBox(
                    height: 36,
                    child: TextField(
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.search,
                          size: 16,
                          color: AppColors.textMuted,
                        ),
                        hintText: 'Search doctor names or subjects...',
                        hintStyle: const TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 13,
                        ),
                        filled: true,
                        fillColor: const Color(0xFFEDF2F7),
                        contentPadding: EdgeInsets.zero,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(
                            color: AppColors.primary,
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // 2. Dual-Pane Body
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Left Pane: Inbox List ──────────────────────────────────
                Expanded(
                  flex: useSinglePaneLayout ? 1 : 4,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Inbox',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textDark,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEBF8FF),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              '24 New',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                          const Spacer(),
                          _buildActionButton(
                            Icons.filter_list_rounded,
                            'Filter',
                          ),
                          const SizedBox(width: 8),
                          _buildActionButton(
                            Icons.swap_vert_rounded,
                            'Sort',
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: ListView(
                          children: [
                            _buildInboxTile(
                              index: 0,
                              name: 'Dr. Sarah Jenkins',
                              specialty: 'Pulmonology • Pediatric Care',
                              title:
                                  'Inquiry: Patient #4421 Dosage Adjustment',
                              body:
                                  'I am reviewing the latest clinical trials regarding the new bronchodilator...',
                              time: '10:45 AM',
                              tag: 'NEW',
                              tagColor: Colors.teal,
                              tagBg: const Color(0xFFE6F2F2),
                            ),
                            _buildInboxTile(
                              index: 1,
                              name: 'Dr. Michael Chen',
                              specialty: 'Critical Care • ICU',
                              title: 'Urgent: Equipment Calibration Query',
                              body:
                                  'The bedside monitors in ICU-4 are showing a 2% variance in...',
                              time: 'Yesterday',
                              tag: 'IN PROGRESS',
                              tagColor: Colors.blue,
                              tagBg: const Color(0xFFEBF8FF),
                            ),
                            _buildInboxTile(
                              index: 2,
                              name: 'Dr. Elena Rodriguez',
                              specialty: 'General Medicine • Community Health',
                              title: 'Request for Educational Brochures',
                              body:
                                  'Our clinic is running low on the COPD awareness pamphlets. Coul...',
                              time: 'Oct 24',
                              tag: 'RESOLVED',
                              tagColor: Colors.grey,
                              tagBg: const Color(0xFFEDF2F7),
                            ),
                            _buildInboxTile(
                              index: 3,
                              name: 'Dr. James Wilson',
                              specialty: 'Internal Medicine',
                              title: 'App Sync Issue',
                              body:
                                  'My patients are reporting that their daily peak flow data is not syncing...',
                              time: 'Oct 23',
                              tag: 'NEW',
                              tagColor: Colors.teal,
                              tagBg: const Color(0xFFE6F2F2),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Right Pane: Message Detail + Reply ────────────────────
                if (!useSinglePaneLayout) ...[
                  const SizedBox(width: 18),
                  Expanded(
                    flex: 5,
                    child: Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: AppColors.cardBg,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.borderLight),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Sender header
                          Row(
                            children: [
                              const CircleAvatar(
                                radius: 18,
                                backgroundColor: Color(0xFF0C4A60),
                                child: Text(
                                  'SJ',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text(
                                      'Dr. Sarah Jenkins',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textDark,
                                      ),
                                    ),
                                    Text(
                                      "Senior Pulmonologist • St. Jude's Medical",
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: AppColors.textMuted,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.archive_outlined,
                                  size: 18,
                                  color: AppColors.textMuted,
                                ),
                                onPressed: () {},
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete_outline_rounded,
                                  size: 18,
                                  color: AppColors.textMuted,
                                ),
                                onPressed: () {},
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.more_vert_rounded,
                                  size: 18,
                                  color: AppColors.textMuted,
                                ),
                                onPressed: () {},
                              ),
                            ],
                          ),
                          const Divider(color: AppColors.borderLight, height: 24),

                          // Subject + received meta
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text(
                                      'SUBJECT',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textMuted,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'Patient #4421 Dosage\nAdjustment',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textDark,
                                        height: 1.3,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: const [
                                  Text(
                                    'RECEIVED',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textMuted,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Oct 25, 2023 •',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textDark,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    '10:45 AM',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textDark,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Message body (scrollable)
                          Expanded(
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF4F7F9),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Hello Admin Team,\n\n'
                                      'I am writing regarding the patient management guidelines for pediatric bronchodilator administration. In the latest app update, I noticed the dosage calculator for patients under 12 years old doesn\'t seem to reflect the updated ERS/ATS guidelines published last month.\n\n'
                                      'Could you please verify if the backend logic for the RespiLink dosage calculator has been updated? I am specifically looking at Patient #4421 who is on a titration schedule.\n\n'
                                      'Thank you,\nSarah',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: AppColors.textDark,
                                        height: 1.45,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    // Attachment chip
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(
                                          color: AppColors.borderLight,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: const [
                                          Icon(
                                            Icons.picture_as_pdf_outlined,
                                            size: 16,
                                            color: Colors.redAccent,
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            'Guidelines_Update.pdf',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.textDark,
                                            ),
                                          ),
                                          SizedBox(width: 12),
                                          Text(
                                            '1.2 MB',
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: AppColors.textMuted,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Reply composer
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppColors.borderLight),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextField(
                                  maxLines: 2,
                                  decoration: InputDecoration(
                                    hintText:
                                        'Write your response to Dr. Jenkins...',
                                    hintStyle: TextStyle(
                                      color: AppColors.textMuted
                                          .withValues(alpha: 0.8),
                                      fontSize: 13,
                                    ),
                                    border: InputBorder.none,
                                    isDense: true,
                                    contentPadding:
                                        const EdgeInsets.symmetric(vertical: 4),
                                  ),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.attach_file_rounded,
                                        size: 18,
                                        color: AppColors.textMuted,
                                      ),
                                      onPressed: () {},
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.sentiment_satisfied_alt_outlined,
                                        size: 18,
                                        color: AppColors.textMuted,
                                      ),
                                      onPressed: () {},
                                    ),
                                    const Spacer(),
                                    ElevatedButton.icon(
                                      onPressed: () {},
                                      // icon/label are intentionally swapped here
                                      // to put text left of the send icon
                                      icon: const Text(
                                        'Send Reply',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      label: const Icon(
                                        Icons.send_rounded,
                                        size: 12,
                                        color: Colors.white,
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFF005B5C),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 14,
                                          vertical: 12,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        elevation: 0,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label) {
    return Container(
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: AppColors.textDark),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInboxTile({
    required int index,
    required String name,
    required String specialty,
    required String title,
    required String body,
    required String time,
    required String tag,
    required Color tagColor,
    required Color tagBg,
  }) {
    final bool isSelected = _selectedQueryIndex == index;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFF0F5F7) : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.4)
              : AppColors.borderLight,
          width: isSelected ? 1.2 : 1.0,
        ),
      ),
      child: InkWell(
        onTap: () => setState(() => _selectedQueryIndex = index),
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: const Color(0xFFE2E8F0),
                    child: Icon(
                      Icons.person,
                      size: 16,
                      color: AppColors.textDark.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 1),
                        Text(
                          specialty,
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textMuted,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        time,
                        style: const TextStyle(
                          fontSize: 10,
                          color: AppColors.textMuted,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: tagBg,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          tag,
                          style: TextStyle(
                            color: tagColor,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                body,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textMuted.withValues(alpha: 0.9),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}