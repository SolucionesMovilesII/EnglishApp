import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/custom_card.dart';
import '../widgets/custom_icons.dart';
import '../widgets/bottom_navigation.dart';
import '../widgets/app_banner.dart';
import '../l10n/app_localizations.dart';
import 'settings_screen.dart';
import 'quiz_screen.dart';
import 'chapter_episodes_screen.dart';
import 'chapter_results_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _currentIndex = 0;
  late PageController _pageController;
  late AnimationController _animationController;
  
  final List<int> _navigableIndices = [0, 1, 2, 3];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
    _animationController.forward().then((_) {
      _animationController.reset();
    });
  }

  void _navigateToIndex(int index) {
    if (_navigableIndices.contains(index)) {
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.velocity.pixelsPerSecond.dx > 100) {
            _swipeToNext();
          }
          else if (details.velocity.pixelsPerSecond.dx < -100) {
            _swipeToPrevious();
          }
        },
        child: PageView.builder(
          controller: _pageController,
          onPageChanged: _onPageChanged,
          itemCount: _navigableIndices.length,
          itemBuilder: (context, index) {
            return _getCurrentScreenByIndex(_navigableIndices[index]);
          },
        ),
      ),
      bottomNavigationBar: CustomBottomNavigation(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 4) {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const SettingsScreen()),
            );
          } else {
            _navigateToIndex(index);
          }
        },
      ),
    );
  }

  void _swipeToNext() {
    final currentIndexInNavigable = _navigableIndices.indexOf(_currentIndex);
    final nextIndex = (currentIndexInNavigable + 1) % _navigableIndices.length;
    _navigateToIndex(_navigableIndices[nextIndex]);
  }

  void _swipeToPrevious() {
    final currentIndexInNavigable = _navigableIndices.indexOf(_currentIndex);
    final previousIndex = (currentIndexInNavigable - 1 + _navigableIndices.length) % _navigableIndices.length;
    _navigateToIndex(_navigableIndices[previousIndex]);
  }

  Widget _getCurrentScreenByIndex(int index) {
    switch (index) {
      case 0:
        return _buildHomeContent();
      case 1:
        return _buildPlaceholderContent(AppLocalizations.of(context)!.folders);
      case 2:
        return _buildPlaceholderContent(AppLocalizations.of(context)!.book);
      case 3:
        return const QuizScreen();
      default:
        return _buildHomeContent();
    }
  }

  Widget _buildPlaceholderContent(String title) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.construction,
              size: 64,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.sectionTitle(title),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.comingSoon,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeContent() {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      appBar: AppBar(
        toolbarHeight: 56,
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
        title: Text(
          AppLocalizations.of(context)!.home,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: Theme.of(context).colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.analytics_outlined,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const ChapterResultsScreen(),
              ),
            ),
            tooltip: AppLocalizations.of(context)!.chapterResults,
          ),
        ],
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Theme.of(context).colorScheme.primary,
          statusBarIconBrightness: Theme.of(context).brightness == Brightness.dark 
              ? Brightness.light 
              : Brightness.dark,
          statusBarBrightness: Theme.of(context).brightness,
        ),
      ),
      body: Column(
        children: [
          // Header
          Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              return AppBanner(
                title: '${AppLocalizations.of(context)!.hi}, ${authProvider.user?.name ?? AppLocalizations.of(context)!.user}',
                subtitle: AppLocalizations.of(context)!.welcomeBack,
                livesText: AppLocalizations.of(context)!.livesRemaining(5),
              );
            },
          ),

          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.yourLearningPath,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Cards
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          // Vocabulary Card
                          CustomCard(
                            title: AppLocalizations.of(context)!.chapterProgress,
                            subtitle: AppLocalizations.of(context)!.continueText,
                            description: AppLocalizations.of(context)!.vocabulary,
                            icon: CustomIcons.vocabularyIcon(),
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const ChapterEpisodesScreen(
                                  chapterTitle: "English Basics",
                                ),
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 8),
                          
                          // Reading Card
                          CustomCard(
                            title: AppLocalizations.of(context)!.software,
                            subtitle: AppLocalizations.of(context)!.continueText,
                            description: AppLocalizations.of(context)!.reading,
                            icon: CustomIcons.readingIcon(),
                            onTap: () => _navigateToSection('reading'),
                          ),
                          
                          const SizedBox(height: 8),
                          
                          // Interview Card
                          CustomCard(
                            title: AppLocalizations.of(context)!.databases,
                            subtitle: AppLocalizations.of(context)!.continueText,
                            description: AppLocalizations.of(context)!.interview,
                            icon: CustomIcons.interviewIcon(),
                            onTap: () => _navigateToSection('interview'),
                          ),
                          
                          const SizedBox(height: 8),
                          
                          // Chapter Results Card
                          CustomCard(
                            title: AppLocalizations.of(context)!.chapterResults,
                            subtitle: AppLocalizations.of(context)!.viewProgress,
                            description: AppLocalizations.of(context)!.evaluationHistory,
                            icon: Icon(
                              Icons.analytics,
                              size: 32,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const ChapterResultsScreen(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToSection(String section) {
    // Placeholder navigation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.navigatingToSection(section)),
        duration: const Duration(seconds: 1),
      ),
    );
  }
}