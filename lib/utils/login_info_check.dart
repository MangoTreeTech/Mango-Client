enum LoginInfoError { noError, emptyUsername, tooShortPassword }

class LoginInfoCheck {
  static LoginInfoError offlineCheck(String username, String password) {
    if (username.isEmpty) {
      return LoginInfoError.emptyUsername;
    }
    if (password.length < 8) {
      return LoginInfoError.tooShortPassword;
    }
    return LoginInfoError.noError;
  }

  static Map<LoginInfoError, String> errorText = {
    LoginInfoError.noError: "无错误",
    LoginInfoError.emptyUsername: "用户名为空",
    LoginInfoError.tooShortPassword: "密码过短",
  };
}
