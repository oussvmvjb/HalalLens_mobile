// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appName => 'HalalLens';

  @override
  String get login => '登录';

  @override
  String get profile => '个人资料';

  @override
  String get navHome => '首页';

  @override
  String get navScanner => '扫描';

  @override
  String get navAnalysis => '分析';

  @override
  String get navHistory => '历史记录';

  @override
  String get navSettings => '设置';

  @override
  String get homeWelcome => '让安心选择更简单。';

  @override
  String homeGreeting(String name) {
    return '欢迎回来，$name';
  }

  @override
  String get homeSubtitle => '扫描产品，查看其配料和相关依据。';

  @override
  String get homeScanAction => '扫描产品';

  @override
  String get homeRecentScans => '最近扫描';

  @override
  String get homeNoRecentScans => '最近扫描的记录会显示在这里。';

  @override
  String get homeExplore => '探索';

  @override
  String get homeViewHistory => '查看扫描历史';

  @override
  String get homeIngredientAnalysis => '配料分析';

  @override
  String get homeProductDetails => '产品详情';

  @override
  String get homeSessionError => '无法检查您的账户会话。';

  @override
  String get authLoginTitle => '欢迎回来';

  @override
  String get authSignupTitle => '创建账户';

  @override
  String get authLoginHeading => '登录 HalalLens';

  @override
  String get authSignupHeading => '注册 HalalLens';

  @override
  String get authLoginDescription => '登录以查看您的个人资料。';

  @override
  String get authSignupDescription => '创建账户以保存个人资料和扫描记录。';

  @override
  String get fullName => '姓名';

  @override
  String get email => '电子邮箱';

  @override
  String get password => '密码';

  @override
  String get confirmPassword => '确认密码';

  @override
  String get forgotPassword => '忘记密码？';

  @override
  String get passwordRecoveryUnavailable => '密码找回功能暂不可用，请联系支持团队。';

  @override
  String get passwordHelper => '请使用至少 12 个字符。';

  @override
  String get showPassword => '显示密码';

  @override
  String get hidePassword => '隐藏密码';

  @override
  String get createAccount => '创建账户';

  @override
  String get newToHalalLens => '还没有 HalalLens 账户？立即注册';

  @override
  String get alreadyHaveAccount => '已有账户？登录';

  @override
  String get enterName => '请输入姓名';

  @override
  String get enterValidEmail => '请输入有效的电子邮箱地址';

  @override
  String get enterPassword => '请输入密码';

  @override
  String get passwordsDoNotMatch => '两次输入的密码不一致。';

  @override
  String get passwordTooShort => '密码至少需要 12 个字符';

  @override
  String get networkError => '无法连接到 API。请检查网络连接后重试。';

  @override
  String get requestTimeout => '服务器响应超时。请检查后端并重试。';

  @override
  String get serverError => '服务器无法处理此请求。请检查后端日志并重试。';

  @override
  String get invalidCredentials => '电子邮箱或密码不正确。';

  @override
  String get emailAlreadyRegistered => '此电子邮箱已注册账户。';

  @override
  String get invalidRequest => '部分信息无效，请检查后重试。';

  @override
  String get requestFailed => '无法完成请求，请重试。';

  @override
  String get scannerTitle => '食品扫描器';

  @override
  String get scannerDescription => '选择产品标签照片以提取上面的文字。';

  @override
  String get uploadingOcr => '正在上传产品图片…';

  @override
  String get preparingOcr => '正在准备扫描器…';

  @override
  String get processingOcr => '正在读取产品标签…';

  @override
  String get processingOcrSlow => '处理时间比平时稍长，请耐心等待…';

  @override
  String get ocrSuccess => '产品文字提取成功！';

  @override
  String get ocrGenericError => '无法读取此图片，请重试。';

  @override
  String get ocrRequestInvalid => '扫描请求不完整，请重新选择图片。';

  @override
  String get ocrRateLimited => '扫描器正忙，请稍等片刻后重试。';

  @override
  String get ocrTimeoutMessage => '扫描时间超出预期，请重试。';

  @override
  String get retryAction => '重试';

  @override
  String get ocrLanguageLabel => 'OCR 识别语言';

  @override
  String get ocrLanguageEnglishFrenchArabic => '英语 + 法语 + 阿拉伯语';

  @override
  String get ocrLanguageEnglish => '英语';

  @override
  String get ocrLanguageFrench => '法语';

  @override
  String get ocrLanguageArabic => '阿拉伯语';

  @override
  String get ocrLanguageChineseSimplified => '简体中文';

  @override
  String get ocrLanguageChineseEnglish => '中文 + 英语';

  @override
  String get scannerAction => '打开扫描器';

  @override
  String get productTitle => '产品详情';

  @override
  String get productDescription => '产品详情和配料依据会显示在这里。';

  @override
  String get analysisTitle => '配料分析';

  @override
  String get analysisDescription => '基于证据的配料分析结果会显示在这里。';

  @override
  String get historyTitle => '扫描历史';

  @override
  String get historyDescription => '已保存的扫描记录会显示在这里。';

  @override
  String get historyEmpty => '暂无扫描记录。请先扫描一个产品。';

  @override
  String get profileTitle => '您的个人资料';

  @override
  String get profileLoginPrompt => '登录或注册以查看个人资料。';

  @override
  String get profileLoginAction => '登录或注册';

  @override
  String get preferredLanguage => '首选语言';

  @override
  String get accountStatus => '账户状态';

  @override
  String get active => '正常';

  @override
  String get inactive => '未启用';

  @override
  String get logOut => '退出登录';

  @override
  String get profileSessionError => '无法检查您的账户，请重试。';

  @override
  String get languageEnglish => '英语';

  @override
  String get languageFrench => '法语';

  @override
  String get languageArabic => '阿拉伯语';

  @override
  String get languageChinese => '简体中文';

  @override
  String get settingsTitle => '设置';

  @override
  String get settingsSubtitle => '选择 HalalLens 的显示语言和布局。';

  @override
  String get languageSettingsTitle => '应用语言';

  @override
  String get languageSettingsDescription => '语言和布局方向会立即更新。';

  @override
  String get languageSaveError => '无法保存语言偏好设置。';

  @override
  String get authBackHome => '返回首页';

  @override
  String get accountButton => '账户';

  @override
  String get quickActionScanner => '扫描产品';

  @override
  String get quickActionHistory => '扫描历史';

  @override
  String get quickActionAnalysis => '配料分析';

  @override
  String get quickActionProduct => '产品详情';

  @override
  String get takePhoto => '拍照';

  @override
  String get chooseImage => '选择图片';

  @override
  String get selectImagePrompt => '请选择清晰的产品标签照片。';

  @override
  String get changeImage => '更换图片';

  @override
  String get scanImage => '提取文字';

  @override
  String get scanningImage => '正在识别文字…';

  @override
  String get imagePreview => '已选择的产品图片';

  @override
  String get scanResults => '提取的文字';

  @override
  String get recognizedBlocks => '识别到的文字区域';

  @override
  String get ingredientSuggestions => '配料建议';

  @override
  String get originalOcrText => 'OCR 原文';

  @override
  String get normalizedSuggestion => '规范化建议';

  @override
  String get reviewRecommended => '请人工核对这项建议。';

  @override
  String get ocrWarnings => 'OCR 提示';

  @override
  String normalizationConfidenceLabel(String confidence) {
    return '匹配置信度：$confidence%';
  }

  @override
  String get copyText => '复制全部文字';

  @override
  String get copySuccess => '已复制提取的文字。';

  @override
  String get scanAgain => '重新扫描此图片';

  @override
  String get noTextDetected => '未识别到文字。请尝试拍摄更清晰、光线更好的照片。';

  @override
  String confidenceLabel(String confidence) {
    return '识别置信度：$confidence%';
  }

  @override
  String get unsupportedImage => '请选择 JPG、PNG 或 WebP 图片。';

  @override
  String get invalidImage => '无法读取此图片，请选择其他图片。';

  @override
  String get imageTooLarge => '图片过大，请选择小于 10 MB 的图片。';

  @override
  String get ocrUnavailable => '文字识别暂时不可用。';

  @override
  String get cameraUnavailable => '此设备上的相机或图片选择器不可用。';

  @override
  String get ocrResponseInvalid => '服务器返回了无效的 OCR 响应。';

  @override
  String get scanBarcode => '扫描条形码';

  @override
  String get barcodeScannerTitle => '扫描产品条形码';

  @override
  String get barcodeScannerHelp => '将产品条形码对准取景框中央。支持 EAN、UPC 等常见产品条码。';

  @override
  String get barcodeLookupLoading => '正在查询产品信息…';

  @override
  String get barcodeNotFound => '未找到此条形码对应的产品。请重试或扫描配料标签。';

  @override
  String get barcodeLookupFailed => '暂时无法查询产品信息，请重试。';

  @override
  String get barcodeInvalid => '条形码无效，请重新扫描。';

  @override
  String get barcodeResponseInvalid => '服务器返回了无效的产品信息。';

  @override
  String get cameraPermissionDenied => '相机权限被拒绝。请在设备设置中允许使用相机后重试。';

  @override
  String get cameraUnavailableTryAgain => '无法启动相机。';

  @override
  String get cameraTryAgain => '重试相机';

  @override
  String get barcodeCameraUnsupported => '此设备不支持条形码扫描。';

  @override
  String get productInformationUnavailable => '产品信息不可用';

  @override
  String get brandLabel => '品牌';

  @override
  String get barcodeLabel => '条形码';

  @override
  String get ingredientsLabel => '配料';

  @override
  String get categoriesLabel => '类别';

  @override
  String get originLabel => '原产国';

  @override
  String get productLabels => '产品标签（来源数据）';

  @override
  String get nutritionLabel => '营养信息';

  @override
  String get certificationsLabel => '认证';

  @override
  String get noIngredientsAvailable => '暂无配料信息。';

  @override
  String get noCertificationsAvailable => 'HalalLens 中没有该产品的认证记录。';

  @override
  String get analysisStatusLabel => '清真分析';

  @override
  String get statusHalal => '已验证清真';

  @override
  String get statusHaram => '存在禁忌标记';

  @override
  String get statusDoubtful => '存疑';

  @override
  String get statusUnknown => '未知';

  @override
  String get scanAnotherProduct => '扫描其他产品';

  @override
  String get retryLookup => '重新查询';

  @override
  String get scanIngredientsLabel => '扫描配料标签';
}

