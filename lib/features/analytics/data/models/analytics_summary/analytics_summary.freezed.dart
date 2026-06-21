// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'analytics_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AnalyticsSummary {

@JsonKey(name: 'organization_id') int get organizationId;@JsonKey(name: 'branch_id') int get branchId;@JsonKey(name: 'worker_id') int? get workerId; AnalyticsPeriod get period; AnalyticsSummaryBlock get summary; List<AnalyticsOccupancyDay> get occupancy; AnalyticsComparison get comparison; AnalyticsGlobal get global; AnalyticsOverview? get overview; AnalyticsSpecialist? get specialist; AnalyticsBenchmarking? get benchmarking; AnalyticsMeta get meta;
/// Create a copy of AnalyticsSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AnalyticsSummaryCopyWith<AnalyticsSummary> get copyWith => _$AnalyticsSummaryCopyWithImpl<AnalyticsSummary>(this as AnalyticsSummary, _$identity);

  /// Serializes this AnalyticsSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnalyticsSummary&&(identical(other.organizationId, organizationId) || other.organizationId == organizationId)&&(identical(other.branchId, branchId) || other.branchId == branchId)&&(identical(other.workerId, workerId) || other.workerId == workerId)&&(identical(other.period, period) || other.period == period)&&(identical(other.summary, summary) || other.summary == summary)&&const DeepCollectionEquality().equals(other.occupancy, occupancy)&&(identical(other.comparison, comparison) || other.comparison == comparison)&&(identical(other.global, global) || other.global == global)&&(identical(other.overview, overview) || other.overview == overview)&&(identical(other.specialist, specialist) || other.specialist == specialist)&&(identical(other.benchmarking, benchmarking) || other.benchmarking == benchmarking)&&(identical(other.meta, meta) || other.meta == meta));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,organizationId,branchId,workerId,period,summary,const DeepCollectionEquality().hash(occupancy),comparison,global,overview,specialist,benchmarking,meta);

@override
String toString() {
  return 'AnalyticsSummary(organizationId: $organizationId, branchId: $branchId, workerId: $workerId, period: $period, summary: $summary, occupancy: $occupancy, comparison: $comparison, global: $global, overview: $overview, specialist: $specialist, benchmarking: $benchmarking, meta: $meta)';
}


}

/// @nodoc
abstract mixin class $AnalyticsSummaryCopyWith<$Res>  {
  factory $AnalyticsSummaryCopyWith(AnalyticsSummary value, $Res Function(AnalyticsSummary) _then) = _$AnalyticsSummaryCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'organization_id') int organizationId,@JsonKey(name: 'branch_id') int branchId,@JsonKey(name: 'worker_id') int? workerId, AnalyticsPeriod period, AnalyticsSummaryBlock summary, List<AnalyticsOccupancyDay> occupancy, AnalyticsComparison comparison, AnalyticsGlobal global, AnalyticsOverview? overview, AnalyticsSpecialist? specialist, AnalyticsBenchmarking? benchmarking, AnalyticsMeta meta
});


$AnalyticsPeriodCopyWith<$Res> get period;$AnalyticsSummaryBlockCopyWith<$Res> get summary;$AnalyticsComparisonCopyWith<$Res> get comparison;$AnalyticsGlobalCopyWith<$Res> get global;$AnalyticsOverviewCopyWith<$Res>? get overview;$AnalyticsSpecialistCopyWith<$Res>? get specialist;$AnalyticsBenchmarkingCopyWith<$Res>? get benchmarking;$AnalyticsMetaCopyWith<$Res> get meta;

}
/// @nodoc
class _$AnalyticsSummaryCopyWithImpl<$Res>
    implements $AnalyticsSummaryCopyWith<$Res> {
  _$AnalyticsSummaryCopyWithImpl(this._self, this._then);

  final AnalyticsSummary _self;
  final $Res Function(AnalyticsSummary) _then;

/// Create a copy of AnalyticsSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? organizationId = null,Object? branchId = null,Object? workerId = freezed,Object? period = null,Object? summary = null,Object? occupancy = null,Object? comparison = null,Object? global = null,Object? overview = freezed,Object? specialist = freezed,Object? benchmarking = freezed,Object? meta = null,}) {
  return _then(_self.copyWith(
organizationId: null == organizationId ? _self.organizationId : organizationId // ignore: cast_nullable_to_non_nullable
as int,branchId: null == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as int,workerId: freezed == workerId ? _self.workerId : workerId // ignore: cast_nullable_to_non_nullable
as int?,period: null == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as AnalyticsPeriod,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as AnalyticsSummaryBlock,occupancy: null == occupancy ? _self.occupancy : occupancy // ignore: cast_nullable_to_non_nullable
as List<AnalyticsOccupancyDay>,comparison: null == comparison ? _self.comparison : comparison // ignore: cast_nullable_to_non_nullable
as AnalyticsComparison,global: null == global ? _self.global : global // ignore: cast_nullable_to_non_nullable
as AnalyticsGlobal,overview: freezed == overview ? _self.overview : overview // ignore: cast_nullable_to_non_nullable
as AnalyticsOverview?,specialist: freezed == specialist ? _self.specialist : specialist // ignore: cast_nullable_to_non_nullable
as AnalyticsSpecialist?,benchmarking: freezed == benchmarking ? _self.benchmarking : benchmarking // ignore: cast_nullable_to_non_nullable
as AnalyticsBenchmarking?,meta: null == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as AnalyticsMeta,
  ));
}
/// Create a copy of AnalyticsSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AnalyticsPeriodCopyWith<$Res> get period {
  
  return $AnalyticsPeriodCopyWith<$Res>(_self.period, (value) {
    return _then(_self.copyWith(period: value));
  });
}/// Create a copy of AnalyticsSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AnalyticsSummaryBlockCopyWith<$Res> get summary {
  
  return $AnalyticsSummaryBlockCopyWith<$Res>(_self.summary, (value) {
    return _then(_self.copyWith(summary: value));
  });
}/// Create a copy of AnalyticsSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AnalyticsComparisonCopyWith<$Res> get comparison {
  
  return $AnalyticsComparisonCopyWith<$Res>(_self.comparison, (value) {
    return _then(_self.copyWith(comparison: value));
  });
}/// Create a copy of AnalyticsSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AnalyticsGlobalCopyWith<$Res> get global {
  
  return $AnalyticsGlobalCopyWith<$Res>(_self.global, (value) {
    return _then(_self.copyWith(global: value));
  });
}/// Create a copy of AnalyticsSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AnalyticsOverviewCopyWith<$Res>? get overview {
    if (_self.overview == null) {
    return null;
  }

  return $AnalyticsOverviewCopyWith<$Res>(_self.overview!, (value) {
    return _then(_self.copyWith(overview: value));
  });
}/// Create a copy of AnalyticsSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AnalyticsSpecialistCopyWith<$Res>? get specialist {
    if (_self.specialist == null) {
    return null;
  }

  return $AnalyticsSpecialistCopyWith<$Res>(_self.specialist!, (value) {
    return _then(_self.copyWith(specialist: value));
  });
}/// Create a copy of AnalyticsSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AnalyticsBenchmarkingCopyWith<$Res>? get benchmarking {
    if (_self.benchmarking == null) {
    return null;
  }

  return $AnalyticsBenchmarkingCopyWith<$Res>(_self.benchmarking!, (value) {
    return _then(_self.copyWith(benchmarking: value));
  });
}/// Create a copy of AnalyticsSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AnalyticsMetaCopyWith<$Res> get meta {
  
  return $AnalyticsMetaCopyWith<$Res>(_self.meta, (value) {
    return _then(_self.copyWith(meta: value));
  });
}
}


/// Adds pattern-matching-related methods to [AnalyticsSummary].
extension AnalyticsSummaryPatterns on AnalyticsSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AnalyticsSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AnalyticsSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AnalyticsSummary value)  $default,){
final _that = this;
switch (_that) {
case _AnalyticsSummary():
return $default(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AnalyticsSummary value)?  $default,){
final _that = this;
switch (_that) {
case _AnalyticsSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'organization_id')  int organizationId, @JsonKey(name: 'branch_id')  int branchId, @JsonKey(name: 'worker_id')  int? workerId,  AnalyticsPeriod period,  AnalyticsSummaryBlock summary,  List<AnalyticsOccupancyDay> occupancy,  AnalyticsComparison comparison,  AnalyticsGlobal global,  AnalyticsOverview? overview,  AnalyticsSpecialist? specialist,  AnalyticsBenchmarking? benchmarking,  AnalyticsMeta meta)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AnalyticsSummary() when $default != null:
return $default(_that.organizationId,_that.branchId,_that.workerId,_that.period,_that.summary,_that.occupancy,_that.comparison,_that.global,_that.overview,_that.specialist,_that.benchmarking,_that.meta);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'organization_id')  int organizationId, @JsonKey(name: 'branch_id')  int branchId, @JsonKey(name: 'worker_id')  int? workerId,  AnalyticsPeriod period,  AnalyticsSummaryBlock summary,  List<AnalyticsOccupancyDay> occupancy,  AnalyticsComparison comparison,  AnalyticsGlobal global,  AnalyticsOverview? overview,  AnalyticsSpecialist? specialist,  AnalyticsBenchmarking? benchmarking,  AnalyticsMeta meta)  $default,) {final _that = this;
switch (_that) {
case _AnalyticsSummary():
return $default(_that.organizationId,_that.branchId,_that.workerId,_that.period,_that.summary,_that.occupancy,_that.comparison,_that.global,_that.overview,_that.specialist,_that.benchmarking,_that.meta);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'organization_id')  int organizationId, @JsonKey(name: 'branch_id')  int branchId, @JsonKey(name: 'worker_id')  int? workerId,  AnalyticsPeriod period,  AnalyticsSummaryBlock summary,  List<AnalyticsOccupancyDay> occupancy,  AnalyticsComparison comparison,  AnalyticsGlobal global,  AnalyticsOverview? overview,  AnalyticsSpecialist? specialist,  AnalyticsBenchmarking? benchmarking,  AnalyticsMeta meta)?  $default,) {final _that = this;
switch (_that) {
case _AnalyticsSummary() when $default != null:
return $default(_that.organizationId,_that.branchId,_that.workerId,_that.period,_that.summary,_that.occupancy,_that.comparison,_that.global,_that.overview,_that.specialist,_that.benchmarking,_that.meta);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AnalyticsSummary implements AnalyticsSummary {
  const _AnalyticsSummary({@JsonKey(name: 'organization_id') required this.organizationId, @JsonKey(name: 'branch_id') required this.branchId, @JsonKey(name: 'worker_id') this.workerId, required this.period, required this.summary, final  List<AnalyticsOccupancyDay> occupancy = const [], required this.comparison, required this.global, this.overview, this.specialist, this.benchmarking, required this.meta}): _occupancy = occupancy;
  factory _AnalyticsSummary.fromJson(Map<String, dynamic> json) => _$AnalyticsSummaryFromJson(json);

@override@JsonKey(name: 'organization_id') final  int organizationId;
@override@JsonKey(name: 'branch_id') final  int branchId;
@override@JsonKey(name: 'worker_id') final  int? workerId;
@override final  AnalyticsPeriod period;
@override final  AnalyticsSummaryBlock summary;
 final  List<AnalyticsOccupancyDay> _occupancy;
@override@JsonKey() List<AnalyticsOccupancyDay> get occupancy {
  if (_occupancy is EqualUnmodifiableListView) return _occupancy;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_occupancy);
}

@override final  AnalyticsComparison comparison;
@override final  AnalyticsGlobal global;
@override final  AnalyticsOverview? overview;
@override final  AnalyticsSpecialist? specialist;
@override final  AnalyticsBenchmarking? benchmarking;
@override final  AnalyticsMeta meta;

/// Create a copy of AnalyticsSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AnalyticsSummaryCopyWith<_AnalyticsSummary> get copyWith => __$AnalyticsSummaryCopyWithImpl<_AnalyticsSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AnalyticsSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AnalyticsSummary&&(identical(other.organizationId, organizationId) || other.organizationId == organizationId)&&(identical(other.branchId, branchId) || other.branchId == branchId)&&(identical(other.workerId, workerId) || other.workerId == workerId)&&(identical(other.period, period) || other.period == period)&&(identical(other.summary, summary) || other.summary == summary)&&const DeepCollectionEquality().equals(other._occupancy, _occupancy)&&(identical(other.comparison, comparison) || other.comparison == comparison)&&(identical(other.global, global) || other.global == global)&&(identical(other.overview, overview) || other.overview == overview)&&(identical(other.specialist, specialist) || other.specialist == specialist)&&(identical(other.benchmarking, benchmarking) || other.benchmarking == benchmarking)&&(identical(other.meta, meta) || other.meta == meta));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,organizationId,branchId,workerId,period,summary,const DeepCollectionEquality().hash(_occupancy),comparison,global,overview,specialist,benchmarking,meta);

@override
String toString() {
  return 'AnalyticsSummary(organizationId: $organizationId, branchId: $branchId, workerId: $workerId, period: $period, summary: $summary, occupancy: $occupancy, comparison: $comparison, global: $global, overview: $overview, specialist: $specialist, benchmarking: $benchmarking, meta: $meta)';
}


}

/// @nodoc
abstract mixin class _$AnalyticsSummaryCopyWith<$Res> implements $AnalyticsSummaryCopyWith<$Res> {
  factory _$AnalyticsSummaryCopyWith(_AnalyticsSummary value, $Res Function(_AnalyticsSummary) _then) = __$AnalyticsSummaryCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'organization_id') int organizationId,@JsonKey(name: 'branch_id') int branchId,@JsonKey(name: 'worker_id') int? workerId, AnalyticsPeriod period, AnalyticsSummaryBlock summary, List<AnalyticsOccupancyDay> occupancy, AnalyticsComparison comparison, AnalyticsGlobal global, AnalyticsOverview? overview, AnalyticsSpecialist? specialist, AnalyticsBenchmarking? benchmarking, AnalyticsMeta meta
});


@override $AnalyticsPeriodCopyWith<$Res> get period;@override $AnalyticsSummaryBlockCopyWith<$Res> get summary;@override $AnalyticsComparisonCopyWith<$Res> get comparison;@override $AnalyticsGlobalCopyWith<$Res> get global;@override $AnalyticsOverviewCopyWith<$Res>? get overview;@override $AnalyticsSpecialistCopyWith<$Res>? get specialist;@override $AnalyticsBenchmarkingCopyWith<$Res>? get benchmarking;@override $AnalyticsMetaCopyWith<$Res> get meta;

}
/// @nodoc
class __$AnalyticsSummaryCopyWithImpl<$Res>
    implements _$AnalyticsSummaryCopyWith<$Res> {
  __$AnalyticsSummaryCopyWithImpl(this._self, this._then);

  final _AnalyticsSummary _self;
  final $Res Function(_AnalyticsSummary) _then;

/// Create a copy of AnalyticsSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? organizationId = null,Object? branchId = null,Object? workerId = freezed,Object? period = null,Object? summary = null,Object? occupancy = null,Object? comparison = null,Object? global = null,Object? overview = freezed,Object? specialist = freezed,Object? benchmarking = freezed,Object? meta = null,}) {
  return _then(_AnalyticsSummary(
organizationId: null == organizationId ? _self.organizationId : organizationId // ignore: cast_nullable_to_non_nullable
as int,branchId: null == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as int,workerId: freezed == workerId ? _self.workerId : workerId // ignore: cast_nullable_to_non_nullable
as int?,period: null == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as AnalyticsPeriod,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as AnalyticsSummaryBlock,occupancy: null == occupancy ? _self._occupancy : occupancy // ignore: cast_nullable_to_non_nullable
as List<AnalyticsOccupancyDay>,comparison: null == comparison ? _self.comparison : comparison // ignore: cast_nullable_to_non_nullable
as AnalyticsComparison,global: null == global ? _self.global : global // ignore: cast_nullable_to_non_nullable
as AnalyticsGlobal,overview: freezed == overview ? _self.overview : overview // ignore: cast_nullable_to_non_nullable
as AnalyticsOverview?,specialist: freezed == specialist ? _self.specialist : specialist // ignore: cast_nullable_to_non_nullable
as AnalyticsSpecialist?,benchmarking: freezed == benchmarking ? _self.benchmarking : benchmarking // ignore: cast_nullable_to_non_nullable
as AnalyticsBenchmarking?,meta: null == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as AnalyticsMeta,
  ));
}

