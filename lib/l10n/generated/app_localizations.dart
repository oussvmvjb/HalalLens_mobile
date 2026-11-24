import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('fr'),
    Locale('zh'),
    Locale('zh', 'CN')
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'HalalLens'**
  String get appName;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get login;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navScanner.
  ///
  /// In en, this message translates to:
  /// **'Scanner'**
  String get navScanner;

  /// No description provided for @navAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Analysis'**
  String get navAnalysis;

  /// No description provided for @navHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get navHistory;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @homeWelcome.
  ///
  /// In en, this message translates to:
  /// **'Fresh choices, made simple.'**
  String get homeWelcome;

  /// No description provided for @homeGreeting.
  ///
  /// In en, this message translates to:
  /// **'Welcome back, {name}'**
  String homeGreeting(String name);

  /// No description provided for @homeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Scan a product to explore its ingredients and evidence.'**
  String get homeSubtitle;

  /// No description provided for @homeScanAction.
  ///
  /// In en, this message translates to:
  /// **'Scan a product'**
  String get homeScanAction;

  /// No description provided for @homeRecentScans.
  ///
  /// In en, this message translates to:
  /// **'Recent scans'**
  String get homeRecentScans;

  /// No description provided for @homeNoRecentScans.
  ///
  /// In en, this message translates to:
  /// **'Your recent scans will appear here.'**
  String get homeNoRecentScans;

  /// No description provided for @homeExplore.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get homeExplore;

  /// No description provided for @homeViewHistory.
  ///
  /// In en, this message translates to:
  /// **'View scan history'**
  String get homeViewHistory;

  /// No description provided for @homeIngredientAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Ingredient analysis'**
  String get homeIngredientAnalysis;

  /// No description provided for @homeProductDetails.
  ///
  /// In en, this message translates to:
  /// **'Product details'**
  String get homeProductDetails;

  /// No description provided for @homeSessionError.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t check your account session.'**
  String get homeSessionError;

  /// No description provided for @authLoginTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get authLoginTitle;

  /// No description provided for @authSignupTitle.
  ///
  /// In en, this message translates to:
  /// **'Create your account'**
  String get authSignupTitle;

  /// No description provided for @authLoginHeading.
  ///
  /// In en, this message translates to:
  /// **'Log in to HalalLens'**
  String get authLoginHeading;

  /// No description provided for @authSignupHeading.
  ///
  /// In en, this message translates to:
  /// **'Sign up for HalalLens'**
  String get authSignupHeading;

  /// No description provided for @authLoginDescription.
  ///
  /// In en, this message translates to:
  /// **'Log in to view your account profile.'**
  String get authLoginDescription;

  /// No description provided for @authSignupDescription.
  ///
  /// In en, this message translates to:
  /// **'Create an account to save your profile and scans.'**
  String get authSignupDescription;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get fullName;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @passwordHelper.
  ///
  /// In en, this message translates to:
  /// **'Use at least 12 characters.'**
  String get passwordHelper;

  /// No description provided for @showPassword.
  ///
  /// In en, this message translates to:
  /// **'Show password'**
  String get showPassword;

  /// No description provided for @hidePassword.
  ///
  /// In en, this message translates to:
  /// **'Hide password'**
  String get hidePassword;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get createAccount;

  /// No description provided for @newToHalalLens.
  ///
  /// In en, this message translates to:
  /// **'New to HalalLens? Sign up'**
  String get newToHalalLens;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Log in'**
  String get alreadyHaveAccount;

  /// No description provided for @enterName.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get enterName;

  /// No description provided for @enterValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address'**
  String get enterValidEmail;

  /// No description provided for @enterPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterPassword;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 12 characters'**
  String get passwordTooShort;

  /// No description provided for @networkError.
  ///
  /// In en, this message translates to:
  /// **'Could not reach the API. Check the connection and API URL. For Flutter Web, make sure FastAPI allows this page\'s origin in CORS.'**
  String get networkError;

  /// No description provided for @requestTimeout.
  ///
  /// In en, this message translates to:
  /// **'The server took too long to respond. Check the backend and try again.'**
  String get requestTimeout;

  /// No description provided for @serverError.
  ///
  /// In en, this message translates to:
  /// **'The server could not process the request. Check the backend logs and try again.'**
  String get serverError;

  /// No description provided for @invalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'The email or password is incorrect.'**
  String get invalidCredentials;

  /// No description provided for @emailAlreadyRegistered.
  ///
  /// In en, this message translates to:
  /// **'An account with this email already exists.'**
  String get emailAlreadyRegistered;

  /// No description provided for @invalidRequest.
  ///
  /// In en, this message translates to:
  /// **'Some information is invalid. Please check and try again.'**
  String get invalidRequest;

  /// No description provided for @requestFailed.
  ///
  /// In en, this message translates to:
  /// **'The request could not be completed. Please try again.'**
  String get requestFailed;

  /// No description provided for @scannerTitle.
  ///
  /// In en, this message translates to:
  /// **'Food scanner'**
  String get scannerTitle;

  /// No description provided for @scannerDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose a product label image to extract its printed text.'**
  String get scannerDescription;

  /// No description provided for @uploadingOcr.
  ///
  /// In en, this message translates to:
  /// **'Uploading your product image...'**
  String get uploadingOcr;

  /// No description provided for @preparingOcr.
  ///
  /// In en, this message translates to:
  /// **'Preparing the scanner...'**
  String get preparingOcr;

  /// No description provided for @processingOcr.
  ///
  /// In en, this message translates to:
  /// **'Reading the product label...'**
  String get processingOcr;

  /// No description provided for @processingOcrSlow.
  ///
  /// In en, this message translates to:
  /// **'This is taking a little longer than usual. Please wait...'**
  String get processingOcrSlow;

  /// No description provided for @ocrSuccess.
  ///
  /// In en, this message translates to:
  /// **'Product text extracted successfully!'**
  String get ocrSuccess;

  /// No description provided for @ocrGenericError.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t read this image. Please try again.'**
  String get ocrGenericError;

  /// No description provided for @ocrRequestInvalid.
  ///
  /// In en, this message translates to:
  /// **'The scan request is incomplete. Please choose the image again.'**
  String get ocrRequestInvalid;

  /// No description provided for @ocrRateLimited.
  ///
  /// In en, this message translates to:
  /// **'The scanner is busy. Please wait a moment and retry.'**
  String get ocrRateLimited;

  /// No description provided for @ocrTimeoutMessage.
  ///
  /// In en, this message translates to:
  /// **'Scanning is taking longer than expected. Please try again.'**
  String get ocrTimeoutMessage;

  /// No description provided for @retryAction.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retryAction;

  /// No description provided for @ocrLanguageLabel.
  ///
  /// In en, this message translates to:
  /// **'OCR language'**
  String get ocrLanguageLabel;

  /// No description provided for @ocrLanguageEnglishFrenchArabic.
  ///
  /// In en, this message translates to:
  /// **'English + French + Arabic'**
  String get ocrLanguageEnglishFrenchArabic;

  /// No description provided for @ocrLanguageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get ocrLanguageEnglish;

  /// No description provided for @ocrLanguageFrench.
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get ocrLanguageFrench;

  /// No description provided for @ocrLanguageArabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get ocrLanguageArabic;

  /// No description provided for @ocrLanguageChineseSimplified.
  ///
  /// In en, this message translates to:
  /// **'Simplified Chinese'**
  String get ocrLanguageChineseSimplified;

  /// No description provided for @ocrLanguageChineseEnglish.
  ///
  /// In en, this message translates to:
  /// **'Chinese + English'**
  String get ocrLanguageChineseEnglish;

  /// No description provided for @scannerAction.
  ///
  /// In en, this message translates to:
  /// **'Open scanner'**
  String get scannerAction;

  /// No description provided for @productTitle.
  ///
  /// In en, this message translates to:
  /// **'Product details'**
  String get productTitle;

  /// No description provided for @productDescription.
  ///
  /// In en, this message translates to:
  /// **'Product details and ingredient evidence will appear here.'**
  String get productDescription;

  /// No description provided for @analysisTitle.
  ///
  /// In en, this message translates to:
  /// **'Ingredient analysis'**
  String get analysisTitle;

  /// No description provided for @analysisDescription.
  ///
  /// In en, this message translates to:
  /// **'Evidence-based ingredient results will appear here.'**
  String get analysisDescription;

  /// No description provided for @historyTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan history'**
  String get historyTitle;

  /// No description provided for @historyDescription.
  ///
  /// In en, this message translates to:
  /// **'Your saved scan history will appear here.'**
  String get historyDescription;

  /// No description provided for @historyEmpty.
  ///
  /// In en, this message translates to:
  /// **'No scans yet. Start by scanning a product.'**
  String get historyEmpty;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Your profile'**
  String get profileTitle;

  /// No description provided for @profileLoginPrompt.
  ///
  /// In en, this message translates to:
  /// **'Log in or sign up to view your profile.'**
  String get profileLoginPrompt;

  /// No description provided for @profileLoginAction.
  ///
  /// In en, this message translates to:
  /// **'Log in or sign up'**
  String get profileLoginAction;

  /// No description provided for @preferredLanguage.
  ///
  /// In en, this message translates to:
  /// **'Preferred language'**
  String get preferredLanguage;

  /// No description provided for @accountStatus.
  ///
  /// In en, this message translates to:
  /// **'Account status'**
  String get accountStatus;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @inactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get inactive;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logOut;

  /// No description provided for @profileSessionError.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t check your account. Please try again.'**
  String get profileSessionError;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageFrench.
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get languageFrench;

  /// No description provided for @languageArabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get languageArabic;

  /// No description provided for @languageChinese.
  ///
  /// In en, this message translates to:
  /// **'Simplified Chinese'**
  String get languageChinese;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose how HalalLens looks and feels.'**
  String get settingsSubtitle;

  /// No description provided for @languageSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'App language'**
  String get languageSettingsTitle;

  /// No description provided for @languageSettingsDescription.
  ///
  /// In en, this message translates to:
  /// **'The language and layout update immediately.'**
  String get languageSettingsDescription;

  /// No description provided for @languageSaveError.
  ///
  /// In en, this message translates to:
  /// **'The language preference could not be saved.'**
  String get languageSaveError;

  /// No description provided for @authBackHome.
  ///
  /// In en, this message translates to:
  /// **'Back to home'**
  String get authBackHome;

  /// No description provided for @accountButton.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get accountButton;

  /// No description provided for @quickActionScanner.
  ///
  /// In en, this message translates to:
  /// **'Scan a product'**
  String get quickActionScanner;

  /// No description provided for @quickActionHistory.
  ///
  /// In en, this message translates to:
  /// **'Scan history'**
  String get quickActionHistory;

  /// No description provided for @quickActionAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Ingredient analysis'**
  String get quickActionAnalysis;

  /// No description provided for @quickActionProduct.
  ///
  /// In en, this message translates to:
  /// **'Product details'**
  String get quickActionProduct;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take a photo'**
  String get takePhoto;

  /// No description provided for @chooseImage.
  ///
  /// In en, this message translates to:
  /// **'Choose an image'**
  String get chooseImage;

  /// No description provided for @selectImagePrompt.
  ///
  /// In en, this message translates to:
  /// **'Choose a clear photo of the product label.'**
  String get selectImagePrompt;

  /// No description provided for @changeImage.
  ///
  /// In en, this message translates to:
  /// **'Change image'**
  String get changeImage;

  /// No description provided for @scanImage.
  ///
  /// In en, this message translates to:
  /// **'Extract text'**
  String get scanImage;

  /// No description provided for @scanningImage.
  ///
  /// In en, this message translates to:
  /// **'Reading text…'**
  String get scanningImage;

  /// No description provided for @imagePreview.
  ///
  /// In en, this message translates to:
  /// **'Selected product image'**
  String get imagePreview;

  /// No description provided for @scanResults.
  ///
  /// In en, this message translates to:
  /// **'Extracted text'**
  String get scanResults;

  /// No description provided for @recognizedBlocks.
  ///
  /// In en, this message translates to:
  /// **'Detected text blocks'**
  String get recognizedBlocks;

  /// No description provided for @ingredientSuggestions.
  ///
  /// In en, this message translates to:
  /// **'Ingredient suggestions'**
  String get ingredientSuggestions;

  /// No description provided for @originalOcrText.
  ///
  /// In en, this message translates to:
  /// **'Original OCR'**
  String get originalOcrText;

  /// No description provided for @normalizedSuggestion.
  ///
  /// In en, this message translates to:
  /// **'Suggested normalization'**
  String get normalizedSuggestion;

  /// No description provided for @reviewRecommended.
  ///
  /// In en, this message translates to:
  /// **'Please verify this suggestion.'**
  String get reviewRecommended;

  /// No description provided for @ocrWarnings.
  ///
  /// In en, this message translates to:
  /// **'OCR warnings'**
  String get ocrWarnings;

  /// No description provided for @normalizationConfidenceLabel.
  ///
  /// In en, this message translates to:
  /// **'{confidence}% match confidence'**
  String normalizationConfidenceLabel(String confidence);

  /// No description provided for @copyText.
  ///
  /// In en, this message translates to:
  /// **'Copy all text'**
  String get copyText;

  /// No description provided for @copySuccess.
  ///
  /// In en, this message translates to:
  /// **'Extracted text copied.'**
  String get copySuccess;

  /// No description provided for @scanAgain.
  ///
  /// In en, this message translates to:
  /// **'Scan this image again'**
  String get scanAgain;

  /// No description provided for @noTextDetected.
  ///
  /// In en, this message translates to:
  /// **'No text was detected. Try a sharper, well-lit photo.'**
  String get noTextDetected;

  /// No description provided for @confidenceLabel.
  ///
  /// In en, this message translates to:
  /// **'{confidence}% confidence'**
  String confidenceLabel(String confidence);

  /// No description provided for @unsupportedImage.
  ///
  /// In en, this message translates to:
  /// **'Choose a JPG, PNG, or WebP image.'**
  String get unsupportedImage;

  /// No description provided for @invalidImage.
  ///
  /// In en, this message translates to:
  /// **'This image could not be read. Choose another image.'**
  String get invalidImage;

  /// No description provided for @imageTooLarge.
  ///
  /// In en, this message translates to:
  /// **'The image is too large. Choose an image under 10 MB.'**
  String get imageTooLarge;

  /// No description provided for @ocrUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Text recognition is temporarily unavailable.'**
  String get ocrUnavailable;

  /// No description provided for @cameraUnavailable.
  ///
  /// In en, this message translates to:
  /// **'The camera or image picker is unavailable on this device.'**
  String get cameraUnavailable;

  /// No description provided for @ocrResponseInvalid.
  ///
  /// In en, this message translates to:
  /// **'The server returned an invalid OCR response.'**
  String get ocrResponseInvalid;

  /// No description provided for @scanBarcode.
  ///
  /// In en, this message translates to:
  /// **'Scan barcode'**
  String get scanBarcode;

  /// No description provided for @barcodeScannerTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan product barcode'**
  String get barcodeScannerTitle;

  /// No description provided for @barcodeScannerHelp.
  ///
  /// In en, this message translates to:
  /// **'Center a product barcode in the frame. EAN, UPC, and other common product formats are supported.'**
  String get barcodeScannerHelp;

  /// No description provided for @barcodeLookupLoading.
  ///
  /// In en, this message translates to:
  /// **'Looking up product information...'**
  String get barcodeLookupLoading;

  /// No description provided for @barcodeNotFound.
  ///
  /// In en, this message translates to:
  /// **'No product was found for this barcode. Try again or scan the ingredients label.'**
  String get barcodeNotFound;

  /// No description provided for @barcodeLookupFailed.
  ///
  /// In en, this message translates to:
  /// **'Product lookup is unavailable. Please try again.'**
  String get barcodeLookupFailed;

  /// No description provided for @barcodeInvalid.
  ///
  /// In en, this message translates to:
  /// **'This barcode is invalid. Please scan it again.'**
  String get barcodeInvalid;

  /// No description provided for @barcodeResponseInvalid.
  ///
  /// In en, this message translates to:
  /// **'The server returned invalid product information.'**
  String get barcodeResponseInvalid;

  /// No description provided for @cameraPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Camera access was denied. Allow camera access in your device settings and try again.'**
  String get cameraPermissionDenied;

  /// No description provided for @cameraUnavailableTryAgain.
  ///
  /// In en, this message translates to:
  /// **'The camera could not be started.'**
  String get cameraUnavailableTryAgain;

  /// No description provided for @cameraTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try camera again'**
  String get cameraTryAgain;

  /// No description provided for @barcodeCameraUnsupported.
  ///
  /// In en, this message translates to:
  /// **'Barcode scanning is not supported on this device.'**
  String get barcodeCameraUnsupported;

  /// No description provided for @productInformationUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Product information unavailable'**
  String get productInformationUnavailable;

  /// No description provided for @brandLabel.
  ///
  /// In en, this message translates to:
  /// **'Brand'**
  String get brandLabel;

  /// No description provided for @barcodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Barcode'**
  String get barcodeLabel;

  /// No description provided for @ingredientsLabel.
  ///
  /// In en, this message translates to:
  /// **'Ingredients'**
  String get ingredientsLabel;

  /// No description provided for @categoriesLabel.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categoriesLabel;

  /// No description provided for @originLabel.
  ///
  /// In en, this message translates to:
  /// **'Country of origin'**
  String get originLabel;

  /// No description provided for @productLabels.
  ///
  /// In en, this message translates to:
  /// **'Product labels (source data)'**
  String get productLabels;

  /// No description provided for @nutritionLabel.
  ///
  /// In en, this message translates to:
  /// **'Nutrition information'**
  String get nutritionLabel;

  /// No description provided for @certificationsLabel.
  ///
  /// In en, this message translates to:
  /// **'Certifications'**
  String get certificationsLabel;

  /// No description provided for @noIngredientsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No ingredient information is available.'**
  String get noIngredientsAvailable;

  /// No description provided for @noCertificationsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No certification records are available in HalalLens.'**
  String get noCertificationsAvailable;

  /// No description provided for @analysisStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'Halal analysis'**
  String get analysisStatusLabel;

  /// No description provided for @statusHalal.
  ///
  /// In en, this message translates to:
  /// **'Halal verified'**
  String get statusHalal;

  /// No description provided for @statusHaram.
  ///
  /// In en, this message translates to:
  /// **'Haram flag'**
  String get statusHaram;

  /// No description provided for @statusDoubtful.
  ///
  /// In en, this message translates to:
  /// **'Doubtful'**
  String get statusDoubtful;

  /// No description provided for @statusUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get statusUnknown;

  /// No description provided for @scanAnotherProduct.
  ///
  /// In en, this message translates to:
  /// **'Scan another product'**
  String get scanAnotherProduct;

  /// No description provided for @retryLookup.
  ///
  /// In en, this message translates to:
  /// **'Retry lookup'**
  String get retryLookup;

  /// No description provided for @scanIngredientsLabel.
  ///
  /// In en, this message translates to:
  /// **'Scan ingredients label'**
  String get scanIngredientsLabel;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en', 'fr', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {

  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'zh': {
  switch (locale.countryCode) {
    case 'CN': return AppLocalizationsZhCn();
   }
  break;
   }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'en': return AppLocalizationsEn();
    case 'fr': return AppLocalizationsFr();
    case 'zh': return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