/// The translations for Chinese, as used in China (`zh_CN`).
class AppLocalizationsZhCn extends AppLocalizationsZh {
  AppLocalizationsZhCn(): super('zh_CN');

  @override
  String get appName => 'HalalLens';

  @override
  String get login => '登录';

  @override
  String get profile => '个人资料';

  @override
  String get navHome => '首页';

  @override
  String get navScanner => '扫描';

  @override
  String get navAnalysis => '分析';

  @override
  String get navHistory => '历史记录';

  @override
  String get navSettings => '设置';

  @override
  String get homeWelcome => '让安心选择更简单。';

  @override
  String homeGreeting(String name) {
    return '欢迎回来，$name';
  }

  @override
  String get homeSubtitle => '扫描产品，查看其配料和相关依据。';

  @override
  String get homeScanAction => '扫描产品';

  @override
  String get homeRecentScans => '最近扫描';

  @override
  String get homeNoRecentScans => '最近扫描的记录会显示在这里。';

  @override
  String get homeExplore => '探索';

  @override
  String get homeViewHistory => '查看扫描历史';

  @override
  String get homeIngredientAnalysis => '配料分析';

  @override
  String get homeProductDetails => '产品详情';

  @override
  String get homeSessionError => '无法检查您的账户会话。';

  @override
  String get authLoginTitle => '欢迎回来';

