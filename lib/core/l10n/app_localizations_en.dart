// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => '3AM Club';

  @override
  String get next => 'Next';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get confirm => 'Confirm';

  @override
  String get archive => 'Archive';

  @override
  String get onbTitle => 'Welcome to the 3AM Club';

  @override
  String get onbIntro =>
      'A calm way to build the habit of waking early. Everything stays on your phone.';

  @override
  String get onbNotifTitle => 'Notifications';

  @override
  String get onbNotifBody =>
      'So the bedtime reminder and the alarm can reach you.';

  @override
  String get onbFsiTitle => 'Show over the lock screen';

  @override
  String get onbFsiBody =>
      'Lets the wake screen appear the moment the alarm rings, even while the phone is locked.';

  @override
  String get onbBatteryTitle => 'Reliable alarms';

  @override
  String get onbBatteryBody =>
      'Ask your phone not to put the app to sleep, so the alarm always rings. (Recommended)';

  @override
  String get onbAllow => 'Allow what\'s needed';

  @override
  String get onbSkip => 'Set up later';

  @override
  String get planTitle => 'Sleep plan';

  @override
  String get bedtimeLabel => 'Bedtime';

  @override
  String get wakeTimeLabel => 'Wake time';

  @override
  String sleepDurationChip(int hours, int minutes) {
    return '${hours}h ${minutes}m of sleep';
  }

  @override
  String sleepDurationChipH(int hours) {
    return '${hours}h of sleep';
  }

  @override
  String sleepDurationChipM(int minutes) {
    return '${minutes}m of sleep';
  }

  @override
  String get sleepHint => 'Earlier bedtime = easier mornings.';

  @override
  String get wakeRangeHint => 'Pick a time between 3:00 and 5:00';

  @override
  String get checklistTitle => 'Pre-sleep checklist';

  @override
  String get checklistAddHint => 'Add an item…';

  @override
  String get checklistRenameTitle => 'Rename item';

  @override
  String get checklistSuggestion1 => 'Put phone on charge';

  @override
  String get checklistSuggestion2 => 'Set out prayer clothes';

  @override
  String get checklistSuggestion3 => 'Lay out workout clothes';

  @override
  String get checklistSuggestion4 => 'Brush teeth and wudu';

  @override
  String get planNext => 'Next: choose your morning promises';

  @override
  String get promisesTitle => 'Morning promises';

  @override
  String budgetUsedOf(int used, int budget) {
    return '$used of $budget min before 6:00';
  }

  @override
  String overBudget(int minutes) {
    return 'Trim $minutes min to fit before 6:00';
  }

  @override
  String get startSmall =>
      'Starting small helps habits stick. You can add more later.';

  @override
  String get addPromise => 'Add a promise';

  @override
  String get promiseTitleLabel => 'Title';

  @override
  String get promiseTitleHint => 'e.g. Tahajud prayer';

  @override
  String get promiseDescriptionLabel => 'Description (optional)';

  @override
  String get promiseDurationLabel => 'Duration';

  @override
  String durationMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String get customDuration => 'Custom';

  @override
  String get categoryLabel => 'Category';

  @override
  String get newCategory => 'New category';

  @override
  String get newCategoryName => 'Category name';

  @override
  String get chooseIcon => 'Icon';

  @override
  String get chooseColor => 'Color';

  @override
  String get createCategory => 'Create';

  @override
  String get saveChanges => 'Save changes';

  @override
  String get editCategoryTitle => 'Edit category';

  @override
  String get archiveCategoryTitle => 'Archive category?';

  @override
  String get archiveCategoryBody =>
      'Archived categories are hidden from the builder.';

  @override
  String get categoryArchived => 'Category archived';

  @override
  String get deletePromiseTitle => 'Delete this promise?';

  @override
  String get deletePromiseBody => 'You can add it back anytime.';

  @override
  String get signNeedsPromise => 'Add at least one promise to sign.';

  @override
  String get reviewPromise => 'Review my promise';

  @override
  String get signTitle => 'Sign your promise';

  @override
  String get signWakeLabel => 'Wake';

  @override
  String get signBedtimeLabel => 'Bedtime';

  @override
  String get signSleepLabel => 'Sleep';

  @override
  String get signChecklistLabel => 'Pre-sleep checklist';

  @override
  String get signWhyTitle => 'Why am I doing this?';

  @override
  String get signWhyHint =>
      'One or two sentences. They will meet you at 4 a.m.';

  @override
  String get signHold => 'Hold to sign';

  @override
  String get signWithoutHold => 'Sign without holding';

  @override
  String finishAround(String time) {
    return 'Finishes around $time';
  }

  @override
  String get promiseSigned => 'Promise signed';

  @override
  String get nightPlaceholderTitle => 'Tonight, you keep your promise.';

  @override
  String get nightPlaceholderBody =>
      'The full night screen arrives in the next build.';

  @override
  String get wakePlaceholderTitle => 'Good morning.';

  @override
  String get wakePlaceholderBody =>
      'The wake screen arrives in the next build.';

  @override
  String get focusPlaceholderTitle => 'One promise at a time.';

  @override
  String get focusPlaceholderBody =>
      'The focus screen arrives in the next build.';

  @override
  String get alarmSpikeTitle => 'Alarm spike (debug)';

  @override
  String get notifBedtimeTitle => '3AM Club';

  @override
  String get notifBedtimeBody => 'Tonight, you keep your promise.';

  @override
  String get alarmWakeLine => 'Good morning. You said you would.';

  @override
  String get nightTitle => 'Tonight, you keep your promise.';

  @override
  String get nightLine => 'Rest well. Morning is already on your side.';

  @override
  String get chargingLine => 'Keep your phone charging and close to you.';

  @override
  String get viewProgress => 'View progress';

  @override
  String get checklistOptionalHint => 'Optional — tick what\'s done';

  @override
  String get wakeHeadline => 'Good morning. You said you would.';

  @override
  String get wakeDefaultLine => 'The hardest part is this one minute. Hold on.';

  @override
  String get wakeHoldLabel => 'Hold to wake up';

  @override
  String get wakeTapAlt => 'Tap to stop instead (accessibility)';

  @override
  String get focusGreeting => 'One promise at a time.';

  @override
  String focusTimeLeft(int minutes) {
    return '$minutes min until 6:00';
  }

  @override
  String focusProgress(int kept, int total) {
    return '$kept of $total promises kept';
  }

  @override
  String get statusNotStarted => 'Not started';

  @override
  String get statusInProgress => 'In progress';

  @override
  String get statusKept => 'Kept';

  @override
  String get statusNotFinished => 'Not finished today';

  @override
  String get focusAllKept => 'Every promise kept. Look at that sun.';

  @override
  String get seeYourProgress => 'See your progress';

  @override
  String get timerStart => 'Start';

  @override
  String get timerComplete => 'Complete';

  @override
  String timerMinutesLeft(int minutes) {
    return '$minutes min left';
  }

  @override
  String get timerEndEarly => 'End early (hold)';

  @override
  String get timerEndEarlyTitle => 'End this early?';

  @override
  String get timerEndEarlyBody => 'It\'s okay. Tomorrow is another chance.';

  @override
  String get timerLine => 'Just this. Nothing else.';

  @override
  String get promiseKept => 'Kept. That counts.';

  @override
  String get dashboardTitle => 'Your progress';

  @override
  String get dashEmptyTitle => 'Day 1 starts tonight.';

  @override
  String get dashEmptyBody =>
      'Sign your plan this evening — the first sunrise is tomorrow.';

  @override
  String get dashHeroKept => 'Promise kept.';

  @override
  String dashCount(int kept, int total) {
    return '$kept of $total';
  }

  @override
  String get dashHeroRest => 'Rest today. The streak waits for you.';

  @override
  String get dashHeroMissed => 'New morning, fresh start.';

  @override
  String get dashFreshTomorrow => 'A fresh start tomorrow.';

  @override
  String get dashFreshMonday => 'A fresh start on Monday.';

  @override
  String get dashFreshFirst => 'A fresh start on the 1st.';

  @override
  String dashForward(String time) {
    return 'Tomorrow the sun rises at $time.';
  }

  @override
  String get streakCurrentLabel => 'Current streak';

  @override
  String get streakBestLabel => 'Best streak';

  @override
  String streakDays(int days) {
    return '$days days';
  }

  @override
  String get streakDayOne => '1 day';

  @override
  String milestoneNextDays(int days, int milestone) {
    return '$days days to your $milestone-day sun';
  }

  @override
  String milestoneNextDay(int milestone) {
    return '1 day to your $milestone-day sun';
  }

  @override
  String journeyDayLabel(int day, int total) {
    return 'Day $day of $total';
  }

  @override
  String get journeyPhase1 => 'Break the old pattern';

  @override
  String get journeyPhase2 => 'Build the new one';

  @override
  String get journeyPhase3 => 'Make it yours';

  @override
  String get weekTitle => 'Last 7 days';

  @override
  String get winsTitle => 'Wins';

  @override
  String get winsMinutesLabel => 'Time on what matters';

  @override
  String winsMinutesHm(int hours, int minutes) {
    return '${hours}h ${minutes}m';
  }

  @override
  String winsMinutesM(int minutes) {
    return '${minutes}m';
  }

  @override
  String get winsEarliestLabel => 'Earliest wake';

  @override
  String get winsMostKeptLabel => 'Most kept';

  @override
  String get promiseRatesTitle => 'Promises · last 30 days';

  @override
  String rateCaption(int kept, int total) {
    return '$kept of $total';
  }

  @override
  String get tonightTitle => 'Tonight';

  @override
  String get tonightWake => 'Wake';

  @override
  String get tonightBed => 'Bedtime';

  @override
  String tonightPromises(int count) {
    return '$count promises';
  }

  @override
  String get restAction => 'Rest tomorrow';

  @override
  String get restConfirmTitle => 'Rest tomorrow?';

  @override
  String get restConfirmBody => 'No alarm tomorrow. The streak waits for you.';

  @override
  String get restUsed => 'Rest day used this week';

  @override
  String get restActive => 'Rest day';

  @override
  String get weekDotKept => 'Kept';

  @override
  String get weekDotFull => 'Every promise kept';

  @override
  String get weekDotRest => 'Rest day';

  @override
  String get weekDotMissed => 'Quiet day';

  @override
  String get weekDotUpcoming => 'Not yet';

  @override
  String get weekDotNone => 'No plan';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsWakelock => 'Keep screen on during timer';

  @override
  String get settingsLead => 'Bedtime reminder lead';

  @override
  String minutesShort(int minutes) {
    return '$minutes min';
  }

  @override
  String get settingsBackup => 'Backup & restore';

  @override
  String get backupTitle => 'Backup & restore';

  @override
  String get backupBody =>
      'Everything lives only on this phone. Export a backup file or restore from one.';

  @override
  String get backupExport => 'Export backup';

  @override
  String get backupExportDone => 'Backup ready to share';

  @override
  String get backupImport => 'Restore from file';

  @override
  String get backupPreviewTitle => 'Restore this backup?';

  @override
  String backupPreviewCounts(int mornings, int promises, int plans) {
    return '$mornings mornings · $promises promises · $plans plans';
  }

  @override
  String get backupReplaceNote =>
      'Restoring replaces everything on this phone.';

  @override
  String get backupRestoreDone => 'Restored';

  @override
  String get backupInvalidFile => 'That file is not a valid backup';

  @override
  String get healthWarnTitle => 'The alarm may not ring';

  @override
  String get healthWarnBody =>
      'A needed permission is off. Without it the wake screen can\'t appear.';

  @override
  String get healthFixNow => 'Fix now';

  @override
  String get settingsBattery => 'Make sure the alarm rings';

  @override
  String get batteryHelpTitle => 'Make sure the alarm rings';

  @override
  String get batteryHelpIntro =>
      'Phone makers save battery by putting apps to sleep. Three settings keep 3AM Club reliable.';

  @override
  String get batteryStepAutoStart =>
      'Allow auto-start (or remove restrictions) so the app can start for the alarm.';

  @override
  String get batteryStepUnrestricted =>
      'Set battery use to Unrestricted (not Optimized) in app battery settings.';

  @override
  String get batteryStepPin =>
      'Lock the app in Recents so the system keeps it alive.';

  @override
  String batteryForBrand(String brand) {
    return 'For your $brand';
  }

  @override
  String get batteryBrandSamsung =>
      'Samsung: Settings → Battery → Background usage limits → make sure 3AM Club is not sleeping; set its Battery to Unrestricted, and turn off Put unused apps to sleep.';

  @override
  String get batteryBrandXiaomi =>
      'Xiaomi/POCO: Security app → Manage apps → 3AM Club → Autostart on, Battery saver: No restrictions, and lock the app in Recents.';

  @override
  String get batteryBrandOppo =>
      'OPPO/Realme/OnePlus: Settings → Battery → More settings → allow 3AM Club: Autostart, and allow background activity in the app\'s battery usage.';

  @override
  String get batteryBrandVivo =>
      'vivo/iQOO: Settings → Battery → Background power consumption → allow 3AM Club, and enable Autostart in the app manager.';

  @override
  String get batteryBrandHuawei =>
      'Huawei/Honor: Settings → Battery → App launch → 3AM Club → disable Manage automatically, enable all three options.';

  @override
  String get batteryBrandGeneric =>
      'Look for the app\'s battery settings (often under Battery or Apps) and choose Unrestricted, plus any Auto-start or Background activity switch.';

  @override
  String get batteryDone => 'Done';
}
