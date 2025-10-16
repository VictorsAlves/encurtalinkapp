class ShortLinkResponse {
  final String alias;
  final String originalUrl;
  final String shortUrl;

  const ShortLinkResponse({
    required this.alias,
    required this.originalUrl,
    required this.shortUrl,
  });

  factory ShortLinkResponse.fromJson(Map<String, dynamic> json) {
    final links = json['_links'] ?? {};
    return ShortLinkResponse(
      alias: json['alias'] ?? '',
      originalUrl: links['self'] ?? '',
      shortUrl: links['short'] ?? '',
    );
  }
}
