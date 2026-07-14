#!/bin/bash

echo "🚀 تشغيل A7la2y - النسخة بدون Authentication"
echo ""
echo "════════════════════════════════════════════"
echo ""

# الانتقال لمجلد المشروع
cd "$(dirname "$0")"

echo "✅ المميزات المتاحة:"
echo "   • خرائط ومواقع"
echo "   • تتبع الموقع (Tracking)"
echo "   • كل واجهات الـ UI"
echo "   • بدون Firebase أو Auth"
echo ""
echo "════════════════════════════════════════════"
echo ""

echo "📱 تحضير التطبيق..."
echo ""

# فحص المكتبات
if [ ! -d ".dart_tool" ]; then
    echo "📦 تحميل المكتبات..."
    flutter pub get
    echo ""
fi

# فحص إذا كان iOS
if [ -d "ios" ]; then
    echo "🍎 تحضير iOS..."
    if [ ! -d "ios/Pods" ]; then
        echo "   تثبيت iOS Pods..."
        cd ios && pod install && cd ..
        echo ""
    fi
fi

echo "════════════════════════════════════════════"
echo ""
echo "▶️  بدء التشغيل..."
echo ""
echo "💡 ملاحظة: اختر (Client) أو (Barber) من الشاشة الرئيسية"
echo ""
echo "════════════════════════════════════════════"
echo ""

# تشغيل التطبيق
flutter run

echo ""
echo "✅ انتهى!"
