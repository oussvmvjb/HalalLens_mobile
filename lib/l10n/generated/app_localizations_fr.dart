// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appName => 'HalalLens';

  @override
  String get login => 'Connexion';

  @override
  String get profile => 'Profil';

  @override
  String get navHome => 'Accueil';

  @override
  String get navScanner => 'Scanner';

  @override
  String get navAnalysis => 'Analyse';

  @override
  String get navHistory => 'Historique';

  @override
  String get navSettings => 'Paramètres';

  @override
  String get homeWelcome => 'Des choix frais, en toute simplicité.';

  @override
  String homeGreeting(String name) {
    return 'Bon retour, $name';
  }

  @override
  String get homeSubtitle => 'Scannez un produit pour découvrir ses ingrédients et les informations associées.';

  @override
  String get homeScanAction => 'Scanner un produit';

  @override
  String get homeRecentScans => 'Scans récents';

  @override
  String get homeNoRecentScans => 'Vos scans récents apparaîtront ici.';

  @override
  String get homeExplore => 'Explorer';

  @override
  String get homeViewHistory => 'Voir l’historique des scans';

  @override
  String get homeIngredientAnalysis => 'Analyse des ingrédients';

  @override
  String get homeProductDetails => 'Détails du produit';

  @override
  String get homeSessionError => 'Impossible de vérifier votre session.';

  @override
  String get authLoginTitle => 'Bon retour';

  @override
  String get authSignupTitle => 'Créer un compte';

  @override
  String get authLoginHeading => 'Se connecter à HalalLens';

  @override
  String get authSignupHeading => 'Créer un compte HalalLens';

  @override
  String get authLoginDescription => 'Connectez-vous pour consulter votre profil.';

  @override
  String get authSignupDescription => 'Créez un compte pour enregistrer votre profil et vos scans.';

  @override
  String get fullName => 'Nom complet';

  @override
  String get email => 'Adresse e-mail';

  @override
  String get password => 'Mot de passe';

  @override
  String get passwordHelper => 'Utilisez au moins 12 caractères.';

  @override
  String get showPassword => 'Afficher le mot de passe';

  @override
  String get hidePassword => 'Masquer le mot de passe';

  @override
  String get createAccount => 'Créer un compte';

  @override
  String get newToHalalLens => 'Nouveau sur HalalLens ? Inscrivez-vous';

  @override
  String get alreadyHaveAccount => 'Vous avez déjà un compte ? Connectez-vous';

  @override
  String get enterName => 'Saisissez votre nom';

  @override
  String get enterValidEmail => 'Saisissez une adresse e-mail valide';

  @override
  String get enterPassword => 'Saisissez votre mot de passe';

  @override
  String get passwordTooShort => 'Le mot de passe doit contenir au moins 12 caractères';

  @override
  String get networkError => 'Impossible de joindre l’API. Vérifiez la connexion et l’URL de l’API. Pour Flutter Web, vérifiez que FastAPI autorise l’origine de cette page dans CORS.';

  @override
  String get requestTimeout => 'Le serveur a mis trop de temps à répondre. Vérifiez le backend et réessayez.';

  @override
  String get serverError => 'Le serveur n’a pas pu traiter la demande. Vérifiez les journaux du backend et réessayez.';

  @override
  String get invalidCredentials => 'L’adresse e-mail ou le mot de passe est incorrect.';

  @override
  String get emailAlreadyRegistered => 'Un compte utilisant cette adresse e-mail existe déjà.';

  @override
  String get invalidRequest => 'Certaines informations sont invalides. Vérifiez-les puis réessayez.';

  @override
  String get requestFailed => 'La demande n’a pas abouti. Veuillez réessayer.';

  @override
  String get scannerTitle => 'Scanner alimentaire';

  @override
  String get scannerDescription => 'Choisissez une photo de l’étiquette pour en extraire le texte imprimé.';

  @override
  String get uploadingOcr => 'Envoi de la photo du produit…';

  @override
  String get preparingOcr => 'Préparation du scanner…';

  @override
  String get processingOcr => 'Lecture de l’étiquette du produit…';

  @override
  String get processingOcrSlow => 'Cela prend un peu plus de temps que prévu. Veuillez patienter…';

  @override
  String get ocrSuccess => 'Le texte du produit a été extrait avec succès !';

  @override
  String get ocrGenericError => 'Impossible de lire cette image. Veuillez réessayer.';

  @override
  String get ocrRequestInvalid => 'La demande de scan est incomplète. Veuillez sélectionner à nouveau l’image.';

  @override
  String get ocrRateLimited => 'Le scanner est occupé. Patientez un instant puis réessayez.';

  @override
  String get ocrTimeoutMessage => 'Le scan prend plus de temps que prévu. Veuillez réessayer.';

  @override
  String get retryAction => 'Réessayer';

  @override
  String get ocrLanguageLabel => 'Langue OCR';

  @override
  String get ocrLanguageEnglishFrenchArabic => 'Anglais + français + arabe';

  @override
  String get ocrLanguageEnglish => 'Anglais';

  @override
  String get ocrLanguageFrench => 'Français';

  @override
  String get ocrLanguageArabic => 'Arabe';

  @override
  String get ocrLanguageChineseSimplified => 'Chinois simplifié';

  @override
  String get ocrLanguageChineseEnglish => 'Chinois + anglais';

  @override
  String get scannerAction => 'Ouvrir le scanner';

  @override
  String get productTitle => 'Détails du produit';

  @override
  String get productDescription => 'Les détails du produit et les informations sur ses ingrédients apparaîtront ici.';

  @override
  String get analysisTitle => 'Analyse des ingrédients';

  @override
  String get analysisDescription => 'Les résultats fondés sur des éléments vérifiables apparaîtront ici.';

  @override
  String get historyTitle => 'Historique des scans';

  @override
  String get historyDescription => 'L’historique de vos scans enregistrés apparaîtra ici.';

  @override
  String get historyEmpty => 'Aucun scan. Commencez par scanner un produit.';

  @override
  String get profileTitle => 'Votre profil';

  @override
  String get profileLoginPrompt => 'Connectez-vous ou créez un compte pour consulter votre profil.';

  @override
  String get profileLoginAction => 'Connexion ou inscription';

  @override
  String get preferredLanguage => 'Langue préférée';

  @override
  String get accountStatus => 'État du compte';

  @override
  String get active => 'Actif';

  @override
  String get inactive => 'Inactif';

  @override
  String get logOut => 'Déconnexion';

  @override
  String get profileSessionError => 'Impossible de vérifier votre compte. Veuillez réessayer.';

  @override
  String get languageEnglish => 'Anglais';

  @override
  String get languageFrench => 'Français';

  @override
  String get languageArabic => 'Arabe';

  @override
  String get languageChinese => 'Chinois simplifié';

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get settingsSubtitle => 'Personnalisez l’apparence de HalalLens.';

  @override
  String get languageSettingsTitle => 'Langue de l’application';

  @override
  String get languageSettingsDescription => 'La langue et la disposition sont mises à jour immédiatement.';

  @override
  String get languageSaveError => 'Impossible d’enregistrer la préférence de langue.';

  @override
  String get authBackHome => 'Retour à l’accueil';

  @override
  String get accountButton => 'Compte';

  @override
  String get quickActionScanner => 'Scanner un produit';

  @override
  String get quickActionHistory => 'Historique des scans';

  @override
  String get quickActionAnalysis => 'Analyse des ingrédients';

  @override
  String get quickActionProduct => 'Détails du produit';

  @override
  String get takePhoto => 'Prendre une photo';

  @override
  String get chooseImage => 'Choisir une image';

  @override
  String get selectImagePrompt => 'Choisissez une photo nette de l’étiquette du produit.';

  @override
  String get changeImage => 'Changer d’image';

  @override
  String get scanImage => 'Extraire le texte';

  @override
  String get scanningImage => 'Lecture du texte…';

  @override
  String get imagePreview => 'Image du produit sélectionnée';

  @override
  String get scanResults => 'Texte extrait';

  @override
  String get recognizedBlocks => 'Blocs de texte détectés';

  @override
  String get ingredientSuggestions => 'Suggestions d’ingrédients';

  @override
  String get originalOcrText => 'Texte OCR d’origine';

  @override
  String get normalizedSuggestion => 'Suggestion normalisée';

  @override
  String get reviewRecommended => 'Veuillez vérifier cette suggestion.';

  @override
  String get ocrWarnings => 'Avertissements OCR';

  @override
  String normalizationConfidenceLabel(String confidence) {
    return 'Correspondance : $confidence %';
  }

  @override
  String get copyText => 'Copier tout le texte';

  @override
  String get copySuccess => 'Le texte extrait a été copié.';

  @override
  String get scanAgain => 'Scanner à nouveau cette image';

  @override
  String get noTextDetected => 'Aucun texte détecté. Essayez une photo plus nette et bien éclairée.';

  @override
  String confidenceLabel(String confidence) {
    return 'Confiance : $confidence %';
  }

  @override
  String get unsupportedImage => 'Choisissez une image JPG, PNG ou WebP.';

  @override
  String get invalidImage => 'Impossible de lire cette image. Choisissez-en une autre.';

  @override
  String get imageTooLarge => 'L’image est trop volumineuse. Choisissez une image de moins de 10 Mo.';

  @override
  String get ocrUnavailable => 'La reconnaissance de texte est temporairement indisponible.';

  @override
  String get cameraUnavailable => 'L’appareil photo ou le sélecteur d’images est indisponible.';

  @override
  String get ocrResponseInvalid => 'Le serveur a renvoyé une réponse OCR invalide.';

  @override
  String get scanBarcode => 'Scanner le code-barres';

  @override
  String get barcodeScannerTitle => 'Scanner le code-barres d’un produit';

  @override
  String get barcodeScannerHelp => 'Placez le code-barres du produit au centre du cadre. Les formats EAN, UPC et d’autres formats courants sont pris en charge.';

  @override
  String get barcodeLookupLoading => 'Recherche des informations du produit…';

  @override
  String get barcodeNotFound => 'Aucun produit ne correspond à ce code-barres. Réessayez ou scannez la liste des ingrédients.';

  @override
  String get barcodeLookupFailed => 'La recherche du produit est indisponible. Veuillez réessayer.';

  @override
  String get barcodeInvalid => 'Ce code-barres est invalide. Veuillez le scanner à nouveau.';

  @override
  String get barcodeResponseInvalid => 'Le serveur a renvoyé des informations produit invalides.';

  @override
  String get cameraPermissionDenied => 'L’accès à l’appareil photo a été refusé. Autorisez-le dans les paramètres de l’appareil puis réessayez.';

  @override
  String get cameraUnavailableTryAgain => 'Impossible de démarrer l’appareil photo.';

  @override
  String get cameraTryAgain => 'Réessayer l’appareil photo';

  @override
  String get barcodeCameraUnsupported => 'La lecture des codes-barres n’est pas prise en charge sur cet appareil.';

  @override
  String get productInformationUnavailable => 'Informations produit indisponibles';

  @override
  String get brandLabel => 'Marque';

  @override
  String get barcodeLabel => 'Code-barres';

  @override
  String get ingredientsLabel => 'Ingrédients';

  @override
  String get categoriesLabel => 'Catégories';

  @override
  String get originLabel => 'Pays d’origine';

  @override
  String get productLabels => 'Mentions du produit (données de la source)';

  @override
  String get nutritionLabel => 'Informations nutritionnelles';

  @override
  String get certificationsLabel => 'Certifications';

  @override
  String get noIngredientsAvailable => 'Aucune information sur les ingrédients n’est disponible.';

  @override
  String get noCertificationsAvailable => 'Aucune certification n’est enregistrée dans HalalLens.';

  @override
  String get analysisStatusLabel => 'Analyse halal';

  @override
  String get statusHalal => 'Halal vérifié';

  @override
  String get statusHaram => 'Signalement haram';

  @override
  String get statusDoubtful => 'Douteux';

  @override
  String get statusUnknown => 'Inconnu';

  @override
  String get scanAnotherProduct => 'Scanner un autre produit';

  @override
  String get retryLookup => 'Réessayer la recherche';

  @override
  String get scanIngredientsLabel => 'Scanner la liste des ingrédients';
}
