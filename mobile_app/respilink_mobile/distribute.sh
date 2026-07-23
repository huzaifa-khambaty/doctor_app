firebase appdistribution:distribute \
  build/app/outputs/flutter-apk/doctor.apk \
  --app 1:935471196970:android:770418ae6bc2bd27f4cc53 \
  --groups "doctor-testers" \
  --release-notes "$RELEASE_NOTES"