class FireBaseAuthError {
  static const kGeneralError = "Ha ocurrido un error inesperado";

  static String errorHandled(String error) {
    switch (error) {
      case "wrong-password":
        return "La contraseña introducida no es correcta";

      case "user-not-found":
        return "El usuario no existe";

      case "email-already-in-use":
        return "El email indicado ya está en uso";

      case "weak-password":
        return "La contraseña utilizada es demasiado débil";

      case "ERROR_TOO_MANY_REQUESTS":
        return "Has realizado demasiados intentos";

      case "ERROR_OPERATION_NOT_ALLOWED":
        return "La operación ralizada no está permitida";

      case "USER_DISABLED":
        return "El usuario ha sido deshabilitado";

      case "USER_NOT_FOUND":
        return "El usuario ha sido encontrado";

      case "USER_TOKEN_EXPIRED":
        return "El token de sesión ha expirado";
      case "USER_INVALID_TOKEN":
        return "El token de sesión ha sido invalidado";

      case "ERROR_INVALID_EMAIL":
        return "El email indicado no es válido";

      case "ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL":
        return "La cuenta existe con otras credenciales";

      case "ERROR_CREDENTIAL_ALREADY_IN_USE":
        return "La credencial usada ya se encuentra en uso";

      case "TOO_LONG":
        return "El teléfono introducido es incorrecto";

      case "ERROR_SESSION_EXPIRED":
        return "El código SMS ha expirado";

      default:
        return "Ha ocurrido un error inesperado";
    }
  }
}
