//An object of this class can generally be thrown when a constructor is passed illegal arguments
class IllegalInitializationException implements Exception {
  String cause;
  IllegalInitializationException(this.cause);
}

//An object of this class is generally thrown when the developer makes an illegal request
class IllegalRequestException implements Exception {
  String request;
  IllegalRequestException(this.request);
}

//Object of this class thrown when the board being parsed has no valid solutions.
class UnsolvableBoardException implements Exception {
  String cause;
  UnsolvableBoardException(this.cause);
}
