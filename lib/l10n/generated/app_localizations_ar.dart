// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'HalalLens';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get navHome => 'الرئيسية';

  @override
  String get navScanner => 'الماسح';

  @override
  String get navAnalysis => 'التحليل';

  @override
  String get navHistory => 'السجل';

  @override
  String get navSettings => 'الإعدادات';

  @override
  String get homeWelcome => 'اختيارات طازجة، بكل بساطة.';

  @override
  String homeGreeting(String name) {
    return 'مرحباً بعودتك، $name';
  }

  @override
  String get homeSubtitle => 'امسح منتجاً لاستكشاف مكوناته والأدلة المتعلقة به.';

  @override
  String get homeScanAction => 'امسح منتجاً';

  @override
  String get homeRecentScans => 'عمليات المسح الأخيرة';

  @override
  String get homeNoRecentScans => 'ستظهر عمليات المسح الأخيرة هنا.';

  @override
  String get homeExplore => 'استكشف';

  @override
  String get homeViewHistory => 'عرض سجل المسح';

  @override
  String get homeIngredientAnalysis => 'تحليل المكونات';

  @override
  String get homeProductDetails => 'تفاصيل المنتج';

  @override
  String get homeSessionError => 'تعذر التحقق من جلسة حسابك.';

  @override
  String get authLoginTitle => 'مرحباً بعودتك';

  @override
  String get authSignupTitle => 'أنشئ حسابك';

  @override
  String get authLoginHeading => 'سجل الدخول إلى HalalLens';

  @override
  String get authSignupHeading => 'أنشئ حساباً في HalalLens';

  @override
  String get authLoginDescription => 'سجل الدخول لعرض ملفك الشخصي.';

  @override
  String get authSignupDescription => 'أنشئ حساباً لحفظ ملفك الشخصي وعمليات المسح.';

  @override
  String get fullName => 'الاسم الكامل';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get passwordHelper => 'استخدم 12 حرفاً على الأقل.';

  @override
  String get showPassword => 'إظهار كلمة المرور';

  @override
  String get hidePassword => 'إخفاء كلمة المرور';

  @override
  String get createAccount => 'إنشاء حساب';

  @override
  String get newToHalalLens => 'جديد في HalalLens؟ أنشئ حساباً';

  @override
  String get alreadyHaveAccount => 'لديك حساب بالفعل؟ سجل الدخول';

  @override
  String get enterName => 'أدخل اسمك';

  @override
  String get enterValidEmail => 'أدخل بريداً إلكترونياً صحيحاً';

  @override
  String get enterPassword => 'أدخل كلمة المرور';

  @override
  String get passwordTooShort => 'يجب ألا تقل كلمة المرور عن 12 حرفاً';

  @override
  String get networkError => 'تعذر الاتصال بواجهة API. تحقق من الاتصال وعنوان API. في Flutter Web، تأكد من السماح بأصل الصفحة في إعدادات CORS في FastAPI.';

  @override
  String get requestTimeout => 'استغرق الخادم وقتاً طويلاً للرد. تحقق من الخادم وحاول مجدداً.';

  @override
  String get serverError => 'تعذر على الخادم معالجة الطلب. تحقق من سجلات الخادم وحاول مجدداً.';

  @override
  String get invalidCredentials => 'البريد الإلكتروني أو كلمة المرور غير صحيحة.';

  @override
  String get emailAlreadyRegistered => 'يوجد حساب مسجل بهذا البريد الإلكتروني.';

  @override
  String get invalidRequest => 'بعض المعلومات غير صحيحة. تحقق منها وحاول مجدداً.';

  @override
  String get requestFailed => 'تعذر إكمال الطلب. حاول مجدداً.';

  @override
  String get scannerTitle => 'ماسح الطعام';

  @override
  String get scannerDescription => 'اختر صورة لملصق المنتج لاستخراج النص المطبوع عليه.';

  @override
  String get uploadingOcr => 'جارٍ تحميل صورة المنتج...';

  @override
  String get preparingOcr => 'جارٍ تجهيز الماسح...';

  @override
  String get processingOcr => 'جارٍ قراءة ملصق المنتج...';

  @override
  String get processingOcrSlow => 'يستغرق ذلك وقتاً أطول من المعتاد. يرجى الانتظار...';

  @override
  String get ocrSuccess => 'تم استخراج نص المنتج بنجاح!';

  @override
  String get ocrGenericError => 'تعذر قراءة هذه الصورة. حاول مرة أخرى.';

  @override
  String get ocrRequestInvalid => 'طلب المسح غير مكتمل. يرجى اختيار الصورة مرة أخرى.';

  @override
  String get ocrRateLimited => 'الماسح مشغول. انتظر قليلاً ثم أعد المحاولة.';

  @override
  String get ocrTimeoutMessage => 'استغرق المسح وقتاً أطول من المتوقع. حاول مرة أخرى.';

  @override
  String get retryAction => 'إعادة المحاولة';

  @override
  String get ocrLanguageLabel => 'لغة OCR';

  @override
  String get ocrLanguageEnglishFrenchArabic => 'الإنجليزية + الفرنسية + العربية';

  @override
  String get ocrLanguageEnglish => 'الإنجليزية';

  @override
  String get ocrLanguageFrench => 'الفرنسية';

  @override
  String get ocrLanguageArabic => 'العربية';

  @override
  String get ocrLanguageChineseSimplified => 'الصينية المبسطة';

  @override
  String get ocrLanguageChineseEnglish => 'الصينية + الإنجليزية';

  @override
  String get scannerAction => 'فتح الماسح';

  @override
  String get productTitle => 'تفاصيل المنتج';

  @override
  String get productDescription => 'ستظهر هنا تفاصيل المنتج وأدلة مكوناته.';

  @override
  String get analysisTitle => 'تحليل المكونات';

  @override
  String get analysisDescription => 'ستظهر هنا نتائج المكونات المستندة إلى الأدلة.';

  @override
  String get historyTitle => 'سجل المسح';

  @override
  String get historyDescription => 'ستظهر هنا عمليات المسح المحفوظة.';

  @override
  String get historyEmpty => 'لا توجد عمليات مسح بعد. ابدأ بمسح منتج.';

  @override
  String get profileTitle => 'ملفك الشخصي';

  @override
  String get profileLoginPrompt => 'سجل الدخول أو أنشئ حساباً لعرض ملفك الشخصي.';

  @override
  String get profileLoginAction => 'تسجيل الدخول أو إنشاء حساب';

  @override
  String get preferredLanguage => 'اللغة المفضلة';

  @override
  String get accountStatus => 'حالة الحساب';

  @override
  String get active => 'نشط';

  @override
  String get inactive => 'غير نشط';

  @override
  String get logOut => 'تسجيل الخروج';

  @override
  String get profileSessionError => 'تعذر التحقق من حسابك. حاول مجدداً.';

  @override
  String get languageEnglish => 'الإنجليزية';

  @override
  String get languageFrench => 'الفرنسية';

  @override
  String get languageArabic => 'العربية';

  @override
  String get languageChinese => 'الصينية المبسطة';

  @override
  String get settingsTitle => 'الإعدادات';

  @override
  String get settingsSubtitle => 'اختر طريقة عرض HalalLens.';

  @override
  String get languageSettingsTitle => 'لغة التطبيق';

  @override
  String get languageSettingsDescription => 'تتغير اللغة واتجاه التخطيط فوراً.';

  @override
  String get languageSaveError => 'تعذر حفظ تفضيل اللغة.';

  @override
  String get authBackHome => 'العودة إلى الرئيسية';

  @override
  String get accountButton => 'الحساب';

  @override
  String get quickActionScanner => 'امسح منتجاً';

  @override
  String get quickActionHistory => 'سجل المسح';

  @override
  String get quickActionAnalysis => 'تحليل المكونات';

  @override
  String get quickActionProduct => 'تفاصيل المنتج';

  @override
  String get takePhoto => 'التقاط صورة';

  @override
  String get chooseImage => 'اختيار صورة';

  @override
  String get selectImagePrompt => 'اختر صورة واضحة لملصق المنتج.';

  @override
  String get changeImage => 'تغيير الصورة';

  @override
  String get scanImage => 'استخراج النص';

  @override
  String get scanningImage => 'جارٍ قراءة النص…';

  @override
  String get imagePreview => 'صورة المنتج المحددة';

  @override
  String get scanResults => 'النص المستخرج';

  @override
  String get recognizedBlocks => 'مقاطع النص المكتشفة';

  @override
  String get ingredientSuggestions => 'اقتراحات المكونات';

  @override
  String get originalOcrText => 'النص الأصلي من OCR';

  @override
  String get normalizedSuggestion => 'الاقتراح بعد التطبيع';

  @override
  String get reviewRecommended => 'يرجى التحقق من هذا الاقتراح.';

  @override
  String get ocrWarnings => 'تحذيرات OCR';

  @override
  String normalizationConfidenceLabel(String confidence) {
    return 'ثقة المطابقة $confidence٪';
  }

  @override
  String get copyText => 'نسخ النص كاملاً';

  @override
  String get copySuccess => 'تم نسخ النص المستخرج.';

  @override
  String get scanAgain => 'مسح هذه الصورة مجدداً';

  @override
  String get noTextDetected => 'لم يتم اكتشاف نص. جرب صورة أوضح وبإضاءة جيدة.';

  @override
  String confidenceLabel(String confidence) {
    return 'دقة $confidence٪';
  }

  @override
  String get unsupportedImage => 'اختر صورة بصيغة JPG أو PNG أو WebP.';

  @override
  String get invalidImage => 'تعذرت قراءة هذه الصورة. اختر صورة أخرى.';

  @override
  String get imageTooLarge => 'حجم الصورة كبير جداً. اختر صورة لا يتجاوز حجمها 10 ميغابايت.';

  @override
  String get ocrUnavailable => 'التعرف على النص غير متاح مؤقتاً.';

  @override
  String get cameraUnavailable => 'الكاميرا أو أداة اختيار الصور غير متاحة على هذا الجهاز.';

  @override
  String get ocrResponseInvalid => 'أعاد الخادم استجابة غير صالحة للتعرف على النص.';

  @override
  String get scanBarcode => 'مسح الرمز الشريطي';

  @override
  String get barcodeScannerTitle => 'مسح الرمز الشريطي للمنتج';

  @override
  String get barcodeScannerHelp => 'ضع رمز المنتج في منتصف الإطار. ندعم تنسيقات EAN وUPC وغيرها من الرموز الشائعة.';

  @override
  String get barcodeLookupLoading => 'جارٍ البحث عن معلومات المنتج...';

  @override
  String get barcodeNotFound => 'لم يُعثر على منتج لهذا الرمز. حاول مجدداً أو امسح ملصق المكونات.';

  @override
  String get barcodeLookupFailed => 'البحث عن المنتج غير متاح حالياً. حاول مجدداً.';

  @override
  String get barcodeInvalid => 'هذا الرمز الشريطي غير صالح. يرجى مسحه مرة أخرى.';

  @override
  String get barcodeResponseInvalid => 'أعاد الخادم معلومات منتج غير صالحة.';

  @override
  String get cameraPermissionDenied => 'تم رفض الوصول إلى الكاميرا. اسمح باستخدامها من إعدادات الجهاز ثم حاول مجدداً.';

  @override
  String get cameraUnavailableTryAgain => 'تعذر تشغيل الكاميرا.';

  @override
  String get cameraTryAgain => 'إعادة محاولة تشغيل الكاميرا';

  @override
  String get barcodeCameraUnsupported => 'مسح الرموز الشريطية غير مدعوم على هذا الجهاز.';

  @override
  String get productInformationUnavailable => 'معلومات المنتج غير متاحة';

  @override
  String get brandLabel => 'العلامة التجارية';

  @override
  String get barcodeLabel => 'الرمز الشريطي';

  @override
  String get ingredientsLabel => 'المكونات';

  @override
  String get categoriesLabel => 'الفئات';

  @override
  String get originLabel => 'بلد المنشأ';

  @override
  String get productLabels => 'ملصقات المنتج (بيانات المصدر)';

  @override
  String get nutritionLabel => 'المعلومات الغذائية';

  @override
  String get certificationsLabel => 'الشهادات';

  @override
  String get noIngredientsAvailable => 'لا تتوفر معلومات عن المكونات.';

  @override
  String get noCertificationsAvailable => 'لا توجد شهادات مسجلة في HalalLens.';

  @override
  String get analysisStatusLabel => 'تحليل الحلال';

  @override
  String get statusHalal => 'حلال موثّق';

  @override
  String get statusHaram => 'إشارة إلى الحرام';

  @override
  String get statusDoubtful => 'مشكوك فيه';

  @override
  String get statusUnknown => 'غير معروف';

  @override
  String get scanAnotherProduct => 'مسح منتج آخر';

  @override
  String get retryLookup => 'إعادة البحث';

  @override
  String get scanIngredientsLabel => 'مسح ملصق المكونات';
}
