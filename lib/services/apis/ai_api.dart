// import 'dart:convert';
// import 'dart:developer';

// import 'package:cashiery_mobile/models/clients_model.dart';
// import 'package:cashiery_mobile/models/products_model.dart';
// import 'package:cashiery_mobile/models/reports_model.dart';
// import 'package:cashiery_mobile/models/transactions_model.dart';
// import 'package:cashiery_mobile/models/treasury_model.dart';
// import 'package:cashiery_mobile/models/users_model.dart';
// import 'package:cashiery_mobile/src/app_globals.dart';
// import 'package:http/http.dart' as http;

// class AiApi {
//   static const Map<String, List<String>> intentKeywords = {
//     'treasury': [
//       'الخزينة',
//       'الرصيد',
//       'المبلغ المتاح',
//       'السيولة',
//       'النقد',
//       'الأرصدة',
//       'treasury',
//       'balance',
//       'cash',
//       'liquid',
//       'available money',
//     ],
//     'transactions_sales': [
//       'المبيعات',
//       'بيع',
//       'مباع',
//       'عائدات',
//       'إيرادات',
//       'دخل',
//       'sales',
//       'selling',
//       'sold',
//       'revenue',
//       'income',
//     ],
//     'transactions_purchases': [
//       'المشتريات',
//       'شراء',
//       'مشترى',
//       'التكاليف',
//       'المصروفات',
//       'purchases',
//       'buying',
//       'bought',
//       'costs',
//       'expenses',
//     ],
//     'transactions_expenses': [
//       'المصروفات',
//       'النفقات',
//       'التكاليف التشغيلية',
//       'مرتبات',
//       'رواتب',
//       'expenses',
//       'costs',
//       'salaries',
//       'operational costs',
//     ],
//     'clients': [
//       'العملاء',
//       'الزبائن',
//       'المشترين',
//       'العميل',
//       'الزبون',
//       'clients',
//       'customers',
//       'buyers',
//     ],
//     'suppliers': [
//       'الموردين',
//       'المورد',
//       'البائعين',
//       'المزودين',
//       'suppliers',
//       'vendors',
//       'providers',
//     ],
//     'products': [
//       'المنتجات',
//       'السلع',
//       'البضائع',
//       'المخزون',
//       'الأصناف',
//       'الفئات',
//       'products',
//       'items',
//       'inventory',
//       'stock',
//       'categories',
//     ],
//     'employees': [
//       'الموظفين',
//       'العاملين',
//       'الموظف',
//       'العامل',
//       'الحضور',
//       'الورديات',
//       'employees',
//       'staff',
//       'workers',
//       'attendance',
//       'shifts',
//     ],
//     'reports': [
//       'التقارير',
//       'الإحصائيات',
//       'التحليلات',
//       'البيانات',
//       'الملخصات',
//       'reports',
//       'statistics',
//       'analytics',
//       'summaries',
//     ],
//     'performance': [
//       'الأداء',
//       'الربحية',
//       'النمو',
//       'المقارنات',
//       'التطور',
//       'performance',
//       'profitability',
//       'growth',
//       'comparisons',
//     ],
//     'payment_methods': [
//       'طرق الدفع',
//       'نقدي',
//       'بنكي',
//       'كاش',
//       'تحويل',
//       'فيزا',
//       'ماستركارد',
//       'payment methods',
//       'cash',
//       'bank',
//       'transfer',
//       'visa',
//       'mastercard',
//     ],
//   };

//   static const Map<String, List<String>> timeKeywords = {
//     'today': ['اليوم', 'today', 'الآن', 'now'],
//     'yesterday': ['أمس', 'yesterday', 'البارحة'],
//     'week': ['الأسبوع', 'week', 'أسبوعي', 'weekly'],
//     'last_week': ['الأسبوع الماضي', 'last week', 'الأسبوع السابق'],
//     'month': ['الشهر', 'month', 'شهري', 'monthly'],
//     'last_month': ['الشهر الماضي', 'last month', 'الشهر السابق'],
//     'quarter': ['الربع', 'quarter', 'ربعي', 'quarterly'],
//     'last_quarter': ['الربع الماضي', 'last quarter', 'الربع السابق'],
//     'year': ['السنة', 'year', 'العام', 'سنوي', 'سنوية'],
//     'last_year': ['السنة الماضية', 'last year', 'العام الماضي'],
//   };

