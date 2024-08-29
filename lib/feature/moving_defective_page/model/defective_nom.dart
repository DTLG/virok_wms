class DefectiveNom {
  final String nom;
  final String article;
  final String cell;
  final String statusNom;
  final double count;

  DefectiveNom({
    required this.nom,
    required this.article,
    required this.cell,
    required this.statusNom,
    required this.count,
  });

  // Factory constructor to create an instance from JSON
  factory DefectiveNom.fromJson(Map<String, dynamic> json) {
    return DefectiveNom(
      nom: json['nom'] as String,
      article: json['article'] as String,
      cell: json['cell'] as String,
      statusNom: json['status_nom'] as String,
      count: (json['count'] as num).toDouble(),
    );
  }
}
