enum RegisterInfoError {
  noError,
  emptyUsername,
  badUsername,
  tooShortPassword,
  differentPassword,
  tooSimplePassword,
  badPhoneNumber,
  badEmail,
}

class RegisterInfoCheck {
  static RegisterInfoError offlineCheck(
      String username, String password, String rePassword,
      {String? phoneNumber, String? email}) {
    if (username.isEmpty) {
      return RegisterInfoError.emptyUsername;
    }
    if (!username.contains(RegExp(r'^(?![0-9]+$)[a-zA-Z0-9]{2,}$'))) {
      return RegisterInfoError.badUsername;
    }
    if (rePassword != password) {
      return RegisterInfoError.differentPassword;
    }
    if (password.length < 8) {
      return RegisterInfoError.tooShortPassword;
    }
    if (!password
        .contains(RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$'))) {
      return RegisterInfoError.tooSimplePassword;
    }
    if (phoneNumber != null &&
        phoneNumber.contains(RegExp(r'^[1][3-9][0-9]{9}$'))) {
      return RegisterInfoError.badPhoneNumber;
    }
    if (email != null &&
        email.contains(RegExp(
            r'^[A-Za-z0-9\u4e00-\u9fa5]+@[a-zA-Z0-9_-]+(.[a-zA-Z0-9_-]+)+$'))) {
      return RegisterInfoError.badEmail;
    }
    return RegisterInfoError.noError;
  }

  static Map<RegisterInfoError, String> errorText = {
    RegisterInfoError.noError: "无错误",
    RegisterInfoError.emptyUsername: "用户名为空",
    RegisterInfoError.badUsername: "用户名长度应大于2，不能为纯数字且不能包含特殊字符",
    RegisterInfoError.tooShortPassword: "密码过短",
    RegisterInfoError.tooSimplePassword: "密码过于简单，需要包含至少一个数字、小写和大写的字母",
    RegisterInfoError.badPhoneNumber: "不正确的手机号格式",
    RegisterInfoError.badEmail: "不正确的电子邮箱格式",
  };
}
