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
  String get dashboardPlaceholderTitle => 'Your progress';

  @override
  String get dashboardPlaceholderBody =>
      'The dashboard arrives in the next build.';

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
  String get focusTimerComing =>
      'The locked countdown timer arrives in the next build.';
}
