
abstract class WeatherException implements Exception {
  final String message;

  const WeatherException(this.message);
}

class CityNotFoundException extends WeatherException {
  const CityNotFoundException()
      : super('City not found. Please check the city name.');
}

class NetworkException extends WeatherException {
  const NetworkException()
      : super('Network error. Please check your internet connection.');
}

class RequestTimeoutException extends WeatherException {
  const RequestTimeoutException()
      : super('Request timed out. Please try again.');
}

class WeatherServiceException extends WeatherException {
  const WeatherServiceException()
      : super('Weather service is unavailable. Please try again later.');
}
