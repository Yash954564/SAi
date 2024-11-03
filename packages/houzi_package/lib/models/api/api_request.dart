class ApiRequest<T> {
  Map<String, dynamic> params;
  Uri uri;
  ApiRequest(this.uri, this.params);

}