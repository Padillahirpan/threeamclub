// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appTitle => '3AM Club';

  @override
  String get next => 'Lanjut';

  @override
  String get cancel => 'Batal';

  @override
  String get save => 'Simpan';

  @override
  String get delete => 'Hapus';

  @override
  String get edit => 'Ubah';

  @override
  String get confirm => 'Konfirmasi';

  @override
  String get archive => 'Arsipkan';

  @override
  String get onbTitle => 'Selamat datang di 3AM Club';

  @override
  String get onbIntro =>
      'Cara tenang membangun kebiasaan bangun pagi. Semuanya tersimpan di ponselmu.';

  @override
  String get onbNotifTitle => 'Notifikasi';

  @override
  String get onbNotifBody =>
      'Agar pengingat waktu tidur dan alarm bisa sampai kepadamu.';

  @override
  String get onbFsiTitle => 'Tampil di atas layar kunci';

  @override
  String get onbFsiBody =>
      'Agar layar bangun muncul begitu alarm berbunyi, meski ponsel terkunci.';

  @override
  String get onbBatteryTitle => 'Alarm yang andal';

  @override
  String get onbBatteryBody =>
      'Minta ponselmu untuk tidak mematikan aplikasi, agar alarm selalu berbunyi. (Disarankan)';

  @override
  String get onbAllow => 'Izinkan yang dibutuhkan';

  @override
  String get onbSkip => 'Atur nanti';

  @override
  String get planTitle => 'Rencana tidur';

  @override
  String get bedtimeLabel => 'Waktu tidur';

  @override
  String get wakeTimeLabel => 'Waktu bangun';

  @override
  String sleepDurationChip(int hours, int minutes) {
    return '${hours}j ${minutes}m tidur';
  }

  @override
  String sleepDurationChipH(int hours) {
    return '$hours jam tidur';
  }

  @override
  String sleepDurationChipM(int minutes) {
    return '$minutes menit tidur';
  }

  @override
  String get sleepHint => 'Tidur lebih awal = pagi lebih ringan.';

  @override
  String get wakeRangeHint => 'Pilih waktu antara 3:00 dan 5:00';

  @override
  String get checklistTitle => 'Checklist sebelum tidur';

  @override
  String get checklistAddHint => 'Tambahkan item…';

  @override
  String get checklistRenameTitle => 'Ganti nama item';

  @override
  String get checklistSuggestion1 => 'Letakkan ponsel di charger';

  @override
  String get checklistSuggestion2 => 'Siapkan pakaian shalat';

  @override
  String get checklistSuggestion3 => 'Siapkan pakaian olahraga';

  @override
  String get checklistSuggestion4 => 'Sikat gigi dan wudu';

  @override
  String get planNext => 'Lanjut: pilih janji pagimu';

  @override
  String get promisesTitle => 'Janji pagi';

  @override
  String budgetUsedOf(int used, int budget) {
    return '$used dari $budget mnt sebelum 6:00';
  }

  @override
  String overBudget(int minutes) {
    return 'Kurangi $minutes menit agar muat sebelum 6:00';
  }

  @override
  String get startSmall =>
      'Mulai kecil membuat kebiasaan lebih menempel. Kamu bisa menambah nanti.';

  @override
  String get addPromise => 'Tambah janji';

  @override
  String get promiseTitleLabel => 'Judul';

  @override
  String get promiseTitleHint => 'mis. Shalat Tahajud';

  @override
  String get promiseDescriptionLabel => 'Deskripsi (opsional)';

  @override
  String get promiseDurationLabel => 'Durasi';

  @override
  String durationMinutes(int minutes) {
    return '$minutes mnt';
  }

  @override
  String get customDuration => 'Kustom';

  @override
  String get categoryLabel => 'Kategori';

  @override
  String get newCategory => 'Kategori baru';

  @override
  String get newCategoryName => 'Nama kategori';

  @override
  String get chooseIcon => 'Ikon';

  @override
  String get chooseColor => 'Warna';

  @override
  String get createCategory => 'Buat';

  @override
  String get saveChanges => 'Simpan perubahan';

  @override
  String get editCategoryTitle => 'Ubah kategori';

  @override
  String get archiveCategoryTitle => 'Arsipkan kategori?';

  @override
  String get archiveCategoryBody =>
      'Kategori yang diarsipkan disembunyikan dari builder.';

  @override
  String get categoryArchived => 'Kategori diarsipkan';

  @override
  String get deletePromiseTitle => 'Hapus janji ini?';

  @override
  String get deletePromiseBody => 'Kamu bisa menambahkannya lagi kapan saja.';

  @override
  String get signNeedsPromise =>
      'Tambahkan minimal satu janji untuk menandatangani.';

  @override
  String get reviewPromise => 'Tinjau janjiku';

  @override
  String get signTitle => 'Tandatangani janjimu';

  @override
  String get signWakeLabel => 'Bangun';

  @override
  String get signBedtimeLabel => 'Tidur';

  @override
  String get signSleepLabel => 'Durasi tidur';

  @override
  String get signChecklistLabel => 'Checklist sebelum tidur';

  @override
  String get signWhyTitle => 'Mengapa aku melakukan ini?';

  @override
  String get signWhyHint =>
      'Satu atau dua kalimat. Kalimat ini akan menemanimu pukul 4 pagi.';

  @override
  String get signHold => 'Tahan untuk menandatangani';

  @override
  String get signWithoutHold => 'Tandatangani tanpa menahan';

  @override
  String finishAround(String time) {
    return 'Selesai sekitar $time';
  }

  @override
  String get promiseSigned => 'Janji ditandatangani';

  @override
  String get nightPlaceholderTitle => 'Malam ini, kamu menepati janji.';

  @override
  String get nightPlaceholderBody =>
      'Layar malam yang lengkap hadir di build berikutnya.';

  @override
  String get wakePlaceholderTitle => 'Selamat pagi.';

  @override
  String get wakePlaceholderBody => 'Layar bangun hadir di build berikutnya.';

  @override
  String get focusPlaceholderTitle => 'Satu janji, satu per satu.';

  @override
  String get focusPlaceholderBody => 'Layar fokus hadir di build berikutnya.';

  @override
  String get dashboardPlaceholderTitle => 'Kemajuanmu';

  @override
  String get dashboardPlaceholderBody => 'Dasbor hadir di build berikutnya.';

  @override
  String get alarmSpikeTitle => 'Uji alarm (debug)';

  @override
  String get notifBedtimeTitle => '3AM Club';

  @override
  String get notifBedtimeBody => 'Malam ini, kamu menepati janji.';

  @override
  String get alarmWakeLine => 'Selamat pagi. Kamu sudah berjanji.';

  @override
  String get nightTitle => 'Malam ini, kamu menepati janji.';

  @override
  String get nightLine => 'Istirahatlah. Pagi sudah berpihak padamu.';

  @override
  String get chargingLine =>
      'Biarkan ponselmu tetap terisi daya dan dekat denganmu.';

  @override
  String get viewProgress => 'Lihat kemajuan';

  @override
  String get checklistOptionalHint => 'Opsional — centang yang sudah selesai';

  @override
  String get wakeHeadline => 'Selamat pagi. Kamu sudah berjanji.';

  @override
  String get wakeDefaultLine =>
      'Bagian tersulit hanya satu menit ini. Tahan sebentar.';

  @override
  String get wakeHoldLabel => 'Tahan untuk bangun';

  @override
  String get wakeTapAlt => 'Ketuk untuk berhenti (aksesibilitas)';

  @override
  String get focusGreeting => 'Satu janji, satu per satu.';

  @override
  String focusTimeLeft(int minutes) {
    return '$minutes menit lagi sebelum 06:00';
  }

  @override
  String focusProgress(int kept, int total) {
    return '$kept dari $total janji ditepati';
  }

  @override
  String get statusNotStarted => 'Belum dimulai';

  @override
  String get statusInProgress => 'Sedang berjalan';

  @override
  String get statusKept => 'Ditepati';

  @override
  String get statusNotFinished => 'Tidak selesai hari ini';

  @override
  String get focusAllKept => 'Semua janji ditepati. Lihat matahari itu.';

  @override
  String get seeYourProgress => 'Lihat kemajuanmu';

  @override
  String get timerStart => 'Mulai';

  @override
  String get timerComplete => 'Selesai';

  @override
  String timerMinutesLeft(int minutes) {
    return '$minutes menit lagi';
  }

  @override
  String get timerEndEarly => 'Akhiri lebih awal (tahan)';

  @override
  String get timerEndEarlyTitle => 'Akhiri sekarang?';

  @override
  String get timerEndEarlyBody => 'Tidak apa-apa. Besok ada kesempatan lagi.';

  @override
  String get timerLine => 'Cukup ini saja.';

  @override
  String get promiseKept => 'Ditepati. Itu berarti.';
}
