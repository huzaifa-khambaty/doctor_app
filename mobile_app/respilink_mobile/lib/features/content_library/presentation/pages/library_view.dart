import 'package:respilink_mobile/features/content_library/domain/models/library_content_model.dart';
import 'package:respilink_mobile/features/content_library/domain/models/library_filter.dart';
import 'package:respilink_mobile/features/content_library/presentation/pages/article_reader_view.dart';
import 'package:respilink_mobile/features/content_library/presentation/widgets/assessment_library_card.dart';
import 'package:respilink_mobile/features/content_library/presentation/widgets/document_library_card.dart';
import 'package:respilink_mobile/features/content_library/presentation/widgets/library_filter_chips.dart';
import 'package:respilink_mobile/features/content_library/presentation/widgets/library_header_banner.dart';
import 'package:respilink_mobile/features/content_library/presentation/widgets/media_library_card.dart';

import '../../../../exports.dart';

// TODO: replace with real data from the backend once the content library API is wired up.
const _content = [
  LibraryContentModel(
    id: 1,
    type: LibraryContentType.video,
    category: 'COPD MANAGEMENT',
    categoryColor: AppColors.primary,
    title: 'Advanced Airway Techniques in Chronic Respiratory Failure',
    image: 'copd.png',
    duration: '12:45',
    metaLeft: 'Oct 24, 2023',
    metaLeftIcon: Icons.calendar_today_outlined,
    metaRight: '1.2k views',
    metaRightIcon: Icons.visibility_outlined,
  ),
  LibraryContentModel(
    id: 2,
    type: LibraryContentType.guideline,
    category: 'PHARMACOLOGY',
    categoryColor: AppColors.purpleAccent,
    title: 'New Era Bronchodilators: A Comparative Meta-Analysis',
    fileSize: '8.4 MB',
    metaLeft: '8 Pages',
    metaLeftIcon: Icons.description_outlined,
    metaRight: '858 Downloads',
    metaRightIcon: Icons.download_outlined,
  ),
  LibraryContentModel(
    id: 3,
    type: LibraryContentType.assessment,
    category: 'INTERACTIVE ASSESSMENT',
    categoryColor: AppColors.purpleAccent,
    title: 'Pulmonary Embolism Diagnosis Masterclass',
    description:
        'Challenge your diagnostic speed with our latest high-fidelity case study. Earn points toward your clinician rank.',
    ctaLabel: 'Start Quiz Now',
  ),
  LibraryContentModel(
    id: 4,
    type: LibraryContentType.diagnostic,
    category: 'DIAGNOSTICS',
    categoryColor: AppColors.purpleAccent,
    title: 'Radiological Patterns in Interstitial Lung Diseases',
    image: 'respiratory.png',
    metaLeft: '8 min read',
    metaLeftIcon: Icons.timer_outlined,
      metaRight: '4.9/5',
    metaRightIcon: Icons.star_outline,
  ),
];

class LibraryView extends StatefulWidget {
  const LibraryView({super.key});

  @override
  State<LibraryView> createState() => _LibraryViewState();
}

class _LibraryViewState extends State<LibraryView> {
  LibraryFilter _selectedFilter = LibraryFilter.topics;

  Widget _cardFor(LibraryContentModel content) {
    return switch (content.type) {
      LibraryContentType.video ||
      LibraryContentType.diagnostic => MediaLibraryCard(
          content: content,
          onTap: () {
            locator<NavigationService>().navigate(
              RouterStrings.articleReaderView,
              arguments: ArticleReaderView(),
            );
          },
          onBookmarkTap: () {
            // TODO: wire to the bookmark API once it exists.
          },
        ),
      LibraryContentType.guideline => DocumentLibraryCard(
          content: content,
          onTap: () {
            // TODO: navigate to the content detail screen once it exists.
          },
          onBookmarkTap: () {
            // TODO: wire to the bookmark API once it exists.
          },
        ),
      LibraryContentType.assessment => AssessmentLibraryCard(
          content: content,
          onStart: () {
            // TODO: navigate to the quiz-taking flow once it exists.
          },
        ),
    };
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        keyboardDismissBehavior: .onDrag,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const LibraryHeaderBanner(),

            SizedBox(height: 20.h),

            LibraryFilterChips(
              selected: _selectedFilter,
              onSelected: (filter) => setState(() => _selectedFilter = filter),
            ),

            SizedBox(height: 20.h),

            for (final content in _content) ...[
              _cardFor(content),
              SizedBox(height: 16.h),
            ],
          ],
        ),
      ),
    );
  }
}
