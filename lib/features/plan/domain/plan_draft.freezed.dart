// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'plan_draft.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PlanDraftState {

 int get bedMinute;// 21:00
 int get wakeMinute;// 04:00
 List<ChecklistItemDraft> get checklist; List<PromiseDraft> get promises; String get whyText;
/// Create a copy of PlanDraftState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlanDraftStateCopyWith<PlanDraftState> get copyWith => _$PlanDraftStateCopyWithImpl<PlanDraftState>(this as PlanDraftState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlanDraftState&&(identical(other.bedMinute, bedMinute) || other.bedMinute == bedMinute)&&(identical(other.wakeMinute, wakeMinute) || other.wakeMinute == wakeMinute)&&const DeepCollectionEquality().equals(other.checklist, checklist)&&const DeepCollectionEquality().equals(other.promises, promises)&&(identical(other.whyText, whyText) || other.whyText == whyText));
}


@override
int get hashCode => Object.hash(runtimeType,bedMinute,wakeMinute,const DeepCollectionEquality().hash(checklist),const DeepCollectionEquality().hash(promises),whyText);

@override
String toString() {
  return 'PlanDraftState(bedMinute: $bedMinute, wakeMinute: $wakeMinute, checklist: $checklist, promises: $promises, whyText: $whyText)';
}


}

/// @nodoc
abstract mixin class $PlanDraftStateCopyWith<$Res>  {
  factory $PlanDraftStateCopyWith(PlanDraftState value, $Res Function(PlanDraftState) _then) = _$PlanDraftStateCopyWithImpl;
@useResult
$Res call({
 int bedMinute, int wakeMinute, List<ChecklistItemDraft> checklist, List<PromiseDraft> promises, String whyText
});




}
/// @nodoc
class _$PlanDraftStateCopyWithImpl<$Res>
    implements $PlanDraftStateCopyWith<$Res> {
  _$PlanDraftStateCopyWithImpl(this._self, this._then);

  final PlanDraftState _self;
  final $Res Function(PlanDraftState) _then;

/// Create a copy of PlanDraftState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? bedMinute = null,Object? wakeMinute = null,Object? checklist = null,Object? promises = null,Object? whyText = null,}) {
  return _then(_self.copyWith(
bedMinute: null == bedMinute ? _self.bedMinute : bedMinute // ignore: cast_nullable_to_non_nullable
as int,wakeMinute: null == wakeMinute ? _self.wakeMinute : wakeMinute // ignore: cast_nullable_to_non_nullable
as int,checklist: null == checklist ? _self.checklist : checklist // ignore: cast_nullable_to_non_nullable
as List<ChecklistItemDraft>,promises: null == promises ? _self.promises : promises // ignore: cast_nullable_to_non_nullable
as List<PromiseDraft>,whyText: null == whyText ? _self.whyText : whyText // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PlanDraftState].
extension PlanDraftStatePatterns on PlanDraftState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlanDraftState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlanDraftState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlanDraftState value)  $default,){
final _that = this;
switch (_that) {
case _PlanDraftState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlanDraftState value)?  $default,){
final _that = this;
switch (_that) {
case _PlanDraftState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int bedMinute,  int wakeMinute,  List<ChecklistItemDraft> checklist,  List<PromiseDraft> promises,  String whyText)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlanDraftState() when $default != null:
return $default(_that.bedMinute,_that.wakeMinute,_that.checklist,_that.promises,_that.whyText);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int bedMinute,  int wakeMinute,  List<ChecklistItemDraft> checklist,  List<PromiseDraft> promises,  String whyText)  $default,) {final _that = this;
switch (_that) {
case _PlanDraftState():
return $default(_that.bedMinute,_that.wakeMinute,_that.checklist,_that.promises,_that.whyText);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int bedMinute,  int wakeMinute,  List<ChecklistItemDraft> checklist,  List<PromiseDraft> promises,  String whyText)?  $default,) {final _that = this;
switch (_that) {
case _PlanDraftState() when $default != null:
return $default(_that.bedMinute,_that.wakeMinute,_that.checklist,_that.promises,_that.whyText);case _:
  return null;

}
}

}