/// Create a copy of AnalyticsSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AnalyticsPeriodCopyWith<$Res> get period {
  
  return $AnalyticsPeriodCopyWith<$Res>(_self.period, (value) {
    return _then(_self.copyWith(period: value));
  });
}/// Create a copy of AnalyticsSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AnalyticsSummaryBlockCopyWith<$Res> get summary {
  
  return $AnalyticsSummaryBlockCopyWith<$Res>(_self.summary, (value) {
    return _then(_self.copyWith(summary: value));
  });
}/// Create a copy of AnalyticsSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AnalyticsComparisonCopyWith<$Res> get comparison {
  
  return $AnalyticsComparisonCopyWith<$Res>(_self.comparison, (value) {
    return _then(_self.copyWith(comparison: value));
  });
}/// Create a copy of AnalyticsSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AnalyticsGlobalCopyWith<$Res> get global {
  
  return $AnalyticsGlobalCopyWith<$Res>(_self.global, (value) {
    return _then(_self.copyWith(global: value));
  });
}/// Create a copy of AnalyticsSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AnalyticsOverviewCopyWith<$Res>? get overview {
    if (_self.overview == null) {
    return null;
  }

  return $AnalyticsOverviewCopyWith<$Res>(_self.overview!, (value) {
    return _then(_self.copyWith(overview: value));
  });
}/// Create a copy of AnalyticsSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AnalyticsSpecialistCopyWith<$Res>? get specialist {
    if (_self.specialist == null) {
    return null;
  }

  return $AnalyticsSpecialistCopyWith<$Res>(_self.specialist!, (value) {
    return _then(_self.copyWith(specialist: value));
  });
}/// Create a copy of AnalyticsSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AnalyticsBenchmarkingCopyWith<$Res>? get benchmarking {
    if (_self.benchmarking == null) {
    return null;
  }

  return $AnalyticsBenchmarkingCopyWith<$Res>(_self.benchmarking!, (value) {
    return _then(_self.copyWith(benchmarking: value));
  });
}/// Create a copy of AnalyticsSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AnalyticsMetaCopyWith<$Res> get meta {
  
  return $AnalyticsMetaCopyWith<$Res>(_self.meta, (value) {
    return _then(_self.copyWith(meta: value));
  });
}
}


/// @nodoc
mixin _$AnalyticsPeriod {

@JsonKey(name: 'datetime__gte') String get datetimeGte;@JsonKey(name: 'datetime__lte') String get datetimeLte;
/// Create a copy of AnalyticsPeriod
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AnalyticsPeriodCopyWith<AnalyticsPeriod> get copyWith => _$AnalyticsPeriodCopyWithImpl<AnalyticsPeriod>(this as AnalyticsPeriod, _$identity);

  /// Serializes this AnalyticsPeriod to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnalyticsPeriod&&(identical(other.datetimeGte, datetimeGte) || other.datetimeGte == datetimeGte)&&(identical(other.datetimeLte, datetimeLte) || other.datetimeLte == datetimeLte));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,datetimeGte,datetimeLte);

@override
String toString() {
  return 'AnalyticsPeriod(datetimeGte: $datetimeGte, datetimeLte: $datetimeLte)';
}


}

/// @nodoc
abstract mixin class $AnalyticsPeriodCopyWith<$Res>  {
  factory $AnalyticsPeriodCopyWith(AnalyticsPeriod value, $Res Function(AnalyticsPeriod) _then) = _$AnalyticsPeriodCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'datetime__gte') String datetimeGte,@JsonKey(name: 'datetime__lte') String datetimeLte
});




}
/// @nodoc
class _$AnalyticsPeriodCopyWithImpl<$Res>
    implements $AnalyticsPeriodCopyWith<$Res> {
  _$AnalyticsPeriodCopyWithImpl(this._self, this._then);

  final AnalyticsPeriod _self;
  final $Res Function(AnalyticsPeriod) _then;

/// Create a copy of AnalyticsPeriod
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? datetimeGte = null,Object? datetimeLte = null,}) {
  return _then(_self.copyWith(
datetimeGte: null == datetimeGte ? _self.datetimeGte : datetimeGte // ignore: cast_nullable_to_non_nullable
as String,datetimeLte: null == datetimeLte ? _self.datetimeLte : datetimeLte // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AnalyticsPeriod].
extension AnalyticsPeriodPatterns on AnalyticsPeriod {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AnalyticsPeriod value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AnalyticsPeriod() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AnalyticsPeriod value)  $default,){
final _that = this;
switch (_that) {
case _AnalyticsPeriod():
return $default(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AnalyticsPeriod value)?  $default,){
final _that = this;
switch (_that) {
case _AnalyticsPeriod() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'datetime__gte')  String datetimeGte, @JsonKey(name: 'datetime__lte')  String datetimeLte)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AnalyticsPeriod() when $default != null:
return $default(_that.datetimeGte,_that.datetimeLte);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'datetime__gte')  String datetimeGte, @JsonKey(name: 'datetime__lte')  String datetimeLte)  $default,) {final _that = this;
switch (_that) {
case _AnalyticsPeriod():
return $default(_that.datetimeGte,_that.datetimeLte);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'datetime__gte')  String datetimeGte, @JsonKey(name: 'datetime__lte')  String datetimeLte)?  $default,) {final _that = this;
switch (_that) {
case _AnalyticsPeriod() when $default != null:
return $default(_that.datetimeGte,_that.datetimeLte);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AnalyticsPeriod implements AnalyticsPeriod {
  const _AnalyticsPeriod({@JsonKey(name: 'datetime__gte') required this.datetimeGte, @JsonKey(name: 'datetime__lte') required this.datetimeLte});
  factory _AnalyticsPeriod.fromJson(Map<String, dynamic> json) => _$AnalyticsPeriodFromJson(json);

@override@JsonKey(name: 'datetime__gte') final  String datetimeGte;
@override@JsonKey(name: 'datetime__lte') final  String datetimeLte;

/// Create a copy of AnalyticsPeriod
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AnalyticsPeriodCopyWith<_AnalyticsPeriod> get copyWith => __$AnalyticsPeriodCopyWithImpl<_AnalyticsPeriod>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AnalyticsPeriodToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AnalyticsPeriod&&(identical(other.datetimeGte, datetimeGte) || other.datetimeGte == datetimeGte)&&(identical(other.datetimeLte, datetimeLte) || other.datetimeLte == datetimeLte));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,datetimeGte,datetimeLte);

@override
String toString() {
  return 'AnalyticsPeriod(datetimeGte: $datetimeGte, datetimeLte: $datetimeLte)';
}


}

/// @nodoc
abstract mixin class _$AnalyticsPeriodCopyWith<$Res> implements $AnalyticsPeriodCopyWith<$Res> {
  factory _$AnalyticsPeriodCopyWith(_AnalyticsPeriod value, $Res Function(_AnalyticsPeriod) _then) = __$AnalyticsPeriodCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'datetime__gte') String datetimeGte,@JsonKey(name: 'datetime__lte') String datetimeLte
});




}
/// @nodoc
class __$AnalyticsPeriodCopyWithImpl<$Res>
    implements _$AnalyticsPeriodCopyWith<$Res> {
  __$AnalyticsPeriodCopyWithImpl(this._self, this._then);

  final _AnalyticsPeriod _self;
  final $Res Function(_AnalyticsPeriod) _then;

/// Create a copy of AnalyticsPeriod
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? datetimeGte = null,Object? datetimeLte = null,}) {
  return _then(_AnalyticsPeriod(
datetimeGte: null == datetimeGte ? _self.datetimeGte : datetimeGte // ignore: cast_nullable_to_non_nullable
as String,datetimeLte: null == datetimeLte ? _self.datetimeLte : datetimeLte // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$AnalyticsSummaryBlock {

 AnalyticsAppointments get appointments; double get occupancy;@JsonKey(name: 'occupancy_today') double? get occupancyToday;@JsonKey(name: 'occupancy_by_day') List<AnalyticsOccupancyDay> get occupancyByDay;@JsonKey(name: 'income_by_day') List<AnalyticsIncomeByDay> get incomeByDay;@JsonKey(name: 'upcoming_services_today') List<AnalyticsNamedCount> get upcomingServicesToday;@JsonKey(name: 'average_check_today') double? get averageCheckToday;@JsonKey(name: 'projected_income_today') double? get projectedIncomeToday;@JsonKey(name: 'factual_income_now') double? get factualIncomeNow;
/// Create a copy of AnalyticsSummaryBlock
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AnalyticsSummaryBlockCopyWith<AnalyticsSummaryBlock> get copyWith => _$AnalyticsSummaryBlockCopyWithImpl<AnalyticsSummaryBlock>(this as AnalyticsSummaryBlock, _$identity);

  /// Serializes this AnalyticsSummaryBlock to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnalyticsSummaryBlock&&(identical(other.appointments, appointments) || other.appointments == appointments)&&(identical(other.occupancy, occupancy) || other.occupancy == occupancy)&&(identical(other.occupancyToday, occupancyToday) || other.occupancyToday == occupancyToday)&&const DeepCollectionEquality().equals(other.occupancyByDay, occupancyByDay)&&const DeepCollectionEquality().equals(other.incomeByDay, incomeByDay)&&const DeepCollectionEquality().equals(other.upcomingServicesToday, upcomingServicesToday)&&(identical(other.averageCheckToday, averageCheckToday) || other.averageCheckToday == averageCheckToday)&&(identical(other.projectedIncomeToday, projectedIncomeToday) || other.projectedIncomeToday == projectedIncomeToday)&&(identical(other.factualIncomeNow, factualIncomeNow) || other.factualIncomeNow == factualIncomeNow));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,appointments,occupancy,occupancyToday,const DeepCollectionEquality().hash(occupancyByDay),const DeepCollectionEquality().hash(incomeByDay),const DeepCollectionEquality().hash(upcomingServicesToday),averageCheckToday,projectedIncomeToday,factualIncomeNow);

@override
String toString() {
  return 'AnalyticsSummaryBlock(appointments: $appointments, occupancy: $occupancy, occupancyToday: $occupancyToday, occupancyByDay: $occupancyByDay, incomeByDay: $incomeByDay, upcomingServicesToday: $upcomingServicesToday, averageCheckToday: $averageCheckToday, projectedIncomeToday: $projectedIncomeToday, factualIncomeNow: $factualIncomeNow)';
}


}

/// @nodoc
abstract mixin class $AnalyticsSummaryBlockCopyWith<$Res>  {
  factory $AnalyticsSummaryBlockCopyWith(AnalyticsSummaryBlock value, $Res Function(AnalyticsSummaryBlock) _then) = _$AnalyticsSummaryBlockCopyWithImpl;
@useResult
$Res call({
 AnalyticsAppointments appointments, double occupancy,@JsonKey(name: 'occupancy_today') double? occupancyToday,@JsonKey(name: 'occupancy_by_day') List<AnalyticsOccupancyDay> occupancyByDay,@JsonKey(name: 'income_by_day') List<AnalyticsIncomeByDay> incomeByDay,@JsonKey(name: 'upcoming_services_today') List<AnalyticsNamedCount> upcomingServicesToday,@JsonKey(name: 'average_check_today') double? averageCheckToday,@JsonKey(name: 'projected_income_today') double? projectedIncomeToday,@JsonKey(name: 'factual_income_now') double? factualIncomeNow
});


$AnalyticsAppointmentsCopyWith<$Res> get appointments;

}
/// @nodoc
class _$AnalyticsSummaryBlockCopyWithImpl<$Res>
    implements $AnalyticsSummaryBlockCopyWith<$Res> {
  _$AnalyticsSummaryBlockCopyWithImpl(this._self, this._then);

  final AnalyticsSummaryBlock _self;
  final $Res Function(AnalyticsSummaryBlock) _then;

/// Create a copy of AnalyticsSummaryBlock
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? appointments = null,Object? occupancy = null,Object? occupancyToday = freezed,Object? occupancyByDay = null,Object? incomeByDay = null,Object? upcomingServicesToday = null,Object? averageCheckToday = freezed,Object? projectedIncomeToday = freezed,Object? factualIncomeNow = freezed,}) {
  return _then(_self.copyWith(
appointments: null == appointments ? _self.appointments : appointments // ignore: cast_nullable_to_non_nullable
as AnalyticsAppointments,occupancy: null == occupancy ? _self.occupancy : occupancy // ignore: cast_nullable_to_non_nullable
as double,occupancyToday: freezed == occupancyToday ? _self.occupancyToday : occupancyToday // ignore: cast_nullable_to_non_nullable
as double?,occupancyByDay: null == occupancyByDay ? _self.occupancyByDay : occupancyByDay // ignore: cast_nullable_to_non_nullable
as List<AnalyticsOccupancyDay>,incomeByDay: null == incomeByDay ? _self.incomeByDay : incomeByDay // ignore: cast_nullable_to_non_nullable
as List<AnalyticsIncomeByDay>,upcomingServicesToday: null == upcomingServicesToday ? _self.upcomingServicesToday : upcomingServicesToday // ignore: cast_nullable_to_non_nullable
as List<AnalyticsNamedCount>,averageCheckToday: freezed == averageCheckToday ? _self.averageCheckToday : averageCheckToday // ignore: cast_nullable_to_non_nullable
as double?,projectedIncomeToday: freezed == projectedIncomeToday ? _self.projectedIncomeToday : projectedIncomeToday // ignore: cast_nullable_to_non_nullable
as double?,factualIncomeNow: freezed == factualIncomeNow ? _self.factualIncomeNow : factualIncomeNow // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}
/// Create a copy of AnalyticsSummaryBlock
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AnalyticsAppointmentsCopyWith<$Res> get appointments {
  
  return $AnalyticsAppointmentsCopyWith<$Res>(_self.appointments, (value) {
    return _then(_self.copyWith(appointments: value));
  });
}
}


/// Adds pattern-matching-related methods to [AnalyticsSummaryBlock].
extension AnalyticsSummaryBlockPatterns on AnalyticsSummaryBlock {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AnalyticsSummaryBlock value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AnalyticsSummaryBlock() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AnalyticsSummaryBlock value)  $default,){
final _that = this;
switch (_that) {
case _AnalyticsSummaryBlock():
return $default(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AnalyticsSummaryBlock value)?  $default,){
final _that = this;
switch (_that) {
case _AnalyticsSummaryBlock() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AnalyticsAppointments appointments,  double occupancy, @JsonKey(name: 'occupancy_today')  double? occupancyToday, @JsonKey(name: 'occupancy_by_day')  List<AnalyticsOccupancyDay> occupancyByDay, @JsonKey(name: 'income_by_day')  List<AnalyticsIncomeByDay> incomeByDay, @JsonKey(name: 'upcoming_services_today')  List<AnalyticsNamedCount> upcomingServicesToday, @JsonKey(name: 'average_check_today')  double? averageCheckToday, @JsonKey(name: 'projected_income_today')  double? projectedIncomeToday, @JsonKey(name: 'factual_income_now')  double? factualIncomeNow)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AnalyticsSummaryBlock() when $default != null:
return $default(_that.appointments,_that.occupancy,_that.occupancyToday,_that.occupancyByDay,_that.incomeByDay,_that.upcomingServicesToday,_that.averageCheckToday,_that.projectedIncomeToday,_that.factualIncomeNow);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AnalyticsAppointments appointments,  double occupancy, @JsonKey(name: 'occupancy_today')  double? occupancyToday, @JsonKey(name: 'occupancy_by_day')  List<AnalyticsOccupancyDay> occupancyByDay, @JsonKey(name: 'income_by_day')  List<AnalyticsIncomeByDay> incomeByDay, @JsonKey(name: 'upcoming_services_today')  List<AnalyticsNamedCount> upcomingServicesToday, @JsonKey(name: 'average_check_today')  double? averageCheckToday, @JsonKey(name: 'projected_income_today')  double? projectedIncomeToday, @JsonKey(name: 'factual_income_now')  double? factualIncomeNow)  $default,) {final _that = this;
switch (_that) {
case _AnalyticsSummaryBlock():
return $default(_that.appointments,_that.occupancy,_that.occupancyToday,_that.occupancyByDay,_that.incomeByDay,_that.upcomingServicesToday,_that.averageCheckToday,_that.projectedIncomeToday,_that.factualIncomeNow);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AnalyticsAppointments appointments,  double occupancy, @JsonKey(name: 'occupancy_today')  double? occupancyToday, @JsonKey(name: 'occupancy_by_day')  List<AnalyticsOccupancyDay> occupancyByDay, @JsonKey(name: 'income_by_day')  List<AnalyticsIncomeByDay> incomeByDay, @JsonKey(name: 'upcoming_services_today')  List<AnalyticsNamedCount> upcomingServicesToday, @JsonKey(name: 'average_check_today')  double? averageCheckToday, @JsonKey(name: 'projected_income_today')  double? projectedIncomeToday, @JsonKey(name: 'factual_income_now')  double? factualIncomeNow)?  $default,) {final _that = this;
switch (_that) {
case _AnalyticsSummaryBlock() when $default != null:
return $default(_that.appointments,_that.occupancy,_that.occupancyToday,_that.occupancyByDay,_that.incomeByDay,_that.upcomingServicesToday,_that.averageCheckToday,_that.projectedIncomeToday,_that.factualIncomeNow);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AnalyticsSummaryBlock implements AnalyticsSummaryBlock {
  const _AnalyticsSummaryBlock({required this.appointments, required this.occupancy, @JsonKey(name: 'occupancy_today') this.occupancyToday, @JsonKey(name: 'occupancy_by_day') final  List<AnalyticsOccupancyDay> occupancyByDay = const [], @JsonKey(name: 'income_by_day') final  List<AnalyticsIncomeByDay> incomeByDay = const [], @JsonKey(name: 'upcoming_services_today') final  List<AnalyticsNamedCount> upcomingServicesToday = const [], @JsonKey(name: 'average_check_today') this.averageCheckToday, @JsonKey(name: 'projected_income_today') this.projectedIncomeToday, @JsonKey(name: 'factual_income_now') this.factualIncomeNow}): _occupancyByDay = occupancyByDay,_incomeByDay = incomeByDay,_upcomingServicesToday = upcomingServicesToday;
  factory _AnalyticsSummaryBlock.fromJson(Map<String, dynamic> json) => _$AnalyticsSummaryBlockFromJson(json);

@override final  AnalyticsAppointments appointments;
@override final  double occupancy;
@override@JsonKey(name: 'occupancy_today') final  double? occupancyToday;
 final  List<AnalyticsOccupancyDay> _occupancyByDay;
@override@JsonKey(name: 'occupancy_by_day') List<AnalyticsOccupancyDay> get occupancyByDay {
  if (_occupancyByDay is EqualUnmodifiableListView) return _occupancyByDay;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_occupancyByDay);
}

 final  List<AnalyticsIncomeByDay> _incomeByDay;
@override@JsonKey(name: 'income_by_day') List<AnalyticsIncomeByDay> get incomeByDay {
  if (_incomeByDay is EqualUnmodifiableListView) return _incomeByDay;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_incomeByDay);
}

 final  List<AnalyticsNamedCount> _upcomingServicesToday;
@override@JsonKey(name: 'upcoming_services_today') List<AnalyticsNamedCount> get upcomingServicesToday {
  if (_upcomingServicesToday is EqualUnmodifiableListView) return _upcomingServicesToday;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_upcomingServicesToday);
}

@override@JsonKey(name: 'average_check_today') final  double? averageCheckToday;
@override@JsonKey(name: 'projected_income_today') final  double? projectedIncomeToday;
@override@JsonKey(name: 'factual_income_now') final  double? factualIncomeNow;

/// Create a copy of AnalyticsSummaryBlock
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AnalyticsSummaryBlockCopyWith<_AnalyticsSummaryBlock> get copyWith => __$AnalyticsSummaryBlockCopyWithImpl<_AnalyticsSummaryBlock>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AnalyticsSummaryBlockToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AnalyticsSummaryBlock&&(identical(other.appointments, appointments) || other.appointments == appointments)&&(identical(other.occupancy, occupancy) || other.occupancy == occupancy)&&(identical(other.occupancyToday, occupancyToday) || other.occupancyToday == occupancyToday)&&const DeepCollectionEquality().equals(other._occupancyByDay, _occupancyByDay)&&const DeepCollectionEquality().equals(other._incomeByDay, _incomeByDay)&&const DeepCollectionEquality().equals(other._upcomingServicesToday, _upcomingServicesToday)&&(identical(other.averageCheckToday, averageCheckToday) || other.averageCheckToday == averageCheckToday)&&(identical(other.projectedIncomeToday, projectedIncomeToday) || other.projectedIncomeToday == projectedIncomeToday)&&(identical(other.factualIncomeNow, factualIncomeNow) || other.factualIncomeNow == factualIncomeNow));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,appointments,occupancy,occupancyToday,const DeepCollectionEquality().hash(_occupancyByDay),const DeepCollectionEquality().hash(_incomeByDay),const DeepCollectionEquality().hash(_upcomingServicesToday),averageCheckToday,projectedIncomeToday,factualIncomeNow);

