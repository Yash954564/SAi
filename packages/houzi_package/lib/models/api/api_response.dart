class ApiResponse<T> {
  T result;
  bool success;
  String message;
  ApiResponse(this.success, this.result, this.message);

}