/// @nodoc


class _PlanDraftState implements PlanDraftState {
  const _PlanDraftState({this.bedMinute = 21 * 60, this.wakeMinute = 4 * 60, final  List<ChecklistItemDraft> checklist = const <ChecklistItemDraft>[], final  List<PromiseDraft> promises = const <PromiseDraft>[], this.whyText = ''}): _checklist = checklist,_promises = promises;
  

@override@JsonKey() final  int bedMinute;
// 21:00
@override@JsonKey() final  int wakeMinute;
// 04:00
 final  List<ChecklistItemDraft> _checklist;
// 04:00
@override@JsonKey() List<ChecklistItemDraft> get checklist {
  if (_checklist is EqualUnmodifiableListView) return _checklist;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_checklist);
}

 final  List<PromiseDraft> _promises;
@override@JsonKey() List<PromiseDraft> get promises {
  if (_promises is EqualUnmodifiableListView) return _promises;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_promises);
}

@override@JsonKey() final  String whyText;

/// Create a copy of PlanDraftState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlanDraftStateCopyWith<_PlanDraftState> get copyWith => __$PlanDraftStateCopyWithImpl<_PlanDraftState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlanDraftState&&(identical(other.bedMinute, bedMinute) || other.bedMinute == bedMinute)&&(identical(other.wakeMinute, wakeMinute) || other.wakeMinute == wakeMinute)&&const DeepCollectionEquality().equals(other._checklist, _checklist)&&const DeepCollectionEquality().equals(other._promises, _promises)&&(identical(other.whyText, whyText) || other.whyText == whyText));
}


@override
int get hashCode => Object.hash(runtimeType,bedMinute,wakeMinute,const DeepCollectionEquality().hash(_checklist),const DeepCollectionEquality().hash(_promises),whyText);

@override
String toString() {
  return 'PlanDraftState(bedMinute: $bedMinute, wakeMinute: $wakeMinute, checklist: $checklist, promises: $promises, whyText: $whyText)';
}


}

