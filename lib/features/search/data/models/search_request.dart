class SearchRequest {
  final String query;

  const SearchRequest({required this.query});

  factory SearchRequest.fromJson(Map<String, dynamic> json) {
    return SearchRequest(query: json['query'] as String);
  }

  Map<String, dynamic> toJson() {
    return {'query': query};
  }
}
