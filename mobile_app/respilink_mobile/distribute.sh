firebase appdistribution:distribute \
  "D:\StudioProjects\doctor_app\mobile_app\respilink_mobile\build\app\outputs\flutter-apk/medsynapse.apk" \
  --app 1:935471196970:android:770418ae6bc2bd27f4cc53 \
  --groups "doctor-testers" \
  --release-notes "$RELEASE_NOTES"