//   static const Map<String, List<String>> metricKeywords = {
//     'count': ['عدد', 'كمية', 'count', 'quantity', 'number'],
//     'total': ['إجمالي', 'مجموع', 'total', 'sum'],
//     'average': ['متوسط', 'average', 'mean'],
//     'profit': ['ربح', 'أرباح', 'profit', 'profits'],
//     'revenue': ['إيرادات', 'عائدات', 'revenue', 'income'],
//     'expenses': ['مصروفات', 'نفقات', 'expenses', 'costs'],
//     'growth': ['نمو', 'زيادة', 'growth', 'increase'],
//     'comparison': ['مقارنة', 'comparison', 'compare'],
//     'trend': ['اتجاه', 'trend', 'pattern'],
//     'top': ['أفضل', 'أعلى', 'top', 'best', 'highest'],
//     'worst': ['أسوأ', 'أقل', 'worst', 'lowest'],
//     'list': ['قائمة', 'list', 'اعرض', 'show'],
//     'details': ['تفاصيل', 'details', 'breakdown'],
//   };

//   Future fetchResponse({
//     required String question,
//     String? intent,
//     required bool isIntent,
//   }) async {
//     String prompt = isIntent
//         ? _intentPrompt(question)
//         : _dataPrompt(_praseIntent(intent!), question);

//     log("Generated Prompt: $prompt");

//     try {
//       var request = await http.post(
//         Uri.parse(
//           "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-lite:generateContent",
//         ),
//         headers: {
//           "Content-Type": "application/json",
//           "X-goog-api-key": "AIzaSyBG8zfOi9jICiXRiAcEhRZRGBpZbLVVL5o",
//         },
//         body: jsonEncode({
//           "contents": [
//             {
//               "parts": [
//                 {"text": prompt},
//               ],
//             },
//           ],
//           "generationConfig": {"temperature": 0.3, "maxOutputTokens": 2048},
//         }),
//       );

//       var response = jsonDecode(request.body);
//       return response["candidates"][0]['content']["parts"][0]['text'];
//     } catch (e) {
//       log("Exception in fetchResponse: $e");
//       return "error $e";
//     }
//   }

//   Map<String, String> _praseIntent(String intentResponse) {
//     try {
//       final cleanResponse = intentResponse
//           .replaceAll('```json', '')
//           .replaceAll('```', '')
//           .trim();
//       final parsed = jsonDecode(cleanResponse);
//       return {
//         'intent': parsed['intent'] ?? 'general',
//         'subIntent': parsed['subIntent'] ?? '',
//         'timeframe': parsed['timeframe'] ?? 'all',
//         'metric': parsed['metric'] ?? 'count',
//         'filters': parsed['filters'] ?? '',
//         'complexity': parsed['complexity'] ?? 'simple',
//       };
//     } catch (e) {
//       log("Error parsing advanced intent: $e");
//       return {
//         'intent': 'general',
//         'subIntent': '',
//         'timeframe': 'all',
//         'metric': 'count',
//         'filters': '',
//         'complexity': 'simple',
//       };
//     }
//   }

//   String _intentPrompt(String question) {
//     return """
// حلل سؤال المستخدم بدقة عالية وأعد النتيجة في صيغة JSON فقط، بدون أي نص آخر.

// المجالات الرئيسية (intent):
// - "treasury": الخزينة والأرصدة والسيولة
// - "transactions": جميع أنواع المعاملات
// - "clients": العملاء والزبائن
// - "suppliers": الموردين والبائعين
// - "products": المنتجات والمخزون والفئات
// - "employees": الموظفين والحضور والورديات والرواتب
// - "reports": التقارير والإحصائيات العامة
// - "performance": تحليل الأداء والربحية والمقارنات
// - "general": أسئلة عامة مرتبطة بالأعمال
// - "irrelevant": أسئلة غير مرتبطة بالأعمال إطلاقاً

// المجالات الفرعية (subIntent):
// - للمعاملات: "sales", "purchases", "expenses", "inventory", "payments"
// - للعملاء: "transactions", "payments", "debts", "top_clients"
// - للمنتجات: "sales", "inventory", "categories", "profit_margins"
// - للموظفين: "transactions", "attendance", "salaries", "performance"
// - للتقارير: "financial", "sales", "inventory", "employee"