@override
String toString() {
  return 'AnalyticsSummaryBlock(appointments: $appointments, occupancy: $occupancy, occupancyToday: $occupancyToday, occupancyByDay: $occupancyByDay, incomeByDay: $incomeByDay, upcomingServicesToday: $upcomingServicesToday, averageCheckToday: $averageCheckToday, projectedIncomeToday: $projectedIncomeToday, factualIncomeNow: $factualIncomeNow)';
}


}

/// @nodoc
abstract mixin class _$AnalyticsSummaryBlockCopyWith<$Res> implements $AnalyticsSummaryBlockCopyWith<$Res> {
  factory _$AnalyticsSummaryBlockCopyWith(_AnalyticsSummaryBlock value, $Res Function(_AnalyticsSummaryBlock) _then) = __$AnalyticsSummaryBlockCopyWithImpl;
@override @useResult
$Res call({
 AnalyticsAppointments appointments, double occupancy,@JsonKey(name: 'occupancy_today') double? occupancyToday,@JsonKey(name: 'occupancy_by_day') List<AnalyticsOccupancyDay> occupancyByDay,@JsonKey(name: 'income_by_day') List<AnalyticsIncomeByDay> incomeByDay,@JsonKey(name: 'upcoming_services_today') List<AnalyticsNamedCount> upcomingServicesToday,@JsonKey(name: 'average_check_today') double? averageCheckToday,@JsonKey(name: 'projected_income_today') double? projectedIncomeToday,@JsonKey(name: 'factual_income_now') double? factualIncomeNow
});


@override $AnalyticsAppointmentsCopyWith<$Res> get appointments;

}
/// @nodoc
class __$AnalyticsSummaryBlockCopyWithImpl<$Res>
    implements _$AnalyticsSummaryBlockCopyWith<$Res> {
  __$AnalyticsSummaryBlockCopyWithImpl(this._self, this._then);

  final _AnalyticsSummaryBlock _self;
  final $Res Function(_AnalyticsSummaryBlock) _then;

/// Create a copy of AnalyticsSummaryBlock
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? appointments = null,Object? occupancy = null,Object? occupancyToday = freezed,Object? occupancyByDay = null,Object? incomeByDay = null,Object? upcomingServicesToday = null,Object? averageCheckToday = freezed,Object? projectedIncomeToday = freezed,Object? factualIncomeNow = freezed,}) {
  return _then(_AnalyticsSummaryBlock(
appointments: null == appointments ? _self.appointments : appointments // ignore: cast_nullable_to_non_nullable
as AnalyticsAppointments,occupancy: null == occupancy ? _self.occupancy : occupancy // ignore: cast_nullable_to_non_nullable
as double,occupancyToday: freezed == occupancyToday ? _self.occupancyToday : occupancyToday // ignore: cast_nullable_to_non_nullable
as double?,occupancyByDay: null == occupancyByDay ? _self._occupancyByDay : occupancyByDay // ignore: cast_nullable_to_non_nullable
as List<AnalyticsOccupancyDay>,incomeByDay: null == incomeByDay ? _self._incomeByDay : incomeByDay // ignore: cast_nullable_to_non_nullable
as List<AnalyticsIncomeByDay>,upcomingServicesToday: null == upcomingServicesToday ? _self._upcomingServicesToday : upcomingServicesToday // ignore: cast_nullable_to_non_nullable
as List<AnalyticsNamedCount>,averageCheckToday: freezed == averageCheckToday ? _self.averageCheckToday : averageCheckToday // ignore: cast_nullable_to_non_nullable
as double?,projectedIncomeToday: freezed == projectedIncomeToday ? _self.projectedIncomeToday : projectedIncomeToday // ignore: cast_nullable_to_non_nullable
as double?,factualIncomeNow: freezed == factualIncomeNow ? _self.factualIncomeNow : factualIncomeNow // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

/// Create a copy of AnalyticsSummaryBlock
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AnalyticsAppointmentsCopyWith<$Res> get appointments {
  
  return $AnalyticsAppointmentsCopyWith<$Res>(_self.appointments, (value) {
    return _then(_self.copyWith(appointments: value));
  });
}
}


/// @nodoc
mixin _$AnalyticsAppointments {

 int get total; int get cancelled;@JsonKey(name: 'new') int get newCount;
/// Create a copy of AnalyticsAppointments
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AnalyticsAppointmentsCopyWith<AnalyticsAppointments> get copyWith => _$AnalyticsAppointmentsCopyWithImpl<AnalyticsAppointments>(this as AnalyticsAppointments, _$identity);

  /// Serializes this AnalyticsAppointments to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnalyticsAppointments&&(identical(other.total, total) || other.total == total)&&(identical(other.cancelled, cancelled) || other.cancelled == cancelled)&&(identical(other.newCount, newCount) || other.newCount == newCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,total,cancelled,newCount);

@override
String toString() {
  return 'AnalyticsAppointments(total: $total, cancelled: $cancelled, newCount: $newCount)';
}


}

/// @nodoc
abstract mixin class $AnalyticsAppointmentsCopyWith<$Res>  {
  factory $AnalyticsAppointmentsCopyWith(AnalyticsAppointments value, $Res Function(AnalyticsAppointments) _then) = _$AnalyticsAppointmentsCopyWithImpl;
@useResult
$Res call({
 int total, int cancelled,@JsonKey(name: 'new') int newCount
});




}
/// @nodoc
class _$AnalyticsAppointmentsCopyWithImpl<$Res>
    implements $AnalyticsAppointmentsCopyWith<$Res> {
  _$AnalyticsAppointmentsCopyWithImpl(this._self, this._then);

  final AnalyticsAppointments _self;
  final $Res Function(AnalyticsAppointments) _then;

/// Create a copy of AnalyticsAppointments
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? total = null,Object? cancelled = null,Object? newCount = null,}) {
  return _then(_self.copyWith(
total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,cancelled: null == cancelled ? _self.cancelled : cancelled // ignore: cast_nullable_to_non_nullable
as int,newCount: null == newCount ? _self.newCount : newCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [AnalyticsAppointments].
extension AnalyticsAppointmentsPatterns on AnalyticsAppointments {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AnalyticsAppointments value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AnalyticsAppointments() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AnalyticsAppointments value)  $default,){
final _that = this;
switch (_that) {
case _AnalyticsAppointments():
return $default(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AnalyticsAppointments value)?  $default,){
final _that = this;
switch (_that) {
case _AnalyticsAppointments() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int total,  int cancelled, @JsonKey(name: 'new')  int newCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AnalyticsAppointments() when $default != null:
return $default(_that.total,_that.cancelled,_that.newCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int total,  int cancelled, @JsonKey(name: 'new')  int newCount)  $default,) {final _that = this;
switch (_that) {
case _AnalyticsAppointments():
return $default(_that.total,_that.cancelled,_that.newCount);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int total,  int cancelled, @JsonKey(name: 'new')  int newCount)?  $default,) {final _that = this;
switch (_that) {
case _AnalyticsAppointments() when $default != null:
return $default(_that.total,_that.cancelled,_that.newCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AnalyticsAppointments implements AnalyticsAppointments {
  const _AnalyticsAppointments({required this.total, required this.cancelled, @JsonKey(name: 'new') required this.newCount});
  factory _AnalyticsAppointments.fromJson(Map<String, dynamic> json) => _$AnalyticsAppointmentsFromJson(json);

@override final  int total;
@override final  int cancelled;
@override@JsonKey(name: 'new') final  int newCount;

/// Create a copy of AnalyticsAppointments
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AnalyticsAppointmentsCopyWith<_AnalyticsAppointments> get copyWith => __$AnalyticsAppointmentsCopyWithImpl<_AnalyticsAppointments>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AnalyticsAppointmentsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AnalyticsAppointments&&(identical(other.total, total) || other.total == total)&&(identical(other.cancelled, cancelled) || other.cancelled == cancelled)&&(identical(other.newCount, newCount) || other.newCount == newCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,total,cancelled,newCount);

@override
String toString() {
  return 'AnalyticsAppointments(total: $total, cancelled: $cancelled, newCount: $newCount)';
}


}

/// @nodoc
abstract mixin class _$AnalyticsAppointmentsCopyWith<$Res> implements $AnalyticsAppointmentsCopyWith<$Res> {
  factory _$AnalyticsAppointmentsCopyWith(_AnalyticsAppointments value, $Res Function(_AnalyticsAppointments) _then) = __$AnalyticsAppointmentsCopyWithImpl;
@override @useResult
$Res call({
 int total, int cancelled,@JsonKey(name: 'new') int newCount
});




}
/// @nodoc
class __$AnalyticsAppointmentsCopyWithImpl<$Res>
    implements _$AnalyticsAppointmentsCopyWith<$Res> {
  __$AnalyticsAppointmentsCopyWithImpl(this._self, this._then);

  final _AnalyticsAppointments _self;
  final $Res Function(_AnalyticsAppointments) _then;

/// Create a copy of AnalyticsAppointments
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? total = null,Object? cancelled = null,Object? newCount = null,}) {
  return _then(_AnalyticsAppointments(
total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,cancelled: null == cancelled ? _self.cancelled : cancelled // ignore: cast_nullable_to_non_nullable
as int,newCount: null == newCount ? _self.newCount : newCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$AnalyticsOccupancyDay {

 String get date; double get occupancy;
/// Create a copy of AnalyticsOccupancyDay
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AnalyticsOccupancyDayCopyWith<AnalyticsOccupancyDay> get copyWith => _$AnalyticsOccupancyDayCopyWithImpl<AnalyticsOccupancyDay>(this as AnalyticsOccupancyDay, _$identity);

  /// Serializes this AnalyticsOccupancyDay to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnalyticsOccupancyDay&&(identical(other.date, date) || other.date == date)&&(identical(other.occupancy, occupancy) || other.occupancy == occupancy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,occupancy);

@override
String toString() {
  return 'AnalyticsOccupancyDay(date: $date, occupancy: $occupancy)';
}


}

/// @nodoc
abstract mixin class $AnalyticsOccupancyDayCopyWith<$Res>  {
  factory $AnalyticsOccupancyDayCopyWith(AnalyticsOccupancyDay value, $Res Function(AnalyticsOccupancyDay) _then) = _$AnalyticsOccupancyDayCopyWithImpl;
@useResult
$Res call({
 String date, double occupancy
});




}
/// @nodoc
class _$AnalyticsOccupancyDayCopyWithImpl<$Res>
    implements $AnalyticsOccupancyDayCopyWith<$Res> {
  _$AnalyticsOccupancyDayCopyWithImpl(this._self, this._then);

  final AnalyticsOccupancyDay _self;
  final $Res Function(AnalyticsOccupancyDay) _then;

/// Create a copy of AnalyticsOccupancyDay
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? occupancy = null,}) {
  return _then(_self.copyWith(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,occupancy: null == occupancy ? _self.occupancy : occupancy // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [AnalyticsOccupancyDay].
extension AnalyticsOccupancyDayPatterns on AnalyticsOccupancyDay {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AnalyticsOccupancyDay value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AnalyticsOccupancyDay() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AnalyticsOccupancyDay value)  $default,){
final _that = this;
switch (_that) {
case _AnalyticsOccupancyDay():
return $default(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AnalyticsOccupancyDay value)?  $default,){
final _that = this;
switch (_that) {
case _AnalyticsOccupancyDay() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String date,  double occupancy)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AnalyticsOccupancyDay() when $default != null:
return $default(_that.date,_that.occupancy);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String date,  double occupancy)  $default,) {final _that = this;
switch (_that) {
case _AnalyticsOccupancyDay():
return $default(_that.date,_that.occupancy);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String date,  double occupancy)?  $default,) {final _that = this;
switch (_that) {
case _AnalyticsOccupancyDay() when $default != null:
return $default(_that.date,_that.occupancy);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AnalyticsOccupancyDay implements AnalyticsOccupancyDay {
  const _AnalyticsOccupancyDay({required this.date, required this.occupancy});
  factory _AnalyticsOccupancyDay.fromJson(Map<String, dynamic> json) => _$AnalyticsOccupancyDayFromJson(json);

@override final  String date;
@override final  double occupancy;

/// Create a copy of AnalyticsOccupancyDay
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AnalyticsOccupancyDayCopyWith<_AnalyticsOccupancyDay> get copyWith => __$AnalyticsOccupancyDayCopyWithImpl<_AnalyticsOccupancyDay>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AnalyticsOccupancyDayToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AnalyticsOccupancyDay&&(identical(other.date, date) || other.date == date)&&(identical(other.occupancy, occupancy) || other.occupancy == occupancy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,occupancy);

@override
String toString() {
  return 'AnalyticsOccupancyDay(date: $date, occupancy: $occupancy)';
}


}

/// @nodoc
abstract mixin class _$AnalyticsOccupancyDayCopyWith<$Res> implements $AnalyticsOccupancyDayCopyWith<$Res> {
  factory _$AnalyticsOccupancyDayCopyWith(_AnalyticsOccupancyDay value, $Res Function(_AnalyticsOccupancyDay) _then) = __$AnalyticsOccupancyDayCopyWithImpl;
@override @useResult
$Res call({
 String date, double occupancy
});




}
/// @nodoc
class __$AnalyticsOccupancyDayCopyWithImpl<$Res>
    implements _$AnalyticsOccupancyDayCopyWith<$Res> {
  __$AnalyticsOccupancyDayCopyWithImpl(this._self, this._then);

  final _AnalyticsOccupancyDay _self;
  final $Res Function(_AnalyticsOccupancyDay) _then;

/// Create a copy of AnalyticsOccupancyDay
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? occupancy = null,}) {
  return _then(_AnalyticsOccupancyDay(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,occupancy: null == occupancy ? _self.occupancy : occupancy // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$AnalyticsIncomeByDay {

 String get date; double? get sum; double? get income;@JsonKey(name: 'pay_due') double? get payDue;
/// Create a copy of AnalyticsIncomeByDay
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AnalyticsIncomeByDayCopyWith<AnalyticsIncomeByDay> get copyWith => _$AnalyticsIncomeByDayCopyWithImpl<AnalyticsIncomeByDay>(this as AnalyticsIncomeByDay, _$identity);

  /// Serializes this AnalyticsIncomeByDay to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnalyticsIncomeByDay&&(identical(other.date, date) || other.date == date)&&(identical(other.sum, sum) || other.sum == sum)&&(identical(other.income, income) || other.income == income)&&(identical(other.payDue, payDue) || other.payDue == payDue));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,sum,income,payDue);

@override
String toString() {
  return 'AnalyticsIncomeByDay(date: $date, sum: $sum, income: $income, payDue: $payDue)';
}


}

/// @nodoc
abstract mixin class $AnalyticsIncomeByDayCopyWith<$Res>  {
  factory $AnalyticsIncomeByDayCopyWith(AnalyticsIncomeByDay value, $Res Function(AnalyticsIncomeByDay) _then) = _$AnalyticsIncomeByDayCopyWithImpl;
@useResult
$Res call({
 String date, double? sum, double? income,@JsonKey(name: 'pay_due') double? payDue
});




}
/// @nodoc
class _$AnalyticsIncomeByDayCopyWithImpl<$Res>
    implements $AnalyticsIncomeByDayCopyWith<$Res> {
  _$AnalyticsIncomeByDayCopyWithImpl(this._self, this._then);

  final AnalyticsIncomeByDay _self;
  final $Res Function(AnalyticsIncomeByDay) _then;

/// Create a copy of AnalyticsIncomeByDay
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? sum = freezed,Object? income = freezed,Object? payDue = freezed,}) {
  return _then(_self.copyWith(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,sum: freezed == sum ? _self.sum : sum // ignore: cast_nullable_to_non_nullable
as double?,income: freezed == income ? _self.income : income // ignore: cast_nullable_to_non_nullable
as double?,payDue: freezed == payDue ? _self.payDue : payDue // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [AnalyticsIncomeByDay].
extension AnalyticsIncomeByDayPatterns on AnalyticsIncomeByDay {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AnalyticsIncomeByDay value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AnalyticsIncomeByDay() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AnalyticsIncomeByDay value)  $default,){
final _that = this;
switch (_that) {
case _AnalyticsIncomeByDay():
return $default(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AnalyticsIncomeByDay value)?  $default,){
final _that = this;
switch (_that) {
case _AnalyticsIncomeByDay() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String date,  double? sum,  double? income, @JsonKey(name: 'pay_due')  double? payDue)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AnalyticsIncomeByDay() when $default != null:
return $default(_that.date,_that.sum,_that.income,_that.payDue);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String date,  double? sum,  double? income, @JsonKey(name: 'pay_due')  double? payDue)  $default,) {final _that = this;
switch (_that) {
case _AnalyticsIncomeByDay():
return $default(_that.date,_that.sum,_that.income,_that.payDue);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String date,  double? sum,  double? income, @JsonKey(name: 'pay_due')  double? payDue)?  $default,) {final _that = this;
switch (_that) {
case _AnalyticsIncomeByDay() when $default != null:
return $default(_that.date,_that.sum,_that.income,_that.payDue);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AnalyticsIncomeByDay extends AnalyticsIncomeByDay {
  const _AnalyticsIncomeByDay({required this.date, this.sum, this.income, @JsonKey(name: 'pay_due') this.payDue}): super._();
  factory _AnalyticsIncomeByDay.fromJson(Map<String, dynamic> json) => _$AnalyticsIncomeByDayFromJson(json);

@override final  String date;
@override final  double? sum;
@override final  double? income;
@override@JsonKey(name: 'pay_due') final  double? payDue;

/// Create a copy of AnalyticsIncomeByDay
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AnalyticsIncomeByDayCopyWith<_AnalyticsIncomeByDay> get copyWith => __$AnalyticsIncomeByDayCopyWithImpl<_AnalyticsIncomeByDay>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AnalyticsIncomeByDayToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AnalyticsIncomeByDay&&(identical(other.date, date) || other.date == date)&&(identical(other.sum, sum) || other.sum == sum)&&(identical(other.income, income) || other.income == income)&&(identical(other.payDue, payDue) || other.payDue == payDue));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,sum,income,payDue);

@override
String toString() {
  return 'AnalyticsIncomeByDay(date: $date, sum: $sum, income: $income, payDue: $payDue)';
}


}

/// @nodoc
abstract mixin class _$AnalyticsIncomeByDayCopyWith<$Res> implements $AnalyticsIncomeByDayCopyWith<$Res> {
  factory _$AnalyticsIncomeByDayCopyWith(_AnalyticsIncomeByDay value, $Res Function(_AnalyticsIncomeByDay) _then) = __$AnalyticsIncomeByDayCopyWithImpl;
@override @useResult
$Res call({
 String date, double? sum, double? income,@JsonKey(name: 'pay_due') double? payDue
});




}
/// @nodoc
class __$AnalyticsIncomeByDayCopyWithImpl<$Res>
    implements _$AnalyticsIncomeByDayCopyWith<$Res> {
  __$AnalyticsIncomeByDayCopyWithImpl(this._self, this._then);

  final _AnalyticsIncomeByDay _self;
  final $Res Function(_AnalyticsIncomeByDay) _then;

/// Create a copy of AnalyticsIncomeByDay
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? sum = freezed,Object? income = freezed,Object? payDue = freezed,}) {
  return _then(_AnalyticsIncomeByDay(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,sum: freezed == sum ? _self.sum : sum // ignore: cast_nullable_to_non_nullable
as double?,income: freezed == income ? _self.income : income // ignore: cast_nullable_to_non_nullable
as double?,payDue: freezed == payDue ? _self.payDue : payDue // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}


/// @nodoc
mixin _$AnalyticsNamedCount {

 String? get service; String? get name; int get count;
/// Create a copy of AnalyticsNamedCount
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AnalyticsNamedCountCopyWith<AnalyticsNamedCount> get copyWith => _$AnalyticsNamedCountCopyWithImpl<AnalyticsNamedCount>(this as AnalyticsNamedCount, _$identity);

  /// Serializes this AnalyticsNamedCount to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnalyticsNamedCount&&(identical(other.service, service) || other.service == service)&&(identical(other.name, name) || other.name == name)&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,service,name,count);

@override
String toString() {
  return 'AnalyticsNamedCount(service: $service, name: $name, count: $count)';
}


}

/// @nodoc
abstract mixin class $AnalyticsNamedCountCopyWith<$Res>  {
  factory $AnalyticsNamedCountCopyWith(AnalyticsNamedCount value, $Res Function(AnalyticsNamedCount) _then) = _$AnalyticsNamedCountCopyWithImpl;
@useResult
$Res call({
 String? service, String? name, int count
});




}
/// @nodoc
class _$AnalyticsNamedCountCopyWithImpl<$Res>
    implements $AnalyticsNamedCountCopyWith<$Res> {
  _$AnalyticsNamedCountCopyWithImpl(this._self, this._then);

  final AnalyticsNamedCount _self;
  final $Res Function(AnalyticsNamedCount) _then;

/// Create a copy of AnalyticsNamedCount
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? service = freezed,Object? name = freezed,Object? count = null,}) {
  return _then(_self.copyWith(
service: freezed == service ? _self.service : service // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [AnalyticsNamedCount].
extension AnalyticsNamedCountPatterns on AnalyticsNamedCount {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AnalyticsNamedCount value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AnalyticsNamedCount() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AnalyticsNamedCount value)  $default,){
final _that = this;
switch (_that) {
case _AnalyticsNamedCount():
return $default(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AnalyticsNamedCount value)?  $default,){
final _that = this;
switch (_that) {
case _AnalyticsNamedCount() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? service,  String? name,  int count)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AnalyticsNamedCount() when $default != null:
return $default(_that.service,_that.name,_that.count);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? service,  String? name,  int count)  $default,) {final _that = this;
switch (_that) {
case _AnalyticsNamedCount():
return $default(_that.service,_that.name,_that.count);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? service,  String? name,  int count)?  $default,) {final _that = this;
switch (_that) {
case _AnalyticsNamedCount() when $default != null:
return $default(_that.service,_that.name,_that.count);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AnalyticsNamedCount extends AnalyticsNamedCount {
  const _AnalyticsNamedCount({this.service, this.name, this.count = 0}): super._();
  factory _AnalyticsNamedCount.fromJson(Map<String, dynamic> json) => _$AnalyticsNamedCountFromJson(json);

@override final  String? service;
@override final  String? name;
@override@JsonKey() final  int count;

/// Create a copy of AnalyticsNamedCount
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AnalyticsNamedCountCopyWith<_AnalyticsNamedCount> get copyWith => __$AnalyticsNamedCountCopyWithImpl<_AnalyticsNamedCount>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AnalyticsNamedCountToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AnalyticsNamedCount&&(identical(other.service, service) || other.service == service)&&(identical(other.name, name) || other.name == name)&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,service,name,count);

@override
String toString() {
  return 'AnalyticsNamedCount(service: $service, name: $name, count: $count)';
}


}

/// @nodoc
abstract mixin class _$AnalyticsNamedCountCopyWith<$Res> implements $AnalyticsNamedCountCopyWith<$Res> {
  factory _$AnalyticsNamedCountCopyWith(_AnalyticsNamedCount value, $Res Function(_AnalyticsNamedCount) _then) = __$AnalyticsNamedCountCopyWithImpl;
@override @useResult
$Res call({
 String? service, String? name, int count
});




}
/// @nodoc
class __$AnalyticsNamedCountCopyWithImpl<$Res>
    implements _$AnalyticsNamedCountCopyWith<$Res> {
  __$AnalyticsNamedCountCopyWithImpl(this._self, this._then);

  final _AnalyticsNamedCount _self;
  final $Res Function(_AnalyticsNamedCount) _then;

/// Create a copy of AnalyticsNamedCount
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? service = freezed,Object? name = freezed,Object? count = null,}) {
  return _then(_AnalyticsNamedCount(
service: freezed == service ? _self.service : service // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$AnalyticsComparison {

 AnalyticsComparisonPeriod get current;
/// Create a copy of AnalyticsComparison
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AnalyticsComparisonCopyWith<AnalyticsComparison> get copyWith => _$AnalyticsComparisonCopyWithImpl<AnalyticsComparison>(this as AnalyticsComparison, _$identity);

  /// Serializes this AnalyticsComparison to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnalyticsComparison&&(identical(other.current, current) || other.current == current));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,current);

@override
String toString() {
  return 'AnalyticsComparison(current: $current)';
}


}

/// @nodoc
abstract mixin class $AnalyticsComparisonCopyWith<$Res>  {
  factory $AnalyticsComparisonCopyWith(AnalyticsComparison value, $Res Function(AnalyticsComparison) _then) = _$AnalyticsComparisonCopyWithImpl;
@useResult
$Res call({
 AnalyticsComparisonPeriod current
});


$AnalyticsComparisonPeriodCopyWith<$Res> get current;

}
/// @nodoc
class _$AnalyticsComparisonCopyWithImpl<$Res>
    implements $AnalyticsComparisonCopyWith<$Res> {
  _$AnalyticsComparisonCopyWithImpl(this._self, this._then);

  final AnalyticsComparison _self;
  final $Res Function(AnalyticsComparison) _then;

/// Create a copy of AnalyticsComparison
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? current = null,}) {
  return _then(_self.copyWith(
current: null == current ? _self.current : current // ignore: cast_nullable_to_non_nullable
as AnalyticsComparisonPeriod,
  ));
}
/// Create a copy of AnalyticsComparison
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AnalyticsComparisonPeriodCopyWith<$Res> get current {
  
  return $AnalyticsComparisonPeriodCopyWith<$Res>(_self.current, (value) {
    return _then(_self.copyWith(current: value));
  });
}
}


/// Adds pattern-matching-related methods to [AnalyticsComparison].
extension AnalyticsComparisonPatterns on AnalyticsComparison {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AnalyticsComparison value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AnalyticsComparison() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AnalyticsComparison value)  $default,){
final _that = this;
switch (_that) {
case _AnalyticsComparison():
return $default(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AnalyticsComparison value)?  $default,){
final _that = this;
switch (_that) {
case _AnalyticsComparison() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AnalyticsComparisonPeriod current)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AnalyticsComparison() when $default != null:
return $default(_that.current);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AnalyticsComparisonPeriod current)  $default,) {final _that = this;
switch (_that) {
case _AnalyticsComparison():
return $default(_that.current);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AnalyticsComparisonPeriod current)?  $default,) {final _that = this;
switch (_that) {
case _AnalyticsComparison() when $default != null:
return $default(_that.current);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AnalyticsComparison implements AnalyticsComparison {
  const _AnalyticsComparison({required this.current});
  factory _AnalyticsComparison.fromJson(Map<String, dynamic> json) => _$AnalyticsComparisonFromJson(json);

@override final  AnalyticsComparisonPeriod current;

/// Create a copy of AnalyticsComparison
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AnalyticsComparisonCopyWith<_AnalyticsComparison> get copyWith => __$AnalyticsComparisonCopyWithImpl<_AnalyticsComparison>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AnalyticsComparisonToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AnalyticsComparison&&(identical(other.current, current) || other.current == current));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,current);

@override
String toString() {
  return 'AnalyticsComparison(current: $current)';
}


}

/// @nodoc
abstract mixin class _$AnalyticsComparisonCopyWith<$Res> implements $AnalyticsComparisonCopyWith<$Res> {
  factory _$AnalyticsComparisonCopyWith(_AnalyticsComparison value, $Res Function(_AnalyticsComparison) _then) = __$AnalyticsComparisonCopyWithImpl;
@override @useResult
$Res call({
 AnalyticsComparisonPeriod current
});


@override $AnalyticsComparisonPeriodCopyWith<$Res> get current;

}
/// @nodoc
class __$AnalyticsComparisonCopyWithImpl<$Res>
    implements _$AnalyticsComparisonCopyWith<$Res> {
  __$AnalyticsComparisonCopyWithImpl(this._self, this._then);

  final _AnalyticsComparison _self;
  final $Res Function(_AnalyticsComparison) _then;

/// Create a copy of AnalyticsComparison
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? current = null,}) {
  return _then(_AnalyticsComparison(
current: null == current ? _self.current : current // ignore: cast_nullable_to_non_nullable
as AnalyticsComparisonPeriod,
  ));
}

/// Create a copy of AnalyticsComparison
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AnalyticsComparisonPeriodCopyWith<$Res> get current {
  
  return $AnalyticsComparisonPeriodCopyWith<$Res>(_self.current, (value) {
    return _then(_self.copyWith(current: value));
  });
}
}


/// @nodoc
mixin _$AnalyticsOverview {

 double? get performance;@JsonKey(name: 'pay_due') double? get payDue; double? get occupancy; double? get income; int? get clients;@JsonKey(name: 'average_check') double? get averageCheck;
/// Create a copy of AnalyticsOverview
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AnalyticsOverviewCopyWith<AnalyticsOverview> get copyWith => _$AnalyticsOverviewCopyWithImpl<AnalyticsOverview>(this as AnalyticsOverview, _$identity);

  /// Serializes this AnalyticsOverview to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnalyticsOverview&&(identical(other.performance, performance) || other.performance == performance)&&(identical(other.payDue, payDue) || other.payDue == payDue)&&(identical(other.occupancy, occupancy) || other.occupancy == occupancy)&&(identical(other.income, income) || other.income == income)&&(identical(other.clients, clients) || other.clients == clients)&&(identical(other.averageCheck, averageCheck) || other.averageCheck == averageCheck));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,performance,payDue,occupancy,income,clients,averageCheck);

@override
String toString() {
  return 'AnalyticsOverview(performance: $performance, payDue: $payDue, occupancy: $occupancy, income: $income, clients: $clients, averageCheck: $averageCheck)';
}


}

/// @nodoc
abstract mixin class $AnalyticsOverviewCopyWith<$Res>  {
  factory $AnalyticsOverviewCopyWith(AnalyticsOverview value, $Res Function(AnalyticsOverview) _then) = _$AnalyticsOverviewCopyWithImpl;
@useResult
$Res call({
 double? performance,@JsonKey(name: 'pay_due') double? payDue, double? occupancy, double? income, int? clients,@JsonKey(name: 'average_check') double? averageCheck
});




}
/// @nodoc
class _$AnalyticsOverviewCopyWithImpl<$Res>
    implements $AnalyticsOverviewCopyWith<$Res> {
  _$AnalyticsOverviewCopyWithImpl(this._self, this._then);

  final AnalyticsOverview _self;
  final $Res Function(AnalyticsOverview) _then;

/// Create a copy of AnalyticsOverview
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? performance = freezed,Object? payDue = freezed,Object? occupancy = freezed,Object? income = freezed,Object? clients = freezed,Object? averageCheck = freezed,}) {
  return _then(_self.copyWith(
performance: freezed == performance ? _self.performance : performance // ignore: cast_nullable_to_non_nullable
as double?,payDue: freezed == payDue ? _self.payDue : payDue // ignore: cast_nullable_to_non_nullable
as double?,occupancy: freezed == occupancy ? _self.occupancy : occupancy // ignore: cast_nullable_to_non_nullable
as double?,income: freezed == income ? _self.income : income // ignore: cast_nullable_to_non_nullable
as double?,clients: freezed == clients ? _self.clients : clients // ignore: cast_nullable_to_non_nullable
as int?,averageCheck: freezed == averageCheck ? _self.averageCheck : averageCheck // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [AnalyticsOverview].
extension AnalyticsOverviewPatterns on AnalyticsOverview {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AnalyticsOverview value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AnalyticsOverview() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AnalyticsOverview value)  $default,){
final _that = this;
switch (_that) {
case _AnalyticsOverview():
return $default(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AnalyticsOverview value)?  $default,){
final _that = this;
switch (_that) {
case _AnalyticsOverview() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double? performance, @JsonKey(name: 'pay_due')  double? payDue,  double? occupancy,  double? income,  int? clients, @JsonKey(name: 'average_check')  double? averageCheck)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AnalyticsOverview() when $default != null:
return $default(_that.performance,_that.payDue,_that.occupancy,_that.income,_that.clients,_that.averageCheck);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double? performance, @JsonKey(name: 'pay_due')  double? payDue,  double? occupancy,  double? income,  int? clients, @JsonKey(name: 'average_check')  double? averageCheck)  $default,) {final _that = this;
switch (_that) {
case _AnalyticsOverview():
return $default(_that.performance,_that.payDue,_that.occupancy,_that.income,_that.clients,_that.averageCheck);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double? performance, @JsonKey(name: 'pay_due')  double? payDue,  double? occupancy,  double? income,  int? clients, @JsonKey(name: 'average_check')  double? averageCheck)?  $default,) {final _that = this;
switch (_that) {
case _AnalyticsOverview() when $default != null:
return $default(_that.performance,_that.payDue,_that.occupancy,_that.income,_that.clients,_that.averageCheck);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AnalyticsOverview implements AnalyticsOverview {
  const _AnalyticsOverview({this.performance, @JsonKey(name: 'pay_due') this.payDue, this.occupancy, this.income, this.clients, @JsonKey(name: 'average_check') this.averageCheck});
  factory _AnalyticsOverview.fromJson(Map<String, dynamic> json) => _$AnalyticsOverviewFromJson(json);

@override final  double? performance;
@override@JsonKey(name: 'pay_due') final  double? payDue;
@override final  double? occupancy;
@override final  double? income;
@override final  int? clients;
@override@JsonKey(name: 'average_check') final  double? averageCheck;

/// Create a copy of AnalyticsOverview
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AnalyticsOverviewCopyWith<_AnalyticsOverview> get copyWith => __$AnalyticsOverviewCopyWithImpl<_AnalyticsOverview>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AnalyticsOverviewToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AnalyticsOverview&&(identical(other.performance, performance) || other.performance == performance)&&(identical(other.payDue, payDue) || other.payDue == payDue)&&(identical(other.occupancy, occupancy) || other.occupancy == occupancy)&&(identical(other.income, income) || other.income == income)&&(identical(other.clients, clients) || other.clients == clients)&&(identical(other.averageCheck, averageCheck) || other.averageCheck == averageCheck));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,performance,payDue,occupancy,income,clients,averageCheck);

@override
String toString() {
  return 'AnalyticsOverview(performance: $performance, payDue: $payDue, occupancy: $occupancy, income: $income, clients: $clients, averageCheck: $averageCheck)';
}


}

/// @nodoc
abstract mixin class _$AnalyticsOverviewCopyWith<$Res> implements $AnalyticsOverviewCopyWith<$Res> {
  factory _$AnalyticsOverviewCopyWith(_AnalyticsOverview value, $Res Function(_AnalyticsOverview) _then) = __$AnalyticsOverviewCopyWithImpl;
@override @useResult
$Res call({
 double? performance,@JsonKey(name: 'pay_due') double? payDue, double? occupancy, double? income, int? clients,@JsonKey(name: 'average_check') double? averageCheck
});




}
/// @nodoc
class __$AnalyticsOverviewCopyWithImpl<$Res>
    implements _$AnalyticsOverviewCopyWith<$Res> {
  __$AnalyticsOverviewCopyWithImpl(this._self, this._then);

  final _AnalyticsOverview _self;
  final $Res Function(_AnalyticsOverview) _then;

/// Create a copy of AnalyticsOverview
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? performance = freezed,Object? payDue = freezed,Object? occupancy = freezed,Object? income = freezed,Object? clients = freezed,Object? averageCheck = freezed,}) {
  return _then(_AnalyticsOverview(
performance: freezed == performance ? _self.performance : performance // ignore: cast_nullable_to_non_nullable
as double?,payDue: freezed == payDue ? _self.payDue : payDue // ignore: cast_nullable_to_non_nullable
as double?,occupancy: freezed == occupancy ? _self.occupancy : occupancy // ignore: cast_nullable_to_non_nullable
as double?,income: freezed == income ? _self.income : income // ignore: cast_nullable_to_non_nullable
as double?,clients: freezed == clients ? _self.clients : clients // ignore: cast_nullable_to_non_nullable
as int?,averageCheck: freezed == averageCheck ? _self.averageCheck : averageCheck // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}


/// @nodoc
mixin _$AnalyticsComparisonPeriod {

@JsonKey(name: 'total_income') double? get totalIncome; double? get performance;@JsonKey(name: 'pay_due') double? get payDue;@JsonKey(name: 'total_clients') int? get totalClients;@JsonKey(name: 'completed_appointments') int? get completedAppointments;@JsonKey(name: 'total_appointments') int? get totalAppointments;@JsonKey(name: 'new_clients') int? get newClients;@JsonKey(name: 'existing_clients') int? get existingClients;@JsonKey(name: 'oneshot_clients') int? get oneshotClients;@JsonKey(name: 'oneshot_clients_all') int? get oneshotClientsAll;@JsonKey(name: 'average_transactions') double? get averageTransactions; double? get occupancy;@JsonKey(name: 'income_by_day') List<AnalyticsIncomeByDay> get incomeByDay;
/// Create a copy of AnalyticsComparisonPeriod
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AnalyticsComparisonPeriodCopyWith<AnalyticsComparisonPeriod> get copyWith => _$AnalyticsComparisonPeriodCopyWithImpl<AnalyticsComparisonPeriod>(this as AnalyticsComparisonPeriod, _$identity);

  /// Serializes this AnalyticsComparisonPeriod to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnalyticsComparisonPeriod&&(identical(other.totalIncome, totalIncome) || other.totalIncome == totalIncome)&&(identical(other.performance, performance) || other.performance == performance)&&(identical(other.payDue, payDue) || other.payDue == payDue)&&(identical(other.totalClients, totalClients) || other.totalClients == totalClients)&&(identical(other.completedAppointments, completedAppointments) || other.completedAppointments == completedAppointments)&&(identical(other.totalAppointments, totalAppointments) || other.totalAppointments == totalAppointments)&&(identical(other.newClients, newClients) || other.newClients == newClients)&&(identical(other.existingClients, existingClients) || other.existingClients == existingClients)&&(identical(other.oneshotClients, oneshotClients) || other.oneshotClients == oneshotClients)&&(identical(other.oneshotClientsAll, oneshotClientsAll) || other.oneshotClientsAll == oneshotClientsAll)&&(identical(other.averageTransactions, averageTransactions) || other.averageTransactions == averageTransactions)&&(identical(other.occupancy, occupancy) || other.occupancy == occupancy)&&const DeepCollectionEquality().equals(other.incomeByDay, incomeByDay));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalIncome,performance,payDue,totalClients,completedAppointments,totalAppointments,newClients,existingClients,oneshotClients,oneshotClientsAll,averageTransactions,occupancy,const DeepCollectionEquality().hash(incomeByDay));

@override
String toString() {
  return 'AnalyticsComparisonPeriod(totalIncome: $totalIncome, performance: $performance, payDue: $payDue, totalClients: $totalClients, completedAppointments: $completedAppointments, totalAppointments: $totalAppointments, newClients: $newClients, existingClients: $existingClients, oneshotClients: $oneshotClients, oneshotClientsAll: $oneshotClientsAll, averageTransactions: $averageTransactions, occupancy: $occupancy, incomeByDay: $incomeByDay)';
}


}

/// @nodoc
abstract mixin class $AnalyticsComparisonPeriodCopyWith<$Res>  {
  factory $AnalyticsComparisonPeriodCopyWith(AnalyticsComparisonPeriod value, $Res Function(AnalyticsComparisonPeriod) _then) = _$AnalyticsComparisonPeriodCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'total_income') double? totalIncome, double? performance,@JsonKey(name: 'pay_due') double? payDue,@JsonKey(name: 'total_clients') int? totalClients,@JsonKey(name: 'completed_appointments') int? completedAppointments,@JsonKey(name: 'total_appointments') int? totalAppointments,@JsonKey(name: 'new_clients') int? newClients,@JsonKey(name: 'existing_clients') int? existingClients,@JsonKey(name: 'oneshot_clients') int? oneshotClients,@JsonKey(name: 'oneshot_clients_all') int? oneshotClientsAll,@JsonKey(name: 'average_transactions') double? averageTransactions, double? occupancy,@JsonKey(name: 'income_by_day') List<AnalyticsIncomeByDay> incomeByDay
});




}
/// @nodoc
class _$AnalyticsComparisonPeriodCopyWithImpl<$Res>
    implements $AnalyticsComparisonPeriodCopyWith<$Res> {
  _$AnalyticsComparisonPeriodCopyWithImpl(this._self, this._then);

  final AnalyticsComparisonPeriod _self;
  final $Res Function(AnalyticsComparisonPeriod) _then;

/// Create a copy of AnalyticsComparisonPeriod
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalIncome = freezed,Object? performance = freezed,Object? payDue = freezed,Object? totalClients = freezed,Object? completedAppointments = freezed,Object? totalAppointments = freezed,Object? newClients = freezed,Object? existingClients = freezed,Object? oneshotClients = freezed,Object? oneshotClientsAll = freezed,Object? averageTransactions = freezed,Object? occupancy = freezed,Object? incomeByDay = null,}) {
  return _then(_self.copyWith(
totalIncome: freezed == totalIncome ? _self.totalIncome : totalIncome // ignore: cast_nullable_to_non_nullable
as double?,performance: freezed == performance ? _self.performance : performance // ignore: cast_nullable_to_non_nullable
as double?,payDue: freezed == payDue ? _self.payDue : payDue // ignore: cast_nullable_to_non_nullable
as double?,totalClients: freezed == totalClients ? _self.totalClients : totalClients // ignore: cast_nullable_to_non_nullable
as int?,completedAppointments: freezed == completedAppointments ? _self.completedAppointments : completedAppointments // ignore: cast_nullable_to_non_nullable
as int?,totalAppointments: freezed == totalAppointments ? _self.totalAppointments : totalAppointments // ignore: cast_nullable_to_non_nullable
as int?,newClients: freezed == newClients ? _self.newClients : newClients // ignore: cast_nullable_to_non_nullable
as int?,existingClients: freezed == existingClients ? _self.existingClients : existingClients // ignore: cast_nullable_to_non_nullable
as int?,oneshotClients: freezed == oneshotClients ? _self.oneshotClients : oneshotClients // ignore: cast_nullable_to_non_nullable
as int?,oneshotClientsAll: freezed == oneshotClientsAll ? _self.oneshotClientsAll : oneshotClientsAll // ignore: cast_nullable_to_non_nullable
as int?,averageTransactions: freezed == averageTransactions ? _self.averageTransactions : averageTransactions // ignore: cast_nullable_to_non_nullable
as double?,occupancy: freezed == occupancy ? _self.occupancy : occupancy // ignore: cast_nullable_to_non_nullable
as double?,incomeByDay: null == incomeByDay ? _self.incomeByDay : incomeByDay // ignore: cast_nullable_to_non_nullable
as List<AnalyticsIncomeByDay>,
  ));
}

}


/// Adds pattern-matching-related methods to [AnalyticsComparisonPeriod].
extension AnalyticsComparisonPeriodPatterns on AnalyticsComparisonPeriod {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AnalyticsComparisonPeriod value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AnalyticsComparisonPeriod() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AnalyticsComparisonPeriod value)  $default,){
final _that = this;
switch (_that) {
case _AnalyticsComparisonPeriod():
return $default(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AnalyticsComparisonPeriod value)?  $default,){
final _that = this;
switch (_that) {
case _AnalyticsComparisonPeriod() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'total_income')  double? totalIncome,  double? performance, @JsonKey(name: 'pay_due')  double? payDue, @JsonKey(name: 'total_clients')  int? totalClients, @JsonKey(name: 'completed_appointments')  int? completedAppointments, @JsonKey(name: 'total_appointments')  int? totalAppointments, @JsonKey(name: 'new_clients')  int? newClients, @JsonKey(name: 'existing_clients')  int? existingClients, @JsonKey(name: 'oneshot_clients')  int? oneshotClients, @JsonKey(name: 'oneshot_clients_all')  int? oneshotClientsAll, @JsonKey(name: 'average_transactions')  double? averageTransactions,  double? occupancy, @JsonKey(name: 'income_by_day')  List<AnalyticsIncomeByDay> incomeByDay)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AnalyticsComparisonPeriod() when $default != null:
return $default(_that.totalIncome,_that.performance,_that.payDue,_that.totalClients,_that.completedAppointments,_that.totalAppointments,_that.newClients,_that.existingClients,_that.oneshotClients,_that.oneshotClientsAll,_that.averageTransactions,_that.occupancy,_that.incomeByDay);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'total_income')  double? totalIncome,  double? performance, @JsonKey(name: 'pay_due')  double? payDue, @JsonKey(name: 'total_clients')  int? totalClients, @JsonKey(name: 'completed_appointments')  int? completedAppointments, @JsonKey(name: 'total_appointments')  int? totalAppointments, @JsonKey(name: 'new_clients')  int? newClients, @JsonKey(name: 'existing_clients')  int? existingClients, @JsonKey(name: 'oneshot_clients')  int? oneshotClients, @JsonKey(name: 'oneshot_clients_all')  int? oneshotClientsAll, @JsonKey(name: 'average_transactions')  double? averageTransactions,  double? occupancy, @JsonKey(name: 'income_by_day')  List<AnalyticsIncomeByDay> incomeByDay)  $default,) {final _that = this;
switch (_that) {
case _AnalyticsComparisonPeriod():
return $default(_that.totalIncome,_that.performance,_that.payDue,_that.totalClients,_that.completedAppointments,_that.totalAppointments,_that.newClients,_that.existingClients,_that.oneshotClients,_that.oneshotClientsAll,_that.averageTransactions,_that.occupancy,_that.incomeByDay);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'total_income')  double? totalIncome,  double? performance, @JsonKey(name: 'pay_due')  double? payDue, @JsonKey(name: 'total_clients')  int? totalClients, @JsonKey(name: 'completed_appointments')  int? completedAppointments, @JsonKey(name: 'total_appointments')  int? totalAppointments, @JsonKey(name: 'new_clients')  int? newClients, @JsonKey(name: 'existing_clients')  int? existingClients, @JsonKey(name: 'oneshot_clients')  int? oneshotClients, @JsonKey(name: 'oneshot_clients_all')  int? oneshotClientsAll, @JsonKey(name: 'average_transactions')  double? averageTransactions,  double? occupancy, @JsonKey(name: 'income_by_day')  List<AnalyticsIncomeByDay> incomeByDay)?  $default,) {final _that = this;
switch (_that) {
case _AnalyticsComparisonPeriod() when $default != null:
return $default(_that.totalIncome,_that.performance,_that.payDue,_that.totalClients,_that.completedAppointments,_that.totalAppointments,_that.newClients,_that.existingClients,_that.oneshotClients,_that.oneshotClientsAll,_that.averageTransactions,_that.occupancy,_that.incomeByDay);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AnalyticsComparisonPeriod implements AnalyticsComparisonPeriod {
  const _AnalyticsComparisonPeriod({@JsonKey(name: 'total_income') this.totalIncome, this.performance, @JsonKey(name: 'pay_due') this.payDue, @JsonKey(name: 'total_clients') this.totalClients, @JsonKey(name: 'completed_appointments') this.completedAppointments, @JsonKey(name: 'total_appointments') this.totalAppointments, @JsonKey(name: 'new_clients') this.newClients, @JsonKey(name: 'existing_clients') this.existingClients, @JsonKey(name: 'oneshot_clients') this.oneshotClients, @JsonKey(name: 'oneshot_clients_all') this.oneshotClientsAll, @JsonKey(name: 'average_transactions') this.averageTransactions, this.occupancy, @JsonKey(name: 'income_by_day') final  List<AnalyticsIncomeByDay> incomeByDay = const []}): _incomeByDay = incomeByDay;
  factory _AnalyticsComparisonPeriod.fromJson(Map<String, dynamic> json) => _$AnalyticsComparisonPeriodFromJson(json);

@override@JsonKey(name: 'total_income') final  double? totalIncome;
@override final  double? performance;
@override@JsonKey(name: 'pay_due') final  double? payDue;
@override@JsonKey(name: 'total_clients') final  int? totalClients;
@override@JsonKey(name: 'completed_appointments') final  int? completedAppointments;
@override@JsonKey(name: 'total_appointments') final  int? totalAppointments;
@override@JsonKey(name: 'new_clients') final  int? newClients;
@override@JsonKey(name: 'existing_clients') final  int? existingClients;
@override@JsonKey(name: 'oneshot_clients') final  int? oneshotClients;
@override@JsonKey(name: 'oneshot_clients_all') final  int? oneshotClientsAll;
@override@JsonKey(name: 'average_transactions') final  double? averageTransactions;
@override final  double? occupancy;
 final  List<AnalyticsIncomeByDay> _incomeByDay;
@override@JsonKey(name: 'income_by_day') List<AnalyticsIncomeByDay> get incomeByDay {
  if (_incomeByDay is EqualUnmodifiableListView) return _incomeByDay;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_incomeByDay);
}


/// Create a copy of AnalyticsComparisonPeriod
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AnalyticsComparisonPeriodCopyWith<_AnalyticsComparisonPeriod> get copyWith => __$AnalyticsComparisonPeriodCopyWithImpl<_AnalyticsComparisonPeriod>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AnalyticsComparisonPeriodToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AnalyticsComparisonPeriod&&(identical(other.totalIncome, totalIncome) || other.totalIncome == totalIncome)&&(identical(other.performance, performance) || other.performance == performance)&&(identical(other.payDue, payDue) || other.payDue == payDue)&&(identical(other.totalClients, totalClients) || other.totalClients == totalClients)&&(identical(other.completedAppointments, completedAppointments) || other.completedAppointments == completedAppointments)&&(identical(other.totalAppointments, totalAppointments) || other.totalAppointments == totalAppointments)&&(identical(other.newClients, newClients) || other.newClients == newClients)&&(identical(other.existingClients, existingClients) || other.existingClients == existingClients)&&(identical(other.oneshotClients, oneshotClients) || other.oneshotClients == oneshotClients)&&(identical(other.oneshotClientsAll, oneshotClientsAll) || other.oneshotClientsAll == oneshotClientsAll)&&(identical(other.averageTransactions, averageTransactions) || other.averageTransactions == averageTransactions)&&(identical(other.occupancy, occupancy) || other.occupancy == occupancy)&&const DeepCollectionEquality().equals(other._incomeByDay, _incomeByDay));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalIncome,performance,payDue,totalClients,completedAppointments,totalAppointments,newClients,existingClients,oneshotClients,oneshotClientsAll,averageTransactions,occupancy,const DeepCollectionEquality().hash(_incomeByDay));

@override
String toString() {
  return 'AnalyticsComparisonPeriod(totalIncome: $totalIncome, performance: $performance, payDue: $payDue, totalClients: $totalClients, completedAppointments: $completedAppointments, totalAppointments: $totalAppointments, newClients: $newClients, existingClients: $existingClients, oneshotClients: $oneshotClients, oneshotClientsAll: $oneshotClientsAll, averageTransactions: $averageTransactions, occupancy: $occupancy, incomeByDay: $incomeByDay)';
}


}

/// @nodoc
abstract mixin class _$AnalyticsComparisonPeriodCopyWith<$Res> implements $AnalyticsComparisonPeriodCopyWith<$Res> {
  factory _$AnalyticsComparisonPeriodCopyWith(_AnalyticsComparisonPeriod value, $Res Function(_AnalyticsComparisonPeriod) _then) = __$AnalyticsComparisonPeriodCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'total_income') double? totalIncome, double? performance,@JsonKey(name: 'pay_due') double? payDue,@JsonKey(name: 'total_clients') int? totalClients,@JsonKey(name: 'completed_appointments') int? completedAppointments,@JsonKey(name: 'total_appointments') int? totalAppointments,@JsonKey(name: 'new_clients') int? newClients,@JsonKey(name: 'existing_clients') int? existingClients,@JsonKey(name: 'oneshot_clients') int? oneshotClients,@JsonKey(name: 'oneshot_clients_all') int? oneshotClientsAll,@JsonKey(name: 'average_transactions') double? averageTransactions, double? occupancy,@JsonKey(name: 'income_by_day') List<AnalyticsIncomeByDay> incomeByDay
});




}
/// @nodoc
class __$AnalyticsComparisonPeriodCopyWithImpl<$Res>
    implements _$AnalyticsComparisonPeriodCopyWith<$Res> {
  __$AnalyticsComparisonPeriodCopyWithImpl(this._self, this._then);

  final _AnalyticsComparisonPeriod _self;
  final $Res Function(_AnalyticsComparisonPeriod) _then;

/// Create a copy of AnalyticsComparisonPeriod
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalIncome = freezed,Object? performance = freezed,Object? payDue = freezed,Object? totalClients = freezed,Object? completedAppointments = freezed,Object? totalAppointments = freezed,Object? newClients = freezed,Object? existingClients = freezed,Object? oneshotClients = freezed,Object? oneshotClientsAll = freezed,Object? averageTransactions = freezed,Object? occupancy = freezed,Object? incomeByDay = null,}) {
  return _then(_AnalyticsComparisonPeriod(
totalIncome: freezed == totalIncome ? _self.totalIncome : totalIncome // ignore: cast_nullable_to_non_nullable
as double?,performance: freezed == performance ? _self.performance : performance // ignore: cast_nullable_to_non_nullable
as double?,payDue: freezed == payDue ? _self.payDue : payDue // ignore: cast_nullable_to_non_nullable
as double?,totalClients: freezed == totalClients ? _self.totalClients : totalClients // ignore: cast_nullable_to_non_nullable
as int?,completedAppointments: freezed == completedAppointments ? _self.completedAppointments : completedAppointments // ignore: cast_nullable_to_non_nullable
as int?,totalAppointments: freezed == totalAppointments ? _self.totalAppointments : totalAppointments // ignore: cast_nullable_to_non_nullable
as int?,newClients: freezed == newClients ? _self.newClients : newClients // ignore: cast_nullable_to_non_nullable
as int?,existingClients: freezed == existingClients ? _self.existingClients : existingClients // ignore: cast_nullable_to_non_nullable
as int?,oneshotClients: freezed == oneshotClients ? _self.oneshotClients : oneshotClients // ignore: cast_nullable_to_non_nullable
as int?,oneshotClientsAll: freezed == oneshotClientsAll ? _self.oneshotClientsAll : oneshotClientsAll // ignore: cast_nullable_to_non_nullable
as int?,averageTransactions: freezed == averageTransactions ? _self.averageTransactions : averageTransactions // ignore: cast_nullable_to_non_nullable
as double?,occupancy: freezed == occupancy ? _self.occupancy : occupancy // ignore: cast_nullable_to_non_nullable
as double?,incomeByDay: null == incomeByDay ? _self._incomeByDay : incomeByDay // ignore: cast_nullable_to_non_nullable
as List<AnalyticsIncomeByDay>,
  ));
}


}


/// @nodoc
mixin _$AnalyticsGlobal {

 List<AnalyticsGlobalService> get services; AnalyticsGlobalClients get clients; Map<String, dynamic> get sources;
/// Create a copy of AnalyticsGlobal
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AnalyticsGlobalCopyWith<AnalyticsGlobal> get copyWith => _$AnalyticsGlobalCopyWithImpl<AnalyticsGlobal>(this as AnalyticsGlobal, _$identity);

  /// Serializes this AnalyticsGlobal to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnalyticsGlobal&&const DeepCollectionEquality().equals(other.services, services)&&(identical(other.clients, clients) || other.clients == clients)&&const DeepCollectionEquality().equals(other.sources, sources));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(services),clients,const DeepCollectionEquality().hash(sources));

@override
String toString() {
  return 'AnalyticsGlobal(services: $services, clients: $clients, sources: $sources)';
}


}

/// @nodoc
abstract mixin class $AnalyticsGlobalCopyWith<$Res>  {
  factory $AnalyticsGlobalCopyWith(AnalyticsGlobal value, $Res Function(AnalyticsGlobal) _then) = _$AnalyticsGlobalCopyWithImpl;
@useResult
$Res call({
 List<AnalyticsGlobalService> services, AnalyticsGlobalClients clients, Map<String, dynamic> sources
});


$AnalyticsGlobalClientsCopyWith<$Res> get clients;

}
/// @nodoc
class _$AnalyticsGlobalCopyWithImpl<$Res>
    implements $AnalyticsGlobalCopyWith<$Res> {
  _$AnalyticsGlobalCopyWithImpl(this._self, this._then);

  final AnalyticsGlobal _self;
  final $Res Function(AnalyticsGlobal) _then;

/// Create a copy of AnalyticsGlobal
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? services = null,Object? clients = null,Object? sources = null,}) {
  return _then(_self.copyWith(
services: null == services ? _self.services : services // ignore: cast_nullable_to_non_nullable
as List<AnalyticsGlobalService>,clients: null == clients ? _self.clients : clients // ignore: cast_nullable_to_non_nullable
as AnalyticsGlobalClients,sources: null == sources ? _self.sources : sources // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}
/// Create a copy of AnalyticsGlobal
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AnalyticsGlobalClientsCopyWith<$Res> get clients {
  
  return $AnalyticsGlobalClientsCopyWith<$Res>(_self.clients, (value) {
    return _then(_self.copyWith(clients: value));
  });
}
}


/// Adds pattern-matching-related methods to [AnalyticsGlobal].
extension AnalyticsGlobalPatterns on AnalyticsGlobal {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AnalyticsGlobal value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AnalyticsGlobal() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AnalyticsGlobal value)  $default,){
final _that = this;
switch (_that) {
case _AnalyticsGlobal():
return $default(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AnalyticsGlobal value)?  $default,){
final _that = this;
switch (_that) {
case _AnalyticsGlobal() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<AnalyticsGlobalService> services,  AnalyticsGlobalClients clients,  Map<String, dynamic> sources)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AnalyticsGlobal() when $default != null:
return $default(_that.services,_that.clients,_that.sources);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<AnalyticsGlobalService> services,  AnalyticsGlobalClients clients,  Map<String, dynamic> sources)  $default,) {final _that = this;
switch (_that) {
case _AnalyticsGlobal():
return $default(_that.services,_that.clients,_that.sources);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<AnalyticsGlobalService> services,  AnalyticsGlobalClients clients,  Map<String, dynamic> sources)?  $default,) {final _that = this;
switch (_that) {
case _AnalyticsGlobal() when $default != null:
return $default(_that.services,_that.clients,_that.sources);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AnalyticsGlobal implements AnalyticsGlobal {
  const _AnalyticsGlobal({final  List<AnalyticsGlobalService> services = const [], this.clients = const AnalyticsGlobalClients(), final  Map<String, dynamic> sources = const {}}): _services = services,_sources = sources;
  factory _AnalyticsGlobal.fromJson(Map<String, dynamic> json) => _$AnalyticsGlobalFromJson(json);

 final  List<AnalyticsGlobalService> _services;
@override@JsonKey() List<AnalyticsGlobalService> get services {
  if (_services is EqualUnmodifiableListView) return _services;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_services);
}

@override@JsonKey() final  AnalyticsGlobalClients clients;
 final  Map<String, dynamic> _sources;
@override@JsonKey() Map<String, dynamic> get sources {
  if (_sources is EqualUnmodifiableMapView) return _sources;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_sources);
}


/// Create a copy of AnalyticsGlobal
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AnalyticsGlobalCopyWith<_AnalyticsGlobal> get copyWith => __$AnalyticsGlobalCopyWithImpl<_AnalyticsGlobal>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AnalyticsGlobalToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AnalyticsGlobal&&const DeepCollectionEquality().equals(other._services, _services)&&(identical(other.clients, clients) || other.clients == clients)&&const DeepCollectionEquality().equals(other._sources, _sources));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_services),clients,const DeepCollectionEquality().hash(_sources));

@override
String toString() {
  return 'AnalyticsGlobal(services: $services, clients: $clients, sources: $sources)';
}


}

