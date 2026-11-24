enum ProductDetailsLanguage {
  english('en', '🇬🇧 English'),
  simplifiedChinese('zh-CN', '🇨🇳 Chinese (Simplified)'),
  french('fr', '🇫🇷 French'),
  arabic('ar', '🇸🇦 Arabic');

  const ProductDetailsLanguage(this.code, this.label);

  final String code;
  final String label;

  bool get isRightToLeft => this == ProductDetailsLanguage.arabic;

  ProductDetailsCopy get copy => switch (this) {
    ProductDetailsLanguage.english => const ProductDetailsCopy(
      languageLabel: 'Product language',
      productInformationUnavailable: 'Product information unavailable',
      brand: 'Brand',
      barcode: 'Barcode',
      analysis: 'Halal analysis',
      ingredients: 'Ingredients',
      noIngredients: 'No ingredient information is available.',
      categories: 'Categories',
      origin: 'Country of origin',
      labels: 'Product labels',
      nutrition: 'Nutrition information',
      certifications: 'Certifications',
      noCertifications: 'No certification records are available in HalalLens.',
      translating: 'Translating product details…',
      translationUnavailable:
          'Translation is unavailable. Showing the original product information.',
    ),
    ProductDetailsLanguage.simplifiedChinese => const ProductDetailsCopy(
      languageLabel: '产品语言',
      productInformationUnavailable: '暂无产品信息',
      brand: '品牌',
      barcode: '条形码',
      analysis: '清真分析',
      ingredients: '配料',
      noIngredients: '暂无配料信息。',
      categories: '类别',
      origin: '原产地',
      labels: '产品标签',
      nutrition: '营养信息',
      certifications: '认证',
      noCertifications: 'HalalLens 中暂无认证记录。',
      translating: '正在翻译产品信息…',
      translationUnavailable: '暂时无法翻译，正在显示产品原始信息。',
    ),
    ProductDetailsLanguage.french => const ProductDetailsCopy(
      languageLabel: 'Langue du produit',
      productInformationUnavailable: 'Informations produit indisponibles',
      brand: 'Marque',
      barcode: 'Code-barres',
      analysis: 'Analyse halal',
      ingredients: 'Ingrédients',
      noIngredients: 'Aucune information sur les ingrédients.',
      categories: 'Catégories',
      origin: 'Pays d’origine',
      labels: 'Étiquettes du produit',
      nutrition: 'Informations nutritionnelles',
      certifications: 'Certifications',
      noCertifications: 'Aucune certification enregistrée dans HalalLens.',
      translating: 'Traduction des détails du produit…',
      translationUnavailable:
          'Traduction indisponible. Affichage des informations d’origine.',
    ),
    ProductDetailsLanguage.arabic => const ProductDetailsCopy(
      languageLabel: 'لغة المنتج',
      productInformationUnavailable: 'معلومات المنتج غير متاحة',
      brand: 'العلامة التجارية',
      barcode: 'الرمز الشريطي',
      analysis: 'تحليل الحلال',
      ingredients: 'المكونات',
      noIngredients: 'لا تتوفر معلومات عن المكونات.',
      categories: 'الفئات',
      origin: 'بلد المنشأ',
      labels: 'ملصقات المنتج',
      nutrition: 'المعلومات الغذائية',
      certifications: 'الشهادات',
      noCertifications: 'لا توجد سجلات شهادات في HalalLens.',
      translating: 'جارٍ ترجمة تفاصيل المنتج…',
      translationUnavailable:
          'الترجمة غير متاحة. يتم عرض معلومات المنتج الأصلية.',
    ),
  };

  String analysisStatus(String status) => switch (this) {
    ProductDetailsLanguage.english => switch (status) {
      'HALAL_VERIFIED' => 'Halal verified',
      'HARAM_FLAG' => 'Haram flag',
      'DOUBTFUL' => 'Doubtful',
      _ => 'Unknown',
    },
    ProductDetailsLanguage.simplifiedChinese => switch (status) {
      'HALAL_VERIFIED' => '清真认证',
      'HARAM_FLAG' => '含禁忌成分',
      'DOUBTFUL' => '存疑',
      _ => '未知',
    },
    ProductDetailsLanguage.french => switch (status) {
      'HALAL_VERIFIED' => 'Halal vérifié',
      'HARAM_FLAG' => 'Signalement haram',
      'DOUBTFUL' => 'Douteux',
      _ => 'Inconnu',
    },
    ProductDetailsLanguage.arabic => switch (status) {
      'HALAL_VERIFIED' => 'حلال موثّق',
      'HARAM_FLAG' => 'إشارة إلى الحرام',
      'DOUBTFUL' => 'موضع شك',
      _ => 'غير معروف',
    },
  };

  String verificationStatus(String status) => switch (this) {
    ProductDetailsLanguage.english => switch (status) {
      'VERIFIED' => 'Verified',
      'REJECTED' => 'Rejected',
      'EXPIRED' => 'Expired',
      'PENDING' => 'Pending',
      _ => 'Unverified',
    },
    ProductDetailsLanguage.simplifiedChinese => switch (status) {
      'VERIFIED' => '已验证',
      'REJECTED' => '已拒绝',
      'EXPIRED' => '已过期',
      'PENDING' => '待处理',
      _ => '未验证',
    },
    ProductDetailsLanguage.french => switch (status) {
      'VERIFIED' => 'Vérifié',
      'REJECTED' => 'Rejeté',
      'EXPIRED' => 'Expiré',
      'PENDING' => 'En attente',
      _ => 'Non vérifié',
    },
    ProductDetailsLanguage.arabic => switch (status) {
      'VERIFIED' => 'تم التحقق',
      'REJECTED' => 'مرفوض',
      'EXPIRED' => 'منتهي الصلاحية',
      'PENDING' => 'قيد الانتظار',
      _ => 'غير متحقق منه',
    },
  };

  String nutrientLabel(String key) {
    final nutrient = switch (key) {
      'energy-kcal_100g' => 0,
      'fat_100g' => 1,
      'saturated-fat_100g' => 2,
      'carbohydrates_100g' => 3,
      'sugars_100g' => 4,
      'fiber_100g' => 5,
      'proteins_100g' => 6,
      'salt_100g' => 7,
      'sodium_100g' => 8,
      _ => -1,
    };
    if (nutrient < 0) return key;
    return switch (this) {
      ProductDetailsLanguage.english =>
        const [
          'Energy (kcal)',
          'Fat',
          'Saturated fat',
          'Carbohydrates',
          'Sugars',
          'Fiber',
          'Protein',
          'Salt',
          'Sodium',
        ][nutrient],
      ProductDetailsLanguage.simplifiedChinese =>
        const [
          '能量（千卡）',
          '脂肪',
          '饱和脂肪',
          '碳水化合物',
          '糖',
          '膳食纤维',
          '蛋白质',
          '盐',
          '钠',
        ][nutrient],
      ProductDetailsLanguage.french =>
        const [
          'Énergie (kcal)',
          'Matières grasses',
          'Acides gras saturés',
          'Glucides',
          'Sucres',
          'Fibres',
          'Protéines',
          'Sel',
          'Sodium',
        ][nutrient],
      ProductDetailsLanguage.arabic =>
        const [
          'الطاقة (سعرة حرارية)',
          'الدهون',
          'الدهون المشبعة',
          'الكربوهيدرات',
          'السكريات',
          'الألياف',
          'البروتين',
          'الملح',
          'الصوديوم',
        ][nutrient],
    };
  }
}

class ProductDetailsCopy {
  const ProductDetailsCopy({
    required this.languageLabel,
    required this.productInformationUnavailable,
    required this.brand,
    required this.barcode,
    required this.analysis,
    required this.ingredients,
    required this.noIngredients,
    required this.categories,
    required this.origin,
    required this.labels,
    required this.nutrition,
    required this.certifications,
    required this.noCertifications,
    required this.translating,
    required this.translationUnavailable,
  });

  final String languageLabel;
  final String productInformationUnavailable;
  final String brand;
  final String barcode;
  final String analysis;
  final String ingredients;
  final String noIngredients;
  final String categories;
  final String origin;
  final String labels;
  final String nutrition;
  final String certifications;
  final String noCertifications;
  final String translating;
  final String translationUnavailable;
}