/// @nodoc
abstract mixin class _$PlanDraftStateCopyWith<$Res> implements $PlanDraftStateCopyWith<$Res> {
  factory _$PlanDraftStateCopyWith(_PlanDraftState value, $Res Function(_PlanDraftState) _then) = __$PlanDraftStateCopyWithImpl;
@override @useResult
$Res call({
 int bedMinute, int wakeMinute, List<ChecklistItemDraft> checklist, List<PromiseDraft> promises, String whyText
});




}
/// @nodoc
class __$PlanDraftStateCopyWithImpl<$Res>
    implements _$PlanDraftStateCopyWith<$Res> {
  __$PlanDraftStateCopyWithImpl(this._self, this._then);

  final _PlanDraftState _self;
  final $Res Function(_PlanDraftState) _then;

/// Create a copy of PlanDraftState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? bedMinute = null,Object? wakeMinute = null,Object? checklist = null,Object? promises = null,Object? whyText = null,}) {
  return _then(_PlanDraftState(
bedMinute: null == bedMinute ? _self.bedMinute : bedMinute // ignore: cast_nullable_to_non_nullable
as int,wakeMinute: null == wakeMinute ? _self.wakeMinute : wakeMinute // ignore: cast_nullable_to_non_nullable
as int,checklist: null == checklist ? _self._checklist : checklist // ignore: cast_nullable_to_non_nullable
as List<ChecklistItemDraft>,promises: null == promises ? _self._promises : promises // ignore: cast_nullable_to_non_nullable
as List<PromiseDraft>,whyText: null == whyText ? _self.whyText : whyText // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$ChecklistItemDraft {

 String get id; String get title;
/// Create a copy of ChecklistItemDraft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChecklistItemDraftCopyWith<ChecklistItemDraft> get copyWith => _$ChecklistItemDraftCopyWithImpl<ChecklistItemDraft>(this as ChecklistItemDraft, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChecklistItemDraft&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title));
}


@override
int get hashCode => Object.hash(runtimeType,id,title);

@override
String toString() {
  return 'ChecklistItemDraft(id: $id, title: $title)';
}


}

/// @nodoc
abstract mixin class $ChecklistItemDraftCopyWith<$Res>  {
  factory $ChecklistItemDraftCopyWith(ChecklistItemDraft value, $Res Function(ChecklistItemDraft) _then) = _$ChecklistItemDraftCopyWithImpl;
@useResult
$Res call({
 String id, String title
});




}
/// @nodoc
class _$ChecklistItemDraftCopyWithImpl<$Res>
    implements $ChecklistItemDraftCopyWith<$Res> {
  _$ChecklistItemDraftCopyWithImpl(this._self, this._then);

  final ChecklistItemDraft _self;
  final $Res Function(ChecklistItemDraft) _then;

/// Create a copy of ChecklistItemDraft
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ChecklistItemDraft].
extension ChecklistItemDraftPatterns on ChecklistItemDraft {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChecklistItemDraft value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChecklistItemDraft() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChecklistItemDraft value)  $default,){
final _that = this;
switch (_that) {
case _ChecklistItemDraft():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChecklistItemDraft value)?  $default,){
final _that = this;
switch (_that) {
case _ChecklistItemDraft() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChecklistItemDraft() when $default != null:
return $default(_that.id,_that.title);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title)  $default,) {final _that = this;
switch (_that) {
case _ChecklistItemDraft():
return $default(_that.id,_that.title);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title)?  $default,) {final _that = this;
switch (_that) {
case _ChecklistItemDraft() when $default != null:
return $default(_that.id,_that.title);case _:
  return null;

}
}

}

/// @nodoc


class _ChecklistItemDraft implements ChecklistItemDraft {
  const _ChecklistItemDraft({required this.id, required this.title});
  

@override final  String id;
@override final  String title;

/// Create a copy of ChecklistItemDraft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChecklistItemDraftCopyWith<_ChecklistItemDraft> get copyWith => __$ChecklistItemDraftCopyWithImpl<_ChecklistItemDraft>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChecklistItemDraft&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title));
}


@override
int get hashCode => Object.hash(runtimeType,id,title);

@override
String toString() {
  return 'ChecklistItemDraft(id: $id, title: $title)';
}


}