/// @nodoc
abstract mixin class _$AnalyticsGlobalCopyWith<$Res> implements $AnalyticsGlobalCopyWith<$Res> {
  factory _$AnalyticsGlobalCopyWith(_AnalyticsGlobal value, $Res Function(_AnalyticsGlobal) _then) = __$AnalyticsGlobalCopyWithImpl;
@override @useResult
$Res call({
 List<AnalyticsGlobalService> services, AnalyticsGlobalClients clients, Map<String, dynamic> sources
});


@override $AnalyticsGlobalClientsCopyWith<$Res> get clients;

}
/// @nodoc
class __$AnalyticsGlobalCopyWithImpl<$Res>
    implements _$AnalyticsGlobalCopyWith<$Res> {
  __$AnalyticsGlobalCopyWithImpl(this._self, this._then);

  final _AnalyticsGlobal _self;
  final $Res Function(_AnalyticsGlobal) _then;

/// Create a copy of AnalyticsGlobal
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? services = null,Object? clients = null,Object? sources = null,}) {
  return _then(_AnalyticsGlobal(
services: null == services ? _self._services : services // ignore: cast_nullable_to_non_nullable
as List<AnalyticsGlobalService>,clients: null == clients ? _self.clients : clients // ignore: cast_nullable_to_non_nullable
as AnalyticsGlobalClients,sources: null == sources ? _self._sources : sources // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}

/// Create a copy of AnalyticsGlobal
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AnalyticsGlobalClientsCopyWith<$Res> get clients {
  
  return $AnalyticsGlobalClientsCopyWith<$Res>(_self.clients, (value) {
    return _then(_self.copyWith(clients: value));
  });
}
}


/// @nodoc
mixin _$AnalyticsGlobalClients {

@JsonKey(name: 'average_age') double? get averageAge; int get total;@JsonKey(name: 'groups_map') Map<String, AnalyticsClientAgeGroup> get groupsMap;
/// Create a copy of AnalyticsGlobalClients
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AnalyticsGlobalClientsCopyWith<AnalyticsGlobalClients> get copyWith => _$AnalyticsGlobalClientsCopyWithImpl<AnalyticsGlobalClients>(this as AnalyticsGlobalClients, _$identity);

  /// Serializes this AnalyticsGlobalClients to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnalyticsGlobalClients&&(identical(other.averageAge, averageAge) || other.averageAge == averageAge)&&(identical(other.total, total) || other.total == total)&&const DeepCollectionEquality().equals(other.groupsMap, groupsMap));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,averageAge,total,const DeepCollectionEquality().hash(groupsMap));

@override
String toString() {
  return 'AnalyticsGlobalClients(averageAge: $averageAge, total: $total, groupsMap: $groupsMap)';
}


}

/// @nodoc
abstract mixin class $AnalyticsGlobalClientsCopyWith<$Res>  {
  factory $AnalyticsGlobalClientsCopyWith(AnalyticsGlobalClients value, $Res Function(AnalyticsGlobalClients) _then) = _$AnalyticsGlobalClientsCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'average_age') double? averageAge, int total,@JsonKey(name: 'groups_map') Map<String, AnalyticsClientAgeGroup> groupsMap
});




}
/// @nodoc
class _$AnalyticsGlobalClientsCopyWithImpl<$Res>
    implements $AnalyticsGlobalClientsCopyWith<$Res> {
  _$AnalyticsGlobalClientsCopyWithImpl(this._self, this._then);

  final AnalyticsGlobalClients _self;
  final $Res Function(AnalyticsGlobalClients) _then;

/// Create a copy of AnalyticsGlobalClients
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? averageAge = freezed,Object? total = null,Object? groupsMap = null,}) {
  return _then(_self.copyWith(
averageAge: freezed == averageAge ? _self.averageAge : averageAge // ignore: cast_nullable_to_non_nullable
as double?,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,groupsMap: null == groupsMap ? _self.groupsMap : groupsMap // ignore: cast_nullable_to_non_nullable
as Map<String, AnalyticsClientAgeGroup>,
  ));
}

}


