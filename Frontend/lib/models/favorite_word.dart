class FavoriteWord {
  final String id;
  final String word;
  final String translation;
  final String language;
  final String? pronunciation;
  final String? definition;
  final List<String> examples;
  final String? audioUrl;
  final String? category;
  final String? difficultyLevel;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isSynced;
  final String? serverId;

  const FavoriteWord({
    required this.id,
    required this.word,
    required this.translation,
    required this.language,
    this.pronunciation,
    this.definition,
    this.examples = const [],
    this.audioUrl,
    this.category,
    this.difficultyLevel,
    required this.createdAt,
    required this.updatedAt,
    this.isSynced = false,
    this.serverId,
  });

  // Factory constructor from JSON (server response)
  factory FavoriteWord.fromJson(Map<String, dynamic> json) {
    return FavoriteWord(
      id: json['id'] ?? '',
      word: json['word'] ?? '',
      translation: json['translation'] ?? '',
      language: json['language'] ?? '',
      pronunciation: json['pronunciation'],
      definition: json['definition'],
      examples: json['examples'] != null 
          ? List<String>.from(json['examples'])
          : [],
      audioUrl: json['audioUrl'],
      category: json['category'],
      difficultyLevel: json['difficultyLevel'],
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
      isSynced: json['isSynced'] ?? true,
      serverId: json['serverId'] ?? json['id'],
    );
  }

  // Factory constructor from local database
  factory FavoriteWord.fromLocalDb(Map<String, dynamic> map) {
    return FavoriteWord(
      id: map['id'] ?? '',
      word: map['word'] ?? '',
      translation: map['translation'] ?? '',
      language: map['language'] ?? '',
      pronunciation: map['pronunciation'],
      definition: map['definition'],
      examples: map['examples'] != null 
          ? List<String>.from(map['examples'].split(',').where((e) => e.isNotEmpty))
          : [],
      audioUrl: map['audio_url'],
      category: map['category'],
      difficultyLevel: map['difficulty_level'],
      createdAt: map['created_at'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(map['created_at'])
          : DateTime.now(),
      updatedAt: map['updated_at'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(map['updated_at'])
          : DateTime.now(),
      isSynced: (map['is_synced'] ?? 0) == 1,
      serverId: map['server_id'],
    );
  }

  // Convert to JSON for server requests
  Map<String, dynamic> toJson() {
    return {
      'id': serverId ?? id,
      'word': word,
      'translation': translation,
      'language': language,
      'pronunciation': pronunciation,
      'definition': definition,
      'examples': examples,
      'audioUrl': audioUrl,
      'category': category,
      'difficultyLevel': difficultyLevel,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Convert to local database format
  Map<String, dynamic> toLocalDb() {
    return {
      'id': id,
      'word': word,
      'translation': translation,
      'language': language,
      'pronunciation': pronunciation,
      'definition': definition,
      'examples': examples.join(','),
      'audio_url': audioUrl,
      'category': category,
      'difficulty_level': difficultyLevel,
      'created_at': createdAt.millisecondsSinceEpoch,
      'updated_at': updatedAt.millisecondsSinceEpoch,
      'is_synced': isSynced ? 1 : 0,
      'server_id': serverId,
    };
  }

  // Copy with method for immutable updates
  FavoriteWord copyWith({
    String? id,
    String? word,
    String? translation,
    String? language,
    String? pronunciation,
    String? definition,
    List<String>? examples,
    String? audioUrl,
    String? category,
    String? difficultyLevel,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isSynced,
    String? serverId,
  }) {
    return FavoriteWord(
      id: id ?? this.id,
      word: word ?? this.word,
      translation: translation ?? this.translation,
      language: language ?? this.language,
      pronunciation: pronunciation ?? this.pronunciation,
      definition: definition ?? this.definition,
      examples: examples ?? this.examples,
      audioUrl: audioUrl ?? this.audioUrl,
      category: category ?? this.category,
      difficultyLevel: difficultyLevel ?? this.difficultyLevel,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
      serverId: serverId ?? this.serverId,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is FavoriteWord &&
        other.id == id &&
        other.word == word &&
        other.translation == translation &&
        other.language == language;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        word.hashCode ^
        translation.hashCode ^
        language.hashCode;
  }

  @override
  String toString() {
    return 'FavoriteWord(id: $id, word: $word, translation: $translation, language: $language)';
  }
}