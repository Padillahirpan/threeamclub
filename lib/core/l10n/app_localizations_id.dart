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

  @override
  String get dashboardTitle => 'Kemajuanmu';

  @override
  String get dashEmptyTitle => 'Hari 1 dimulai malam ini.';

  @override
  String get dashEmptyBody =>
      'Tanda tangani rencanamu malam ini — matahari pertama terbit besok.';

  @override
  String get dashHeroKept => 'Janji ditepati.';

  @override
  String dashCount(int kept, int total) {
    return '$kept dari $total';
  }

  @override
  String get dashHeroRest => 'Istirahat hari ini. Runtunan menunggumu.';

  @override
  String get dashHeroMissed => 'Pagi baru, awal baru.';

  @override
  String get dashFreshTomorrow => 'Awal baru besok.';

  @override
  String get dashFreshMonday => 'Awal baru hari Senin.';

  @override
  String get dashFreshFirst => 'Awal baru tanggal 1.';

  @override
  String dashForward(String time) {
    return 'Besok matahari terbit pukul $time.';
  }

  @override
  String get streakCurrentLabel => 'Runtunan sekarang';

  @override
  String get streakBestLabel => 'Runtunan terbaik';

  @override
  String streakDays(int days) {
    return '$days hari';
  }

  @override
  String get streakDayOne => '1 hari';

  @override
  String milestoneNextDays(int days, int milestone) {
    return '$days hari lagi menuju matahari $milestone harimu';
  }

  @override
  String milestoneNextDay(int milestone) {
    return '1 hari lagi menuju matahari $milestone harimu';
  }

  @override
  String journeyDayLabel(int day, int total) {
    return 'Hari $day dari $total';
  }

  @override
  String get journeyPhase1 => 'Patahkan pola lama';

  @override
  String get journeyPhase2 => 'Bangun yang baru';

  @override
  String get journeyPhase3 => 'Jadikan milikmu';

  @override
  String get weekTitle => '7 hari terakhir';

  @override
  String get winsTitle => 'Kemenangan';

  @override
  String get winsMinutesLabel => 'Waktu untuk yang penting';

  @override
  String winsMinutesHm(int hours, int minutes) {
    return '${hours}j ${minutes}m';
  }

  @override
  String winsMinutesM(int minutes) {
    return '${minutes}m';
  }

  @override
  String get winsEarliestLabel => 'Bangun paling pagi';

  @override
  String get winsMostKeptLabel => 'Paling sering ditepati';

  @override
  String get promiseRatesTitle => 'Janji · 30 hari terakhir';

  @override
  String rateCaption(int kept, int total) {
    return '$kept dari $total';
  }

  @override
  String get tonightTitle => 'Malam ini';

  @override
  String get tonightWake => 'Bangun';

  @override
  String get tonightBed => 'Tidur';

  @override
  String tonightPromises(int count) {
    return '$count janji';
  }

  @override
  String get restAction => 'Istirahat besok';

  @override
  String get restConfirmTitle => 'Istirahat besok?';

  @override
  String get restConfirmBody => 'Tanpa alarm besok. Runtunan menunggumu.';

  @override
  String get restUsed => 'Hari istirahat sudah dipakai minggu ini';

  @override
  String get restActive => 'Hari istirahat';

  @override
  String get weekDotKept => 'Ditepati';

  @override
  String get weekDotFull => 'Semua janji ditepati';

  @override
  String get weekDotRest => 'Hari istirahat';

  @override
  String get weekDotMissed => 'Hari tenang';

  @override
  String get weekDotUpcoming => 'Belum tiba';

  @override
  String get weekDotNone => 'Tidak ada rencana';

  @override
  String get settingsTitle => 'Pengaturan';

  @override
  String get settingsWakelock => 'Layar tetap menyala saat timer';

  @override
  String get settingsLead => 'Jeda pengingat waktu tidur';

  @override
  String minutesShort(int minutes) {
    return '$minutes mnt';
  }

  @override
  String get settingsBackup => 'Cadangkan & pulihkan';

  @override
  String get backupTitle => 'Cadangkan & pulihkan';

  @override
  String get backupBody =>
      'Semua data hanya ada di ponsel ini. Ekspor file cadangan atau pulihkan darinya.';

  @override
  String get backupExport => 'Ekspor cadangan';

  @override
  String get backupExportDone => 'Cadangan siap dibagikan';

  @override
  String get backupImport => 'Pulihkan dari file';

  @override
  String get backupPreviewTitle => 'Pulihkan cadangan ini?';

  @override
  String backupPreviewCounts(int mornings, int promises, int plans) {
    return '$mornings pagi · $promises janji · $plans rencana';
  }

  @override
  String get backupReplaceNote =>
      'Memulihkan akan mengganti semua data di ponsel ini.';

  @override
  String get backupRestoreDone => 'Dipulihkan';

  @override
  String get backupInvalidFile => 'File itu bukan cadangan yang valid';
}