/// Adds pattern-matching-related methods to [AnalyticsGlobalClients].
extension AnalyticsGlobalClientsPatterns on AnalyticsGlobalClients {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AnalyticsGlobalClients value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AnalyticsGlobalClients() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AnalyticsGlobalClients value)  $default,){
final _that = this;
switch (_that) {
case _AnalyticsGlobalClients():
return $default(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AnalyticsGlobalClients value)?  $default,){
final _that = this;
switch (_that) {
case _AnalyticsGlobalClients() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'average_age')  double? averageAge,  int total, @JsonKey(name: 'groups_map')  Map<String, AnalyticsClientAgeGroup> groupsMap)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AnalyticsGlobalClients() when $default != null:
return $default(_that.averageAge,_that.total,_that.groupsMap);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'average_age')  double? averageAge,  int total, @JsonKey(name: 'groups_map')  Map<String, AnalyticsClientAgeGroup> groupsMap)  $default,) {final _that = this;
switch (_that) {
case _AnalyticsGlobalClients():
return $default(_that.averageAge,_that.total,_that.groupsMap);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'average_age')  double? averageAge,  int total, @JsonKey(name: 'groups_map')  Map<String, AnalyticsClientAgeGroup> groupsMap)?  $default,) {final _that = this;
switch (_that) {
case _AnalyticsGlobalClients() when $default != null:
return $default(_that.averageAge,_that.total,_that.groupsMap);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AnalyticsGlobalClients extends AnalyticsGlobalClients {
  const _AnalyticsGlobalClients({@JsonKey(name: 'average_age') this.averageAge, this.total = 0, @JsonKey(name: 'groups_map') final  Map<String, AnalyticsClientAgeGroup> groupsMap = const {}}): _groupsMap = groupsMap,super._();
  factory _AnalyticsGlobalClients.fromJson(Map<String, dynamic> json) => _$AnalyticsGlobalClientsFromJson(json);

@override@JsonKey(name: 'average_age') final  double? averageAge;
@override@JsonKey() final  int total;
 final  Map<String, AnalyticsClientAgeGroup> _groupsMap;
@override@JsonKey(name: 'groups_map') Map<String, AnalyticsClientAgeGroup> get groupsMap {
  if (_groupsMap is EqualUnmodifiableMapView) return _groupsMap;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_groupsMap);
}


/// Create a copy of AnalyticsGlobalClients
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AnalyticsGlobalClientsCopyWith<_AnalyticsGlobalClients> get copyWith => __$AnalyticsGlobalClientsCopyWithImpl<_AnalyticsGlobalClients>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AnalyticsGlobalClientsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AnalyticsGlobalClients&&(identical(other.averageAge, averageAge) || other.averageAge == averageAge)&&(identical(other.total, total) || other.total == total)&&const DeepCollectionEquality().equals(other._groupsMap, _groupsMap));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,averageAge,total,const DeepCollectionEquality().hash(_groupsMap));