// الفترات الزمنية (timeframe):
// - "today", "yesterday", "week", "last_week", "month", "last_month"
// - "quarter", "last_quarter", "year", "last_year", "custom", "all"

// المقاييس (metric):
// - "count", "total", "sum", "average", "median", "min", "max"
// - "profit", "revenue", "expenses", "balance", "percentage"
// - "growth", "decline", "comparison", "trend", "ratio", "margin"
// - "performance", "distribution", "status", "list", "details", "breakdown"

// الفلاتر (filters):
// - "payment_method", "employee_filter", "client_filter", "product_filter"
// - "amount_range", "date_range", "category_filter", "status_filter"

// مستوى التعقيد (complexity):
// - "simple": سؤال مباشر واضح
// - "complex": يتطلب تحليل متقدم أو مقارنات
// - "analytical": يتطلب حسابات معقدة أو استنتاجات

// أمثلة:
// - "كم عدد المبيعات اليوم؟" → {"intent": "transactions", "subIntent": "sales", "timeframe": "today", "metric": "count", "filters": "", "complexity": "simple"}
// - "من هو أفضل عميل هذا الشهر من ناحية الأرباح؟" → {"intent": "clients", "subIntent": "top_clients", "timeframe": "month", "metric": "profit", "filters": "", "complexity": "complex"}

// النتيجة المطلوبة:
// {"intent": "value", "subIntent": "value", "timeframe": "value", "metric": "value", "filters": "value", "complexity": "value"}

// السؤال: $question
// """;
//   }
// }

// String _dataPrompt(Map<String, String> intent, String question) {
//   final userName = AppGlobals.currentUser?.name ?? "المستخدم";
//   final storeName = AppGlobals.currentGym?.name ?? "المحل";
//   final currentDate = DateTime.now();

//   String basePrompt =
//       """
// ### معلومات النظام ###
// - اسم المحل او الشركة: $storeName
// - اسم المستخدم: $userName
// - التاريخ الحالي: ${currentDate.day}/${currentDate.month}/${currentDate.year}
// - العملة: ال${AppGlobals.currentGym!.currency} المصري (${AppGlobals.currentGym!.currency})
// - النظام: كاشيري Cashiery

// ### الهوية والدور ###
// أنت 'كاشي'، محلل مالي ذكي ومتخصص في نظام كاشيري. لديك خبرة عميقة في:
// - التحليل المالي والمحاسبي
// - إدارة المخزون والمبيعات
// - تحليل أداء العملاء والموظفين
// - التقارير المالية المتقدمة
// - اتجاهات السوق والأداء التجاري

// ### قواعد التحليل المتقدمة ###
// 1. **أنواع المعاملات:**
//    - type: 'inventory' = المشتريات من الموردين
//    - type: 'sale' = مبيعات للعملاء
//    - type: 'expense' = مصروفات (إذا كان التعليق "مرتبات" فهو راتب موظف)
//    - type: 'return' = مرتجعات

// 2. **تحليل العملاء والموردين:**
//    - العملاء: جميع المعاملات ما عدا type: 'inventory'
//    - الموردين: معاملات type: 'inventory' فقط
//    - حلل ديون العملاء من الفرق بين total_price و money_paid
//    - حدد أفضل العملاء بناءً على إجمالي المشتريات أو التكرار

// 3. **تحليل الموظفين:**
//    - المعاملات: ابحث في حقل created_by
//    - الرواتب: معاملات type: 'expense' مع تعليق "مرتبات"
//    - الحضور: من بيانات الموظفين إن وجدت
//    - الأداء: عدد وقيمة المعاملات المنجزة

// 4. **تحليل المنتجات:**
//    - الفئات: من product_categories
//    - المبيعات: عدد مرات البيع وإجمالي القيمة
//    - المخزون: الكميات المتاحة
//    - الربحية: الفرق بين سعر البيع والشراء

// 5. **التحليل المالي:**
//    - الإيرادات: مجموع المبيعات (type: 'sale')
//    - التكاليف: مجموع المشتريات والمصروفات
//    - الأرباح الصافية: الإيرادات - التكاليف
//    - السيولة: رصيد الخزينة الحالي

