#!/bin/bash

echo "🔧 إصلاح وتشغيل التطبيق..."
echo ""

# الانتقال لمجلد المشروع
cd "$(dirname "$0")"

echo "1️⃣ حذف ملفات البناء القديمة..."
rm -rf ios/build
rm -rf ios/Pods
rm -rf ios/Podfile.lock
rm -rf build/

echo ""
echo "2️⃣ تحميل المكتبات..."
flutter pub get

echo ""
echo "3️⃣ تثبيت iOS Pods..."
cd ios && pod install && cd ..

echo ""
echo "4️⃣ تشغيل التطبيق..."
echo ""
echo "⚠️  تأكد من:"
echo "   • الآيفون موصول بالكابل"
echo "   • الآيفون مفتوح (غير مقفل)"
echo "   • تم الضغط على Trust على الآيفون"
echo ""
echo "▶️  بدء التشغيل..."
echo ""

flutter run

echo ""
echo "✅ انتهى!"
