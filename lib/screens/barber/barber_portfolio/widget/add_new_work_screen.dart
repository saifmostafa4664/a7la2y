import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddNewWorkScreen extends StatefulWidget {
  const AddNewWorkScreen({super.key});

  @override
  State<AddNewWorkScreen> createState() => _AddNewWorkScreenState();
}

class _AddNewWorkScreenState extends State<AddNewWorkScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  String _selectedCategory = 'قصة شعر';
  bool _isFeatured = false;

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
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.black,
              size: 16,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            "إضافة عمل جديد",
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
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                          width: double.infinity,
                          height: 180,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFBFBFB),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: const Color(0xFFEFEFEF),
                              width: 1.5,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.add_photo_alternate_outlined,
                                color: Colors.black,
                                size: 32,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "اضغط لرفع صورة العمل الجديد",
                                style: GoogleFonts.zain(
                                  fontSize: 14,
                                  color: const Color(0xFF7A7A7A),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      "عنوان العمل",
                      style: GoogleFonts.zain(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFBFBFB),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: const Color(0xFFEFEFEF),
                          width: 1.5,
                        ),
                      ),
                      child: TextField(
                        controller: _titleController,
                        style: const TextStyle(fontSize: 15),
                        decoration: InputDecoration(
                          hintText: "مثال: تدريج زيرو كلاسيك",
                          hintStyle: GoogleFonts.zain(
                            fontSize: 14,
                            color: const Color(0xFF9E9E9E),
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "التصنيف",
                      style: GoogleFonts.zain(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFBFBFB),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: const Color(0xFFEFEFEF),
                          width: 1.5,
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedCategory,
                          isExpanded: true,
                          icon: const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: Colors.black,
                          ),
                          style: GoogleFonts.zain(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          items: <String>['قصة شعر', 'لحية', 'كولونيال'].map((
                            String value,
                          ) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() => _selectedCategory = value!);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "تفاصيل إضافية (اختياري)",
                      style: GoogleFonts.zain(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFBFBFB),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: const Color(0xFFEFEFEF),
                          width: 1.5,
                        ),
                      ),
                      child: TextField(
                        controller: _descController,
                        maxLines: 3,
                        style: const TextStyle(fontSize: 15),
                        decoration: InputDecoration(
                          hintText:
                              "اكتب المنتجات المستخدمة أو تفاصيل القصة...",
                          hintStyle: GoogleFonts.zain(
                            fontSize: 14,
                            color: const Color(0xFF9E9E9E),
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 4,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "تعيين كعمل مميز",
                                style: GoogleFonts.zain(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                "سيظهر هذا العمل في مقدمة حافظتك للعملاء",
                                style: GoogleFonts.zain(
                                  fontSize: 12,
                                  color: const Color(0xFF7A7A7A),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Switch(
                            value: _isFeatured,
                            activeThumbColor: Colors.black,
                            activeTrackColor: const Color(0xFFEFEFEF),
                            inactiveThumbColor: Colors.grey,
                            inactiveTrackColor: const Color(0xFFF5F5F5),
                            onChanged: (value) {
                              setState(() => _isFeatured = value);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    "نشر في حافظة الأعمال",
                    style: GoogleFonts.zain(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