// ### تعليمات الإجابة ###
// 1. استخدم اللغة العربية حصرياً
// 2. قدم أرقام دقيقة مع العملة (${AppGlobals.currentGym!.currency})
// 3. اربط الإجابة بالفترة المطلوبة: ${intent['timeframe']}
// 4. ركز على المقياس: ${intent['metric']}
// 5. استخدم التحليل المناسب لمستوى التعقيد: ${intent['complexity']}
// 6. إذا لم توجد بيانات كافية، قل: "عذراً، البيانات المتاحة غير كافية للإجابة على هذا السؤال بدقة."
// 7. للأسئلة غير المرتبطة بالأعمال: "أنا متخصص في التحليل المالي ونظام كاشيري فقط. يمكنني مساعدتك في أسئلة المبيعات، المشتريات العملاء، المنتجات، الموظفين، والتقارير المالية."
// 8. استخدم طريقة كتابه سلسة و مدعومة بنوع ما من الemojis و الbullets
// 9. تأكد من صحة الإجابة و عدم وجود فيها مصطلحات برمجية او من التعليمات المرسلة

// ### السؤال ###
// $question

// ### نوع التحليل المطلوب ###
// - المجال: ${intent['intent']}
// - المجال الفرعي: ${intent['subIntent']}
// - الفترة: ${intent['timeframe']}
// - المقياس: ${intent['metric']}
// - مستوى التعقيد: ${intent['complexity']}

// ### البيانات المتاحة ###
// """;

//   // Add relevant data based on intent and complexity
//   basePrompt += _getRelevantData(intent);

//   basePrompt += "\n\n### المطلوب ###\n";
//   basePrompt += _getAnalysisInstructions(intent);

//   return basePrompt;
// }

// String _getRelevantData(Map<String, String> intent) {
//   String data = "";

//   switch (intent['intent']) {
//     case 'treasury':
//       data += _getTreasuryAnalysisData();
//       break;
//     case 'transactions':
//       data += _getTransactionsAnalysisData(intent['subIntent'] ?? '');
//       break;
//     case 'clients':
//       data += _getClientsAnalysisData();
//       data += _getTransactionsAnalysisData('client_related');
//       break;
//     case 'suppliers':
//       data += _getSuppliersAnalysisData();
//       break;
//     case 'products':
//       data += _getProductsAnalysisData();
//       data += _getTransactionsAnalysisData('product_related');
//       break;
//     case 'employees':
//       data += _getEmployeesAnalysisData();
//       data += _getTransactionsAnalysisData('employee_related');
//       break;
//     case 'performance':
//     case 'reports':
//       data += _getCompleteAnalysisData();
//       break;
//     default:
//       data += _getCompleteAnalysisData();
//   }

//   return data.isEmpty ? "لا توجد بيانات متاحة للتحليل." : data;
// }

// String _getTreasuryAnalysisData() {
//   String data = "";
//   if (AppGlobals.treasuryModel != null) {
//     data += "**بيانات الخزينة والأرصدة:**\n";
//     data += "${jsonEncode(AppGlobals.treasuryModel!.toCompactJson())}\n\n";
//   }
//   if (AppGlobals.transactionsModel != null) {
//     data += "**ملخص المعاملات المالية:**\n";
//     data += "${jsonEncode(AppGlobals.transactionsModel!.toJsonCompact())}\n\n";
//   }
//   return data;
// }

// String _getTransactionsAnalysisData(String subIntent) {
//   log(
//     "TransactionsModel: ${AppGlobals.transactionsModel?.toJsonCompact() ?? 'nigga null trans'}",
//   );
//   if (AppGlobals.transactionsModel == null) {
//     return "لا توجد بيانات معاملات متاحة.\n";
//   }

//   String data = "**بيانات المعاملات المفصلة:**\n";
//   data += "${jsonEncode(AppGlobals.transactionsModel!.toJsonCompact())}\n\n";

//   // Add related data based on sub-intent
//   if (subIntent.contains('client') && AppGlobals.clientsModel != null) {
//     data += "**بيانات العملاء ذات الصلة:**\n";
//     data += "${jsonEncode(AppGlobals.clientsModel!.toCompactJson())}\n\n";
//   }