@override
String toString() {
  return 'AnalyticsGlobalClients(averageAge: $averageAge, total: $total, groupsMap: $groupsMap)';
}


}

/// @nodoc
abstract mixin class _$AnalyticsGlobalClientsCopyWith<$Res> implements $AnalyticsGlobalClientsCopyWith<$Res> {
  factory _$AnalyticsGlobalClientsCopyWith(_AnalyticsGlobalClients value, $Res Function(_AnalyticsGlobalClients) _then) = __$AnalyticsGlobalClientsCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'average_age') double? averageAge, int total,@JsonKey(name: 'groups_map') Map<String, AnalyticsClientAgeGroup> groupsMap
});




}
/// @nodoc
class __$AnalyticsGlobalClientsCopyWithImpl<$Res>
    implements _$AnalyticsGlobalClientsCopyWith<$Res> {
  __$AnalyticsGlobalClientsCopyWithImpl(this._self, this._then);

  final _AnalyticsGlobalClients _self;
  final $Res Function(_AnalyticsGlobalClients) _then;

/// Create a copy of AnalyticsGlobalClients
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? averageAge = freezed,Object? total = null,Object? groupsMap = null,}) {
  return _then(_AnalyticsGlobalClients(
averageAge: freezed == averageAge ? _self.averageAge : averageAge // ignore: cast_nullable_to_non_nullable
as double?,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,groupsMap: null == groupsMap ? _self._groupsMap : groupsMap // ignore: cast_nullable_to_non_nullable
as Map<String, AnalyticsClientAgeGroup>,
  ));
}


}


