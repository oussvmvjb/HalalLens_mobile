// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'HalalLens';

  @override
  String get login => 'Log in';

  @override
  String get profile => 'Profile';

  @override
  String get navHome => 'Home';

  @override
  String get navScanner => 'Scanner';

  @override
  String get navAnalysis => 'Analysis';

  @override
  String get navHistory => 'History';

  @override
  String get navSettings => 'Settings';

  @override
  String get homeWelcome => 'Fresh choices, made simple.';

  @override
  String homeGreeting(String name) {
    return 'Welcome back, $name';
  }

  @override
  String get homeSubtitle => 'Scan a product to explore its ingredients and evidence.';

  @override
  String get homeScanAction => 'Scan a product';

  @override
  String get homeRecentScans => 'Recent scans';

  @override
  String get homeNoRecentScans => 'Your recent scans will appear here.';

  @override
  String get homeExplore => 'Explore';

  @override
  String get homeViewHistory => 'View scan history';

  @override
  String get homeIngredientAnalysis => 'Ingredient analysis';

  @override
  String get homeProductDetails => 'Product details';

  @override
  String get homeSessionError => 'We couldn\'t check your account session.';

  @override
  String get authLoginTitle => 'Welcome back';

  @override
  String get authSignupTitle => 'Create your account';

  @override
  String get authLoginHeading => 'Log in to HalalLens';

  @override
  String get authSignupHeading => 'Sign up for HalalLens';

  @override
  String get authLoginDescription => 'Log in to view your account profile.';

  @override
  String get authSignupDescription => 'Create an account to save your profile and scans.';

  @override
  String get fullName => 'Full name';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm password';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get passwordRecoveryUnavailable => 'Password recovery is not available yet. Please contact support.';

  @override
  String get passwordHelper => 'Use at least 12 characters.';

  @override
  String get showPassword => 'Show password';

  @override
  String get hidePassword => 'Hide password';

  @override
  String get createAccount => 'Create account';

  @override
  String get newToHalalLens => 'New to HalalLens? Sign up';

  @override
  String get alreadyHaveAccount => 'Already have an account? Log in';

  @override
  String get enterName => 'Enter your name';

  @override
  String get enterValidEmail => 'Enter a valid email address';

  @override
  String get enterPassword => 'Enter your password';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match.';

  @override
  String get passwordTooShort => 'Password must be at least 12 characters';

  @override
  String get networkError => 'Could not reach the API. Check your internet connection and try again.';

  @override
  String get requestTimeout => 'The server took too long to respond. Check the backend and try again.';

  @override
  String get serverError => 'The server could not process the request. Check the backend logs and try again.';

  @override
  String get invalidCredentials => 'The email or password is incorrect.';

  @override
  String get emailAlreadyRegistered => 'An account with this email already exists.';

  @override
  String get invalidRequest => 'Some information is invalid. Please check and try again.';

  @override
  String get requestFailed => 'The request could not be completed. Please try again.';

  @override
  String get scannerTitle => 'Food scanner';

  @override
  String get scannerDescription => 'Choose a product label image to extract its printed text.';

  @override
  String get uploadingOcr => 'Uploading your product image...';

  @override
  String get preparingOcr => 'Preparing the scanner...';

  @override
  String get processingOcr => 'Reading the product label...';

  @override
  String get processingOcrSlow => 'This is taking a little longer than usual. Please wait...';

  @override
  String get ocrSuccess => 'Product text extracted successfully!';

  @override
  String get ocrGenericError => 'We couldn\'t read this image. Please try again.';

  @override
  String get ocrRequestInvalid => 'The scan request is incomplete. Please choose the image again.';

  @override
  String get ocrRateLimited => 'The scanner is busy. Please wait a moment and retry.';

  @override
  String get ocrTimeoutMessage => 'Scanning is taking longer than expected. Please try again.';

  @override
  String get retryAction => 'Retry';

  @override
  String get ocrLanguageLabel => 'OCR language';

  @override
  String get ocrLanguageEnglishFrenchArabic => 'English + French + Arabic';

  @override
  String get ocrLanguageEnglish => 'English';

  @override
  String get ocrLanguageFrench => 'French';

  @override
  String get ocrLanguageArabic => 'Arabic';

  @override
  String get ocrLanguageChineseSimplified => 'Simplified Chinese';

  @override
  String get ocrLanguageChineseEnglish => 'Chinese + English';

  @override
  String get scannerAction => 'Open scanner';

  @override
  String get productTitle => 'Product details';

  @override
  String get productDescription => 'Product details and ingredient evidence will appear here.';

  @override
  String get analysisTitle => 'Ingredient analysis';

  @override
  String get analysisDescription => 'Evidence-based ingredient results will appear here.';

  @override
  String get historyTitle => 'Scan history';

  @override
  String get historyDescription => 'Your saved scan history will appear here.';

  @override
  String get historyEmpty => 'No scans yet. Start by scanning a product.';

  @override
  String get profileTitle => 'Your profile';

  @override
  String get profileLoginPrompt => 'Log in or sign up to view your profile.';

  @override
  String get profileLoginAction => 'Log in or sign up';

  @override
  String get preferredLanguage => 'Preferred language';

  @override
  String get accountStatus => 'Account status';

  @override
  String get active => 'Active';

  @override
  String get inactive => 'Inactive';

  @override
  String get logOut => 'Log out';

  @override
  String get profileSessionError => 'We couldn\'t check your account. Please try again.';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageFrench => 'French';

  @override
  String get languageArabic => 'Arabic';

  @override
  String get languageChinese => 'Simplified Chinese';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsSubtitle => 'Choose how HalalLens looks and feels.';

  @override
  String get languageSettingsTitle => 'App language';

  @override
  String get languageSettingsDescription => 'The language and layout update immediately.';

  @override
  String get languageSaveError => 'The language preference could not be saved.';

  @override
  String get authBackHome => 'Back to home';

  @override
  String get accountButton => 'Account';

  @override
  String get quickActionScanner => 'Scan a product';

  @override
  String get quickActionHistory => 'Scan history';

  @override
  String get quickActionAnalysis => 'Ingredient analysis';

  @override
  String get quickActionProduct => 'Product details';

  @override
  String get takePhoto => 'Take a photo';

  @override
  String get chooseImage => 'Choose an image';

  @override
  String get selectImagePrompt => 'Choose a clear photo of the product label.';

  @override
  String get changeImage => 'Change image';

  @override
  String get scanImage => 'Extract text';

  @override
  String get scanningImage => 'Reading text…';

  @override
  String get imagePreview => 'Selected product image';

  @override
  String get scanResults => 'Extracted text';

  @override
  String get recognizedBlocks => 'Detected text blocks';

  @override
  String get ingredientSuggestions => 'Ingredient suggestions';

  @override
  String get originalOcrText => 'Original OCR';

  @override
  String get normalizedSuggestion => 'Suggested normalization';

  @override
  String get reviewRecommended => 'Please verify this suggestion.';

  @override
  String get ocrWarnings => 'OCR warnings';

  @override
  String normalizationConfidenceLabel(String confidence) {
    return '$confidence% match confidence';
  }

  @override
  String get copyText => 'Copy all text';

  @override
  String get copySuccess => 'Extracted text copied.';

  @override
  String get scanAgain => 'Scan this image again';

  @override
  String get noTextDetected => 'No text was detected. Try a sharper, well-lit photo.';

  @override
  String confidenceLabel(String confidence) {
    return '$confidence% confidence';
  }

  @override
  String get unsupportedImage => 'Choose a JPG, PNG, or WebP image.';

  @override
  String get invalidImage => 'This image could not be read. Choose another image.';

  @override
  String get imageTooLarge => 'The image is too large. Choose an image under 10 MB.';

  @override
  String get ocrUnavailable => 'Text recognition is temporarily unavailable.';

  @override
  String get cameraUnavailable => 'The camera or image picker is unavailable on this device.';

  @override
  String get ocrResponseInvalid => 'The server returned an invalid OCR response.';

  @override
  String get scanBarcode => 'Scan barcode';

  @override
  String get barcodeScannerTitle => 'Scan product barcode';

  @override
  String get barcodeScannerHelp => 'Center a product barcode in the frame. EAN, UPC, and other common product formats are supported.';

  @override
  String get barcodeLookupLoading => 'Looking up product information...';

  @override
  String get barcodeNotFound => 'No product was found for this barcode. Try again or scan the ingredients label.';

  @override
  String get barcodeLookupFailed => 'Product lookup is unavailable. Please try again.';

  @override
  String get barcodeInvalid => 'This barcode is invalid. Please scan it again.';

  @override
  String get barcodeResponseInvalid => 'The server returned invalid product information.';

  @override
  String get cameraPermissionDenied => 'Camera access was denied. Allow camera access in your device settings and try again.';

  @override
  String get cameraUnavailableTryAgain => 'The camera could not be started.';

  @override
  String get cameraTryAgain => 'Try camera again';

  @override
  String get barcodeCameraUnsupported => 'Barcode scanning is not supported on this device.';

  @override
  String get productInformationUnavailable => 'Product information unavailable';

  @override
  String get brandLabel => 'Brand';

  @override
  String get barcodeLabel => 'Barcode';

  @override
  String get ingredientsLabel => 'Ingredients';

  @override
  String get categoriesLabel => 'Categories';

  @override
  String get originLabel => 'Country of origin';

  @override
  String get productLabels => 'Product labels (source data)';

  @override
  String get nutritionLabel => 'Nutrition information';

  @override
  String get certificationsLabel => 'Certifications';

  @override
  String get noIngredientsAvailable => 'No ingredient information is available.';

  @override
  String get noCertificationsAvailable => 'No certification records are available in HalalLens.';

  @override
  String get analysisStatusLabel => 'Halal analysis';

  @override
  String get statusHalal => 'Halal verified';

  @override
  String get statusHaram => 'Haram flag';

  @override
  String get statusDoubtful => 'Doubtful';

  @override
  String get statusUnknown => 'Unknown';

  @override
  String get scanAnotherProduct => 'Scan another product';

  @override
  String get retryLookup => 'Retry lookup';

  @override
  String get scanIngredientsLabel => 'Scan ingredients label';
}
