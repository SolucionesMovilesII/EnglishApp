class Translation {
  final String id;
  final String originalText;
  final String translatedText;
  final String sourceLanguage;
  final String targetLanguage;
  final String? pronunciation;
  final List<String> examples;
  final String? audioUrl;
  final String? definition;
  final String? context;
  final DateTime createdAt;
  final DateTime? expiresAt;

  const Translation({
    required this.id,
    required this.originalText,
    required this.translatedText,
    required this.sourceLanguage,
    required this.targetLanguage,
    this.pronunciation,
    this.examples = const [],
    this.audioUrl,
    this.definition,
    this.context,
    required this.createdAt,
    this.expiresAt,
  });

  // Factory constructor from JSON (server response)
  factory Translation.fromJson(Map<String, dynamic> json) {
    return Translation(
      id: json['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      originalText: json['originalText'] ?? json['text'] ?? '',
      translatedText: json['translatedText'] ?? json['translation'] ?? '',
      sourceLanguage: json['sourceLanguage'] ?? 'en',
      targetLanguage: json['targetLanguage'] ?? 'es',
      pronunciation: json['pronunciation'],
      examples: json['examples'] != null 
          ? List<String>.from(json['examples'])
          : [],
      audioUrl: json['audioUrl'],
      definition: json['definition'],
      context: json['context'],
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      expiresAt: json['expiresAt'] != null 
          ? DateTime.parse(json['expiresAt'])
          : null,
    );
  }

  // Factory constructor from local database
  factory Translation.fromLocalDb(Map<String, dynamic> map) {
    return Translation(
      id: map['id'] ?? '',
      originalText: map['original_text'] ?? '',
      translatedText: map['translated_text'] ?? '',
      sourceLanguage: map['source_language'] ?? '',
      targetLanguage: map['target_language'] ?? '',
      pronunciation: map['pronunciation'],
      examples: map['examples'] != null 
          ? map['examples'].toString().split(',').where((e) => e.isNotEmpty).toList()
          : [],
      audioUrl: map['audio_url'],
      definition: null, // Not stored in cache
      context: null, // Not stored in cache
      createdAt: map['created_at'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(map['created_at'])
          : DateTime.now(),
      expiresAt: map['expires_at'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(map['expires_at'])
          : null,
    );
  }

  // Convert to JSON for server requests
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'originalText': originalText,
      'translatedText': translatedText,
      'sourceLanguage': sourceLanguage,
      'targetLanguage': targetLanguage,
      'pronunciation': pronunciation,
      'examples': examples,
      'audioUrl': audioUrl,
      'definition': definition,
      'context': context,
      'createdAt': createdAt.toIso8601String(),
      'expiresAt': expiresAt?.toIso8601String(),
    };
  }

  // Convert to local database format
  Map<String, dynamic> toLocalDb() {
    final textHash = '$originalText-$sourceLanguage-$targetLanguage'.hashCode.toString();
    
    return {
      'id': id,
      'text_hash': textHash,
      'original_text': originalText,
      'translated_text': translatedText,
      'source_language': sourceLanguage,
      'target_language': targetLanguage,
      'pronunciation': pronunciation,
      'examples': examples.join(','),
      'audio_url': audioUrl,
      'created_at': createdAt.millisecondsSinceEpoch,
      'expires_at': expiresAt?.millisecondsSinceEpoch,
    };
  }

  // Copy with method for immutable updates
  Translation copyWith({
    String? id,
    String? originalText,
    String? translatedText,
    String? sourceLanguage,
    String? targetLanguage,
    String? pronunciation,
    List<String>? examples,
    String? audioUrl,
    String? definition,
    String? context,
    DateTime? createdAt,
    DateTime? expiresAt,
  }) {
    return Translation(
      id: id ?? this.id,
      originalText: originalText ?? this.originalText,
      translatedText: translatedText ?? this.translatedText,
      sourceLanguage: sourceLanguage ?? this.sourceLanguage,
      targetLanguage: targetLanguage ?? this.targetLanguage,
      pronunciation: pronunciation ?? this.pronunciation,
      examples: examples ?? this.examples,
      audioUrl: audioUrl ?? this.audioUrl,
      definition: definition ?? this.definition,
      context: context ?? this.context,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is Translation &&
        other.id == id &&
        other.originalText == originalText &&
        other.translatedText == translatedText &&
        other.sourceLanguage == sourceLanguage &&
        other.targetLanguage == targetLanguage;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        originalText.hashCode ^
        translatedText.hashCode ^
        sourceLanguage.hashCode ^
        targetLanguage.hashCode;
  }

  @override
  String toString() {
    return 'Translation(id: $id, originalText: $originalText, translatedText: $translatedText, sourceLanguage: $sourceLanguage, targetLanguage: $targetLanguage)';
  }
}