  @override
  String get authSignupTitle => '创建账户';

  @override
  String get authLoginHeading => '登录 HalalLens';

  @override
  String get authSignupHeading => '注册 HalalLens';

  @override
  String get authLoginDescription => '登录以查看您的个人资料。';

  @override
  String get authSignupDescription => '创建账户以保存个人资料和扫描记录。';

  @override
  String get fullName => '姓名';

  @override
  String get email => '电子邮箱';

  @override
  String get password => '密码';

  @override
  String get confirmPassword => '确认密码';

  @override
  String get forgotPassword => '忘记密码？';

  @override
  String get passwordRecoveryUnavailable => '密码找回功能暂不可用，请联系支持团队。';

  @override
  String get passwordHelper => '请使用至少 12 个字符。';

  @override
  String get showPassword => '显示密码';

  @override
  String get hidePassword => '隐藏密码';

  @override
  String get createAccount => '创建账户';

  @override
  String get newToHalalLens => '还没有 HalalLens 账户？立即注册';

  @override
  String get alreadyHaveAccount => '已有账户？登录';

  @override
  String get enterName => '请输入姓名';

  @override
  String get enterValidEmail => '请输入有效的电子邮箱地址';

  @override
  String get enterPassword => '请输入密码';

  @override
  String get passwordsDoNotMatch => '两次输入的密码不一致。';

