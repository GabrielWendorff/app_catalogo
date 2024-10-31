class AppModel {
  String id;
  String title;
  String description;
  String category;

  AppModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
  });

  factory AppModel.fromMap(Map<String, dynamic> data, String documentId) {
    return AppModel(
      id: documentId,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      category: data['category'] ?? 'Outros',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'category': category,
    };
  }
}
