import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthFlowScreen extends StatefulWidget {
  const AuthFlowScreen({super.key});

  @override
  State<AuthFlowScreen> createState() => _AuthFlowScreenState();
}

class _AuthFlowScreenState extends State<AuthFlowScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  final int _totalSteps = 6;

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final List<TextEditingController> _otpControllers = List.generate(
    4,
    (_) => TextEditingController(),
  );

  String _userType = 'client';
  String _selectedCountryCode = '+20';
  bool _hasUploadedImage = false;
  // ignore: unused_field
  final _formKey = GlobalKey<FormState>();
  void _nextStep() {
    if (_currentStep == 0) {
      if (_phoneController.text.length != 11) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'برجاء إدخال رقم هاتف صحيح مكون من 11 رقماً لمنع هدر كود التحقق!',
            ),
            backgroundColor: Colors.black,
          ),
        );
        return;
      }
    }

    if (_currentStep < _totalSteps - 1) {
      setState(() => _currentStep++);
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('تم إنشاء الحساب بنجاح!')));
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: const Color(0xFFF7F7F7),
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.black,
                  size: 14,
                ),
                onPressed: _prevStep,
              ),
            ),
          ),
          title: Text(
            _currentStep == 0 ? "التحقق من الهوية" : "إنشاء حساب جديد",
            style: GoogleFonts.zain(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: Colors.black,
            ),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            LinearProgressIndicator(
              value: (_currentStep + 1) / _totalSteps,
              backgroundColor: const Color(0xFFF5F5F5),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.black),
              minHeight: 3,
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildCenterStep(_buildPhoneStep()),
                  _buildCenterStep(_buildOtpStep()),
                  _buildCenterStep(_buildUserTypeStep()),
                  _buildCenterStep(_buildNameAndProfileStep()),
                  _buildCenterStep(_buildPasswordStep()),
                  _buildCenterStep(_buildEmailStep()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCenterStep(Widget stepContent) {
    return Center(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            stepContent,
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _nextStep,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _currentStep == _totalSteps - 1
                          ? "تأكيد وتفعيل الحساب"
                          : "المتابعة",
                      style: GoogleFonts.zain(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(Icons.arrow_forward_ios_rounded, size: 12),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // الخطوة 1: رقم الموبايل مع رمز الدولة الذكي
  Widget _buildPhoneStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "مرحباً بك في A7LA2Y",
          style: GoogleFonts.zain(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: Colors.black,
          ),
        ),
        Text(
          "أدخل رقم هاتفك للمتابعة أو إنشاء حساب جديد.",
          style: GoogleFonts.zain(
            fontSize: 14,
            color: const Color(0xFF7A7A7A),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 24),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFFBFBFB),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFEFEFEF), width: 1.5),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: DropdownButton<String>(
                  value: _selectedCountryCode,
                  underline: const SizedBox(),
                  icon: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: Colors.black,
                    size: 18,
                  ),
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  items: <String>['+20', '+966', '+971', '+964'].map((
                    String value,
                  ) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, textDirection: TextDirection.ltr),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() => _selectedCountryCode = value!);
                  },
                ),
              ),
              Container(width: 1, height: 24, color: const Color(0xFFEFEFEF)),
              Expanded(
                child: TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  maxLength: 11,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: InputDecoration(
                    hintText: "01xxxxxxxxx",
                    hintStyle: GoogleFonts.zain(
                      fontSize: 15,
                      color: const Color(0xFF9E9E9E),
                    ),
                    counterText: "",
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOtpStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "رمز التحقق",
          style: GoogleFonts.zain(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: Colors.black,
          ),
        ),
        Text(
          "أدخل كود التحقق المكون من 4 أرقام المرسل إلى هاتفك.",
          style: GoogleFonts.zain(
            fontSize: 14,
            color: const Color(0xFF7A7A7A),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 28),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(4, (index) {
            return SizedBox(
              width: 58,
              height: 58,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFFBFBFB),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: const Color(0xFFEFEFEF),
                    width: 1.5,
                  ),
                ),
                child: TextField(
                  controller: _otpControllers[index],
                  maxLength: 1,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  cursorColor: Colors.black,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'Inter',
                    color: Colors.black,
                  ),
                  decoration: const InputDecoration(
                    counterText: "",
                    border: InputBorder.none,
                  ),
                  onChanged: (value) {
                    if (value.isNotEmpty && index < 3) {
                      FocusScope.of(context).nextFocus();
                    } else if (value.isEmpty && index > 0) {
                      FocusScope.of(context).previousFocus();
                    }
                  },
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 16),
        Center(
          child: TextButton(
            onPressed: () {},
            child: Text(
              "إعادة إرسال الكود",
              style: GoogleFonts.zain(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUserTypeStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "اختر نوع الحساب",
          style: GoogleFonts.zain(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: Colors.black,
          ),
        ),
        Text(
          "حدد هويتك لتخصيص لوحة التحكم الخاصة بك.",
          style: GoogleFonts.zain(
            fontSize: 14,
            color: const Color(0xFF7A7A7A),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 24),
        Column(
          children: [
            _buildTypeRowItem(
              type: 'client',
              title: 'أنا عميل (أبحث عن حلاق)',
              icon: Icons.person_search_rounded,
            ),
            const SizedBox(height: 12),
            _buildTypeRowItem(
              type: 'barber',
              title: 'أنا حلاق مستقل (أعمل بحرية)',
              icon: Icons.content_cut_rounded,
            ),
            const SizedBox(height: 12),
            _buildTypeRowItem(
              type: 'salon',
              title: 'صاحب صالون / محل حلاقة مكامل',
              icon: Icons.store_rounded,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTypeRowItem({
    required String type,
    required String title,
    required IconData icon,
  }) {
    bool isSelected = _userType == type;
    return GestureDetector(
      onTap: () => setState(() => _userType = type),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : const Color(0xFFFBFBFB),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? Colors.black : const Color(0xFFEFEFEF),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.black,
              size: 22,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.zain(
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                  color: isSelected ? Colors.white : Colors.black,
                ),
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle_rounded,
                color: Colors.white,
                size: 18,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNameAndProfileStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Align(
          alignment: Alignment.topRight,
          child: Text(
            "بياناتك الشخصية",
            style: GoogleFonts.zain(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: Colors.black,
            ),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: Text(
            "أضف صورتك واسمك ليتعرف عليك النظام والصالونات.",
            style: GoogleFonts.zain(
              fontSize: 14,
              color: const Color(0xFF7A7A7A),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 24),
        GestureDetector(
          onTap: () => setState(() => _hasUploadedImage = !_hasUploadedImage),
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFF7F7F7),
                  border: Border.all(color: const Color(0xFFEFEFEF), width: 2),
                ),
                child: _hasUploadedImage
                    ? const Icon(
                        Icons.check_circle_rounded,
                        color: Colors.black,
                        size: 32,
                      )
                    : const Icon(
                        Icons.person_outline_rounded,
                        color: Color(0xFF9E9E9E),
                        size: 36,
                      ),
              ),
              const CircleAvatar(
                radius: 14,
                backgroundColor: Colors.black,
                child: Icon(
                  Icons.add_a_photo_rounded,
                  color: Colors.white,
                  size: 12,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFFBFBFB),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFEFEFEF), width: 1.5),
          ),
          child: TextField(
            controller: _nameController,
            style: const TextStyle(fontSize: 15),
            decoration: InputDecoration(
              hintText: "الاسم بالكامل",
              hintStyle: GoogleFonts.zain(
                fontSize: 15,
                color: const Color(0xFF9E9E9E),
              ),
              prefixIcon: const Icon(
                Icons.person_outline_rounded,
                color: Colors.black,
                size: 18,
              ),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "تعيين كلمة المرور",
          style: GoogleFonts.zain(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: Colors.black,
          ),
        ),
        Text(
          "احرص على كتابة كلمة مرور قوية لحماية حسابك.",
          style: GoogleFonts.zain(
            fontSize: 14,
            color: const Color(0xFF7A7A7A),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFFBFBFB),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFEFEFEF), width: 1.5),
          ),
          child: TextField(
            controller: _passwordController,
            obscureText: true,
            style: const TextStyle(fontSize: 15),
            decoration: InputDecoration(
              hintText: "كلمة المرور الجديدة",
              hintStyle: GoogleFonts.zain(
                fontSize: 15,
                color: const Color(0xFF9E9E9E),
              ),
              prefixIcon: const Icon(
                Icons.lock_outline_rounded,
                color: Colors.black,
                size: 18,
              ),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmailStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "بريدك الإلكتروني",
          style: GoogleFonts.zain(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: Colors.black,
          ),
        ),
        Text(
          "سنرسل لك تفاصيل الفواتير وحالة الحجوزات هنا (اختياري).",
          style: GoogleFonts.zain(
            fontSize: 14,
            color: const Color(0xFF7A7A7A),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFFBFBFB),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFEFEFEF), width: 1.5),
          ),
          child: TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            style: const TextStyle(fontSize: 15),
            decoration: InputDecoration(
              hintText: "البريد الإلكتروني",
              hintStyle: GoogleFonts.zain(
                fontSize: 15,
                color: const Color(0xFF9E9E9E),
              ),
              prefixIcon: const Icon(
                Icons.alternate_email_rounded,
                color: Colors.black,
                size: 18,
              ),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}
