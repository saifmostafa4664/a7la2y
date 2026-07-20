class AuthErrorMapper {
  AuthErrorMapper._();

  static String mapFirebaseError(String code) {
    switch (code) {
      case 'invalid-phone-number':
        return 'رقم الهاتف غير صالح. تأكد من إدخال رقم صحيح.';
      case 'invalid-verification-code':
        return 'رمز التحقق غير صحيح. حاول مرة أخرى.';
      case 'session-expired':
        return 'انتهت صلاحية رمز التحقق. أعد إرسال الرمز.';
      case 'too-many-requests':
        return 'طلبات كثيرة جداً. حاول مرة أخرى بعد قليل.';
      case 'network-request-failed':
        return 'فشل الاتصال بالشبكة. تحقق من اتصالك بالإنترنت.';
      case 'user-disabled':
        return 'تم تعطيل هذا الحساب. تواصل مع الدعم.';
      case 'operation-not-allowed':
        return 'تسجيل الهاتف غير مفعّل لهذا التطبيق في Firebase. تأكد من تفعيل Phone provider لنفس مشروع Firebase وملف GoogleService-Info.plist الحالي.';
      case 'app-not-authorized':
      case 'invalid-app-credential':
      case 'missing-client-identifier':
        return 'تسجيل الهاتف يحتاج إعداد SHA-1/SHA-256 للتطبيق في Firebase ثم تنزيل ملف google-services.json من جديد.';
      case 'captcha-check-failed':
        return 'فشل التحقق الأمني للهاتف. تأكد من إعدادات Firebase للتطبيق وحاول مرة أخرى.';
      case 'account-exists-with-different-credential':
        return 'يوجد حساب مسجل بهذا البريد بطريقة أخرى.';
      case 'credential-already-in-use':
        return 'هذه البيانات مرتبطة بحساب آخر.';
      case 'sign-in-cancelled':
      case 'cancelled':
        return 'تم إلغاء تسجيل الدخول.';
      case 'web-context-cancelled':
        return 'تم إلغاء عملية التحقق.';
      case 'missing-verification-code':
        return 'لم يتم إدخال رمز التحقق.';
      case 'quota-exceeded':
        return 'تم تجاوز الحد المسموح. حاول لاحقاً.';
      case 'no-internet':
        return 'لا يوجد اتصال بالإنترنت. تحقق من اتصالك.';
      case 'timeout':
        return 'انتهت مهلة الاتصال. حاول مرة أخرى.';
      default:
        return 'حدث خطأ غير متوقع. حاول مرة أخرى.';
    }
  }
}