/// @nodoc
abstract mixin class _$ChecklistItemDraftCopyWith<$Res> implements $ChecklistItemDraftCopyWith<$Res> {
  factory _$ChecklistItemDraftCopyWith(_ChecklistItemDraft value, $Res Function(_ChecklistItemDraft) _then) = __$ChecklistItemDraftCopyWithImpl;
@override @useResult
$Res call({
 String id, String title
});




}
/// @nodoc
class __$ChecklistItemDraftCopyWithImpl<$Res>
    implements _$ChecklistItemDraftCopyWith<$Res> {
  __$ChecklistItemDraftCopyWithImpl(this._self, this._then);

  final _ChecklistItemDraft _self;
  final $Res Function(_ChecklistItemDraft) _then;

/// Create a copy of ChecklistItemDraft
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,}) {
  return _then(_ChecklistItemDraft(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$PromiseDraft {

 String get id; String get categoryId; String get title; String? get description; int get durationMin;
/// Create a copy of PromiseDraft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PromiseDraftCopyWith<PromiseDraft> get copyWith => _$PromiseDraftCopyWithImpl<PromiseDraft>(this as PromiseDraft, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PromiseDraft&&(identical(other.id, id) || other.id == id)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.durationMin, durationMin) || other.durationMin == durationMin));
}


@override
int get hashCode => Object.hash(runtimeType,id,categoryId,title,description,durationMin);

@override
String toString() {
  return 'PromiseDraft(id: $id, categoryId: $categoryId, title: $title, description: $description, durationMin: $durationMin)';
}


}

/// @nodoc
abstract mixin class $PromiseDraftCopyWith<$Res>  {
  factory $PromiseDraftCopyWith(PromiseDraft value, $Res Function(PromiseDraft) _then) = _$PromiseDraftCopyWithImpl;
@useResult
$Res call({
 String id, String categoryId, String title, String? description, int durationMin
});




}
/// @nodoc
class _$PromiseDraftCopyWithImpl<$Res>
    implements $PromiseDraftCopyWith<$Res> {
  _$PromiseDraftCopyWithImpl(this._self, this._then);

  final PromiseDraft _self;
  final $Res Function(PromiseDraft) _then;

/// Create a copy of PromiseDraft
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? categoryId = null,Object? title = null,Object? description = freezed,Object? durationMin = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,durationMin: null == durationMin ? _self.durationMin : durationMin // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PromiseDraft].
extension PromiseDraftPatterns on PromiseDraft {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PromiseDraft value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PromiseDraft() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PromiseDraft value)  $default,){
final _that = this;
switch (_that) {
case _PromiseDraft():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PromiseDraft value)?  $default,){
final _that = this;
switch (_that) {
case _PromiseDraft() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String categoryId,  String title,  String? description,  int durationMin)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PromiseDraft() when $default != null:
return $default(_that.id,_that.categoryId,_that.title,_that.description,_that.durationMin);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String categoryId,  String title,  String? description,  int durationMin)  $default,) {final _that = this;
switch (_that) {
case _PromiseDraft():
return $default(_that.id,_that.categoryId,_that.title,_that.description,_that.durationMin);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String categoryId,  String title,  String? description,  int durationMin)?  $default,) {final _that = this;
switch (_that) {
case _PromiseDraft() when $default != null:
return $default(_that.id,_that.categoryId,_that.title,_that.description,_that.durationMin);case _:
  return null;

}
}

}

/// @nodoc


class _PromiseDraft implements PromiseDraft {
  const _PromiseDraft({required this.id, required this.categoryId, required this.title, this.description, this.durationMin = 15});
  

@override final  String id;
@override final  String categoryId;
@override final  String title;
@override final  String? description;
@override@JsonKey() final  int durationMin;

/// Create a copy of PromiseDraft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PromiseDraftCopyWith<_PromiseDraft> get copyWith => __$PromiseDraftCopyWithImpl<_PromiseDraft>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PromiseDraft&&(identical(other.id, id) || other.id == id)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.durationMin, durationMin) || other.durationMin == durationMin));
}


@override
int get hashCode => Object.hash(runtimeType,id,categoryId,title,description,durationMin);

@override
String toString() {
  return 'PromiseDraft(id: $id, categoryId: $categoryId, title: $title, description: $description, durationMin: $durationMin)';
}


}

/// @nodoc
abstract mixin class _$PromiseDraftCopyWith<$Res> implements $PromiseDraftCopyWith<$Res> {
  factory _$PromiseDraftCopyWith(_PromiseDraft value, $Res Function(_PromiseDraft) _then) = __$PromiseDraftCopyWithImpl;
@override @useResult
$Res call({
 String id, String categoryId, String title, String? description, int durationMin
});




}
/// @nodoc
class __$PromiseDraftCopyWithImpl<$Res>
    implements _$PromiseDraftCopyWith<$Res> {
  __$PromiseDraftCopyWithImpl(this._self, this._then);

  final _PromiseDraft _self;
  final $Res Function(_PromiseDraft) _then;

/// Create a copy of PromiseDraft
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? categoryId = null,Object? title = null,Object? description = freezed,Object? durationMin = null,}) {
  return _then(_PromiseDraft(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,durationMin: null == durationMin ? _self.durationMin : durationMin // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
