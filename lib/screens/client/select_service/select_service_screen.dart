import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SelectServiceScreen extends StatefulWidget {
  const SelectServiceScreen({super.key});

  @override
  State<SelectServiceScreen> createState() => _SelectServiceScreenState();
}

class _SelectServiceScreenState extends State<SelectServiceScreen> {
  final List<Map<String, dynamic>> _services = [
    {
      'name': 'قص شعر',
      'icon': Icons.content_cut_rounded,
      'selected': true,
      'price': 25,
    },
    {
      'name': 'حلاقة',
      'icon': Icons.brush_rounded,
      'selected': true,
      'price': 15,
    },
    {
      'name': 'تشكيل لحية',
      'icon': Icons.face_retouching_natural_rounded,
      'selected': false,
      'price': 20,
    },
    {
      'name': 'غسيل شعر',
      'icon': Icons.shower_rounded,
      'selected': false,
      'price': 10,
    },
    {
      'name': 'تنظيف بشر&',
      'icon': Icons.face_rounded,
      'selected': false,
      'price': 30,
    },
    {
      'name': 'صبغة شعر',
      'icon': Icons.color_lens_outlined,
      'selected': false,
      'price': 50,
    },
    {
      'name': 'عناية بالبشرة',
      'icon': Icons.dry_cleaning_rounded,
      'selected': false,
      'price': 40,
    },
  ];

  int get _totalPrice {
    return _services
        .where((service) => service['selected'] == true)
        .fold(0, (sum, service) => sum + (service['price'] as int));
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
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.black,
              size: 16,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            "اختر الخدمة",
            style: GoogleFonts.zain(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: Colors.black,
            ),
          ),
          centerTitle: true,
          actions: const [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Center(
                child: Text(
                  "04",
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                itemCount: _services.length,
                itemBuilder: (context, index) {
                  final service = _services[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Color(0xFFF5F5F5), width: 1),
                      ),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          service['icon'] as IconData,
                          color: Colors.black,
                          size: 18,
                        ),
                      ),
                      title: Text(
                        service['name'] as String,
                        style: GoogleFonts.zain(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      trailing: Transform.scale(
                        scale: 0.9,
                        child: Checkbox(
                          value: service['selected'] as bool,
                          activeColor: Colors.black,
                          checkColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          side: const BorderSide(
                            color: Color(0xFFCCCCCC),
                            width: 1.5,
                          ),
                          onChanged: (bool? value) {
                            setState(() {
                              _services[index]['selected'] = value;
                            });
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "الإجمالي",
                        style: GoogleFonts.zain(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        "$_totalPrice ج.م",
                        style: GoogleFonts.zain(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        "التالي",
                        style: GoogleFonts.zain(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
