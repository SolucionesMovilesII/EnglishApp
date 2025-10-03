import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/translation.dart';
import '../models/favorite_word.dart';
import '../providers/auth_provider.dart';
import '../providers/favorites_provider.dart';
import '../utils/translation_service.dart';
import '../utils/audio_service.dart';
import 'translation_panel_widget.dart';

class TranslationTooltipWidget extends StatefulWidget {
  final String text;
  final Widget child;
  final String sourceLanguage;
  final String targetLanguage;
  final String? context;
  final bool showOnTap;
  final bool showOnLongPress;
  final VoidCallback? onTranslationLoaded;
  final EdgeInsetsGeometry? tooltipPadding;
  final Color? tooltipBackgroundColor;
  final TextStyle? tooltipTextStyle;
  final double? tooltipBorderRadius;
  final bool enableFavorites;
  final bool enablePronunciation;
  final bool enableExpandedView;

  const TranslationTooltipWidget({
    super.key,
    required this.text,
    required this.child,
    this.sourceLanguage = 'en',
    this.targetLanguage = 'es',
    this.context,
    this.showOnTap = true,
    this.showOnLongPress = true,
    this.onTranslationLoaded,
    this.tooltipPadding,
    this.tooltipBackgroundColor,
    this.tooltipTextStyle,
    this.tooltipBorderRadius,
    this.enableFavorites = true,
    this.enablePronunciation = true,
    this.enableExpandedView = true,
  });

  @override
  State<TranslationTooltipWidget> createState() => _TranslationTooltipWidgetState();
}