//   if (subIntent.contains('product') && AppGlobals.productsModel != null) {
//     data += "**بيانات المنتجات ذات الصلة:**\n";
//     data += "${jsonEncode(AppGlobals.productsModel!.toCompactJson())}\n\n";
//   }

//   if (subIntent.contains('employee') && AppGlobals.employeesModel != null) {
//     data += "**بيانات الموظفين ذات الصلة:**\n";
//     data += "${jsonEncode(AppGlobals.employeesModel!.toCompactJson())}\n\n";
//   }

//   return data;
// }

// String _getClientsAnalysisData() {
//   String data = "";
//   if (AppGlobals.clientsModel != null) {
//     data += "**بيانات العملاء التفصيلية:**\n";
//     data += "${jsonEncode(AppGlobals.clientsModel!.toCompactJson())}\n\n";
//   }
//   return data;
// }

// String _getSuppliersAnalysisData() {
//   String data = "";
//   if (AppGlobals.clientsModel != null) {
//     data += "**بيانات الموردين (من العملاء - معاملات المخزون):**\n";
//     data += "${jsonEncode(AppGlobals.clientsModel!.toCompactJson())}\n\n";
//   }
//   if (AppGlobals.transactionsModel != null) {
//     data += "**معاملات المشتريات من الموردين:**\n";
//     data += "${jsonEncode(AppGlobals.transactionsModel!.toJsonCompact())}\n\n";
//   }
//   return data;
// }

// String _getProductsAnalysisData() {
//   String data = "";
//   if (AppGlobals.productsModel != null) {
//     data += "**بيانات المنتجات والمخزون:**\n";
//     data += "${jsonEncode(AppGlobals.productsModel!.toCompactJson())}\n\n";
//   }
//   return data;
// }

// String _getEmployeesAnalysisData() {
//   String data = "";
//   if (AppGlobals.employeesModel != null) {
//     data += "**بيانات الموظفين التفصيلية:**\n";
//     data += "${jsonEncode(AppGlobals.employeesModel!.toCompactJson())}\n\n";
//   }
//   return data;
// }

// String _getCompleteAnalysisData() {
//   String data = "";

//   if (AppGlobals.transactionsModel != null) {
//     data += "**المعاملات الشاملة:**\n";
//     data += "${jsonEncode(AppGlobals.transactionsModel!.toJsonCompact())}\n\n";
//   }

//   if (AppGlobals.clientsModel != null) {
//     data += "**العملاء والموردين:**\n";
//     data += "${jsonEncode(AppGlobals.clientsModel!.toCompactJson())}\n\n";
//   }

//   if (AppGlobals.productsModel != null) {
//     data += "**المنتجات والمخزون:**\n";
//     data += "${jsonEncode(AppGlobals.productsModel!.toCompactJson())}\n\n";
//   }

//   if (AppGlobals.employeesModel != null) {
//     data += "**الموظفين:**\n";
//     data += "${jsonEncode(AppGlobals.employeesModel!.toCompactJson())}\n\n";
//   }

//   if (AppGlobals.treasuryModel != null) {
//     data += "**الخزينة:**\n";
//     data += "${jsonEncode(AppGlobals.treasuryModel!.toCompactJson())}\n\n";
//   }

//   if (AppGlobals.reportsModel != null) {
//     data += "**التقارير:**\n";
//     data +=
//         "${jsonEncode(AppGlobals.aiReportsModel != null ? AppGlobals.aiReportsModel!.toCompactJson() : AppGlobals.reportsModel!.toCompactJson())}\n\n";
//   }

//   return data;
// }

// String _getAnalysisInstructions(Map<String, String> intent) {
//   switch (intent['complexity']) {
//     case 'complex':
//       return "قدم تحليلاً متقدماً يتضمن مقارنات وتوجهات واستنتاجات مالية عميقة مع اقتراحات عملية.";
//     case 'analytical':
//       return "أجري حسابات معقدة ومقارنات تفصيلية مع تحليل الأسباب والنتائج وتوصيات استراتيجية.";
//     default:
//       return "قدم إجابة واضحة ومباشرة مع الأرقام والإحصائيات الأساسية المطلوبة.";
//   }
// }
