// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $PlansTable extends Plans with TableInfo<$PlansTable, PlanRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlansTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _wakeMinuteMeta = const VerificationMeta(
    'wakeMinute',
  );
  @override
  late final GeneratedColumn<int> wakeMinute = GeneratedColumn<int>(
    'wake_minute',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bedMinuteMeta = const VerificationMeta(
    'bedMinute',
  );
  @override
  late final GeneratedColumn<int> bedMinute = GeneratedColumn<int>(
    'bed_minute',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _whyTextMeta = const VerificationMeta(
    'whyText',
  );
  @override
  late final GeneratedColumn<String> whyText = GeneratedColumn<String>(
    'why_text',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _signedAtMeta = const VerificationMeta(
    'signedAt',
  );
  @override
  late final GeneratedColumn<DateTime> signedAt = GeneratedColumn<DateTime>(
    'signed_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _journeyStartDateMeta = const VerificationMeta(
    'journeyStartDate',
  );
  @override
  late final GeneratedColumn<DateTime> journeyStartDate =
      GeneratedColumn<DateTime>(
        'journey_start_date',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _journeyLengthDaysMeta = const VerificationMeta(
    'journeyLengthDays',
  );
  @override
  late final GeneratedColumn<int> journeyLengthDays = GeneratedColumn<int>(
    'journey_length_days',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(66),
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    wakeMinute,
    bedMinute,
    whyText,
    signedAt,
    journeyStartDate,
    journeyLengthDays,
    isActive,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'plans';
  @override
  VerificationContext validateIntegrity(
    Insertable<PlanRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('wake_minute')) {
      context.handle(
        _wakeMinuteMeta,
        wakeMinute.isAcceptableOrUnknown(data['wake_minute']!, _wakeMinuteMeta),
      );
    } else if (isInserting) {
      context.missing(_wakeMinuteMeta);
    }
    if (data.containsKey('bed_minute')) {
      context.handle(
        _bedMinuteMeta,
        bedMinute.isAcceptableOrUnknown(data['bed_minute']!, _bedMinuteMeta),
      );
    } else if (isInserting) {
      context.missing(_bedMinuteMeta);
    }
    if (data.containsKey('why_text')) {
      context.handle(
        _whyTextMeta,
        whyText.isAcceptableOrUnknown(data['why_text']!, _whyTextMeta),
      );
    }
    if (data.containsKey('signed_at')) {
      context.handle(
        _signedAtMeta,
        signedAt.isAcceptableOrUnknown(data['signed_at']!, _signedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_signedAtMeta);
    }
    if (data.containsKey('journey_start_date')) {
      context.handle(
        _journeyStartDateMeta,
        journeyStartDate.isAcceptableOrUnknown(
          data['journey_start_date']!,
          _journeyStartDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_journeyStartDateMeta);
    }
    if (data.containsKey('journey_length_days')) {
      context.handle(
        _journeyLengthDaysMeta,
        journeyLengthDays.isAcceptableOrUnknown(
          data['journey_length_days']!,
          _journeyLengthDaysMeta,
        ),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    } else if (isInserting) {
      context.missing(_isActiveMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PlanRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlanRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      wakeMinute: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}wake_minute'],
      )!,
      bedMinute: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}bed_minute'],
      )!,
      whyText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}why_text'],
      ),
      signedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}signed_at'],
      )!,
      journeyStartDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}journey_start_date'],
      )!,
      journeyLengthDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}journey_length_days'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $PlansTable createAlias(String alias) {
    return $PlansTable(attachedDatabase, alias);
  }
}

