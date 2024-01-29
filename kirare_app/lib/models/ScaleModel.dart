class ScaleModel {
  final String name;
  final String description;
  final String braceletDiagram;
  final String braceletDiagramDescription;
  final String tonnetzDiagramDescription;
  final String youtubeLink;

  ScaleModel({
    required this.name,
    required this.description,
    required this.braceletDiagram,
    required this.braceletDiagramDescription,
    required this.tonnetzDiagramDescription,
    required this.youtubeLink,
  });

  ScaleModel.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        description = json['description'],
        braceletDiagram = json['braceletDiagram'],
        braceletDiagramDescription = json['braceletDiagramDescription'],
        tonnetzDiagramDescription = json['tonnetzDiagramDescription'],
        youtubeLink = json['youtubeLink'];
}