  @override
  String get passwordTooShort => '密码至少需要 12 个字符';

  @override
  String get networkError => '无法连接到 API。请检查网络连接后重试。';

  @override
  String get requestTimeout => '服务器响应超时。请检查后端并重试。';

  @override
  String get serverError => '服务器无法处理此请求。请检查后端日志并重试。';

  @override
  String get invalidCredentials => '电子邮箱或密码不正确。';

  @override
  String get emailAlreadyRegistered => '此电子邮箱已注册账户。';

  @override
  String get invalidRequest => '部分信息无效，请检查后重试。';

  @override
  String get requestFailed => '无法完成请求，请重试。';

  @override
  String get scannerTitle => '食品扫描器';

  @override
  String get scannerDescription => '选择产品标签照片以提取上面的文字。';

  @override
  String get uploadingOcr => '正在上传产品图片…';

  @override
  String get preparingOcr => '正在准备扫描器…';

  @override
  String get processingOcr => '正在读取产品标签…';

  @override
  String get processingOcrSlow => '处理时间比平时稍长，请耐心等待…';

  @override
  String get ocrSuccess => '产品文字提取成功！';

  @override
  String get ocrGenericError => '无法读取此图片，请重试。';

  @override
  String get ocrRequestInvalid => '扫描请求不完整，请重新选择图片。';

  @override
  String get ocrRateLimited => '扫描器正忙，请稍等片刻后重试。';

  @override
  String get ocrTimeoutMessage => '扫描时间超出预期，请重试。';

  @override
  String get retryAction => '重试';

  @override
  String get ocrLanguageLabel => 'OCR 识别语言';

  @override
  String get ocrLanguageEnglishFrenchArabic => '英语 + 法语 + 阿拉伯语';

  @override
  String get ocrLanguageEnglish => '英语';

  @override
  String get ocrLanguageFrench => '法语';

  @override
  String get ocrLanguageArabic => '阿拉伯语';

  @override
  String get ocrLanguageChineseSimplified => '简体中文';

  @override
  String get ocrLanguageChineseEnglish => '中文 + 英语';

  @override
  String get scannerAction => '打开扫描器';

  @override
  String get productTitle => '产品详情';

  @override
  String get productDescription => '产品详情和配料依据会显示在这里。';

  @override
  String get analysisTitle => '配料分析';

  @override
  String get analysisDescription => '基于证据的配料分析结果会显示在这里。';

  @override
  String get historyTitle => '扫描历史';

  @override
  String get historyDescription => '已保存的扫描记录会显示在这里。';

  @override
  String get historyEmpty => '暂无扫描记录。请先扫描一个产品。';

  @override
  String get profileTitle => '您的个人资料';

  @override
  String get profileLoginPrompt => '登录或注册以查看个人资料。';

  @override
  String get profileLoginAction => '登录或注册';

  @override
  String get preferredLanguage => '首选语言';

  @override
  String get accountStatus => '账户状态';

  @override
  String get active => '正常';

  @override
  String get inactive => '未启用';

  @override
  String get logOut => '退出登录';

  @override
  String get profileSessionError => '无法检查您的账户，请重试。';

  @override
  String get languageEnglish => '英语';

  @override
  String get languageFrench => '法语';

  @override
  String get languageArabic => '阿拉伯语';

  @override
  String get languageChinese => '简体中文';

  @override
  String get settingsTitle => '设置';

  @override
  String get settingsSubtitle => '选择 HalalLens 的显示语言和布局。';

  @override
  String get languageSettingsTitle => '应用语言';

  @override
  String get languageSettingsDescription => '语言和布局方向会立即更新。';

  @override
  String get languageSaveError => '无法保存语言偏好设置。';

  @override
  String get authBackHome => '返回首页';

  @override
  String get accountButton => '账户';