class PlanRow extends DataClass implements Insertable<PlanRow> {
  final String id;
  final int wakeMinute;
  final int bedMinute;
  final String? whyText;
  final DateTime signedAt;
  final DateTime journeyStartDate;
  final int journeyLengthDays;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  const PlanRow({
    required this.id,
    required this.wakeMinute,
    required this.bedMinute,
    this.whyText,
    required this.signedAt,
    required this.journeyStartDate,
    required this.journeyLengthDays,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['wake_minute'] = Variable<int>(wakeMinute);
    map['bed_minute'] = Variable<int>(bedMinute);
    if (!nullToAbsent || whyText != null) {
      map['why_text'] = Variable<String>(whyText);
    }
    map['signed_at'] = Variable<DateTime>(signedAt);
    map['journey_start_date'] = Variable<DateTime>(journeyStartDate);
    map['journey_length_days'] = Variable<int>(journeyLengthDays);
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  PlansCompanion toCompanion(bool nullToAbsent) {
    return PlansCompanion(
      id: Value(id),
      wakeMinute: Value(wakeMinute),
      bedMinute: Value(bedMinute),
      whyText: whyText == null && nullToAbsent
          ? const Value.absent()
          : Value(whyText),
      signedAt: Value(signedAt),
      journeyStartDate: Value(journeyStartDate),
      journeyLengthDays: Value(journeyLengthDays),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory PlanRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlanRow(
      id: serializer.fromJson<String>(json['id']),
      wakeMinute: serializer.fromJson<int>(json['wakeMinute']),
      bedMinute: serializer.fromJson<int>(json['bedMinute']),
      whyText: serializer.fromJson<String?>(json['whyText']),
      signedAt: serializer.fromJson<DateTime>(json['signedAt']),
      journeyStartDate: serializer.fromJson<DateTime>(json['journeyStartDate']),
      journeyLengthDays: serializer.fromJson<int>(json['journeyLengthDays']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'wakeMinute': serializer.toJson<int>(wakeMinute),
      'bedMinute': serializer.toJson<int>(bedMinute),
      'whyText': serializer.toJson<String?>(whyText),
      'signedAt': serializer.toJson<DateTime>(signedAt),
      'journeyStartDate': serializer.toJson<DateTime>(journeyStartDate),
      'journeyLengthDays': serializer.toJson<int>(journeyLengthDays),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  PlanRow copyWith({
    String? id,
    int? wakeMinute,
    int? bedMinute,
    Value<String?> whyText = const Value.absent(),
    DateTime? signedAt,
    DateTime? journeyStartDate,
    int? journeyLengthDays,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => PlanRow(
    id: id ?? this.id,
    wakeMinute: wakeMinute ?? this.wakeMinute,
    bedMinute: bedMinute ?? this.bedMinute,
    whyText: whyText.present ? whyText.value : this.whyText,
    signedAt: signedAt ?? this.signedAt,
    journeyStartDate: journeyStartDate ?? this.journeyStartDate,
    journeyLengthDays: journeyLengthDays ?? this.journeyLengthDays,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  PlanRow copyWithCompanion(PlansCompanion data) {
    return PlanRow(
      id: data.id.present ? data.id.value : this.id,
      wakeMinute: data.wakeMinute.present
          ? data.wakeMinute.value
          : this.wakeMinute,
      bedMinute: data.bedMinute.present ? data.bedMinute.value : this.bedMinute,
      whyText: data.whyText.present ? data.whyText.value : this.whyText,
      signedAt: data.signedAt.present ? data.signedAt.value : this.signedAt,
      journeyStartDate: data.journeyStartDate.present
          ? data.journeyStartDate.value
          : this.journeyStartDate,
      journeyLengthDays: data.journeyLengthDays.present
          ? data.journeyLengthDays.value
          : this.journeyLengthDays,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlanRow(')
          ..write('id: $id, ')
          ..write('wakeMinute: $wakeMinute, ')
          ..write('bedMinute: $bedMinute, ')
          ..write('whyText: $whyText, ')
          ..write('signedAt: $signedAt, ')
          ..write('journeyStartDate: $journeyStartDate, ')
          ..write('journeyLengthDays: $journeyLengthDays, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    wakeMinute,
    bedMinute,
    whyText,
    signedAt,
    journeyStartDate,
    journeyLengthDays,
    isActive,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlanRow &&
          other.id == this.id &&
          other.wakeMinute == this.wakeMinute &&
          other.bedMinute == this.bedMinute &&
          other.whyText == this.whyText &&
          other.signedAt == this.signedAt &&
          other.journeyStartDate == this.journeyStartDate &&
          other.journeyLengthDays == this.journeyLengthDays &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class PlansCompanion extends UpdateCompanion<PlanRow> {
  final Value<String> id;
  final Value<int> wakeMinute;
  final Value<int> bedMinute;
  final Value<String?> whyText;
  final Value<DateTime> signedAt;
  final Value<DateTime> journeyStartDate;
  final Value<int> journeyLengthDays;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const PlansCompanion({
    this.id = const Value.absent(),
    this.wakeMinute = const Value.absent(),
    this.bedMinute = const Value.absent(),
    this.whyText = const Value.absent(),
    this.signedAt = const Value.absent(),
    this.journeyStartDate = const Value.absent(),
    this.journeyLengthDays = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PlansCompanion.insert({
    required String id,
    required int wakeMinute,
    required int bedMinute,
    this.whyText = const Value.absent(),
    required DateTime signedAt,
    required DateTime journeyStartDate,
    this.journeyLengthDays = const Value.absent(),
    required bool isActive,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       wakeMinute = Value(wakeMinute),
       bedMinute = Value(bedMinute),
       signedAt = Value(signedAt),
       journeyStartDate = Value(journeyStartDate),
       isActive = Value(isActive),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<PlanRow> custom({
    Expression<String>? id,
    Expression<int>? wakeMinute,
    Expression<int>? bedMinute,
    Expression<String>? whyText,
    Expression<DateTime>? signedAt,
    Expression<DateTime>? journeyStartDate,
    Expression<int>? journeyLengthDays,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (wakeMinute != null) 'wake_minute': wakeMinute,
      if (bedMinute != null) 'bed_minute': bedMinute,
      if (whyText != null) 'why_text': whyText,
      if (signedAt != null) 'signed_at': signedAt,
      if (journeyStartDate != null) 'journey_start_date': journeyStartDate,
      if (journeyLengthDays != null) 'journey_length_days': journeyLengthDays,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PlansCompanion copyWith({
    Value<String>? id,
    Value<int>? wakeMinute,
    Value<int>? bedMinute,
    Value<String?>? whyText,
    Value<DateTime>? signedAt,
    Value<DateTime>? journeyStartDate,
    Value<int>? journeyLengthDays,
    Value<bool>? isActive,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return PlansCompanion(
      id: id ?? this.id,
      wakeMinute: wakeMinute ?? this.wakeMinute,
      bedMinute: bedMinute ?? this.bedMinute,
      whyText: whyText ?? this.whyText,
      signedAt: signedAt ?? this.signedAt,
      journeyStartDate: journeyStartDate ?? this.journeyStartDate,
      journeyLengthDays: journeyLengthDays ?? this.journeyLengthDays,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (wakeMinute.present) {
      map['wake_minute'] = Variable<int>(wakeMinute.value);
    }
    if (bedMinute.present) {
      map['bed_minute'] = Variable<int>(bedMinute.value);
    }
    if (whyText.present) {
      map['why_text'] = Variable<String>(whyText.value);
    }
    if (signedAt.present) {
      map['signed_at'] = Variable<DateTime>(signedAt.value);
    }
    if (journeyStartDate.present) {
      map['journey_start_date'] = Variable<DateTime>(journeyStartDate.value);
    }
    if (journeyLengthDays.present) {
      map['journey_length_days'] = Variable<int>(journeyLengthDays.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlansCompanion(')
          ..write('id: $id, ')
          ..write('wakeMinute: $wakeMinute, ')
          ..write('bedMinute: $bedMinute, ')
          ..write('whyText: $whyText, ')
          ..write('signedAt: $signedAt, ')
          ..write('journeyStartDate: $journeyStartDate, ')
          ..write('journeyLengthDays: $journeyLengthDays, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PreSleepItemsTable extends PreSleepItems
    with TableInfo<$PreSleepItemsTable, PreSleepItemRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PreSleepItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _planIdMeta = const VerificationMeta('planId');
  @override
  late final GeneratedColumn<String> planId = GeneratedColumn<String>(
    'plan_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES plans (id)',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    planId,
    title,
    sortOrder,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pre_sleep_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<PreSleepItemRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('plan_id')) {
      context.handle(
        _planIdMeta,
        planId.isAcceptableOrUnknown(data['plan_id']!, _planIdMeta),
      );
    } else if (isInserting) {
      context.missing(_planIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PreSleepItemRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PreSleepItemRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      planId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}plan_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $PreSleepItemsTable createAlias(String alias) {
    return $PreSleepItemsTable(attachedDatabase, alias);
  }
}

class PreSleepItemRow extends DataClass implements Insertable<PreSleepItemRow> {
  final String id;
  final String planId;
  final String title;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;
  const PreSleepItemRow({
    required this.id,
    required this.planId,
    required this.title,
    required this.sortOrder,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['plan_id'] = Variable<String>(planId);
    map['title'] = Variable<String>(title);
    map['sort_order'] = Variable<int>(sortOrder);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  PreSleepItemsCompanion toCompanion(bool nullToAbsent) {
    return PreSleepItemsCompanion(
      id: Value(id),
      planId: Value(planId),
      title: Value(title),
      sortOrder: Value(sortOrder),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory PreSleepItemRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PreSleepItemRow(
      id: serializer.fromJson<String>(json['id']),
      planId: serializer.fromJson<String>(json['planId']),
      title: serializer.fromJson<String>(json['title']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'planId': serializer.toJson<String>(planId),
      'title': serializer.toJson<String>(title),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  PreSleepItemRow copyWith({
    String? id,
    String? planId,
    String? title,
    int? sortOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => PreSleepItemRow(
    id: id ?? this.id,
    planId: planId ?? this.planId,
    title: title ?? this.title,
    sortOrder: sortOrder ?? this.sortOrder,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  PreSleepItemRow copyWithCompanion(PreSleepItemsCompanion data) {
    return PreSleepItemRow(
      id: data.id.present ? data.id.value : this.id,
      planId: data.planId.present ? data.planId.value : this.planId,
      title: data.title.present ? data.title.value : this.title,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PreSleepItemRow(')
          ..write('id: $id, ')
          ..write('planId: $planId, ')
          ..write('title: $title, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, planId, title, sortOrder, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PreSleepItemRow &&
          other.id == this.id &&
          other.planId == this.planId &&
          other.title == this.title &&
          other.sortOrder == this.sortOrder &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class PreSleepItemsCompanion extends UpdateCompanion<PreSleepItemRow> {
  final Value<String> id;
  final Value<String> planId;
  final Value<String> title;
  final Value<int> sortOrder;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const PreSleepItemsCompanion({
    this.id = const Value.absent(),
    this.planId = const Value.absent(),
    this.title = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PreSleepItemsCompanion.insert({
    required String id,
    required String planId,
    required String title,
    required int sortOrder,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       planId = Value(planId),
       title = Value(title),
       sortOrder = Value(sortOrder),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<PreSleepItemRow> custom({
    Expression<String>? id,
    Expression<String>? planId,
    Expression<String>? title,
    Expression<int>? sortOrder,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (planId != null) 'plan_id': planId,
      if (title != null) 'title': title,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PreSleepItemsCompanion copyWith({
    Value<String>? id,
    Value<String>? planId,
    Value<String>? title,
    Value<int>? sortOrder,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return PreSleepItemsCompanion(
      id: id ?? this.id,
      planId: planId ?? this.planId,
      title: title ?? this.title,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (planId.present) {
      map['plan_id'] = Variable<String>(planId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PreSleepItemsCompanion(')
          ..write('id: $id, ')
          ..write('planId: $planId, ')
          ..write('title: $title, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CategoriesTable extends Categories
    with TableInfo<$CategoriesTable, CategoryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _iconKeyMeta = const VerificationMeta(
    'iconKey',
  );
  @override
  late final GeneratedColumn<String> iconKey = GeneratedColumn<String>(
    'icon_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorKeyMeta = const VerificationMeta(
    'colorKey',
  );
  @override
  late final GeneratedColumn<String> colorKey = GeneratedColumn<String>(
    'color_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isBuiltInMeta = const VerificationMeta(
    'isBuiltIn',
  );
  @override
  late final GeneratedColumn<bool> isBuiltIn = GeneratedColumn<bool>(
    'is_built_in',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_built_in" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isArchivedMeta = const VerificationMeta(
    'isArchived',
  );
  @override
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
    'is_archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    iconKey,
    colorKey,
    isBuiltIn,
    isArchived,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<CategoryRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('icon_key')) {
      context.handle(
        _iconKeyMeta,
        iconKey.isAcceptableOrUnknown(data['icon_key']!, _iconKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_iconKeyMeta);
    }
    if (data.containsKey('color_key')) {
      context.handle(
        _colorKeyMeta,
        colorKey.isAcceptableOrUnknown(data['color_key']!, _colorKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_colorKeyMeta);
    }
    if (data.containsKey('is_built_in')) {
      context.handle(
        _isBuiltInMeta,
        isBuiltIn.isAcceptableOrUnknown(data['is_built_in']!, _isBuiltInMeta),
      );
    }
    if (data.containsKey('is_archived')) {
      context.handle(
        _isArchivedMeta,
        isArchived.isAcceptableOrUnknown(data['is_archived']!, _isArchivedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CategoryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CategoryRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      iconKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon_key'],
      )!,
      colorKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color_key'],
      )!,
      isBuiltIn: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_built_in'],
      )!,
      isArchived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_archived'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(attachedDatabase, alias);
  }
}

class CategoryRow extends DataClass implements Insertable<CategoryRow> {
  final String id;
  final String name;
  final String iconKey;
  final String colorKey;
  final bool isBuiltIn;
  final bool isArchived;
  final DateTime createdAt;
  final DateTime updatedAt;
  const CategoryRow({
    required this.id,
    required this.name,
    required this.iconKey,
    required this.colorKey,
    required this.isBuiltIn,
    required this.isArchived,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['icon_key'] = Variable<String>(iconKey);
    map['color_key'] = Variable<String>(colorKey);
    map['is_built_in'] = Variable<bool>(isBuiltIn);
    map['is_archived'] = Variable<bool>(isArchived);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: Value(id),
      name: Value(name),
      iconKey: Value(iconKey),
      colorKey: Value(colorKey),
      isBuiltIn: Value(isBuiltIn),
      isArchived: Value(isArchived),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory CategoryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CategoryRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      iconKey: serializer.fromJson<String>(json['iconKey']),
      colorKey: serializer.fromJson<String>(json['colorKey']),
      isBuiltIn: serializer.fromJson<bool>(json['isBuiltIn']),
      isArchived: serializer.fromJson<bool>(json['isArchived']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'iconKey': serializer.toJson<String>(iconKey),
      'colorKey': serializer.toJson<String>(colorKey),
      'isBuiltIn': serializer.toJson<bool>(isBuiltIn),
      'isArchived': serializer.toJson<bool>(isArchived),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  CategoryRow copyWith({
    String? id,
    String? name,
    String? iconKey,
    String? colorKey,
    bool? isBuiltIn,
    bool? isArchived,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => CategoryRow(
    id: id ?? this.id,
    name: name ?? this.name,
    iconKey: iconKey ?? this.iconKey,
    colorKey: colorKey ?? this.colorKey,
    isBuiltIn: isBuiltIn ?? this.isBuiltIn,
    isArchived: isArchived ?? this.isArchived,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  CategoryRow copyWithCompanion(CategoriesCompanion data) {
    return CategoryRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      iconKey: data.iconKey.present ? data.iconKey.value : this.iconKey,
      colorKey: data.colorKey.present ? data.colorKey.value : this.colorKey,
      isBuiltIn: data.isBuiltIn.present ? data.isBuiltIn.value : this.isBuiltIn,
      isArchived: data.isArchived.present
          ? data.isArchived.value
          : this.isArchived,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CategoryRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('iconKey: $iconKey, ')
          ..write('colorKey: $colorKey, ')
          ..write('isBuiltIn: $isBuiltIn, ')
          ..write('isArchived: $isArchived, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    iconKey,
    colorKey,
    isBuiltIn,
    isArchived,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategoryRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.iconKey == this.iconKey &&
          other.colorKey == this.colorKey &&
          other.isBuiltIn == this.isBuiltIn &&
          other.isArchived == this.isArchived &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class CategoriesCompanion extends UpdateCompanion<CategoryRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> iconKey;
  final Value<String> colorKey;
  final Value<bool> isBuiltIn;
  final Value<bool> isArchived;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.iconKey = const Value.absent(),
    this.colorKey = const Value.absent(),
    this.isBuiltIn = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CategoriesCompanion.insert({
    required String id,
    required String name,
    required String iconKey,
    required String colorKey,
    this.isBuiltIn = const Value.absent(),
    this.isArchived = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       iconKey = Value(iconKey),
       colorKey = Value(colorKey),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<CategoryRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? iconKey,
    Expression<String>? colorKey,
    Expression<bool>? isBuiltIn,
    Expression<bool>? isArchived,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (iconKey != null) 'icon_key': iconKey,
      if (colorKey != null) 'color_key': colorKey,
      if (isBuiltIn != null) 'is_built_in': isBuiltIn,
      if (isArchived != null) 'is_archived': isArchived,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CategoriesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? iconKey,
    Value<String>? colorKey,
    Value<bool>? isBuiltIn,
    Value<bool>? isArchived,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return CategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      iconKey: iconKey ?? this.iconKey,
      colorKey: colorKey ?? this.colorKey,
      isBuiltIn: isBuiltIn ?? this.isBuiltIn,
      isArchived: isArchived ?? this.isArchived,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (iconKey.present) {
      map['icon_key'] = Variable<String>(iconKey.value);
    }
    if (colorKey.present) {
      map['color_key'] = Variable<String>(colorKey.value);
    }
    if (isBuiltIn.present) {
      map['is_built_in'] = Variable<bool>(isBuiltIn.value);
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('iconKey: $iconKey, ')
          ..write('colorKey: $colorKey, ')
          ..write('isBuiltIn: $isBuiltIn, ')
          ..write('isArchived: $isArchived, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PromisesTable extends Promises
    with TableInfo<$PromisesTable, PromiseRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PromisesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _planIdMeta = const VerificationMeta('planId');
  @override
  late final GeneratedColumn<String> planId = GeneratedColumn<String>(
    'plan_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES plans (id)',
    ),
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categories (id)',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _durationMinMeta = const VerificationMeta(
    'durationMin',
  );
  @override
  late final GeneratedColumn<int> durationMin = GeneratedColumn<int>(
    'duration_min',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    planId,
    categoryId,
    title,
    description,
    durationMin,
    sortOrder,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'promises';
  @override
  VerificationContext validateIntegrity(
    Insertable<PromiseRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('plan_id')) {
      context.handle(
        _planIdMeta,
        planId.isAcceptableOrUnknown(data['plan_id']!, _planIdMeta),
      );
    } else if (isInserting) {
      context.missing(_planIdMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('duration_min')) {
      context.handle(
        _durationMinMeta,
        durationMin.isAcceptableOrUnknown(
          data['duration_min']!,
          _durationMinMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_durationMinMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PromiseRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PromiseRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      planId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}plan_id'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      durationMin: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_min'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $PromisesTable createAlias(String alias) {
    return $PromisesTable(attachedDatabase, alias);
  }
}

class PromiseRow extends DataClass implements Insertable<PromiseRow> {
  final String id;
  final String planId;
  final String categoryId;
  final String title;
  final String? description;
  final int durationMin;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;
  const PromiseRow({
    required this.id,
    required this.planId,
    required this.categoryId,
    required this.title,
    this.description,
    required this.durationMin,
    required this.sortOrder,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['plan_id'] = Variable<String>(planId);
    map['category_id'] = Variable<String>(categoryId);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['duration_min'] = Variable<int>(durationMin);
    map['sort_order'] = Variable<int>(sortOrder);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  PromisesCompanion toCompanion(bool nullToAbsent) {
    return PromisesCompanion(
      id: Value(id),
      planId: Value(planId),
      categoryId: Value(categoryId),
      title: Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      durationMin: Value(durationMin),
      sortOrder: Value(sortOrder),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory PromiseRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PromiseRow(
      id: serializer.fromJson<String>(json['id']),
      planId: serializer.fromJson<String>(json['planId']),
      categoryId: serializer.fromJson<String>(json['categoryId']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      durationMin: serializer.fromJson<int>(json['durationMin']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'planId': serializer.toJson<String>(planId),
      'categoryId': serializer.toJson<String>(categoryId),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'durationMin': serializer.toJson<int>(durationMin),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  PromiseRow copyWith({
    String? id,
    String? planId,
    String? categoryId,
    String? title,
    Value<String?> description = const Value.absent(),
    int? durationMin,
    int? sortOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => PromiseRow(
    id: id ?? this.id,
    planId: planId ?? this.planId,
    categoryId: categoryId ?? this.categoryId,
    title: title ?? this.title,
    description: description.present ? description.value : this.description,
    durationMin: durationMin ?? this.durationMin,
    sortOrder: sortOrder ?? this.sortOrder,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  PromiseRow copyWithCompanion(PromisesCompanion data) {
    return PromiseRow(
      id: data.id.present ? data.id.value : this.id,
      planId: data.planId.present ? data.planId.value : this.planId,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      durationMin: data.durationMin.present
          ? data.durationMin.value
          : this.durationMin,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PromiseRow(')
          ..write('id: $id, ')
          ..write('planId: $planId, ')
          ..write('categoryId: $categoryId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('durationMin: $durationMin, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    planId,
    categoryId,
    title,
    description,
    durationMin,
    sortOrder,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PromiseRow &&
          other.id == this.id &&
          other.planId == this.planId &&
          other.categoryId == this.categoryId &&
          other.title == this.title &&
          other.description == this.description &&
          other.durationMin == this.durationMin &&
          other.sortOrder == this.sortOrder &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class PromisesCompanion extends UpdateCompanion<PromiseRow> {
  final Value<String> id;
  final Value<String> planId;
  final Value<String> categoryId;
  final Value<String> title;
  final Value<String?> description;
  final Value<int> durationMin;
  final Value<int> sortOrder;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const PromisesCompanion({
    this.id = const Value.absent(),
    this.planId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.durationMin = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PromisesCompanion.insert({
    required String id,
    required String planId,
    required String categoryId,
    required String title,
    this.description = const Value.absent(),
    required int durationMin,
    required int sortOrder,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       planId = Value(planId),
       categoryId = Value(categoryId),
       title = Value(title),
       durationMin = Value(durationMin),
       sortOrder = Value(sortOrder),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<PromiseRow> custom({
    Expression<String>? id,
    Expression<String>? planId,
    Expression<String>? categoryId,
    Expression<String>? title,
    Expression<String>? description,
    Expression<int>? durationMin,
    Expression<int>? sortOrder,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (planId != null) 'plan_id': planId,
      if (categoryId != null) 'category_id': categoryId,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (durationMin != null) 'duration_min': durationMin,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PromisesCompanion copyWith({
    Value<String>? id,
    Value<String>? planId,
    Value<String>? categoryId,
    Value<String>? title,
    Value<String?>? description,
    Value<int>? durationMin,
    Value<int>? sortOrder,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return PromisesCompanion(
      id: id ?? this.id,
      planId: planId ?? this.planId,
      categoryId: categoryId ?? this.categoryId,
      title: title ?? this.title,
      description: description ?? this.description,
      durationMin: durationMin ?? this.durationMin,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (planId.present) {
      map['plan_id'] = Variable<String>(planId.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (durationMin.present) {
      map['duration_min'] = Variable<int>(durationMin.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PromisesCompanion(')
          ..write('id: $id, ')
          ..write('planId: $planId, ')
          ..write('categoryId: $categoryId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('durationMin: $durationMin, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MorningsTable extends Mornings
    with TableInfo<$MorningsTable, MorningRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MorningsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _planIdMeta = const VerificationMeta('planId');
  @override
  late final GeneratedColumn<String> planId = GeneratedColumn<String>(
    'plan_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES plans (id)',
    ),
  );
  static const VerificationMeta _scheduledAtMeta = const VerificationMeta(
    'scheduledAt',
  );
  @override
  late final GeneratedColumn<DateTime> scheduledAt = GeneratedColumn<DateTime>(
    'scheduled_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _alarmFiredAtMeta = const VerificationMeta(
    'alarmFiredAt',
  );
  @override
  late final GeneratedColumn<DateTime> alarmFiredAt = GeneratedColumn<DateTime>(
    'alarm_fired_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _wakeConfirmedAtMeta = const VerificationMeta(
    'wakeConfirmedAt',
  );
  @override
  late final GeneratedColumn<DateTime> wakeConfirmedAt =
      GeneratedColumn<DateTime>(
        'wake_confirmed_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _resultMeta = const VerificationMeta('result');
  @override
  late final GeneratedColumn<String> result = GeneratedColumn<String>(
    'result',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    date,
    planId,
    scheduledAt,
    alarmFiredAt,
    wakeConfirmedAt,
    result,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'mornings';
  @override
  VerificationContext validateIntegrity(
    Insertable<MorningRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('plan_id')) {
      context.handle(
        _planIdMeta,
        planId.isAcceptableOrUnknown(data['plan_id']!, _planIdMeta),
      );
    } else if (isInserting) {
      context.missing(_planIdMeta);
    }
    if (data.containsKey('scheduled_at')) {
      context.handle(
        _scheduledAtMeta,
        scheduledAt.isAcceptableOrUnknown(
          data['scheduled_at']!,
          _scheduledAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_scheduledAtMeta);
    }
    if (data.containsKey('alarm_fired_at')) {
      context.handle(
        _alarmFiredAtMeta,
        alarmFiredAt.isAcceptableOrUnknown(
          data['alarm_fired_at']!,
          _alarmFiredAtMeta,
        ),
      );
    }
    if (data.containsKey('wake_confirmed_at')) {
      context.handle(
        _wakeConfirmedAtMeta,
        wakeConfirmedAt.isAcceptableOrUnknown(
          data['wake_confirmed_at']!,
          _wakeConfirmedAtMeta,
        ),
      );
    }
    if (data.containsKey('result')) {
      context.handle(
        _resultMeta,
        result.isAcceptableOrUnknown(data['result']!, _resultMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MorningRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MorningRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      planId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}plan_id'],
      )!,
      scheduledAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}scheduled_at'],
      )!,
      alarmFiredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}alarm_fired_at'],
      ),
      wakeConfirmedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}wake_confirmed_at'],
      ),
      result: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}result'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $MorningsTable createAlias(String alias) {
    return $MorningsTable(attachedDatabase, alias);
  }
}

class MorningRow extends DataClass implements Insertable<MorningRow> {
  final String id;
  final String date;
  final String planId;
  final DateTime scheduledAt;
  final DateTime? alarmFiredAt;
  final DateTime? wakeConfirmedAt;
  final String result;
  final DateTime createdAt;
  final DateTime updatedAt;
  const MorningRow({
    required this.id,
    required this.date,
    required this.planId,
    required this.scheduledAt,
    this.alarmFiredAt,
    this.wakeConfirmedAt,
    required this.result,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['date'] = Variable<String>(date);
    map['plan_id'] = Variable<String>(planId);
    map['scheduled_at'] = Variable<DateTime>(scheduledAt);
    if (!nullToAbsent || alarmFiredAt != null) {
      map['alarm_fired_at'] = Variable<DateTime>(alarmFiredAt);
    }
    if (!nullToAbsent || wakeConfirmedAt != null) {
      map['wake_confirmed_at'] = Variable<DateTime>(wakeConfirmedAt);
    }
    map['result'] = Variable<String>(result);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  MorningsCompanion toCompanion(bool nullToAbsent) {
    return MorningsCompanion(
      id: Value(id),
      date: Value(date),
      planId: Value(planId),
      scheduledAt: Value(scheduledAt),
      alarmFiredAt: alarmFiredAt == null && nullToAbsent
          ? const Value.absent()
          : Value(alarmFiredAt),
      wakeConfirmedAt: wakeConfirmedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(wakeConfirmedAt),
      result: Value(result),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory MorningRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MorningRow(
      id: serializer.fromJson<String>(json['id']),
      date: serializer.fromJson<String>(json['date']),
      planId: serializer.fromJson<String>(json['planId']),
      scheduledAt: serializer.fromJson<DateTime>(json['scheduledAt']),
      alarmFiredAt: serializer.fromJson<DateTime?>(json['alarmFiredAt']),
      wakeConfirmedAt: serializer.fromJson<DateTime?>(json['wakeConfirmedAt']),
      result: serializer.fromJson<String>(json['result']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'date': serializer.toJson<String>(date),
      'planId': serializer.toJson<String>(planId),
      'scheduledAt': serializer.toJson<DateTime>(scheduledAt),
      'alarmFiredAt': serializer.toJson<DateTime?>(alarmFiredAt),
      'wakeConfirmedAt': serializer.toJson<DateTime?>(wakeConfirmedAt),
      'result': serializer.toJson<String>(result),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  MorningRow copyWith({
    String? id,
    String? date,
    String? planId,
    DateTime? scheduledAt,
    Value<DateTime?> alarmFiredAt = const Value.absent(),
    Value<DateTime?> wakeConfirmedAt = const Value.absent(),
    String? result,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => MorningRow(
    id: id ?? this.id,
    date: date ?? this.date,
    planId: planId ?? this.planId,
    scheduledAt: scheduledAt ?? this.scheduledAt,
    alarmFiredAt: alarmFiredAt.present ? alarmFiredAt.value : this.alarmFiredAt,
    wakeConfirmedAt: wakeConfirmedAt.present
        ? wakeConfirmedAt.value
        : this.wakeConfirmedAt,
    result: result ?? this.result,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  MorningRow copyWithCompanion(MorningsCompanion data) {
    return MorningRow(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      planId: data.planId.present ? data.planId.value : this.planId,
      scheduledAt: data.scheduledAt.present
          ? data.scheduledAt.value
          : this.scheduledAt,
      alarmFiredAt: data.alarmFiredAt.present
          ? data.alarmFiredAt.value
          : this.alarmFiredAt,
      wakeConfirmedAt: data.wakeConfirmedAt.present
          ? data.wakeConfirmedAt.value
          : this.wakeConfirmedAt,
      result: data.result.present ? data.result.value : this.result,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MorningRow(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('planId: $planId, ')
          ..write('scheduledAt: $scheduledAt, ')
          ..write('alarmFiredAt: $alarmFiredAt, ')
          ..write('wakeConfirmedAt: $wakeConfirmedAt, ')
          ..write('result: $result, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    date,
    planId,
    scheduledAt,
    alarmFiredAt,
    wakeConfirmedAt,
    result,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MorningRow &&
          other.id == this.id &&
          other.date == this.date &&
          other.planId == this.planId &&
          other.scheduledAt == this.scheduledAt &&
          other.alarmFiredAt == this.alarmFiredAt &&
          other.wakeConfirmedAt == this.wakeConfirmedAt &&
          other.result == this.result &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class MorningsCompanion extends UpdateCompanion<MorningRow> {
  final Value<String> id;
  final Value<String> date;
  final Value<String> planId;
  final Value<DateTime> scheduledAt;
  final Value<DateTime?> alarmFiredAt;
  final Value<DateTime?> wakeConfirmedAt;
  final Value<String> result;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const MorningsCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.planId = const Value.absent(),
    this.scheduledAt = const Value.absent(),
    this.alarmFiredAt = const Value.absent(),
    this.wakeConfirmedAt = const Value.absent(),
    this.result = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MorningsCompanion.insert({
    required String id,
    required String date,
    required String planId,
    required DateTime scheduledAt,
    this.alarmFiredAt = const Value.absent(),
    this.wakeConfirmedAt = const Value.absent(),
    this.result = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       date = Value(date),
       planId = Value(planId),
       scheduledAt = Value(scheduledAt),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<MorningRow> custom({
    Expression<String>? id,
    Expression<String>? date,
    Expression<String>? planId,
    Expression<DateTime>? scheduledAt,
    Expression<DateTime>? alarmFiredAt,
    Expression<DateTime>? wakeConfirmedAt,
    Expression<String>? result,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (planId != null) 'plan_id': planId,
      if (scheduledAt != null) 'scheduled_at': scheduledAt,
      if (alarmFiredAt != null) 'alarm_fired_at': alarmFiredAt,
      if (wakeConfirmedAt != null) 'wake_confirmed_at': wakeConfirmedAt,
      if (result != null) 'result': result,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MorningsCompanion copyWith({
    Value<String>? id,
    Value<String>? date,
    Value<String>? planId,
    Value<DateTime>? scheduledAt,
    Value<DateTime?>? alarmFiredAt,
    Value<DateTime?>? wakeConfirmedAt,
    Value<String>? result,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return MorningsCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      planId: planId ?? this.planId,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      alarmFiredAt: alarmFiredAt ?? this.alarmFiredAt,
      wakeConfirmedAt: wakeConfirmedAt ?? this.wakeConfirmedAt,
      result: result ?? this.result,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (planId.present) {
      map['plan_id'] = Variable<String>(planId.value);
    }
    if (scheduledAt.present) {
      map['scheduled_at'] = Variable<DateTime>(scheduledAt.value);
    }
    if (alarmFiredAt.present) {
      map['alarm_fired_at'] = Variable<DateTime>(alarmFiredAt.value);
    }
    if (wakeConfirmedAt.present) {
      map['wake_confirmed_at'] = Variable<DateTime>(wakeConfirmedAt.value);
    }
    if (result.present) {
      map['result'] = Variable<String>(result.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MorningsCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('planId: $planId, ')
          ..write('scheduledAt: $scheduledAt, ')
          ..write('alarmFiredAt: $alarmFiredAt, ')
          ..write('wakeConfirmedAt: $wakeConfirmedAt, ')
          ..write('result: $result, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PromiseLogsTable extends PromiseLogs
    with TableInfo<$PromiseLogsTable, PromiseLogRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PromiseLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _morningIdMeta = const VerificationMeta(
    'morningId',
  );
  @override
  late final GeneratedColumn<String> morningId = GeneratedColumn<String>(
    'morning_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES mornings (id)',
    ),
  );
  static const VerificationMeta _promiseIdMeta = const VerificationMeta(
    'promiseId',
  );
  @override
  late final GeneratedColumn<String> promiseId = GeneratedColumn<String>(
    'promise_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES promises (id)',
    ),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _plannedSecMeta = const VerificationMeta(
    'plannedSec',
  );
  @override
  late final GeneratedColumn<int> plannedSec = GeneratedColumn<int>(
    'planned_sec',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endedEarlyMeta = const VerificationMeta(
    'endedEarly',
  );
  @override
  late final GeneratedColumn<bool> endedEarly = GeneratedColumn<bool>(
    'ended_early',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("ended_early" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    morningId,
    promiseId,
    status,
    startedAt,
    completedAt,
    plannedSec,
    endedEarly,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'promise_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<PromiseLogRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('morning_id')) {
      context.handle(
        _morningIdMeta,
        morningId.isAcceptableOrUnknown(data['morning_id']!, _morningIdMeta),
      );
    } else if (isInserting) {
      context.missing(_morningIdMeta);
    }
    if (data.containsKey('promise_id')) {
      context.handle(
        _promiseIdMeta,
        promiseId.isAcceptableOrUnknown(data['promise_id']!, _promiseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_promiseIdMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    if (data.containsKey('planned_sec')) {
      context.handle(
        _plannedSecMeta,
        plannedSec.isAcceptableOrUnknown(data['planned_sec']!, _plannedSecMeta),
      );
    } else if (isInserting) {
      context.missing(_plannedSecMeta);
    }
    if (data.containsKey('ended_early')) {
      context.handle(
        _endedEarlyMeta,
        endedEarly.isAcceptableOrUnknown(data['ended_early']!, _endedEarlyMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PromiseLogRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PromiseLogRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      morningId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}morning_id'],
      )!,
      promiseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}promise_id'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      ),
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
      plannedSec: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}planned_sec'],
      )!,
      endedEarly: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}ended_early'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $PromiseLogsTable createAlias(String alias) {
    return $PromiseLogsTable(attachedDatabase, alias);
  }
}

class PromiseLogRow extends DataClass implements Insertable<PromiseLogRow> {
  final String id;
  final String morningId;
  final String promiseId;
  final String status;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final int plannedSec;
  final bool endedEarly;
  final DateTime createdAt;
  final DateTime updatedAt;
  const PromiseLogRow({
    required this.id,
    required this.morningId,
    required this.promiseId,
    required this.status,
    this.startedAt,
    this.completedAt,
    required this.plannedSec,
    required this.endedEarly,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['morning_id'] = Variable<String>(morningId);
    map['promise_id'] = Variable<String>(promiseId);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || startedAt != null) {
      map['started_at'] = Variable<DateTime>(startedAt);
    }
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    map['planned_sec'] = Variable<int>(plannedSec);
    map['ended_early'] = Variable<bool>(endedEarly);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  PromiseLogsCompanion toCompanion(bool nullToAbsent) {
    return PromiseLogsCompanion(
      id: Value(id),
      morningId: Value(morningId),
      promiseId: Value(promiseId),
      status: Value(status),
      startedAt: startedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(startedAt),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      plannedSec: Value(plannedSec),
      endedEarly: Value(endedEarly),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory PromiseLogRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PromiseLogRow(
      id: serializer.fromJson<String>(json['id']),
      morningId: serializer.fromJson<String>(json['morningId']),
      promiseId: serializer.fromJson<String>(json['promiseId']),
      status: serializer.fromJson<String>(json['status']),
      startedAt: serializer.fromJson<DateTime?>(json['startedAt']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      plannedSec: serializer.fromJson<int>(json['plannedSec']),
      endedEarly: serializer.fromJson<bool>(json['endedEarly']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'morningId': serializer.toJson<String>(morningId),
      'promiseId': serializer.toJson<String>(promiseId),
      'status': serializer.toJson<String>(status),
      'startedAt': serializer.toJson<DateTime?>(startedAt),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'plannedSec': serializer.toJson<int>(plannedSec),
      'endedEarly': serializer.toJson<bool>(endedEarly),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  PromiseLogRow copyWith({
    String? id,
    String? morningId,
    String? promiseId,
    String? status,
    Value<DateTime?> startedAt = const Value.absent(),
    Value<DateTime?> completedAt = const Value.absent(),
    int? plannedSec,
    bool? endedEarly,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => PromiseLogRow(
    id: id ?? this.id,
    morningId: morningId ?? this.morningId,
    promiseId: promiseId ?? this.promiseId,
    status: status ?? this.status,
    startedAt: startedAt.present ? startedAt.value : this.startedAt,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
    plannedSec: plannedSec ?? this.plannedSec,
    endedEarly: endedEarly ?? this.endedEarly,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  PromiseLogRow copyWithCompanion(PromiseLogsCompanion data) {
    return PromiseLogRow(
      id: data.id.present ? data.id.value : this.id,
      morningId: data.morningId.present ? data.morningId.value : this.morningId,
      promiseId: data.promiseId.present ? data.promiseId.value : this.promiseId,
      status: data.status.present ? data.status.value : this.status,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
      plannedSec: data.plannedSec.present
          ? data.plannedSec.value
          : this.plannedSec,
      endedEarly: data.endedEarly.present
          ? data.endedEarly.value
          : this.endedEarly,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PromiseLogRow(')
          ..write('id: $id, ')
          ..write('morningId: $morningId, ')
          ..write('promiseId: $promiseId, ')
          ..write('status: $status, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('plannedSec: $plannedSec, ')
          ..write('endedEarly: $endedEarly, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    morningId,
    promiseId,
    status,
    startedAt,
    completedAt,
    plannedSec,
    endedEarly,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PromiseLogRow &&
          other.id == this.id &&
          other.morningId == this.morningId &&
          other.promiseId == this.promiseId &&
          other.status == this.status &&
          other.startedAt == this.startedAt &&
          other.completedAt == this.completedAt &&
          other.plannedSec == this.plannedSec &&
          other.endedEarly == this.endedEarly &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class PromiseLogsCompanion extends UpdateCompanion<PromiseLogRow> {
  final Value<String> id;
  final Value<String> morningId;
  final Value<String> promiseId;
  final Value<String> status;
  final Value<DateTime?> startedAt;
  final Value<DateTime?> completedAt;
  final Value<int> plannedSec;
  final Value<bool> endedEarly;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const PromiseLogsCompanion({
    this.id = const Value.absent(),
    this.morningId = const Value.absent(),
    this.promiseId = const Value.absent(),
    this.status = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.plannedSec = const Value.absent(),
    this.endedEarly = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PromiseLogsCompanion.insert({
    required String id,
    required String morningId,
    required String promiseId,
    this.status = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    required int plannedSec,
    this.endedEarly = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       morningId = Value(morningId),
       promiseId = Value(promiseId),
       plannedSec = Value(plannedSec),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<PromiseLogRow> custom({
    Expression<String>? id,
    Expression<String>? morningId,
    Expression<String>? promiseId,
    Expression<String>? status,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? completedAt,
    Expression<int>? plannedSec,
    Expression<bool>? endedEarly,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (morningId != null) 'morning_id': morningId,
      if (promiseId != null) 'promise_id': promiseId,
      if (status != null) 'status': status,
      if (startedAt != null) 'started_at': startedAt,
      if (completedAt != null) 'completed_at': completedAt,
      if (plannedSec != null) 'planned_sec': plannedSec,
      if (endedEarly != null) 'ended_early': endedEarly,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PromiseLogsCompanion copyWith({
    Value<String>? id,
    Value<String>? morningId,
    Value<String>? promiseId,
    Value<String>? status,
    Value<DateTime?>? startedAt,
    Value<DateTime?>? completedAt,
    Value<int>? plannedSec,
    Value<bool>? endedEarly,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return PromiseLogsCompanion(
      id: id ?? this.id,
      morningId: morningId ?? this.morningId,
      promiseId: promiseId ?? this.promiseId,
      status: status ?? this.status,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      plannedSec: plannedSec ?? this.plannedSec,
      endedEarly: endedEarly ?? this.endedEarly,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (morningId.present) {
      map['morning_id'] = Variable<String>(morningId.value);
    }
    if (promiseId.present) {
      map['promise_id'] = Variable<String>(promiseId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (plannedSec.present) {
      map['planned_sec'] = Variable<int>(plannedSec.value);
    }
    if (endedEarly.present) {
      map['ended_early'] = Variable<bool>(endedEarly.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PromiseLogsCompanion(')
          ..write('id: $id, ')
          ..write('morningId: $morningId, ')
          ..write('promiseId: $promiseId, ')
          ..write('status: $status, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('plannedSec: $plannedSec, ')
          ..write('endedEarly: $endedEarly, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PreSleepLogsTable extends PreSleepLogs
    with TableInfo<$PreSleepLogsTable, PreSleepLogRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PreSleepLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _morningIdMeta = const VerificationMeta(
    'morningId',
  );
  @override
  late final GeneratedColumn<String> morningId = GeneratedColumn<String>(
    'morning_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES mornings (id)',
    ),
  );
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<String> itemId = GeneratedColumn<String>(
    'item_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES pre_sleep_items (id)',
    ),
  );
  static const VerificationMeta _checkedMeta = const VerificationMeta(
    'checked',
  );
  @override
  late final GeneratedColumn<bool> checked = GeneratedColumn<bool>(
    'checked',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("checked" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _checkedAtMeta = const VerificationMeta(
    'checkedAt',
  );
  @override
  late final GeneratedColumn<DateTime> checkedAt = GeneratedColumn<DateTime>(
    'checked_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    morningId,
    itemId,
    checked,
    checkedAt,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pre_sleep_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<PreSleepLogRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('morning_id')) {
      context.handle(
        _morningIdMeta,
        morningId.isAcceptableOrUnknown(data['morning_id']!, _morningIdMeta),
      );
    } else if (isInserting) {
      context.missing(_morningIdMeta);
    }
    if (data.containsKey('item_id')) {
      context.handle(
        _itemIdMeta,
        itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta),
      );
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('checked')) {
      context.handle(
        _checkedMeta,
        checked.isAcceptableOrUnknown(data['checked']!, _checkedMeta),
      );
    }
    if (data.containsKey('checked_at')) {
      context.handle(
        _checkedAtMeta,
        checkedAt.isAcceptableOrUnknown(data['checked_at']!, _checkedAtMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PreSleepLogRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PreSleepLogRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      morningId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}morning_id'],
      )!,
      itemId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}item_id'],
      )!,
      checked: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}checked'],
      )!,
      checkedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}checked_at'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $PreSleepLogsTable createAlias(String alias) {
    return $PreSleepLogsTable(attachedDatabase, alias);
  }
}

class PreSleepLogRow extends DataClass implements Insertable<PreSleepLogRow> {
  final String id;
  final String morningId;
  final String itemId;
  final bool checked;
  final DateTime? checkedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  const PreSleepLogRow({
    required this.id,
    required this.morningId,
    required this.itemId,
    required this.checked,
    this.checkedAt,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['morning_id'] = Variable<String>(morningId);
    map['item_id'] = Variable<String>(itemId);
    map['checked'] = Variable<bool>(checked);
    if (!nullToAbsent || checkedAt != null) {
      map['checked_at'] = Variable<DateTime>(checkedAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  PreSleepLogsCompanion toCompanion(bool nullToAbsent) {
    return PreSleepLogsCompanion(
      id: Value(id),
      morningId: Value(morningId),
      itemId: Value(itemId),
      checked: Value(checked),
      checkedAt: checkedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(checkedAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory PreSleepLogRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PreSleepLogRow(
      id: serializer.fromJson<String>(json['id']),
      morningId: serializer.fromJson<String>(json['morningId']),
      itemId: serializer.fromJson<String>(json['itemId']),
      checked: serializer.fromJson<bool>(json['checked']),
      checkedAt: serializer.fromJson<DateTime?>(json['checkedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'morningId': serializer.toJson<String>(morningId),
      'itemId': serializer.toJson<String>(itemId),
      'checked': serializer.toJson<bool>(checked),
      'checkedAt': serializer.toJson<DateTime?>(checkedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  PreSleepLogRow copyWith({
    String? id,
    String? morningId,
    String? itemId,
    bool? checked,
    Value<DateTime?> checkedAt = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => PreSleepLogRow(
    id: id ?? this.id,
    morningId: morningId ?? this.morningId,
    itemId: itemId ?? this.itemId,
    checked: checked ?? this.checked,
    checkedAt: checkedAt.present ? checkedAt.value : this.checkedAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  PreSleepLogRow copyWithCompanion(PreSleepLogsCompanion data) {
    return PreSleepLogRow(
      id: data.id.present ? data.id.value : this.id,
      morningId: data.morningId.present ? data.morningId.value : this.morningId,
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      checked: data.checked.present ? data.checked.value : this.checked,
      checkedAt: data.checkedAt.present ? data.checkedAt.value : this.checkedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PreSleepLogRow(')
          ..write('id: $id, ')
          ..write('morningId: $morningId, ')
          ..write('itemId: $itemId, ')
          ..write('checked: $checked, ')
          ..write('checkedAt: $checkedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    morningId,
    itemId,
    checked,
    checkedAt,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PreSleepLogRow &&
          other.id == this.id &&
          other.morningId == this.morningId &&
          other.itemId == this.itemId &&
          other.checked == this.checked &&
          other.checkedAt == this.checkedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class PreSleepLogsCompanion extends UpdateCompanion<PreSleepLogRow> {
  final Value<String> id;
  final Value<String> morningId;
  final Value<String> itemId;
  final Value<bool> checked;
  final Value<DateTime?> checkedAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const PreSleepLogsCompanion({
    this.id = const Value.absent(),
    this.morningId = const Value.absent(),
    this.itemId = const Value.absent(),
    this.checked = const Value.absent(),
    this.checkedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PreSleepLogsCompanion.insert({
    required String id,
    required String morningId,
    required String itemId,
    this.checked = const Value.absent(),
    this.checkedAt = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       morningId = Value(morningId),
       itemId = Value(itemId),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<PreSleepLogRow> custom({
    Expression<String>? id,
    Expression<String>? morningId,
    Expression<String>? itemId,
    Expression<bool>? checked,
    Expression<DateTime>? checkedAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (morningId != null) 'morning_id': morningId,
      if (itemId != null) 'item_id': itemId,
      if (checked != null) 'checked': checked,
      if (checkedAt != null) 'checked_at': checkedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PreSleepLogsCompanion copyWith({
    Value<String>? id,
    Value<String>? morningId,
    Value<String>? itemId,
    Value<bool>? checked,
    Value<DateTime?>? checkedAt,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return PreSleepLogsCompanion(
      id: id ?? this.id,
      morningId: morningId ?? this.morningId,
      itemId: itemId ?? this.itemId,
      checked: checked ?? this.checked,
      checkedAt: checkedAt ?? this.checkedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (morningId.present) {
      map['morning_id'] = Variable<String>(morningId.value);
    }
    if (itemId.present) {
      map['item_id'] = Variable<String>(itemId.value);
    }
    if (checked.present) {
      map['checked'] = Variable<bool>(checked.value);
    }
    if (checkedAt.present) {
      map['checked_at'] = Variable<DateTime>(checkedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PreSleepLogsCompanion(')
          ..write('id: $id, ')
          ..write('morningId: $morningId, ')
          ..write('itemId: $itemId, ')
          ..write('checked: $checked, ')
          ..write('checkedAt: $checkedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SettingsTable extends Settings
    with TableInfo<$SettingsTable, SettingsRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bedtimeLeadMinutesMeta =
      const VerificationMeta('bedtimeLeadMinutes');
  @override
  late final GeneratedColumn<int> bedtimeLeadMinutes = GeneratedColumn<int>(
    'bedtime_lead_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(30),
  );
  static const VerificationMeta _languageMeta = const VerificationMeta(
    'language',
  );
  @override
  late final GeneratedColumn<String> language = GeneratedColumn<String>(
    'language',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('system'),
  );
  static const VerificationMeta _reduceMotionOverrideMeta =
      const VerificationMeta('reduceMotionOverride');
  @override
  late final GeneratedColumn<bool> reduceMotionOverride = GeneratedColumn<bool>(
    'reduce_motion_override',
    aliasedName,
    true,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("reduce_motion_override" IN (0, 1))',
    ),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    bedtimeLeadMinutes,
    language,
    reduceMotionOverride,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<SettingsRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('bedtime_lead_minutes')) {
      context.handle(
        _bedtimeLeadMinutesMeta,
        bedtimeLeadMinutes.isAcceptableOrUnknown(
          data['bedtime_lead_minutes']!,
          _bedtimeLeadMinutesMeta,
        ),
      );
    }
    if (data.containsKey('language')) {
      context.handle(
        _languageMeta,
        language.isAcceptableOrUnknown(data['language']!, _languageMeta),
      );
    }
    if (data.containsKey('reduce_motion_override')) {
      context.handle(
        _reduceMotionOverrideMeta,
        reduceMotionOverride.isAcceptableOrUnknown(
          data['reduce_motion_override']!,
          _reduceMotionOverrideMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SettingsRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SettingsRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      bedtimeLeadMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}bedtime_lead_minutes'],
      )!,
      language: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}language'],
      )!,
      reduceMotionOverride: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}reduce_motion_override'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $SettingsTable createAlias(String alias) {
    return $SettingsTable(attachedDatabase, alias);
  }
}

class SettingsRow extends DataClass implements Insertable<SettingsRow> {
  final String id;
  final int bedtimeLeadMinutes;
  final String language;
  final bool? reduceMotionOverride;
  final DateTime createdAt;
  final DateTime updatedAt;
  const SettingsRow({
    required this.id,
    required this.bedtimeLeadMinutes,
    required this.language,
    this.reduceMotionOverride,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['bedtime_lead_minutes'] = Variable<int>(bedtimeLeadMinutes);
    map['language'] = Variable<String>(language);
    if (!nullToAbsent || reduceMotionOverride != null) {
      map['reduce_motion_override'] = Variable<bool>(reduceMotionOverride);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SettingsCompanion toCompanion(bool nullToAbsent) {
    return SettingsCompanion(
      id: Value(id),
      bedtimeLeadMinutes: Value(bedtimeLeadMinutes),
      language: Value(language),
      reduceMotionOverride: reduceMotionOverride == null && nullToAbsent
          ? const Value.absent()
          : Value(reduceMotionOverride),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory SettingsRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SettingsRow(
      id: serializer.fromJson<String>(json['id']),
      bedtimeLeadMinutes: serializer.fromJson<int>(json['bedtimeLeadMinutes']),
      language: serializer.fromJson<String>(json['language']),
      reduceMotionOverride: serializer.fromJson<bool?>(
        json['reduceMotionOverride'],
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'bedtimeLeadMinutes': serializer.toJson<int>(bedtimeLeadMinutes),
      'language': serializer.toJson<String>(language),
      'reduceMotionOverride': serializer.toJson<bool?>(reduceMotionOverride),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  SettingsRow copyWith({
    String? id,
    int? bedtimeLeadMinutes,
    String? language,
    Value<bool?> reduceMotionOverride = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => SettingsRow(
    id: id ?? this.id,
    bedtimeLeadMinutes: bedtimeLeadMinutes ?? this.bedtimeLeadMinutes,
    language: language ?? this.language,
    reduceMotionOverride: reduceMotionOverride.present
        ? reduceMotionOverride.value
        : this.reduceMotionOverride,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  SettingsRow copyWithCompanion(SettingsCompanion data) {
    return SettingsRow(
      id: data.id.present ? data.id.value : this.id,
      bedtimeLeadMinutes: data.bedtimeLeadMinutes.present
          ? data.bedtimeLeadMinutes.value
          : this.bedtimeLeadMinutes,
      language: data.language.present ? data.language.value : this.language,
      reduceMotionOverride: data.reduceMotionOverride.present
          ? data.reduceMotionOverride.value
          : this.reduceMotionOverride,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SettingsRow(')
          ..write('id: $id, ')
          ..write('bedtimeLeadMinutes: $bedtimeLeadMinutes, ')
          ..write('language: $language, ')
          ..write('reduceMotionOverride: $reduceMotionOverride, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    bedtimeLeadMinutes,
    language,
    reduceMotionOverride,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SettingsRow &&
          other.id == this.id &&
          other.bedtimeLeadMinutes == this.bedtimeLeadMinutes &&
          other.language == this.language &&
          other.reduceMotionOverride == this.reduceMotionOverride &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class SettingsCompanion extends UpdateCompanion<SettingsRow> {
  final Value<String> id;
  final Value<int> bedtimeLeadMinutes;
  final Value<String> language;
  final Value<bool?> reduceMotionOverride;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const SettingsCompanion({
    this.id = const Value.absent(),
    this.bedtimeLeadMinutes = const Value.absent(),
    this.language = const Value.absent(),
    this.reduceMotionOverride = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SettingsCompanion.insert({
    required String id,
    this.bedtimeLeadMinutes = const Value.absent(),
    this.language = const Value.absent(),
    this.reduceMotionOverride = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<SettingsRow> custom({
    Expression<String>? id,
    Expression<int>? bedtimeLeadMinutes,
    Expression<String>? language,
    Expression<bool>? reduceMotionOverride,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (bedtimeLeadMinutes != null)
        'bedtime_lead_minutes': bedtimeLeadMinutes,
      if (language != null) 'language': language,
      if (reduceMotionOverride != null)
        'reduce_motion_override': reduceMotionOverride,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SettingsCompanion copyWith({
    Value<String>? id,
    Value<int>? bedtimeLeadMinutes,
    Value<String>? language,
    Value<bool?>? reduceMotionOverride,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return SettingsCompanion(
      id: id ?? this.id,
      bedtimeLeadMinutes: bedtimeLeadMinutes ?? this.bedtimeLeadMinutes,
      language: language ?? this.language,
      reduceMotionOverride: reduceMotionOverride ?? this.reduceMotionOverride,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (bedtimeLeadMinutes.present) {
      map['bedtime_lead_minutes'] = Variable<int>(bedtimeLeadMinutes.value);
    }
    if (language.present) {
      map['language'] = Variable<String>(language.value);
    }
    if (reduceMotionOverride.present) {
      map['reduce_motion_override'] = Variable<bool>(
        reduceMotionOverride.value,
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsCompanion(')
          ..write('id: $id, ')
          ..write('bedtimeLeadMinutes: $bedtimeLeadMinutes, ')
          ..write('language: $language, ')
          ..write('reduceMotionOverride: $reduceMotionOverride, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $PlansTable plans = $PlansTable(this);
  late final $PreSleepItemsTable preSleepItems = $PreSleepItemsTable(this);
  late final $CategoriesTable categories = $CategoriesTable(this);
  late final $PromisesTable promises = $PromisesTable(this);
  late final $MorningsTable mornings = $MorningsTable(this);
  late final $PromiseLogsTable promiseLogs = $PromiseLogsTable(this);
  late final $PreSleepLogsTable preSleepLogs = $PreSleepLogsTable(this);
  late final $SettingsTable settings = $SettingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    plans,
    preSleepItems,
    categories,
    promises,
    mornings,
    promiseLogs,
    preSleepLogs,
    settings,
  ];
}

typedef $$PlansTableCreateCompanionBuilder =
    PlansCompanion Function({
      required String id,
      required int wakeMinute,
      required int bedMinute,
      Value<String?> whyText,
      required DateTime signedAt,
      required DateTime journeyStartDate,
      Value<int> journeyLengthDays,
      required bool isActive,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$PlansTableUpdateCompanionBuilder =
    PlansCompanion Function({
      Value<String> id,
      Value<int> wakeMinute,
      Value<int> bedMinute,
      Value<String?> whyText,
      Value<DateTime> signedAt,
      Value<DateTime> journeyStartDate,
      Value<int> journeyLengthDays,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$PlansTableReferences
    extends BaseReferences<_$AppDatabase, $PlansTable, PlanRow> {
  $$PlansTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$PreSleepItemsTable, List<PreSleepItemRow>>
  _preSleepItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.preSleepItems,
    aliasName: 'plans__id__pre_sleep_items__plan_id',
  );

  $$PreSleepItemsTableProcessedTableManager get preSleepItemsRefs {
    final manager = $$PreSleepItemsTableTableManager(
      $_db,
      $_db.preSleepItems,
    ).filter((f) => f.planId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_preSleepItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PromisesTable, List<PromiseRow>>
  _promisesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.promises,
    aliasName: 'plans__id__promises__plan_id',
  );

  $$PromisesTableProcessedTableManager get promisesRefs {
    final manager = $$PromisesTableTableManager(
      $_db,
      $_db.promises,
    ).filter((f) => f.planId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_promisesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$MorningsTable, List<MorningRow>>
  _morningsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.mornings,
    aliasName: 'plans__id__mornings__plan_id',
  );

  $$MorningsTableProcessedTableManager get morningsRefs {
    final manager = $$MorningsTableTableManager(
      $_db,
      $_db.mornings,
    ).filter((f) => f.planId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_morningsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PlansTableFilterComposer extends Composer<_$AppDatabase, $PlansTable> {
  $$PlansTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get wakeMinute => $composableBuilder(
    column: $table.wakeMinute,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get bedMinute => $composableBuilder(
    column: $table.bedMinute,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get whyText => $composableBuilder(
    column: $table.whyText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get signedAt => $composableBuilder(
    column: $table.signedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get journeyStartDate => $composableBuilder(
    column: $table.journeyStartDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get journeyLengthDays => $composableBuilder(
    column: $table.journeyLengthDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> preSleepItemsRefs(
    Expression<bool> Function($$PreSleepItemsTableFilterComposer f) f,
  ) {
    final $$PreSleepItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.preSleepItems,
      getReferencedColumn: (t) => t.planId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PreSleepItemsTableFilterComposer(
            $db: $db,
            $table: $db.preSleepItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> promisesRefs(
    Expression<bool> Function($$PromisesTableFilterComposer f) f,
  ) {
    final $$PromisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.promises,
      getReferencedColumn: (t) => t.planId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PromisesTableFilterComposer(
            $db: $db,
            $table: $db.promises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> morningsRefs(
    Expression<bool> Function($$MorningsTableFilterComposer f) f,
  ) {
    final $$MorningsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.mornings,
      getReferencedColumn: (t) => t.planId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MorningsTableFilterComposer(
            $db: $db,
            $table: $db.mornings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PlansTableOrderingComposer
    extends Composer<_$AppDatabase, $PlansTable> {
  $$PlansTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get wakeMinute => $composableBuilder(
    column: $table.wakeMinute,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get bedMinute => $composableBuilder(
    column: $table.bedMinute,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get whyText => $composableBuilder(
    column: $table.whyText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get signedAt => $composableBuilder(
    column: $table.signedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get journeyStartDate => $composableBuilder(
    column: $table.journeyStartDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get journeyLengthDays => $composableBuilder(
    column: $table.journeyLengthDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PlansTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlansTable> {
  $$PlansTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get wakeMinute => $composableBuilder(
    column: $table.wakeMinute,
    builder: (column) => column,
  );

  GeneratedColumn<int> get bedMinute =>
      $composableBuilder(column: $table.bedMinute, builder: (column) => column);

  GeneratedColumn<String> get whyText =>
      $composableBuilder(column: $table.whyText, builder: (column) => column);

  GeneratedColumn<DateTime> get signedAt =>
      $composableBuilder(column: $table.signedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get journeyStartDate => $composableBuilder(
    column: $table.journeyStartDate,
    builder: (column) => column,
  );

  GeneratedColumn<int> get journeyLengthDays => $composableBuilder(
    column: $table.journeyLengthDays,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> preSleepItemsRefs<T extends Object>(
    Expression<T> Function($$PreSleepItemsTableAnnotationComposer a) f,
  ) {
    final $$PreSleepItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.preSleepItems,
      getReferencedColumn: (t) => t.planId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PreSleepItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.preSleepItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> promisesRefs<T extends Object>(
    Expression<T> Function($$PromisesTableAnnotationComposer a) f,
  ) {
    final $$PromisesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.promises,
      getReferencedColumn: (t) => t.planId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PromisesTableAnnotationComposer(
            $db: $db,
            $table: $db.promises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> morningsRefs<T extends Object>(
    Expression<T> Function($$MorningsTableAnnotationComposer a) f,
  ) {
    final $$MorningsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.mornings,
      getReferencedColumn: (t) => t.planId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MorningsTableAnnotationComposer(
            $db: $db,
            $table: $db.mornings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PlansTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PlansTable,
          PlanRow,
          $$PlansTableFilterComposer,
          $$PlansTableOrderingComposer,
          $$PlansTableAnnotationComposer,
          $$PlansTableCreateCompanionBuilder,
          $$PlansTableUpdateCompanionBuilder,
          (PlanRow, $$PlansTableReferences),
          PlanRow,
          PrefetchHooks Function({
            bool preSleepItemsRefs,
            bool promisesRefs,
            bool morningsRefs,
          })
        > {
  $$PlansTableTableManager(_$AppDatabase db, $PlansTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlansTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlansTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlansTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> wakeMinute = const Value.absent(),
                Value<int> bedMinute = const Value.absent(),
                Value<String?> whyText = const Value.absent(),
                Value<DateTime> signedAt = const Value.absent(),
                Value<DateTime> journeyStartDate = const Value.absent(),
                Value<int> journeyLengthDays = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PlansCompanion(
                id: id,
                wakeMinute: wakeMinute,
                bedMinute: bedMinute,
                whyText: whyText,
                signedAt: signedAt,
                journeyStartDate: journeyStartDate,
                journeyLengthDays: journeyLengthDays,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int wakeMinute,
                required int bedMinute,
                Value<String?> whyText = const Value.absent(),
                required DateTime signedAt,
                required DateTime journeyStartDate,
                Value<int> journeyLengthDays = const Value.absent(),
                required bool isActive,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => PlansCompanion.insert(
                id: id,
                wakeMinute: wakeMinute,
                bedMinute: bedMinute,
                whyText: whyText,
                signedAt: signedAt,
                journeyStartDate: journeyStartDate,
                journeyLengthDays: journeyLengthDays,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$PlansTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                preSleepItemsRefs = false,
                promisesRefs = false,
                morningsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (preSleepItemsRefs) db.preSleepItems,
                    if (promisesRefs) db.promises,
                    if (morningsRefs) db.mornings,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (preSleepItemsRefs)
                        await $_getPrefetchedData<
                          PlanRow,
                          $PlansTable,
                          PreSleepItemRow
                        >(
                          currentTable: table,
                          referencedTable: $$PlansTableReferences
                              ._preSleepItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PlansTableReferences(
                                db,
                                table,
                                p0,
                              ).preSleepItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.planId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (promisesRefs)
                        await $_getPrefetchedData<
                          PlanRow,
                          $PlansTable,
                          PromiseRow
                        >(
                          currentTable: table,
                          referencedTable: $$PlansTableReferences
                              ._promisesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PlansTableReferences(
                                db,
                                table,
                                p0,
                              ).promisesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.planId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (morningsRefs)
                        await $_getPrefetchedData<
                          PlanRow,
                          $PlansTable,
                          MorningRow
                        >(
                          currentTable: table,
                          referencedTable: $$PlansTableReferences
                              ._morningsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PlansTableReferences(
                                db,
                                table,
                                p0,
                              ).morningsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.planId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$PlansTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PlansTable,
      PlanRow,
      $$PlansTableFilterComposer,
      $$PlansTableOrderingComposer,
      $$PlansTableAnnotationComposer,
      $$PlansTableCreateCompanionBuilder,
      $$PlansTableUpdateCompanionBuilder,
      (PlanRow, $$PlansTableReferences),
      PlanRow,
      PrefetchHooks Function({
        bool preSleepItemsRefs,
        bool promisesRefs,
        bool morningsRefs,
      })
    >;
typedef $$PreSleepItemsTableCreateCompanionBuilder =
    PreSleepItemsCompanion Function({
      required String id,
      required String planId,
      required String title,
      required int sortOrder,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$PreSleepItemsTableUpdateCompanionBuilder =
    PreSleepItemsCompanion Function({
      Value<String> id,
      Value<String> planId,
      Value<String> title,
      Value<int> sortOrder,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$PreSleepItemsTableReferences
    extends
        BaseReferences<_$AppDatabase, $PreSleepItemsTable, PreSleepItemRow> {
  $$PreSleepItemsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $PlansTable _planIdTable(_$AppDatabase db) =>
      db.plans.createAlias('pre_sleep_items__plan_id__plans__id');

  $$PlansTableProcessedTableManager get planId {
    final $_column = $_itemColumn<String>('plan_id')!;

    final manager = $$PlansTableTableManager(
      $_db,
      $_db.plans,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_planIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$PreSleepLogsTable, List<PreSleepLogRow>>
  _preSleepLogsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.preSleepLogs,
    aliasName: 'pre_sleep_items__id__pre_sleep_logs__item_id',
  );

  $$PreSleepLogsTableProcessedTableManager get preSleepLogsRefs {
    final manager = $$PreSleepLogsTableTableManager(
      $_db,
      $_db.preSleepLogs,
    ).filter((f) => f.itemId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_preSleepLogsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PreSleepItemsTableFilterComposer
    extends Composer<_$AppDatabase, $PreSleepItemsTable> {
  $$PreSleepItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$PlansTableFilterComposer get planId {
    final $$PlansTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.planId,
      referencedTable: $db.plans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlansTableFilterComposer(
            $db: $db,
            $table: $db.plans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> preSleepLogsRefs(
    Expression<bool> Function($$PreSleepLogsTableFilterComposer f) f,
  ) {
    final $$PreSleepLogsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.preSleepLogs,
      getReferencedColumn: (t) => t.itemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PreSleepLogsTableFilterComposer(
            $db: $db,
            $table: $db.preSleepLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PreSleepItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $PreSleepItemsTable> {
  $$PreSleepItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$PlansTableOrderingComposer get planId {
    final $$PlansTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.planId,
      referencedTable: $db.plans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlansTableOrderingComposer(
            $db: $db,
            $table: $db.plans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PreSleepItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PreSleepItemsTable> {
  $$PreSleepItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$PlansTableAnnotationComposer get planId {
    final $$PlansTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.planId,
      referencedTable: $db.plans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlansTableAnnotationComposer(
            $db: $db,
            $table: $db.plans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> preSleepLogsRefs<T extends Object>(
    Expression<T> Function($$PreSleepLogsTableAnnotationComposer a) f,
  ) {
    final $$PreSleepLogsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.preSleepLogs,
      getReferencedColumn: (t) => t.itemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PreSleepLogsTableAnnotationComposer(
            $db: $db,
            $table: $db.preSleepLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PreSleepItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PreSleepItemsTable,
          PreSleepItemRow,
          $$PreSleepItemsTableFilterComposer,
          $$PreSleepItemsTableOrderingComposer,
          $$PreSleepItemsTableAnnotationComposer,
          $$PreSleepItemsTableCreateCompanionBuilder,
          $$PreSleepItemsTableUpdateCompanionBuilder,
          (PreSleepItemRow, $$PreSleepItemsTableReferences),
          PreSleepItemRow,
          PrefetchHooks Function({bool planId, bool preSleepLogsRefs})
        > {
  $$PreSleepItemsTableTableManager(_$AppDatabase db, $PreSleepItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PreSleepItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PreSleepItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PreSleepItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> planId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PreSleepItemsCompanion(
                id: id,
                planId: planId,
                title: title,
                sortOrder: sortOrder,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String planId,
                required String title,
                required int sortOrder,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => PreSleepItemsCompanion.insert(
                id: id,
                planId: planId,
                title: title,
                sortOrder: sortOrder,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PreSleepItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({planId = false, preSleepLogsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (preSleepLogsRefs) db.preSleepLogs],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (planId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.planId,
                                referencedTable: $$PreSleepItemsTableReferences
                                    ._planIdTable(db),
                                referencedColumn: $$PreSleepItemsTableReferences
                                    ._planIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (preSleepLogsRefs)
                    await $_getPrefetchedData<
                      PreSleepItemRow,
                      $PreSleepItemsTable,
                      PreSleepLogRow
                    >(
                      currentTable: table,
                      referencedTable: $$PreSleepItemsTableReferences
                          ._preSleepLogsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$PreSleepItemsTableReferences(
                            db,
                            table,
                            p0,
                          ).preSleepLogsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.itemId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$PreSleepItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PreSleepItemsTable,
      PreSleepItemRow,
      $$PreSleepItemsTableFilterComposer,
      $$PreSleepItemsTableOrderingComposer,
      $$PreSleepItemsTableAnnotationComposer,
      $$PreSleepItemsTableCreateCompanionBuilder,
      $$PreSleepItemsTableUpdateCompanionBuilder,
      (PreSleepItemRow, $$PreSleepItemsTableReferences),
      PreSleepItemRow,
      PrefetchHooks Function({bool planId, bool preSleepLogsRefs})
    >;
typedef $$CategoriesTableCreateCompanionBuilder =
    CategoriesCompanion Function({
      required String id,
      required String name,
      required String iconKey,
      required String colorKey,
      Value<bool> isBuiltIn,
      Value<bool> isArchived,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$CategoriesTableUpdateCompanionBuilder =
    CategoriesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> iconKey,
      Value<String> colorKey,
      Value<bool> isBuiltIn,
      Value<bool> isArchived,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$CategoriesTableReferences
    extends BaseReferences<_$AppDatabase, $CategoriesTable, CategoryRow> {
  $$CategoriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$PromisesTable, List<PromiseRow>>
  _promisesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.promises,
    aliasName: 'categories__id__promises__category_id',
  );

  $$PromisesTableProcessedTableManager get promisesRefs {
    final manager = $$PromisesTableTableManager(
      $_db,
      $_db.promises,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_promisesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get iconKey => $composableBuilder(
    column: $table.iconKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get colorKey => $composableBuilder(
    column: $table.colorKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isBuiltIn => $composableBuilder(
    column: $table.isBuiltIn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> promisesRefs(
    Expression<bool> Function($$PromisesTableFilterComposer f) f,
  ) {
    final $$PromisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.promises,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PromisesTableFilterComposer(
            $db: $db,
            $table: $db.promises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get iconKey => $composableBuilder(
    column: $table.iconKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get colorKey => $composableBuilder(
    column: $table.colorKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isBuiltIn => $composableBuilder(
    column: $table.isBuiltIn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get iconKey =>
      $composableBuilder(column: $table.iconKey, builder: (column) => column);

  GeneratedColumn<String> get colorKey =>
      $composableBuilder(column: $table.colorKey, builder: (column) => column);

  GeneratedColumn<bool> get isBuiltIn =>
      $composableBuilder(column: $table.isBuiltIn, builder: (column) => column);

  GeneratedColumn<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> promisesRefs<T extends Object>(
    Expression<T> Function($$PromisesTableAnnotationComposer a) f,
  ) {
    final $$PromisesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.promises,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PromisesTableAnnotationComposer(
            $db: $db,
            $table: $db.promises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CategoriesTable,
          CategoryRow,
          $$CategoriesTableFilterComposer,
          $$CategoriesTableOrderingComposer,
          $$CategoriesTableAnnotationComposer,
          $$CategoriesTableCreateCompanionBuilder,
          $$CategoriesTableUpdateCompanionBuilder,
          (CategoryRow, $$CategoriesTableReferences),
          CategoryRow,
          PrefetchHooks Function({bool promisesRefs})
        > {
  $$CategoriesTableTableManager(_$AppDatabase db, $CategoriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> iconKey = const Value.absent(),
                Value<String> colorKey = const Value.absent(),
                Value<bool> isBuiltIn = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CategoriesCompanion(
                id: id,
                name: name,
                iconKey: iconKey,
                colorKey: colorKey,
                isBuiltIn: isBuiltIn,
                isArchived: isArchived,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String iconKey,
                required String colorKey,
                Value<bool> isBuiltIn = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => CategoriesCompanion.insert(
                id: id,
                name: name,
                iconKey: iconKey,
                colorKey: colorKey,
                isBuiltIn: isBuiltIn,
                isArchived: isArchived,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CategoriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({promisesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (promisesRefs) db.promises],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (promisesRefs)
                    await $_getPrefetchedData<
                      CategoryRow,
                      $CategoriesTable,
                      PromiseRow
                    >(
                      currentTable: table,
                      referencedTable: $$CategoriesTableReferences
                          ._promisesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$CategoriesTableReferences(
                            db,
                            table,
                            p0,
                          ).promisesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.categoryId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$CategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CategoriesTable,
      CategoryRow,
      $$CategoriesTableFilterComposer,
      $$CategoriesTableOrderingComposer,
      $$CategoriesTableAnnotationComposer,
      $$CategoriesTableCreateCompanionBuilder,
      $$CategoriesTableUpdateCompanionBuilder,
      (CategoryRow, $$CategoriesTableReferences),
      CategoryRow,
      PrefetchHooks Function({bool promisesRefs})
    >;
typedef $$PromisesTableCreateCompanionBuilder =
    PromisesCompanion Function({
      required String id,
      required String planId,
      required String categoryId,
      required String title,
      Value<String?> description,
      required int durationMin,
      required int sortOrder,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$PromisesTableUpdateCompanionBuilder =
    PromisesCompanion Function({
      Value<String> id,
      Value<String> planId,
      Value<String> categoryId,
      Value<String> title,
      Value<String?> description,
      Value<int> durationMin,
      Value<int> sortOrder,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$PromisesTableReferences
    extends BaseReferences<_$AppDatabase, $PromisesTable, PromiseRow> {
  $$PromisesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PlansTable _planIdTable(_$AppDatabase db) =>
      db.plans.createAlias('promises__plan_id__plans__id');

  $$PlansTableProcessedTableManager get planId {
    final $_column = $_itemColumn<String>('plan_id')!;

    final manager = $$PlansTableTableManager(
      $_db,
      $_db.plans,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_planIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CategoriesTable _categoryIdTable(_$AppDatabase db) =>
      db.categories.createAlias('promises__category_id__categories__id');

  $$CategoriesTableProcessedTableManager get categoryId {
    final $_column = $_itemColumn<String>('category_id')!;

    final manager = $$CategoriesTableTableManager(
      $_db,
      $_db.categories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$PromiseLogsTable, List<PromiseLogRow>>
  _promiseLogsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.promiseLogs,
    aliasName: 'promises__id__promise_logs__promise_id',
  );

  $$PromiseLogsTableProcessedTableManager get promiseLogsRefs {
    final manager = $$PromiseLogsTableTableManager(
      $_db,
      $_db.promiseLogs,
    ).filter((f) => f.promiseId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_promiseLogsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PromisesTableFilterComposer
    extends Composer<_$AppDatabase, $PromisesTable> {
  $$PromisesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationMin => $composableBuilder(
    column: $table.durationMin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$PlansTableFilterComposer get planId {
    final $$PlansTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.planId,
      referencedTable: $db.plans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlansTableFilterComposer(
            $db: $db,
            $table: $db.plans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableFilterComposer get categoryId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableFilterComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> promiseLogsRefs(
    Expression<bool> Function($$PromiseLogsTableFilterComposer f) f,
  ) {
    final $$PromiseLogsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.promiseLogs,
      getReferencedColumn: (t) => t.promiseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PromiseLogsTableFilterComposer(
            $db: $db,
            $table: $db.promiseLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PromisesTableOrderingComposer
    extends Composer<_$AppDatabase, $PromisesTable> {
  $$PromisesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationMin => $composableBuilder(
    column: $table.durationMin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$PlansTableOrderingComposer get planId {
    final $$PlansTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.planId,
      referencedTable: $db.plans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlansTableOrderingComposer(
            $db: $db,
            $table: $db.plans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableOrderingComposer get categoryId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PromisesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PromisesTable> {
  $$PromisesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<int> get durationMin => $composableBuilder(
    column: $table.durationMin,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$PlansTableAnnotationComposer get planId {
    final $$PlansTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.planId,
      referencedTable: $db.plans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlansTableAnnotationComposer(
            $db: $db,
            $table: $db.plans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableAnnotationComposer get categoryId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> promiseLogsRefs<T extends Object>(
    Expression<T> Function($$PromiseLogsTableAnnotationComposer a) f,
  ) {
    final $$PromiseLogsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.promiseLogs,
      getReferencedColumn: (t) => t.promiseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PromiseLogsTableAnnotationComposer(
            $db: $db,
            $table: $db.promiseLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PromisesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PromisesTable,
          PromiseRow,
          $$PromisesTableFilterComposer,
          $$PromisesTableOrderingComposer,
          $$PromisesTableAnnotationComposer,
          $$PromisesTableCreateCompanionBuilder,
          $$PromisesTableUpdateCompanionBuilder,
          (PromiseRow, $$PromisesTableReferences),
          PromiseRow,
          PrefetchHooks Function({
            bool planId,
            bool categoryId,
            bool promiseLogsRefs,
          })
        > {
  $$PromisesTableTableManager(_$AppDatabase db, $PromisesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PromisesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PromisesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PromisesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> planId = const Value.absent(),
                Value<String> categoryId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<int> durationMin = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PromisesCompanion(
                id: id,
                planId: planId,
                categoryId: categoryId,
                title: title,
                description: description,
                durationMin: durationMin,
                sortOrder: sortOrder,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String planId,
                required String categoryId,
                required String title,
                Value<String?> description = const Value.absent(),
                required int durationMin,
                required int sortOrder,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => PromisesCompanion.insert(
                id: id,
                planId: planId,
                categoryId: categoryId,
                title: title,
                description: description,
                durationMin: durationMin,
                sortOrder: sortOrder,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PromisesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({planId = false, categoryId = false, promiseLogsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (promiseLogsRefs) db.promiseLogs,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (planId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.planId,
                                    referencedTable: $$PromisesTableReferences
                                        ._planIdTable(db),
                                    referencedColumn: $$PromisesTableReferences
                                        ._planIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (categoryId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.categoryId,
                                    referencedTable: $$PromisesTableReferences
                                        ._categoryIdTable(db),
                                    referencedColumn: $$PromisesTableReferences
                                        ._categoryIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (promiseLogsRefs)
                        await $_getPrefetchedData<
                          PromiseRow,
                          $PromisesTable,
                          PromiseLogRow
                        >(
                          currentTable: table,
                          referencedTable: $$PromisesTableReferences
                              ._promiseLogsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PromisesTableReferences(
                                db,
                                table,
                                p0,
                              ).promiseLogsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.promiseId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$PromisesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PromisesTable,
      PromiseRow,
      $$PromisesTableFilterComposer,
      $$PromisesTableOrderingComposer,
      $$PromisesTableAnnotationComposer,
      $$PromisesTableCreateCompanionBuilder,
      $$PromisesTableUpdateCompanionBuilder,
      (PromiseRow, $$PromisesTableReferences),
      PromiseRow,
      PrefetchHooks Function({
        bool planId,
        bool categoryId,
        bool promiseLogsRefs,
      })
    >;
typedef $$MorningsTableCreateCompanionBuilder =
    MorningsCompanion Function({
      required String id,
      required String date,
      required String planId,
      required DateTime scheduledAt,
      Value<DateTime?> alarmFiredAt,
      Value<DateTime?> wakeConfirmedAt,
      Value<String> result,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$MorningsTableUpdateCompanionBuilder =
    MorningsCompanion Function({
      Value<String> id,
      Value<String> date,
      Value<String> planId,
      Value<DateTime> scheduledAt,
      Value<DateTime?> alarmFiredAt,
      Value<DateTime?> wakeConfirmedAt,
      Value<String> result,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$MorningsTableReferences
    extends BaseReferences<_$AppDatabase, $MorningsTable, MorningRow> {
  $$MorningsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PlansTable _planIdTable(_$AppDatabase db) =>
      db.plans.createAlias('mornings__plan_id__plans__id');

  $$PlansTableProcessedTableManager get planId {
    final $_column = $_itemColumn<String>('plan_id')!;

    final manager = $$PlansTableTableManager(
      $_db,
      $_db.plans,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_planIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$PromiseLogsTable, List<PromiseLogRow>>
  _promiseLogsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.promiseLogs,
    aliasName: 'mornings__id__promise_logs__morning_id',
  );

  $$PromiseLogsTableProcessedTableManager get promiseLogsRefs {
    final manager = $$PromiseLogsTableTableManager(
      $_db,
      $_db.promiseLogs,
    ).filter((f) => f.morningId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_promiseLogsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PreSleepLogsTable, List<PreSleepLogRow>>
  _preSleepLogsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.preSleepLogs,
    aliasName: 'mornings__id__pre_sleep_logs__morning_id',
  );

  $$PreSleepLogsTableProcessedTableManager get preSleepLogsRefs {
    final manager = $$PreSleepLogsTableTableManager(
      $_db,
      $_db.preSleepLogs,
    ).filter((f) => f.morningId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_preSleepLogsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$MorningsTableFilterComposer
    extends Composer<_$AppDatabase, $MorningsTable> {
  $$MorningsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get scheduledAt => $composableBuilder(
    column: $table.scheduledAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get alarmFiredAt => $composableBuilder(
    column: $table.alarmFiredAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get wakeConfirmedAt => $composableBuilder(
    column: $table.wakeConfirmedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get result => $composableBuilder(
    column: $table.result,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$PlansTableFilterComposer get planId {
    final $$PlansTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.planId,
      referencedTable: $db.plans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlansTableFilterComposer(
            $db: $db,
            $table: $db.plans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> promiseLogsRefs(
    Expression<bool> Function($$PromiseLogsTableFilterComposer f) f,
  ) {
    final $$PromiseLogsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.promiseLogs,
      getReferencedColumn: (t) => t.morningId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PromiseLogsTableFilterComposer(
            $db: $db,
            $table: $db.promiseLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> preSleepLogsRefs(
    Expression<bool> Function($$PreSleepLogsTableFilterComposer f) f,
  ) {
    final $$PreSleepLogsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.preSleepLogs,
      getReferencedColumn: (t) => t.morningId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PreSleepLogsTableFilterComposer(
            $db: $db,
            $table: $db.preSleepLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MorningsTableOrderingComposer
    extends Composer<_$AppDatabase, $MorningsTable> {
  $$MorningsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get scheduledAt => $composableBuilder(
    column: $table.scheduledAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get alarmFiredAt => $composableBuilder(
    column: $table.alarmFiredAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get wakeConfirmedAt => $composableBuilder(
    column: $table.wakeConfirmedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get result => $composableBuilder(
    column: $table.result,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$PlansTableOrderingComposer get planId {
    final $$PlansTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.planId,
      referencedTable: $db.plans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlansTableOrderingComposer(
            $db: $db,
            $table: $db.plans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MorningsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MorningsTable> {
  $$MorningsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<DateTime> get scheduledAt => $composableBuilder(
    column: $table.scheduledAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get alarmFiredAt => $composableBuilder(
    column: $table.alarmFiredAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get wakeConfirmedAt => $composableBuilder(
    column: $table.wakeConfirmedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get result =>
      $composableBuilder(column: $table.result, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$PlansTableAnnotationComposer get planId {
    final $$PlansTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.planId,
      referencedTable: $db.plans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlansTableAnnotationComposer(
            $db: $db,
            $table: $db.plans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> promiseLogsRefs<T extends Object>(
    Expression<T> Function($$PromiseLogsTableAnnotationComposer a) f,
  ) {
    final $$PromiseLogsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.promiseLogs,
      getReferencedColumn: (t) => t.morningId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PromiseLogsTableAnnotationComposer(
            $db: $db,
            $table: $db.promiseLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> preSleepLogsRefs<T extends Object>(
    Expression<T> Function($$PreSleepLogsTableAnnotationComposer a) f,
  ) {
    final $$PreSleepLogsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.preSleepLogs,
      getReferencedColumn: (t) => t.morningId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PreSleepLogsTableAnnotationComposer(
            $db: $db,
            $table: $db.preSleepLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MorningsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MorningsTable,
          MorningRow,
          $$MorningsTableFilterComposer,
          $$MorningsTableOrderingComposer,
          $$MorningsTableAnnotationComposer,
          $$MorningsTableCreateCompanionBuilder,
          $$MorningsTableUpdateCompanionBuilder,
          (MorningRow, $$MorningsTableReferences),
          MorningRow,
          PrefetchHooks Function({
            bool planId,
            bool promiseLogsRefs,
            bool preSleepLogsRefs,
          })
        > {
  $$MorningsTableTableManager(_$AppDatabase db, $MorningsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MorningsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MorningsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MorningsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> date = const Value.absent(),
                Value<String> planId = const Value.absent(),
                Value<DateTime> scheduledAt = const Value.absent(),
                Value<DateTime?> alarmFiredAt = const Value.absent(),
                Value<DateTime?> wakeConfirmedAt = const Value.absent(),
                Value<String> result = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MorningsCompanion(
                id: id,
                date: date,
                planId: planId,
                scheduledAt: scheduledAt,
                alarmFiredAt: alarmFiredAt,
                wakeConfirmedAt: wakeConfirmedAt,
                result: result,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String date,
                required String planId,
                required DateTime scheduledAt,
                Value<DateTime?> alarmFiredAt = const Value.absent(),
                Value<DateTime?> wakeConfirmedAt = const Value.absent(),
                Value<String> result = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => MorningsCompanion.insert(
                id: id,
                date: date,
                planId: planId,
                scheduledAt: scheduledAt,
                alarmFiredAt: alarmFiredAt,
                wakeConfirmedAt: wakeConfirmedAt,
                result: result,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MorningsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                planId = false,
                promiseLogsRefs = false,
                preSleepLogsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (promiseLogsRefs) db.promiseLogs,
                    if (preSleepLogsRefs) db.preSleepLogs,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (planId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.planId,
                                    referencedTable: $$MorningsTableReferences
                                        ._planIdTable(db),
                                    referencedColumn: $$MorningsTableReferences
                                        ._planIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (promiseLogsRefs)
                        await $_getPrefetchedData<
                          MorningRow,
                          $MorningsTable,
                          PromiseLogRow
                        >(
                          currentTable: table,
                          referencedTable: $$MorningsTableReferences
                              ._promiseLogsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MorningsTableReferences(
                                db,
                                table,
                                p0,
                              ).promiseLogsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.morningId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (preSleepLogsRefs)
                        await $_getPrefetchedData<
                          MorningRow,
                          $MorningsTable,
                          PreSleepLogRow
                        >(
                          currentTable: table,
                          referencedTable: $$MorningsTableReferences
                              ._preSleepLogsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MorningsTableReferences(
                                db,
                                table,
                                p0,
                              ).preSleepLogsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.morningId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$MorningsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MorningsTable,
      MorningRow,
      $$MorningsTableFilterComposer,
      $$MorningsTableOrderingComposer,
      $$MorningsTableAnnotationComposer,
      $$MorningsTableCreateCompanionBuilder,
      $$MorningsTableUpdateCompanionBuilder,
      (MorningRow, $$MorningsTableReferences),
      MorningRow,
      PrefetchHooks Function({
        bool planId,
        bool promiseLogsRefs,
        bool preSleepLogsRefs,
      })
    >;
typedef $$PromiseLogsTableCreateCompanionBuilder =
    PromiseLogsCompanion Function({
      required String id,
      required String morningId,
      required String promiseId,
      Value<String> status,
      Value<DateTime?> startedAt,
      Value<DateTime?> completedAt,
      required int plannedSec,
      Value<bool> endedEarly,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$PromiseLogsTableUpdateCompanionBuilder =
    PromiseLogsCompanion Function({
      Value<String> id,
      Value<String> morningId,
      Value<String> promiseId,
      Value<String> status,
      Value<DateTime?> startedAt,
      Value<DateTime?> completedAt,
      Value<int> plannedSec,
      Value<bool> endedEarly,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$PromiseLogsTableReferences
    extends BaseReferences<_$AppDatabase, $PromiseLogsTable, PromiseLogRow> {
  $$PromiseLogsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MorningsTable _morningIdTable(_$AppDatabase db) =>
      db.mornings.createAlias('promise_logs__morning_id__mornings__id');

  $$MorningsTableProcessedTableManager get morningId {
    final $_column = $_itemColumn<String>('morning_id')!;

    final manager = $$MorningsTableTableManager(
      $_db,
      $_db.mornings,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_morningIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $PromisesTable _promiseIdTable(_$AppDatabase db) =>
      db.promises.createAlias('promise_logs__promise_id__promises__id');

  $$PromisesTableProcessedTableManager get promiseId {
    final $_column = $_itemColumn<String>('promise_id')!;

    final manager = $$PromisesTableTableManager(
      $_db,
      $_db.promises,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_promiseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PromiseLogsTableFilterComposer
    extends Composer<_$AppDatabase, $PromiseLogsTable> {
  $$PromiseLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get plannedSec => $composableBuilder(
    column: $table.plannedSec,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get endedEarly => $composableBuilder(
    column: $table.endedEarly,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$MorningsTableFilterComposer get morningId {
    final $$MorningsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.morningId,
      referencedTable: $db.mornings,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MorningsTableFilterComposer(
            $db: $db,
            $table: $db.mornings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PromisesTableFilterComposer get promiseId {
    final $$PromisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.promiseId,
      referencedTable: $db.promises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PromisesTableFilterComposer(
            $db: $db,
            $table: $db.promises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PromiseLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $PromiseLogsTable> {
  $$PromiseLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get plannedSec => $composableBuilder(
    column: $table.plannedSec,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get endedEarly => $composableBuilder(
    column: $table.endedEarly,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$MorningsTableOrderingComposer get morningId {
    final $$MorningsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.morningId,
      referencedTable: $db.mornings,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MorningsTableOrderingComposer(
            $db: $db,
            $table: $db.mornings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PromisesTableOrderingComposer get promiseId {
    final $$PromisesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.promiseId,
      referencedTable: $db.promises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PromisesTableOrderingComposer(
            $db: $db,
            $table: $db.promises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PromiseLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PromiseLogsTable> {
  $$PromiseLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get plannedSec => $composableBuilder(
    column: $table.plannedSec,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get endedEarly => $composableBuilder(
    column: $table.endedEarly,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$MorningsTableAnnotationComposer get morningId {
    final $$MorningsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.morningId,
      referencedTable: $db.mornings,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MorningsTableAnnotationComposer(
            $db: $db,
            $table: $db.mornings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PromisesTableAnnotationComposer get promiseId {
    final $$PromisesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.promiseId,
      referencedTable: $db.promises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PromisesTableAnnotationComposer(
            $db: $db,
            $table: $db.promises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PromiseLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PromiseLogsTable,
          PromiseLogRow,
          $$PromiseLogsTableFilterComposer,
          $$PromiseLogsTableOrderingComposer,
          $$PromiseLogsTableAnnotationComposer,
          $$PromiseLogsTableCreateCompanionBuilder,
          $$PromiseLogsTableUpdateCompanionBuilder,
          (PromiseLogRow, $$PromiseLogsTableReferences),
          PromiseLogRow,
          PrefetchHooks Function({bool morningId, bool promiseId})
        > {
  $$PromiseLogsTableTableManager(_$AppDatabase db, $PromiseLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PromiseLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PromiseLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PromiseLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> morningId = const Value.absent(),
                Value<String> promiseId = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime?> startedAt = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<int> plannedSec = const Value.absent(),
                Value<bool> endedEarly = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PromiseLogsCompanion(
                id: id,
                morningId: morningId,
                promiseId: promiseId,
                status: status,
                startedAt: startedAt,
                completedAt: completedAt,
                plannedSec: plannedSec,
                endedEarly: endedEarly,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String morningId,
                required String promiseId,
                Value<String> status = const Value.absent(),
                Value<DateTime?> startedAt = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                required int plannedSec,
                Value<bool> endedEarly = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => PromiseLogsCompanion.insert(
                id: id,
                morningId: morningId,
                promiseId: promiseId,
                status: status,
                startedAt: startedAt,
                completedAt: completedAt,
                plannedSec: plannedSec,
                endedEarly: endedEarly,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PromiseLogsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({morningId = false, promiseId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (morningId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.morningId,
                                referencedTable: $$PromiseLogsTableReferences
                                    ._morningIdTable(db),
                                referencedColumn: $$PromiseLogsTableReferences
                                    ._morningIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (promiseId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.promiseId,
                                referencedTable: $$PromiseLogsTableReferences
                                    ._promiseIdTable(db),
                                referencedColumn: $$PromiseLogsTableReferences
                                    ._promiseIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PromiseLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PromiseLogsTable,
      PromiseLogRow,
      $$PromiseLogsTableFilterComposer,
      $$PromiseLogsTableOrderingComposer,
      $$PromiseLogsTableAnnotationComposer,
      $$PromiseLogsTableCreateCompanionBuilder,
      $$PromiseLogsTableUpdateCompanionBuilder,
      (PromiseLogRow, $$PromiseLogsTableReferences),
      PromiseLogRow,
      PrefetchHooks Function({bool morningId, bool promiseId})
    >;
typedef $$PreSleepLogsTableCreateCompanionBuilder =
    PreSleepLogsCompanion Function({
      required String id,
      required String morningId,
      required String itemId,
      Value<bool> checked,
      Value<DateTime?> checkedAt,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$PreSleepLogsTableUpdateCompanionBuilder =
    PreSleepLogsCompanion Function({
      Value<String> id,
      Value<String> morningId,
      Value<String> itemId,
      Value<bool> checked,
      Value<DateTime?> checkedAt,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$PreSleepLogsTableReferences
    extends BaseReferences<_$AppDatabase, $PreSleepLogsTable, PreSleepLogRow> {
  $$PreSleepLogsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MorningsTable _morningIdTable(_$AppDatabase db) =>
      db.mornings.createAlias('pre_sleep_logs__morning_id__mornings__id');

  $$MorningsTableProcessedTableManager get morningId {
    final $_column = $_itemColumn<String>('morning_id')!;

    final manager = $$MorningsTableTableManager(
      $_db,
      $_db.mornings,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_morningIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $PreSleepItemsTable _itemIdTable(_$AppDatabase db) => db.preSleepItems
      .createAlias('pre_sleep_logs__item_id__pre_sleep_items__id');

  $$PreSleepItemsTableProcessedTableManager get itemId {
    final $_column = $_itemColumn<String>('item_id')!;

    final manager = $$PreSleepItemsTableTableManager(
      $_db,
      $_db.preSleepItems,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_itemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PreSleepLogsTableFilterComposer
    extends Composer<_$AppDatabase, $PreSleepLogsTable> {
  $$PreSleepLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get checked => $composableBuilder(
    column: $table.checked,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get checkedAt => $composableBuilder(
    column: $table.checkedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$MorningsTableFilterComposer get morningId {
    final $$MorningsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.morningId,
      referencedTable: $db.mornings,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MorningsTableFilterComposer(
            $db: $db,
            $table: $db.mornings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PreSleepItemsTableFilterComposer get itemId {
    final $$PreSleepItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: $db.preSleepItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PreSleepItemsTableFilterComposer(
            $db: $db,
            $table: $db.preSleepItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PreSleepLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $PreSleepLogsTable> {
  $$PreSleepLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get checked => $composableBuilder(
    column: $table.checked,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get checkedAt => $composableBuilder(
    column: $table.checkedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$MorningsTableOrderingComposer get morningId {
    final $$MorningsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.morningId,
      referencedTable: $db.mornings,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MorningsTableOrderingComposer(
            $db: $db,
            $table: $db.mornings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PreSleepItemsTableOrderingComposer get itemId {
    final $$PreSleepItemsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: $db.preSleepItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PreSleepItemsTableOrderingComposer(
            $db: $db,
            $table: $db.preSleepItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PreSleepLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PreSleepLogsTable> {
  $$PreSleepLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<bool> get checked =>
      $composableBuilder(column: $table.checked, builder: (column) => column);

  GeneratedColumn<DateTime> get checkedAt =>
      $composableBuilder(column: $table.checkedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$MorningsTableAnnotationComposer get morningId {
    final $$MorningsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.morningId,
      referencedTable: $db.mornings,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MorningsTableAnnotationComposer(
            $db: $db,
            $table: $db.mornings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PreSleepItemsTableAnnotationComposer get itemId {
    final $$PreSleepItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: $db.preSleepItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PreSleepItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.preSleepItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PreSleepLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PreSleepLogsTable,
          PreSleepLogRow,
          $$PreSleepLogsTableFilterComposer,
          $$PreSleepLogsTableOrderingComposer,
          $$PreSleepLogsTableAnnotationComposer,
          $$PreSleepLogsTableCreateCompanionBuilder,
          $$PreSleepLogsTableUpdateCompanionBuilder,
          (PreSleepLogRow, $$PreSleepLogsTableReferences),
          PreSleepLogRow,
          PrefetchHooks Function({bool morningId, bool itemId})
        > {
  $$PreSleepLogsTableTableManager(_$AppDatabase db, $PreSleepLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PreSleepLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PreSleepLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PreSleepLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> morningId = const Value.absent(),
                Value<String> itemId = const Value.absent(),
                Value<bool> checked = const Value.absent(),
                Value<DateTime?> checkedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PreSleepLogsCompanion(
                id: id,
                morningId: morningId,
                itemId: itemId,
                checked: checked,
                checkedAt: checkedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String morningId,
                required String itemId,
                Value<bool> checked = const Value.absent(),
                Value<DateTime?> checkedAt = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => PreSleepLogsCompanion.insert(
                id: id,
                morningId: morningId,
                itemId: itemId,
                checked: checked,
                checkedAt: checkedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PreSleepLogsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({morningId = false, itemId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (morningId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.morningId,
                                referencedTable: $$PreSleepLogsTableReferences
                                    ._morningIdTable(db),
                                referencedColumn: $$PreSleepLogsTableReferences
                                    ._morningIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (itemId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.itemId,
                                referencedTable: $$PreSleepLogsTableReferences
                                    ._itemIdTable(db),
                                referencedColumn: $$PreSleepLogsTableReferences
                                    ._itemIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PreSleepLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PreSleepLogsTable,
      PreSleepLogRow,
      $$PreSleepLogsTableFilterComposer,
      $$PreSleepLogsTableOrderingComposer,
      $$PreSleepLogsTableAnnotationComposer,
      $$PreSleepLogsTableCreateCompanionBuilder,
      $$PreSleepLogsTableUpdateCompanionBuilder,
      (PreSleepLogRow, $$PreSleepLogsTableReferences),
      PreSleepLogRow,
      PrefetchHooks Function({bool morningId, bool itemId})
    >;
typedef $$SettingsTableCreateCompanionBuilder =
    SettingsCompanion Function({
      required String id,
      Value<int> bedtimeLeadMinutes,
      Value<String> language,
      Value<bool?> reduceMotionOverride,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$SettingsTableUpdateCompanionBuilder =
    SettingsCompanion Function({
      Value<String> id,
      Value<int> bedtimeLeadMinutes,
      Value<String> language,
      Value<bool?> reduceMotionOverride,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$SettingsTableFilterComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get bedtimeLeadMinutes => $composableBuilder(
    column: $table.bedtimeLeadMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get reduceMotionOverride => $composableBuilder(
    column: $table.reduceMotionOverride,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get bedtimeLeadMinutes => $composableBuilder(
    column: $table.bedtimeLeadMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get reduceMotionOverride => $composableBuilder(
    column: $table.reduceMotionOverride,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get bedtimeLeadMinutes => $composableBuilder(
    column: $table.bedtimeLeadMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get language =>
      $composableBuilder(column: $table.language, builder: (column) => column);

  GeneratedColumn<bool> get reduceMotionOverride => $composableBuilder(
    column: $table.reduceMotionOverride,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$SettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SettingsTable,
          SettingsRow,
          $$SettingsTableFilterComposer,
          $$SettingsTableOrderingComposer,
          $$SettingsTableAnnotationComposer,
          $$SettingsTableCreateCompanionBuilder,
          $$SettingsTableUpdateCompanionBuilder,
          (
            SettingsRow,
            BaseReferences<_$AppDatabase, $SettingsTable, SettingsRow>,
          ),
          SettingsRow,
          PrefetchHooks Function()
        > {
  $$SettingsTableTableManager(_$AppDatabase db, $SettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> bedtimeLeadMinutes = const Value.absent(),
                Value<String> language = const Value.absent(),
                Value<bool?> reduceMotionOverride = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SettingsCompanion(
                id: id,
                bedtimeLeadMinutes: bedtimeLeadMinutes,
                language: language,
                reduceMotionOverride: reduceMotionOverride,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<int> bedtimeLeadMinutes = const Value.absent(),
                Value<String> language = const Value.absent(),
                Value<bool?> reduceMotionOverride = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => SettingsCompanion.insert(
                id: id,
                bedtimeLeadMinutes: bedtimeLeadMinutes,
                language: language,
                reduceMotionOverride: reduceMotionOverride,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SettingsTable,
      SettingsRow,
      $$SettingsTableFilterComposer,
      $$SettingsTableOrderingComposer,
      $$SettingsTableAnnotationComposer,
      $$SettingsTableCreateCompanionBuilder,
      $$SettingsTableUpdateCompanionBuilder,
      (SettingsRow, BaseReferences<_$AppDatabase, $SettingsTable, SettingsRow>),
      SettingsRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PlansTableTableManager get plans =>
      $$PlansTableTableManager(_db, _db.plans);
  $$PreSleepItemsTableTableManager get preSleepItems =>
      $$PreSleepItemsTableTableManager(_db, _db.preSleepItems);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db, _db.categories);
  $$PromisesTableTableManager get promises =>
      $$PromisesTableTableManager(_db, _db.promises);
  $$MorningsTableTableManager get mornings =>
      $$MorningsTableTableManager(_db, _db.mornings);
  $$PromiseLogsTableTableManager get promiseLogs =>
      $$PromiseLogsTableTableManager(_db, _db.promiseLogs);
  $$PreSleepLogsTableTableManager get preSleepLogs =>
      $$PreSleepLogsTableTableManager(_db, _db.preSleepLogs);
  $$SettingsTableTableManager get settings =>
      $$SettingsTableTableManager(_db, _db.settings);
}
