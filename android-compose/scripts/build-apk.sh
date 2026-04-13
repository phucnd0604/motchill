#!/bin/bash
# Build debug APK và copy vào docs/
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
OUTPUT_DIR="$PROJECT_DIR/docs"

# Dùng JDK bundled trong Android Studio nếu chưa có JAVA_HOME
if [ -z "$JAVA_HOME" ] || ! command -v java &>/dev/null; then
  AS_JBR="/Applications/Android Studio.app/Contents/jbr/Contents/Home"
  AS_JRE="/Applications/Android Studio.app/Contents/jre/Contents/Home"
  if [ -d "$AS_JBR" ]; then
    export JAVA_HOME="$AS_JBR"
  elif [ -d "$AS_JRE" ]; then
    export JAVA_HOME="$AS_JRE"
  else
    echo "❌ Không tìm thấy JDK. Hãy set JAVA_HOME thủ công."
    exit 1
  fi
  export PATH="$JAVA_HOME/bin:$PATH"
  echo "☕ Using JDK: $JAVA_HOME"
fi

echo "📦 Building debug APK..."
cd "$PROJECT_DIR"
./gradlew assembleDebug

APK_SRC="$PROJECT_DIR/app/build/outputs/apk/debug/app-debug.apk"
APK_DST="$OUTPUT_DIR/phuctv-debug.apk"

cp "$APK_SRC" "$APK_DST"
echo "✅ APK saved to: $APK_DST"