/// @nodoc
mixin _$AnalyticsClientAgeGroup {

 int get male; int get female;
/// Create a copy of AnalyticsClientAgeGroup
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AnalyticsClientAgeGroupCopyWith<AnalyticsClientAgeGroup> get copyWith => _$AnalyticsClientAgeGroupCopyWithImpl<AnalyticsClientAgeGroup>(this as AnalyticsClientAgeGroup, _$identity);

  /// Serializes this AnalyticsClientAgeGroup to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnalyticsClientAgeGroup&&(identical(other.male, male) || other.male == male)&&(identical(other.female, female) || other.female == female));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,male,female);

@override
String toString() {
  return 'AnalyticsClientAgeGroup(male: $male, female: $female)';
}


}

/// @nodoc
abstract mixin class $AnalyticsClientAgeGroupCopyWith<$Res>  {
  factory $AnalyticsClientAgeGroupCopyWith(AnalyticsClientAgeGroup value, $Res Function(AnalyticsClientAgeGroup) _then) = _$AnalyticsClientAgeGroupCopyWithImpl;
@useResult
$Res call({
 int male, int female
});




}
/// @nodoc
class _$AnalyticsClientAgeGroupCopyWithImpl<$Res>
    implements $AnalyticsClientAgeGroupCopyWith<$Res> {
  _$AnalyticsClientAgeGroupCopyWithImpl(this._self, this._then);

  final AnalyticsClientAgeGroup _self;
  final $Res Function(AnalyticsClientAgeGroup) _then;

/// Create a copy of AnalyticsClientAgeGroup
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? male = null,Object? female = null,}) {
  return _then(_self.copyWith(
male: null == male ? _self.male : male // ignore: cast_nullable_to_non_nullable
as int,female: null == female ? _self.female : female // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [AnalyticsClientAgeGroup].
extension AnalyticsClientAgeGroupPatterns on AnalyticsClientAgeGroup {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AnalyticsClientAgeGroup value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AnalyticsClientAgeGroup() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AnalyticsClientAgeGroup value)  $default,){
final _that = this;
switch (_that) {
case _AnalyticsClientAgeGroup():
return $default(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AnalyticsClientAgeGroup value)?  $default,){
final _that = this;
switch (_that) {
case _AnalyticsClientAgeGroup() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int male,  int female)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AnalyticsClientAgeGroup() when $default != null:
return $default(_that.male,_that.female);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int male,  int female)  $default,) {final _that = this;
switch (_that) {
case _AnalyticsClientAgeGroup():
return $default(_that.male,_that.female);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int male,  int female)?  $default,) {final _that = this;
switch (_that) {
case _AnalyticsClientAgeGroup() when $default != null:
return $default(_that.male,_that.female);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AnalyticsClientAgeGroup implements AnalyticsClientAgeGroup {
  const _AnalyticsClientAgeGroup({this.male = 0, this.female = 0});
  factory _AnalyticsClientAgeGroup.fromJson(Map<String, dynamic> json) => _$AnalyticsClientAgeGroupFromJson(json);

@override@JsonKey() final  int male;
@override@JsonKey() final  int female;

/// Create a copy of AnalyticsClientAgeGroup
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AnalyticsClientAgeGroupCopyWith<_AnalyticsClientAgeGroup> get copyWith => __$AnalyticsClientAgeGroupCopyWithImpl<_AnalyticsClientAgeGroup>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AnalyticsClientAgeGroupToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AnalyticsClientAgeGroup&&(identical(other.male, male) || other.male == male)&&(identical(other.female, female) || other.female == female));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,male,female);

@override
String toString() {
  return 'AnalyticsClientAgeGroup(male: $male, female: $female)';
}


}

/// @nodoc
abstract mixin class _$AnalyticsClientAgeGroupCopyWith<$Res> implements $AnalyticsClientAgeGroupCopyWith<$Res> {
  factory _$AnalyticsClientAgeGroupCopyWith(_AnalyticsClientAgeGroup value, $Res Function(_AnalyticsClientAgeGroup) _then) = __$AnalyticsClientAgeGroupCopyWithImpl;
@override @useResult
$Res call({
 int male, int female
});




}
/// @nodoc
class __$AnalyticsClientAgeGroupCopyWithImpl<$Res>
    implements _$AnalyticsClientAgeGroupCopyWith<$Res> {
  __$AnalyticsClientAgeGroupCopyWithImpl(this._self, this._then);

  final _AnalyticsClientAgeGroup _self;
  final $Res Function(_AnalyticsClientAgeGroup) _then;

/// Create a copy of AnalyticsClientAgeGroup
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? male = null,Object? female = null,}) {
  return _then(_AnalyticsClientAgeGroup(
male: null == male ? _self.male : male // ignore: cast_nullable_to_non_nullable
as int,female: null == female ? _self.female : female // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$AnalyticsGlobalService {

 String? get name; String? get service; int get count; int get total;
/// Create a copy of AnalyticsGlobalService
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AnalyticsGlobalServiceCopyWith<AnalyticsGlobalService> get copyWith => _$AnalyticsGlobalServiceCopyWithImpl<AnalyticsGlobalService>(this as AnalyticsGlobalService, _$identity);

  /// Serializes this AnalyticsGlobalService to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnalyticsGlobalService&&(identical(other.name, name) || other.name == name)&&(identical(other.service, service) || other.service == service)&&(identical(other.count, count) || other.count == count)&&(identical(other.total, total) || other.total == total));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,service,count,total);

@override
String toString() {
  return 'AnalyticsGlobalService(name: $name, service: $service, count: $count, total: $total)';
}


}

/// @nodoc
abstract mixin class $AnalyticsGlobalServiceCopyWith<$Res>  {
  factory $AnalyticsGlobalServiceCopyWith(AnalyticsGlobalService value, $Res Function(AnalyticsGlobalService) _then) = _$AnalyticsGlobalServiceCopyWithImpl;
@useResult
$Res call({
 String? name, String? service, int count, int total
});




}
/// @nodoc
class _$AnalyticsGlobalServiceCopyWithImpl<$Res>
    implements $AnalyticsGlobalServiceCopyWith<$Res> {
  _$AnalyticsGlobalServiceCopyWithImpl(this._self, this._then);

  final AnalyticsGlobalService _self;
  final $Res Function(AnalyticsGlobalService) _then;

/// Create a copy of AnalyticsGlobalService
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = freezed,Object? service = freezed,Object? count = null,Object? total = null,}) {
  return _then(_self.copyWith(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,service: freezed == service ? _self.service : service // ignore: cast_nullable_to_non_nullable
as String?,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [AnalyticsGlobalService].
extension AnalyticsGlobalServicePatterns on AnalyticsGlobalService {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AnalyticsGlobalService value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AnalyticsGlobalService() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AnalyticsGlobalService value)  $default,){
final _that = this;
switch (_that) {
case _AnalyticsGlobalService():
return $default(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AnalyticsGlobalService value)?  $default,){
final _that = this;
switch (_that) {
case _AnalyticsGlobalService() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? name,  String? service,  int count,  int total)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AnalyticsGlobalService() when $default != null:
return $default(_that.name,_that.service,_that.count,_that.total);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? name,  String? service,  int count,  int total)  $default,) {final _that = this;
switch (_that) {
case _AnalyticsGlobalService():
return $default(_that.name,_that.service,_that.count,_that.total);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? name,  String? service,  int count,  int total)?  $default,) {final _that = this;
switch (_that) {
case _AnalyticsGlobalService() when $default != null:
return $default(_that.name,_that.service,_that.count,_that.total);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AnalyticsGlobalService extends AnalyticsGlobalService {
  const _AnalyticsGlobalService({this.name, this.service, this.count = 0, this.total = 0}): super._();
  factory _AnalyticsGlobalService.fromJson(Map<String, dynamic> json) => _$AnalyticsGlobalServiceFromJson(json);

@override final  String? name;
@override final  String? service;
@override@JsonKey() final  int count;
@override@JsonKey() final  int total;

/// Create a copy of AnalyticsGlobalService
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AnalyticsGlobalServiceCopyWith<_AnalyticsGlobalService> get copyWith => __$AnalyticsGlobalServiceCopyWithImpl<_AnalyticsGlobalService>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AnalyticsGlobalServiceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AnalyticsGlobalService&&(identical(other.name, name) || other.name == name)&&(identical(other.service, service) || other.service == service)&&(identical(other.count, count) || other.count == count)&&(identical(other.total, total) || other.total == total));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,service,count,total);

@override
String toString() {
  return 'AnalyticsGlobalService(name: $name, service: $service, count: $count, total: $total)';
}


}

/// @nodoc
abstract mixin class _$AnalyticsGlobalServiceCopyWith<$Res> implements $AnalyticsGlobalServiceCopyWith<$Res> {
  factory _$AnalyticsGlobalServiceCopyWith(_AnalyticsGlobalService value, $Res Function(_AnalyticsGlobalService) _then) = __$AnalyticsGlobalServiceCopyWithImpl;
@override @useResult
$Res call({
 String? name, String? service, int count, int total
});




}
/// @nodoc
class __$AnalyticsGlobalServiceCopyWithImpl<$Res>
    implements _$AnalyticsGlobalServiceCopyWith<$Res> {
  __$AnalyticsGlobalServiceCopyWithImpl(this._self, this._then);

  final _AnalyticsGlobalService _self;
  final $Res Function(_AnalyticsGlobalService) _then;

/// Create a copy of AnalyticsGlobalService
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = freezed,Object? service = freezed,Object? count = null,Object? total = null,}) {
  return _then(_AnalyticsGlobalService(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,service: freezed == service ? _self.service : service // ignore: cast_nullable_to_non_nullable
as String?,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$AnalyticsSpecialist {

 double? get performance;@JsonKey(name: 'pay_due') double? get payDue;
/// Create a copy of AnalyticsSpecialist
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AnalyticsSpecialistCopyWith<AnalyticsSpecialist> get copyWith => _$AnalyticsSpecialistCopyWithImpl<AnalyticsSpecialist>(this as AnalyticsSpecialist, _$identity);

  /// Serializes this AnalyticsSpecialist to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnalyticsSpecialist&&(identical(other.performance, performance) || other.performance == performance)&&(identical(other.payDue, payDue) || other.payDue == payDue));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,performance,payDue);

@override
String toString() {
  return 'AnalyticsSpecialist(performance: $performance, payDue: $payDue)';
}


}

/// @nodoc
abstract mixin class $AnalyticsSpecialistCopyWith<$Res>  {
  factory $AnalyticsSpecialistCopyWith(AnalyticsSpecialist value, $Res Function(AnalyticsSpecialist) _then) = _$AnalyticsSpecialistCopyWithImpl;
@useResult
$Res call({
 double? performance,@JsonKey(name: 'pay_due') double? payDue
});




}
/// @nodoc
class _$AnalyticsSpecialistCopyWithImpl<$Res>
    implements $AnalyticsSpecialistCopyWith<$Res> {
  _$AnalyticsSpecialistCopyWithImpl(this._self, this._then);

  final AnalyticsSpecialist _self;
  final $Res Function(AnalyticsSpecialist) _then;

/// Create a copy of AnalyticsSpecialist
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? performance = freezed,Object? payDue = freezed,}) {
  return _then(_self.copyWith(
performance: freezed == performance ? _self.performance : performance // ignore: cast_nullable_to_non_nullable
as double?,payDue: freezed == payDue ? _self.payDue : payDue // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [AnalyticsSpecialist].
extension AnalyticsSpecialistPatterns on AnalyticsSpecialist {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AnalyticsSpecialist value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AnalyticsSpecialist() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AnalyticsSpecialist value)  $default,){
final _that = this;
switch (_that) {
case _AnalyticsSpecialist():
return $default(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AnalyticsSpecialist value)?  $default,){
final _that = this;
switch (_that) {
case _AnalyticsSpecialist() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double? performance, @JsonKey(name: 'pay_due')  double? payDue)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AnalyticsSpecialist() when $default != null:
return $default(_that.performance,_that.payDue);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double? performance, @JsonKey(name: 'pay_due')  double? payDue)  $default,) {final _that = this;
switch (_that) {
case _AnalyticsSpecialist():
return $default(_that.performance,_that.payDue);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double? performance, @JsonKey(name: 'pay_due')  double? payDue)?  $default,) {final _that = this;
switch (_that) {
case _AnalyticsSpecialist() when $default != null:
return $default(_that.performance,_that.payDue);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AnalyticsSpecialist implements AnalyticsSpecialist {
  const _AnalyticsSpecialist({this.performance, @JsonKey(name: 'pay_due') this.payDue});
  factory _AnalyticsSpecialist.fromJson(Map<String, dynamic> json) => _$AnalyticsSpecialistFromJson(json);

@override final  double? performance;
@override@JsonKey(name: 'pay_due') final  double? payDue;

/// Create a copy of AnalyticsSpecialist
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AnalyticsSpecialistCopyWith<_AnalyticsSpecialist> get copyWith => __$AnalyticsSpecialistCopyWithImpl<_AnalyticsSpecialist>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AnalyticsSpecialistToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AnalyticsSpecialist&&(identical(other.performance, performance) || other.performance == performance)&&(identical(other.payDue, payDue) || other.payDue == payDue));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,performance,payDue);

@override
String toString() {
  return 'AnalyticsSpecialist(performance: $performance, payDue: $payDue)';
}


}

/// @nodoc
abstract mixin class _$AnalyticsSpecialistCopyWith<$Res> implements $AnalyticsSpecialistCopyWith<$Res> {
  factory _$AnalyticsSpecialistCopyWith(_AnalyticsSpecialist value, $Res Function(_AnalyticsSpecialist) _then) = __$AnalyticsSpecialistCopyWithImpl;
@override @useResult
$Res call({
 double? performance,@JsonKey(name: 'pay_due') double? payDue
});




}
/// @nodoc
class __$AnalyticsSpecialistCopyWithImpl<$Res>
    implements _$AnalyticsSpecialistCopyWith<$Res> {
  __$AnalyticsSpecialistCopyWithImpl(this._self, this._then);

  final _AnalyticsSpecialist _self;
  final $Res Function(_AnalyticsSpecialist) _then;

/// Create a copy of AnalyticsSpecialist
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? performance = freezed,Object? payDue = freezed,}) {
  return _then(_AnalyticsSpecialist(
performance: freezed == performance ? _self.performance : performance // ignore: cast_nullable_to_non_nullable
as double?,payDue: freezed == payDue ? _self.payDue : payDue // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}


/// @nodoc
mixin _$AnalyticsBenchmarking {

 Map<String, dynamic> get data;
/// Create a copy of AnalyticsBenchmarking
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AnalyticsBenchmarkingCopyWith<AnalyticsBenchmarking> get copyWith => _$AnalyticsBenchmarkingCopyWithImpl<AnalyticsBenchmarking>(this as AnalyticsBenchmarking, _$identity);

  /// Serializes this AnalyticsBenchmarking to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnalyticsBenchmarking&&const DeepCollectionEquality().equals(other.data, data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(data));

@override
String toString() {
  return 'AnalyticsBenchmarking(data: $data)';
}


}

/// @nodoc
abstract mixin class $AnalyticsBenchmarkingCopyWith<$Res>  {
  factory $AnalyticsBenchmarkingCopyWith(AnalyticsBenchmarking value, $Res Function(AnalyticsBenchmarking) _then) = _$AnalyticsBenchmarkingCopyWithImpl;
@useResult
$Res call({
 Map<String, dynamic> data
});




}
/// @nodoc
class _$AnalyticsBenchmarkingCopyWithImpl<$Res>
    implements $AnalyticsBenchmarkingCopyWith<$Res> {
  _$AnalyticsBenchmarkingCopyWithImpl(this._self, this._then);

  final AnalyticsBenchmarking _self;
  final $Res Function(AnalyticsBenchmarking) _then;

/// Create a copy of AnalyticsBenchmarking
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? data = null,}) {
  return _then(_self.copyWith(
data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}

}


/// Adds pattern-matching-related methods to [AnalyticsBenchmarking].
extension AnalyticsBenchmarkingPatterns on AnalyticsBenchmarking {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AnalyticsBenchmarking value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AnalyticsBenchmarking() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AnalyticsBenchmarking value)  $default,){
final _that = this;
switch (_that) {
case _AnalyticsBenchmarking():
return $default(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AnalyticsBenchmarking value)?  $default,){
final _that = this;
switch (_that) {
case _AnalyticsBenchmarking() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Map<String, dynamic> data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AnalyticsBenchmarking() when $default != null:
return $default(_that.data);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Map<String, dynamic> data)  $default,) {final _that = this;
switch (_that) {
case _AnalyticsBenchmarking():
return $default(_that.data);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Map<String, dynamic> data)?  $default,) {final _that = this;
switch (_that) {
case _AnalyticsBenchmarking() when $default != null:
return $default(_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AnalyticsBenchmarking implements AnalyticsBenchmarking {
  const _AnalyticsBenchmarking({final  Map<String, dynamic> data = const {}}): _data = data;
  factory _AnalyticsBenchmarking.fromJson(Map<String, dynamic> json) => _$AnalyticsBenchmarkingFromJson(json);

 final  Map<String, dynamic> _data;
@override@JsonKey() Map<String, dynamic> get data {
  if (_data is EqualUnmodifiableMapView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_data);
}


/// Create a copy of AnalyticsBenchmarking
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AnalyticsBenchmarkingCopyWith<_AnalyticsBenchmarking> get copyWith => __$AnalyticsBenchmarkingCopyWithImpl<_AnalyticsBenchmarking>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AnalyticsBenchmarkingToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AnalyticsBenchmarking&&const DeepCollectionEquality().equals(other._data, _data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_data));

@override
String toString() {
  return 'AnalyticsBenchmarking(data: $data)';
}


}

/// @nodoc
abstract mixin class _$AnalyticsBenchmarkingCopyWith<$Res> implements $AnalyticsBenchmarkingCopyWith<$Res> {
  factory _$AnalyticsBenchmarkingCopyWith(_AnalyticsBenchmarking value, $Res Function(_AnalyticsBenchmarking) _then) = __$AnalyticsBenchmarkingCopyWithImpl;
@override @useResult
$Res call({
 Map<String, dynamic> data
});




}
/// @nodoc
class __$AnalyticsBenchmarkingCopyWithImpl<$Res>
    implements _$AnalyticsBenchmarkingCopyWith<$Res> {
  __$AnalyticsBenchmarkingCopyWithImpl(this._self, this._then);

  final _AnalyticsBenchmarking _self;
  final $Res Function(_AnalyticsBenchmarking) _then;

/// Create a copy of AnalyticsBenchmarking
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? data = null,}) {
  return _then(_AnalyticsBenchmarking(
data: null == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}


}


/// @nodoc
mixin _$AnalyticsMeta {

 int? get role;@JsonKey(name: 'can_see_income') bool get canSeeIncome;@JsonKey(name: 'can_see_pay_due') bool get canSeePayDue;
/// Create a copy of AnalyticsMeta
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AnalyticsMetaCopyWith<AnalyticsMeta> get copyWith => _$AnalyticsMetaCopyWithImpl<AnalyticsMeta>(this as AnalyticsMeta, _$identity);

  /// Serializes this AnalyticsMeta to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnalyticsMeta&&(identical(other.role, role) || other.role == role)&&(identical(other.canSeeIncome, canSeeIncome) || other.canSeeIncome == canSeeIncome)&&(identical(other.canSeePayDue, canSeePayDue) || other.canSeePayDue == canSeePayDue));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,role,canSeeIncome,canSeePayDue);

@override
String toString() {
  return 'AnalyticsMeta(role: $role, canSeeIncome: $canSeeIncome, canSeePayDue: $canSeePayDue)';
}


}

/// @nodoc
abstract mixin class $AnalyticsMetaCopyWith<$Res>  {
  factory $AnalyticsMetaCopyWith(AnalyticsMeta value, $Res Function(AnalyticsMeta) _then) = _$AnalyticsMetaCopyWithImpl;
@useResult
$Res call({
 int? role,@JsonKey(name: 'can_see_income') bool canSeeIncome,@JsonKey(name: 'can_see_pay_due') bool canSeePayDue
});




}
/// @nodoc
class _$AnalyticsMetaCopyWithImpl<$Res>
    implements $AnalyticsMetaCopyWith<$Res> {
  _$AnalyticsMetaCopyWithImpl(this._self, this._then);

  final AnalyticsMeta _self;
  final $Res Function(AnalyticsMeta) _then;

/// Create a copy of AnalyticsMeta
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? role = freezed,Object? canSeeIncome = null,Object? canSeePayDue = null,}) {
  return _then(_self.copyWith(
role: freezed == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as int?,canSeeIncome: null == canSeeIncome ? _self.canSeeIncome : canSeeIncome // ignore: cast_nullable_to_non_nullable
as bool,canSeePayDue: null == canSeePayDue ? _self.canSeePayDue : canSeePayDue // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [AnalyticsMeta].
extension AnalyticsMetaPatterns on AnalyticsMeta {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AnalyticsMeta value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AnalyticsMeta() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AnalyticsMeta value)  $default,){
final _that = this;
switch (_that) {
case _AnalyticsMeta():
return $default(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AnalyticsMeta value)?  $default,){
final _that = this;
switch (_that) {
case _AnalyticsMeta() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? role, @JsonKey(name: 'can_see_income')  bool canSeeIncome, @JsonKey(name: 'can_see_pay_due')  bool canSeePayDue)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AnalyticsMeta() when $default != null:
return $default(_that.role,_that.canSeeIncome,_that.canSeePayDue);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? role, @JsonKey(name: 'can_see_income')  bool canSeeIncome, @JsonKey(name: 'can_see_pay_due')  bool canSeePayDue)  $default,) {final _that = this;
switch (_that) {
case _AnalyticsMeta():
return $default(_that.role,_that.canSeeIncome,_that.canSeePayDue);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? role, @JsonKey(name: 'can_see_income')  bool canSeeIncome, @JsonKey(name: 'can_see_pay_due')  bool canSeePayDue)?  $default,) {final _that = this;
switch (_that) {
case _AnalyticsMeta() when $default != null:
return $default(_that.role,_that.canSeeIncome,_that.canSeePayDue);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AnalyticsMeta implements AnalyticsMeta {
  const _AnalyticsMeta({this.role, @JsonKey(name: 'can_see_income') this.canSeeIncome = true, @JsonKey(name: 'can_see_pay_due') this.canSeePayDue = false});
  factory _AnalyticsMeta.fromJson(Map<String, dynamic> json) => _$AnalyticsMetaFromJson(json);

@override final  int? role;
@override@JsonKey(name: 'can_see_income') final  bool canSeeIncome;
@override@JsonKey(name: 'can_see_pay_due') final  bool canSeePayDue;

/// Create a copy of AnalyticsMeta
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AnalyticsMetaCopyWith<_AnalyticsMeta> get copyWith => __$AnalyticsMetaCopyWithImpl<_AnalyticsMeta>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AnalyticsMetaToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AnalyticsMeta&&(identical(other.role, role) || other.role == role)&&(identical(other.canSeeIncome, canSeeIncome) || other.canSeeIncome == canSeeIncome)&&(identical(other.canSeePayDue, canSeePayDue) || other.canSeePayDue == canSeePayDue));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,role,canSeeIncome,canSeePayDue);

@override
String toString() {
  return 'AnalyticsMeta(role: $role, canSeeIncome: $canSeeIncome, canSeePayDue: $canSeePayDue)';
}


}

/// @nodoc
abstract mixin class _$AnalyticsMetaCopyWith<$Res> implements $AnalyticsMetaCopyWith<$Res> {
  factory _$AnalyticsMetaCopyWith(_AnalyticsMeta value, $Res Function(_AnalyticsMeta) _then) = __$AnalyticsMetaCopyWithImpl;
@override @useResult
$Res call({
 int? role,@JsonKey(name: 'can_see_income') bool canSeeIncome,@JsonKey(name: 'can_see_pay_due') bool canSeePayDue
});




}
/// @nodoc
class __$AnalyticsMetaCopyWithImpl<$Res>
    implements _$AnalyticsMetaCopyWith<$Res> {
  __$AnalyticsMetaCopyWithImpl(this._self, this._then);

  final _AnalyticsMeta _self;
  final $Res Function(_AnalyticsMeta) _then;

/// Create a copy of AnalyticsMeta
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? role = freezed,Object? canSeeIncome = null,Object? canSeePayDue = null,}) {
  return _then(_AnalyticsMeta(
role: freezed == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as int?,canSeeIncome: null == canSeeIncome ? _self.canSeeIncome : canSeeIncome // ignore: cast_nullable_to_non_nullable
as bool,canSeePayDue: null == canSeePayDue ? _self.canSeePayDue : canSeePayDue // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
