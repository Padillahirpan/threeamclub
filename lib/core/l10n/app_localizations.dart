import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_id.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('id'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'3AM Club'**
  String get appTitle;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @archive.
  ///
  /// In en, this message translates to:
  /// **'Archive'**
  String get archive;

  /// No description provided for @onbTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to the 3AM Club'**
  String get onbTitle;

  /// No description provided for @onbIntro.
  ///
  /// In en, this message translates to:
  /// **'A calm way to build the habit of waking early. Everything stays on your phone.'**
  String get onbIntro;

  /// No description provided for @onbNotifTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get onbNotifTitle;

  /// No description provided for @onbNotifBody.
  ///
  /// In en, this message translates to:
  /// **'So the bedtime reminder and the alarm can reach you.'**
  String get onbNotifBody;

  /// No description provided for @onbFsiTitle.
  ///
  /// In en, this message translates to:
  /// **'Show over the lock screen'**
  String get onbFsiTitle;

  /// No description provided for @onbFsiBody.
  ///
  /// In en, this message translates to:
  /// **'Lets the wake screen appear the moment the alarm rings, even while the phone is locked.'**
  String get onbFsiBody;

  /// No description provided for @onbBatteryTitle.
  ///
  /// In en, this message translates to:
  /// **'Reliable alarms'**
  String get onbBatteryTitle;

  /// No description provided for @onbBatteryBody.
  ///
  /// In en, this message translates to:
  /// **'Ask your phone not to put the app to sleep, so the alarm always rings. (Recommended)'**
  String get onbBatteryBody;

  /// No description provided for @onbAllow.
  ///
  /// In en, this message translates to:
  /// **'Allow what\'s needed'**
  String get onbAllow;

  /// No description provided for @onbSkip.
  ///
  /// In en, this message translates to:
  /// **'Set up later'**
  String get onbSkip;

  /// No description provided for @planTitle.
  ///
  /// In en, this message translates to:
  /// **'Sleep plan'**
  String get planTitle;

  /// No description provided for @bedtimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Bedtime'**
  String get bedtimeLabel;

  /// No description provided for @wakeTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Wake time'**
  String get wakeTimeLabel;

  /// No description provided for @sleepDurationChip.
  ///
  /// In en, this message translates to:
  /// **'{hours}h {minutes}m of sleep'**
  String sleepDurationChip(int hours, int minutes);

  /// No description provided for @sleepDurationChipH.
  ///
  /// In en, this message translates to:
  /// **'{hours}h of sleep'**
  String sleepDurationChipH(int hours);

  /// No description provided for @sleepDurationChipM.
  ///
  /// In en, this message translates to:
  /// **'{minutes}m of sleep'**
  String sleepDurationChipM(int minutes);

  /// No description provided for @sleepHint.
  ///
  /// In en, this message translates to:
  /// **'Earlier bedtime = easier mornings.'**
  String get sleepHint;

  /// No description provided for @wakeRangeHint.
  ///
  /// In en, this message translates to:
  /// **'Pick a time between 3:00 and 5:00'**
  String get wakeRangeHint;

  /// No description provided for @checklistTitle.
  ///
  /// In en, this message translates to:
  /// **'Pre-sleep checklist'**
  String get checklistTitle;

  /// No description provided for @checklistAddHint.
  ///
  /// In en, this message translates to:
  /// **'Add an item…'**
  String get checklistAddHint;

  /// No description provided for @checklistRenameTitle.
  ///
  /// In en, this message translates to:
  /// **'Rename item'**
  String get checklistRenameTitle;

  /// No description provided for @checklistSuggestion1.
  ///
  /// In en, this message translates to:
  /// **'Put phone on charge'**
  String get checklistSuggestion1;

  /// No description provided for @checklistSuggestion2.
  ///
  /// In en, this message translates to:
  /// **'Set out prayer clothes'**
  String get checklistSuggestion2;

  /// No description provided for @checklistSuggestion3.
  ///
  /// In en, this message translates to:
  /// **'Lay out workout clothes'**
  String get checklistSuggestion3;

  /// No description provided for @checklistSuggestion4.
  ///
  /// In en, this message translates to:
  /// **'Brush teeth and wudu'**
  String get checklistSuggestion4;

  /// No description provided for @planNext.
  ///
  /// In en, this message translates to:
  /// **'Next: choose your morning promises'**
  String get planNext;

  /// No description provided for @promisesTitle.
  ///
  /// In en, this message translates to:
  /// **'Morning promises'**
  String get promisesTitle;

  /// No description provided for @budgetUsedOf.
  ///
  /// In en, this message translates to:
  /// **'{used} of {budget} min before 6:00'**
  String budgetUsedOf(int used, int budget);

  /// No description provided for @overBudget.
  ///
  /// In en, this message translates to:
  /// **'Trim {minutes} min to fit before 6:00'**
  String overBudget(int minutes);

  /// No description provided for @startSmall.
  ///
  /// In en, this message translates to:
  /// **'Starting small helps habits stick. You can add more later.'**
  String get startSmall;

  /// No description provided for @addPromise.
  ///
  /// In en, this message translates to:
  /// **'Add a promise'**
  String get addPromise;

  /// No description provided for @promiseTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get promiseTitleLabel;

  /// No description provided for @promiseTitleHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Tahajud prayer'**
  String get promiseTitleHint;

  /// No description provided for @promiseDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Description (optional)'**
  String get promiseDescriptionLabel;

  /// No description provided for @promiseDurationLabel.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get promiseDurationLabel;

  /// No description provided for @durationMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String durationMinutes(int minutes);

  /// No description provided for @customDuration.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get customDuration;

  /// No description provided for @categoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get categoryLabel;

  /// No description provided for @newCategory.
  ///
  /// In en, this message translates to:
  /// **'New category'**
  String get newCategory;

  /// No description provided for @newCategoryName.
  ///
  /// In en, this message translates to:
  /// **'Category name'**
  String get newCategoryName;

  /// No description provided for @chooseIcon.
  ///
  /// In en, this message translates to:
  /// **'Icon'**
  String get chooseIcon;

  /// No description provided for @chooseColor.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get chooseColor;

  /// No description provided for @createCategory.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get createCategory;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get saveChanges;

  /// No description provided for @editCategoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit category'**
  String get editCategoryTitle;

  /// No description provided for @archiveCategoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Archive category?'**
  String get archiveCategoryTitle;

  /// No description provided for @archiveCategoryBody.
  ///
  /// In en, this message translates to:
  /// **'Archived categories are hidden from the builder.'**
  String get archiveCategoryBody;

  /// No description provided for @categoryArchived.
  ///
  /// In en, this message translates to:
  /// **'Category archived'**
  String get categoryArchived;

  /// No description provided for @deletePromiseTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this promise?'**
  String get deletePromiseTitle;

  /// No description provided for @deletePromiseBody.
  ///
  /// In en, this message translates to:
  /// **'You can add it back anytime.'**
  String get deletePromiseBody;

  /// No description provided for @signNeedsPromise.
  ///
  /// In en, this message translates to:
  /// **'Add at least one promise to sign.'**
  String get signNeedsPromise;

  /// No description provided for @reviewPromise.
  ///
  /// In en, this message translates to:
  /// **'Review my promise'**
  String get reviewPromise;

  /// No description provided for @signTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign your promise'**
  String get signTitle;

  /// No description provided for @signWakeLabel.
  ///
  /// In en, this message translates to:
  /// **'Wake'**
  String get signWakeLabel;

  /// No description provided for @signBedtimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Bedtime'**
  String get signBedtimeLabel;

  /// No description provided for @signSleepLabel.
  ///
  /// In en, this message translates to:
  /// **'Sleep'**
  String get signSleepLabel;

  /// No description provided for @signChecklistLabel.
  ///
  /// In en, this message translates to:
  /// **'Pre-sleep checklist'**
  String get signChecklistLabel;

  /// No description provided for @signWhyTitle.
  ///
  /// In en, this message translates to:
  /// **'Why am I doing this?'**
  String get signWhyTitle;

  /// No description provided for @signWhyHint.
  ///
  /// In en, this message translates to:
  /// **'One or two sentences. They will meet you at 4 a.m.'**
  String get signWhyHint;

  /// No description provided for @signHold.
  ///
  /// In en, this message translates to:
  /// **'Hold to sign'**
  String get signHold;

  /// No description provided for @signWithoutHold.
  ///
  /// In en, this message translates to:
  /// **'Sign without holding'**
  String get signWithoutHold;

  /// No description provided for @finishAround.
  ///
  /// In en, this message translates to:
  /// **'Finishes around {time}'**
  String finishAround(String time);

  /// No description provided for @promiseSigned.
  ///
  /// In en, this message translates to:
  /// **'Promise signed'**
  String get promiseSigned;

  /// No description provided for @nightPlaceholderTitle.
  ///
  /// In en, this message translates to:
  /// **'Tonight, you keep your promise.'**
  String get nightPlaceholderTitle;

  /// No description provided for @nightPlaceholderBody.
  ///
  /// In en, this message translates to:
  /// **'The full night screen arrives in the next build.'**
  String get nightPlaceholderBody;

  /// No description provided for @wakePlaceholderTitle.
  ///
  /// In en, this message translates to:
  /// **'Good morning.'**
  String get wakePlaceholderTitle;

  /// No description provided for @wakePlaceholderBody.
  ///
  /// In en, this message translates to:
  /// **'The wake screen arrives in the next build.'**
  String get wakePlaceholderBody;

  /// No description provided for @focusPlaceholderTitle.
  ///
  /// In en, this message translates to:
  /// **'One promise at a time.'**
  String get focusPlaceholderTitle;

  /// No description provided for @focusPlaceholderBody.
  ///
  /// In en, this message translates to:
  /// **'The focus screen arrives in the next build.'**
  String get focusPlaceholderBody;

  /// No description provided for @alarmSpikeTitle.
  ///
  /// In en, this message translates to:
  /// **'Alarm spike (debug)'**
  String get alarmSpikeTitle;

  /// No description provided for @notifBedtimeTitle.
  ///
  /// In en, this message translates to:
  /// **'3AM Club'**
  String get notifBedtimeTitle;

  /// No description provided for @notifBedtimeBody.
  ///
  /// In en, this message translates to:
  /// **'Tonight, you keep your promise.'**
  String get notifBedtimeBody;

  /// No description provided for @alarmWakeLine.
  ///
  /// In en, this message translates to:
  /// **'Good morning. You said you would.'**
  String get alarmWakeLine;

  /// No description provided for @nightTitle.
  ///
  /// In en, this message translates to:
  /// **'Tonight, you keep your promise.'**
  String get nightTitle;

  /// No description provided for @nightLine.
  ///
  /// In en, this message translates to:
  /// **'Rest well. Morning is already on your side.'**
  String get nightLine;

  /// No description provided for @chargingLine.
  ///
  /// In en, this message translates to:
  /// **'Keep your phone charging and close to you.'**
  String get chargingLine;

  /// No description provided for @viewProgress.
  ///
  /// In en, this message translates to:
  /// **'View progress'**
  String get viewProgress;

  /// No description provided for @checklistOptionalHint.
  ///
  /// In en, this message translates to:
  /// **'Optional — tick what\'s done'**
  String get checklistOptionalHint;

  /// No description provided for @wakeHeadline.
  ///
  /// In en, this message translates to:
  /// **'Good morning. You said you would.'**
  String get wakeHeadline;

  /// No description provided for @wakeDefaultLine.
  ///
  /// In en, this message translates to:
  /// **'The hardest part is this one minute. Hold on.'**
  String get wakeDefaultLine;

  /// No description provided for @wakeHoldLabel.
  ///
  /// In en, this message translates to:
  /// **'Hold to wake up'**
  String get wakeHoldLabel;

  /// No description provided for @wakeTapAlt.
  ///
  /// In en, this message translates to:
  /// **'Tap to stop instead (accessibility)'**
  String get wakeTapAlt;

  /// No description provided for @focusGreeting.
  ///
  /// In en, this message translates to:
  /// **'One promise at a time.'**
  String get focusGreeting;

  /// No description provided for @focusTimeLeft.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min until 6:00'**
  String focusTimeLeft(int minutes);

  /// No description provided for @focusProgress.
  ///
  /// In en, this message translates to:
  /// **'{kept} of {total} promises kept'**
  String focusProgress(int kept, int total);

  /// No description provided for @statusNotStarted.
  ///
  /// In en, this message translates to:
  /// **'Not started'**
  String get statusNotStarted;

  /// No description provided for @statusInProgress.
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get statusInProgress;

  /// No description provided for @statusKept.
  ///
  /// In en, this message translates to:
  /// **'Kept'**
  String get statusKept;

  /// No description provided for @statusNotFinished.
  ///
  /// In en, this message translates to:
  /// **'Not finished today'**
  String get statusNotFinished;

  /// No description provided for @focusAllKept.
  ///
  /// In en, this message translates to:
  /// **'Every promise kept. Look at that sun.'**
  String get focusAllKept;

  /// No description provided for @seeYourProgress.
  ///
  /// In en, this message translates to:
  /// **'See your progress'**
  String get seeYourProgress;

  /// No description provided for @timerStart.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get timerStart;

  /// No description provided for @timerComplete.
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get timerComplete;

  /// No description provided for @timerMinutesLeft.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min left'**
  String timerMinutesLeft(int minutes);

  /// No description provided for @timerEndEarly.
  ///
  /// In en, this message translates to:
  /// **'End early (hold)'**
  String get timerEndEarly;

  /// No description provided for @timerEndEarlyTitle.
  ///
  /// In en, this message translates to:
  /// **'End this early?'**
  String get timerEndEarlyTitle;

  /// No description provided for @timerEndEarlyBody.
  ///
  /// In en, this message translates to:
  /// **'It\'s okay. Tomorrow is another chance.'**
  String get timerEndEarlyBody;

  /// No description provided for @timerLine.
  ///
  /// In en, this message translates to:
  /// **'Just this. Nothing else.'**
  String get timerLine;

  /// No description provided for @promiseKept.
  ///
  /// In en, this message translates to:
  /// **'Kept. That counts.'**
  String get promiseKept;

  /// No description provided for @dashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Your progress'**
  String get dashboardTitle;

  /// No description provided for @dashEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Day 1 starts tonight.'**
  String get dashEmptyTitle;

  /// No description provided for @dashEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Sign your plan this evening — the first sunrise is tomorrow.'**
  String get dashEmptyBody;

  /// No description provided for @dashHeroKept.
  ///
  /// In en, this message translates to:
  /// **'Promise kept.'**
  String get dashHeroKept;

  /// No description provided for @dashCount.
  ///
  /// In en, this message translates to:
  /// **'{kept} of {total}'**
  String dashCount(int kept, int total);

  /// No description provided for @dashHeroRest.
  ///
  /// In en, this message translates to:
  /// **'Rest today. The streak waits for you.'**
  String get dashHeroRest;

  /// No description provided for @dashHeroMissed.
  ///
  /// In en, this message translates to:
  /// **'New morning, fresh start.'**
  String get dashHeroMissed;

  /// No description provided for @dashFreshTomorrow.
  ///
  /// In en, this message translates to:
  /// **'A fresh start tomorrow.'**
  String get dashFreshTomorrow;

  /// No description provided for @dashFreshMonday.
  ///
  /// In en, this message translates to:
  /// **'A fresh start on Monday.'**
  String get dashFreshMonday;

  /// No description provided for @dashFreshFirst.
  ///
  /// In en, this message translates to:
  /// **'A fresh start on the 1st.'**
  String get dashFreshFirst;

  /// No description provided for @dashForward.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow the sun rises at {time}.'**
  String dashForward(String time);

  /// No description provided for @streakCurrentLabel.
  ///
  /// In en, this message translates to:
  /// **'Current streak'**
  String get streakCurrentLabel;

  /// No description provided for @streakBestLabel.
  ///
  /// In en, this message translates to:
  /// **'Best streak'**
  String get streakBestLabel;

  /// No description provided for @streakDays.
  ///
  /// In en, this message translates to:
  /// **'{days} days'**
  String streakDays(int days);

  /// No description provided for @streakDayOne.
  ///
  /// In en, this message translates to:
  /// **'1 day'**
  String get streakDayOne;

  /// No description provided for @milestoneNextDays.
  ///
  /// In en, this message translates to:
  /// **'{days} days to your {milestone}-day sun'**
  String milestoneNextDays(int days, int milestone);

  /// No description provided for @milestoneNextDay.
  ///
  /// In en, this message translates to:
  /// **'1 day to your {milestone}-day sun'**
  String milestoneNextDay(int milestone);

  /// No description provided for @journeyDayLabel.
  ///
  /// In en, this message translates to:
  /// **'Day {day} of {total}'**
  String journeyDayLabel(int day, int total);

  /// No description provided for @journeyPhase1.
  ///
  /// In en, this message translates to:
  /// **'Break the old pattern'**
  String get journeyPhase1;

  /// No description provided for @journeyPhase2.
  ///
  /// In en, this message translates to:
  /// **'Build the new one'**
  String get journeyPhase2;

  /// No description provided for @journeyPhase3.
  ///
  /// In en, this message translates to:
  /// **'Make it yours'**
  String get journeyPhase3;

  /// No description provided for @weekTitle.
  ///
  /// In en, this message translates to:
  /// **'Last 7 days'**
  String get weekTitle;

  /// No description provided for @winsTitle.
  ///
  /// In en, this message translates to:
  /// **'Wins'**
  String get winsTitle;

  /// No description provided for @winsMinutesLabel.
  ///
  /// In en, this message translates to:
  /// **'Time on what matters'**
  String get winsMinutesLabel;

  /// No description provided for @winsMinutesHm.
  ///
  /// In en, this message translates to:
  /// **'{hours}h {minutes}m'**
  String winsMinutesHm(int hours, int minutes);

  /// No description provided for @winsMinutesM.
  ///
  /// In en, this message translates to:
  /// **'{minutes}m'**
  String winsMinutesM(int minutes);

  /// No description provided for @winsEarliestLabel.
  ///
  /// In en, this message translates to:
  /// **'Earliest wake'**
  String get winsEarliestLabel;

  /// No description provided for @winsMostKeptLabel.
  ///
  /// In en, this message translates to:
  /// **'Most kept'**
  String get winsMostKeptLabel;

  /// No description provided for @promiseRatesTitle.
  ///
  /// In en, this message translates to:
  /// **'Promises · last 30 days'**
  String get promiseRatesTitle;

  /// No description provided for @rateCaption.
  ///
  /// In en, this message translates to:
  /// **'{kept} of {total}'**
  String rateCaption(int kept, int total);

  /// No description provided for @tonightTitle.
  ///
  /// In en, this message translates to:
  /// **'Tonight'**
  String get tonightTitle;

  /// No description provided for @tonightWake.
  ///
  /// In en, this message translates to:
  /// **'Wake'**
  String get tonightWake;

  /// No description provided for @tonightBed.
  ///
  /// In en, this message translates to:
  /// **'Bedtime'**
  String get tonightBed;

  /// No description provided for @tonightPromises.
  ///
  /// In en, this message translates to:
  /// **'{count} promises'**
  String tonightPromises(int count);

  /// No description provided for @restAction.
  ///
  /// In en, this message translates to:
  /// **'Rest tomorrow'**
  String get restAction;

  /// No description provided for @restConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Rest tomorrow?'**
  String get restConfirmTitle;

  /// No description provided for @restConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'No alarm tomorrow. The streak waits for you.'**
  String get restConfirmBody;

  /// No description provided for @restUsed.
  ///
  /// In en, this message translates to:
  /// **'Rest day used this week'**
  String get restUsed;

  /// No description provided for @restActive.
  ///
  /// In en, this message translates to:
  /// **'Rest day'**
  String get restActive;

  /// No description provided for @weekDotKept.
  ///
  /// In en, this message translates to:
  /// **'Kept'**
  String get weekDotKept;

  /// No description provided for @weekDotFull.
  ///
  /// In en, this message translates to:
  /// **'Every promise kept'**
  String get weekDotFull;

  /// No description provided for @weekDotRest.
  ///
  /// In en, this message translates to:
  /// **'Rest day'**
  String get weekDotRest;

  /// No description provided for @weekDotMissed.
  ///
  /// In en, this message translates to:
  /// **'Quiet day'**
  String get weekDotMissed;

  /// No description provided for @weekDotUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Not yet'**
  String get weekDotUpcoming;

  /// No description provided for @weekDotNone.
  ///
  /// In en, this message translates to:
  /// **'No plan'**
  String get weekDotNone;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsWakelock.
  ///
  /// In en, this message translates to:
  /// **'Keep screen on during timer'**
  String get settingsWakelock;

  /// No description provided for @settingsLead.
  ///
  /// In en, this message translates to:
  /// **'Bedtime reminder lead'**
  String get settingsLead;

  /// No description provided for @minutesShort.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String minutesShort(int minutes);

  /// No description provided for @settingsBackup.
  ///
  /// In en, this message translates to:
  /// **'Backup & restore'**
  String get settingsBackup;

  /// No description provided for @backupTitle.
  ///
  /// In en, this message translates to:
  /// **'Backup & restore'**
  String get backupTitle;

  /// No description provided for @backupBody.
  ///
  /// In en, this message translates to:
  /// **'Everything lives only on this phone. Export a backup file or restore from one.'**
  String get backupBody;

  /// No description provided for @backupExport.
  ///
  /// In en, this message translates to:
  /// **'Export backup'**
  String get backupExport;

  /// No description provided for @backupExportDone.
  ///
  /// In en, this message translates to:
  /// **'Backup ready to share'**
  String get backupExportDone;

  /// No description provided for @backupImport.
  ///
  /// In en, this message translates to:
  /// **'Restore from file'**
  String get backupImport;

  /// No description provided for @backupPreviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Restore this backup?'**
  String get backupPreviewTitle;

  /// No description provided for @backupPreviewCounts.
  ///
  /// In en, this message translates to:
  /// **'{mornings} mornings · {promises} promises · {plans} plans'**
  String backupPreviewCounts(int mornings, int promises, int plans);

  /// No description provided for @backupReplaceNote.
  ///
  /// In en, this message translates to:
  /// **'Restoring replaces everything on this phone.'**
  String get backupReplaceNote;

  /// No description provided for @backupRestoreDone.
  ///
  /// In en, this message translates to:
  /// **'Restored'**
  String get backupRestoreDone;

  /// No description provided for @backupInvalidFile.
  ///
  /// In en, this message translates to:
  /// **'That file is not a valid backup'**
  String get backupInvalidFile;

  /// No description provided for @healthWarnTitle.
  ///
  /// In en, this message translates to:
  /// **'The alarm may not ring'**
  String get healthWarnTitle;

  /// No description provided for @healthWarnBody.
  ///
  /// In en, this message translates to:
  /// **'A needed permission is off. Without it the wake screen can\'t appear.'**
  String get healthWarnBody;

  /// No description provided for @healthFixNow.
  ///
  /// In en, this message translates to:
  /// **'Fix now'**
  String get healthFixNow;

  /// No description provided for @settingsBattery.
  ///
  /// In en, this message translates to:
  /// **'Make sure the alarm rings'**
  String get settingsBattery;

  /// No description provided for @batteryHelpTitle.
  ///
  /// In en, this message translates to:
  /// **'Make sure the alarm rings'**
  String get batteryHelpTitle;

  /// No description provided for @batteryHelpIntro.
  ///
  /// In en, this message translates to:
  /// **'Phone makers save battery by putting apps to sleep. Three settings keep 3AM Club reliable.'**
  String get batteryHelpIntro;

  /// No description provided for @batteryStepAutoStart.
  ///
  /// In en, this message translates to:
  /// **'Allow auto-start (or remove restrictions) so the app can start for the alarm.'**
  String get batteryStepAutoStart;

  /// No description provided for @batteryStepUnrestricted.
  ///
  /// In en, this message translates to:
  /// **'Set battery use to Unrestricted (not Optimized) in app battery settings.'**
  String get batteryStepUnrestricted;

  /// No description provided for @batteryStepPin.
  ///
  /// In en, this message translates to:
  /// **'Lock the app in Recents so the system keeps it alive.'**
  String get batteryStepPin;

  /// No description provided for @batteryForBrand.
  ///
  /// In en, this message translates to:
  /// **'For your {brand}'**
  String batteryForBrand(String brand);

  /// No description provided for @batteryBrandSamsung.
  ///
  /// In en, this message translates to:
  /// **'Samsung: Settings → Battery → Background usage limits → make sure 3AM Club is not sleeping; set its Battery to Unrestricted, and turn off Put unused apps to sleep.'**
  String get batteryBrandSamsung;

  /// No description provided for @batteryBrandXiaomi.
  ///
  /// In en, this message translates to:
  /// **'Xiaomi/POCO: Security app → Manage apps → 3AM Club → Autostart on, Battery saver: No restrictions, and lock the app in Recents.'**
  String get batteryBrandXiaomi;

  /// No description provided for @batteryBrandOppo.
  ///
  /// In en, this message translates to:
  /// **'OPPO/Realme/OnePlus: Settings → Battery → More settings → allow 3AM Club: Autostart, and allow background activity in the app\'s battery usage.'**
  String get batteryBrandOppo;

  /// No description provided for @batteryBrandVivo.
  ///
  /// In en, this message translates to:
  /// **'vivo/iQOO: Settings → Battery → Background power consumption → allow 3AM Club, and enable Autostart in the app manager.'**
  String get batteryBrandVivo;

  /// No description provided for @batteryBrandHuawei.
  ///
  /// In en, this message translates to:
  /// **'Huawei/Honor: Settings → Battery → App launch → 3AM Club → disable Manage automatically, enable all three options.'**
  String get batteryBrandHuawei;

  /// No description provided for @batteryBrandGeneric.
  ///
  /// In en, this message translates to:
  /// **'Look for the app\'s battery settings (often under Battery or Apps) and choose Unrestricted, plus any Auto-start or Background activity switch.'**
  String get batteryBrandGeneric;

  /// No description provided for @batteryDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get batteryDone;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'id'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'id':
      return AppLocalizationsId();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
