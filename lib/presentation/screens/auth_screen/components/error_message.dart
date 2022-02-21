import 'package:shop_app/modals/http_exception.dart';

String getErrorMessage(HttpException error){
  String errorMessage = "Authentication Failed";
  if (error.toString().contains("EMAIL_EXISTS")) {
    errorMessage = 'This email address is already in use';
  } else if (error.toString().contains("INVALID_EMAIL")) {
    errorMessage = "This is not a valid email address";
  } else if (error.toString().contains("WEAK_PASSWORD")) {
    errorMessage = "This password is too weak";
  } else if (error.toString().contains("EMAIL_NOT_FOUND")) {
    errorMessage = "Couldn't find the user with this email address";
  } else if (error.toString().contains("INVALID_PASSWORD")) {
    errorMessage = "Invalid Password";
  }
  return errorMessage;
}