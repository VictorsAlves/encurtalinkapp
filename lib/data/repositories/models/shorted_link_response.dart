class ShortedLinkResponse {
  final String url;

  const ShortedLinkResponse({required this.url});

  factory ShortedLinkResponse.fromJson(Map<String, dynamic> json) {
    return ShortedLinkResponse(url: json['url'] ?? '');
  }

}