  @override
  String get quickActionScanner => '扫描产品';

  @override
  String get quickActionHistory => '扫描历史';

  @override
  String get quickActionAnalysis => '配料分析';

  @override
  String get quickActionProduct => '产品详情';

  @override
  String get takePhoto => '拍照';

  @override
  String get chooseImage => '选择图片';

  @override
  String get selectImagePrompt => '请选择清晰的产品标签照片。';

  @override
  String get changeImage => '更换图片';

  @override
  String get scanImage => '提取文字';

  @override
  String get scanningImage => '正在识别文字…';

  @override
  String get imagePreview => '已选择的产品图片';

  @override
  String get scanResults => '提取的文字';

  @override
  String get recognizedBlocks => '识别到的文字区域';

  @override
  String get ingredientSuggestions => '配料建议';

  @override
  String get originalOcrText => 'OCR 原文';

  @override
  String get normalizedSuggestion => '规范化建议';

  @override
  String get reviewRecommended => '请人工核对这项建议。';

  @override
  String get ocrWarnings => 'OCR 提示';

  @override
  String normalizationConfidenceLabel(String confidence) {
    return '匹配置信度：$confidence%';
  }

  @override
  String get copyText => '复制全部文字';

  @override
  String get copySuccess => '已复制提取的文字。';

  @override
  String get scanAgain => '重新扫描此图片';

  @override
  String get noTextDetected => '未识别到文字。请尝试拍摄更清晰、光线更好的照片。';

  @override
  String confidenceLabel(String confidence) {
    return '识别置信度：$confidence%';
  }

  @override
  String get unsupportedImage => '请选择 JPG、PNG 或 WebP 图片。';

  @override
  String get invalidImage => '无法读取此图片，请选择其他图片。';

  @override
  String get imageTooLarge => '图片过大，请选择小于 10 MB 的图片。';

  @override
  String get ocrUnavailable => '文字识别暂时不可用。';

  @override
  String get cameraUnavailable => '此设备上的相机或图片选择器不可用。';

  @override
  String get ocrResponseInvalid => '服务器返回了无效的 OCR 响应。';

  @override
  String get scanBarcode => '扫描条形码';

  @override
  String get barcodeScannerTitle => '扫描产品条形码';

  @override
  String get barcodeScannerHelp => '将产品条形码对准取景框中央。支持 EAN、UPC 等常见产品条码。';

  @override
  String get barcodeLookupLoading => '正在查询产品信息…';

  @override
  String get barcodeNotFound => '未找到此条形码对应的产品。请重试或扫描配料标签。';

  @override
  String get barcodeLookupFailed => '暂时无法查询产品信息，请重试。';

  @override
  String get barcodeInvalid => '条形码无效，请重新扫描。';

  @override
  String get barcodeResponseInvalid => '服务器返回了无效的产品信息。';

  @override
  String get cameraPermissionDenied => '相机权限被拒绝。请在设备设置中允许使用相机后重试。';

  @override
  String get cameraUnavailableTryAgain => '无法启动相机。';

  @override
  String get cameraTryAgain => '重试相机';

  @override
  String get barcodeCameraUnsupported => '此设备不支持条形码扫描。';

  @override
  String get productInformationUnavailable => '产品信息不可用';

  @override
  String get brandLabel => '品牌';

  @override
  String get barcodeLabel => '条形码';

  @override
  String get ingredientsLabel => '配料';

  @override
  String get categoriesLabel => '类别';

  @override
  String get originLabel => '原产国';

  @override
  String get productLabels => '产品标签（来源数据）';

  @override
  String get nutritionLabel => '营养信息';

  @override
  String get certificationsLabel => '认证';

  @override
  String get noIngredientsAvailable => '暂无配料信息。';

  @override
  String get noCertificationsAvailable => 'HalalLens 中没有该产品的认证记录。';

  @override
  String get analysisStatusLabel => '清真分析';

  @override
  String get statusHalal => '已验证清真';

  @override
  String get statusHaram => '存在禁忌标记';

  @override
  String get statusDoubtful => '存疑';

  @override
  String get statusUnknown => '未知';

  @override
  String get scanAnotherProduct => '扫描其他产品';

  @override
  String get retryLookup => '重新查询';

  @override
  String get scanIngredientsLabel => '扫描配料标签';
}