class _TranslationTooltipWidgetState extends State<TranslationTooltipWidget>
    with SingleTickerProviderStateMixin {
  final TranslationService _translationService = TranslationService();
  final GlobalKey _tooltipKey = GlobalKey();
  
  Translation? _translation;
  bool _isLoading = false;
  String? _error;
  OverlayEntry? _overlayEntry;
  AnimationController? _animationController;
  Animation<double>? _fadeAnimation;
  bool _isTooltipVisible = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController!,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _hideTooltip();
    _animationController?.dispose();
    super.dispose();
  }

  Future<void> _loadTranslation() async {
    if (_isLoading || widget.text.trim().isEmpty) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final token = authProvider.token;

      final result = await _translationService.translate(
        text: widget.text.trim(),
        sourceLanguage: widget.sourceLanguage,
        targetLanguage: widget.targetLanguage,
        context: widget.context,
        token: token,
      );

      if (result.success && result.translation != null) {
        setState(() {
          _translation = result.translation;
          _error = null;
        });
        widget.onTranslationLoaded?.call();
      } else {
        setState(() {
          _error = result.error ?? 'Translation failed';
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Translation error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showTooltip() {
    if (_isTooltipVisible) return;

    _loadTranslation();
    
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);
    
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        top: offset.dy + size.height + 8,
        child: Material(
          color: Colors.transparent,
          child: FadeTransition(
            opacity: _fadeAnimation!,
            child: _buildTooltipContent(),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    _animationController!.forward();
    _isTooltipVisible = true;
  }

  void _hideTooltip() {
    if (!_isTooltipVisible) return;

    _animationController!.reverse().then((_) {
      _overlayEntry?.remove();
      _overlayEntry = null;
      _isTooltipVisible = false;
    });
  }

  Widget _buildTooltipContent() {
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 300,
        minWidth: 200,
      ),
      padding: widget.tooltipPadding ?? const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: widget.tooltipBackgroundColor ?? Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(widget.tooltipBorderRadius ?? 8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 8),
          _buildContent(),
          if (widget.enableFavorites || widget.enableExpandedView)
            _buildActions(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: Text(
            widget.text,
            style: widget.tooltipTextStyle?.copyWith(
              fontWeight: FontWeight.bold,
            ) ?? Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.close, size: 18),
          onPressed: _hideTooltip,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(
            minWidth: 24,
            minHeight: 24,
          ),
        ),
      ],
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Row(
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          SizedBox(width: 8),
          Text('Translating...'),
        ],
      );
    }

    if (_error != null) {
      return Row(
        children: [
          Icon(
            Icons.error_outline,
            size: 16,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _error!,
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
                fontSize: 12,
              ),
            ),
          ),
        ],
      );
    }

    if (_translation == null) {
      return const Text(
        'Tap to translate',
        style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                _translation!.translatedText,
                style: widget.tooltipTextStyle ?? Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            if (widget.enablePronunciation && _translation!.pronunciation != null)
              IconButton(
                icon: const Icon(Icons.volume_up, size: 18),
                onPressed: () => _playPronunciation(),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(
                  minWidth: 24,
                  minHeight: 24,
                ),
              ),
          ],
        ),
        if (_translation!.pronunciation != null) ...[
          const SizedBox(height: 4),
          Text(
            '/${_translation!.pronunciation}/',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontStyle: FontStyle.italic,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ],
        if (_translation!.examples.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            'Example:',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            _translation!.examples!.first,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontStyle: FontStyle.italic,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }

  Widget _buildActions() {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (widget.enableFavorites && _translation != null)
            Consumer<FavoritesProvider>(builder: (context, favoritesProvider, child) {
              final isFavorite = favoritesProvider.isFavorite(widget.text);
              return IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  size: 18,
                  color: isFavorite ? Colors.red : null,
                ),
                onPressed: () => _toggleFavorite(favoritesProvider),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(
                  minWidth: 24,
                  minHeight: 24,
                ),
              );
            }),
          if (widget.enableExpandedView && _translation != null)
            IconButton(
              icon: const Icon(Icons.open_in_full, size: 18),
              onPressed: _showExpandedView,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(
                minWidth: 24,
                minHeight: 24,
              ),
            ),
        ],
      ),
    );
  }

  void _playPronunciation() async {
    if (_translation == null) return;
    
    final audioService = AudioService();
    
    try {
      // Try to speak the original text with pronunciation
      final textToSpeak = _translation!.pronunciation != null 
          ? widget.text 
          : _translation!.translatedText;
      
      final language = _translation!.pronunciation != null 
          ? widget.sourceLanguage 
          : widget.targetLanguage;
      
      final success = await audioService.speakText(
        textToSpeak,
        language: audioService.getSupportedLanguage(language),
      );
      
      if (!success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Audio playback failed'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Audio error: $e'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _toggleFavorite(FavoritesProvider favoritesProvider) async {
    if (_translation == null) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.token;

    final isFavorite = favoritesProvider.isFavorite(widget.text);
    
    if (isFavorite) {
      final favoriteWord = favoritesProvider.getFavoriteByWord(widget.text);
      if (favoriteWord != null) {
        await favoritesProvider.removeFromFavorites(favoriteWord.id, token: token);
      }
    } else {
      final favoriteWord = FavoriteWord(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        word: widget.text,
        translation: _translation!.translatedText,
        language: widget.sourceLanguage,
        pronunciation: _translation!.pronunciation,
        definition: null,
        examples: _translation!.examples,
        audioUrl: _translation!.audioUrl,
        category: widget.context,
        difficultyLevel: null,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isSynced: false,
        serverId: null,
      );
      
      await favoritesProvider.addToFavorites(favoriteWord, token: token);
    }
  }

  void _showExpandedView() {
    if (_translation == null) return;

    _hideTooltip();
    
    showDialog(
      context: context,
      builder: (context) => TranslationPanelWidget(
        translation: _translation!,
        originalText: widget.text,
        sourceLanguage: widget.sourceLanguage,
        targetLanguage: widget.targetLanguage,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.showOnTap ? () {
        if (_isTooltipVisible) {
          _hideTooltip();
        } else {
          _showTooltip();
        }
      } : null,
      onLongPress: widget.showOnLongPress ? () {
        if (!_isTooltipVisible) {
          _showTooltip();
        }
      } : null,
      child: widget.child,
    );
  }
}

// Helper widget for wrapping text with translation tooltips
class TranslatableText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final String sourceLanguage;
  final String targetLanguage;
  final String? context;
  final bool enableTranslation;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextAlign? textAlign;

  const TranslatableText(
    this.text, {
    super.key,
    this.style,
    this.sourceLanguage = 'en',
    this.targetLanguage = 'es',
    this.context,
    this.enableTranslation = true,
    this.maxLines,
    this.overflow,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    final textWidget = Text(
      text,
      style: style,
      maxLines: maxLines,
      overflow: overflow,
      textAlign: textAlign,
    );

    if (!enableTranslation) {
      return textWidget;
    }

    return TranslationTooltipWidget(
      text: text,
      sourceLanguage: sourceLanguage,
      targetLanguage: targetLanguage,
      context: this.context,
      child: textWidget,
    );
  }
}