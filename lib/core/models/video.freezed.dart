// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'video.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Video {

 String get id; String get url; String get title; String get category; String get author; String get caption; String get music; int get likes; int get comments; int get shares; int get views; Color get thumbColor; String? get logoUrl; bool get isLive;
/// Create a copy of Video
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VideoCopyWith<Video> get copyWith => _$VideoCopyWithImpl<Video>(this as Video, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Video&&(identical(other.id, id) || other.id == id)&&(identical(other.url, url) || other.url == url)&&(identical(other.title, title) || other.title == title)&&(identical(other.category, category) || other.category == category)&&(identical(other.author, author) || other.author == author)&&(identical(other.caption, caption) || other.caption == caption)&&(identical(other.music, music) || other.music == music)&&(identical(other.likes, likes) || other.likes == likes)&&(identical(other.comments, comments) || other.comments == comments)&&(identical(other.shares, shares) || other.shares == shares)&&(identical(other.views, views) || other.views == views)&&(identical(other.thumbColor, thumbColor) || other.thumbColor == thumbColor)&&(identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl)&&(identical(other.isLive, isLive) || other.isLive == isLive));
}


@override
int get hashCode => Object.hash(runtimeType,id,url,title,category,author,caption,music,likes,comments,shares,views,thumbColor,logoUrl,isLive);

@override
String toString() {
  return 'Video(id: $id, url: $url, title: $title, category: $category, author: $author, caption: $caption, music: $music, likes: $likes, comments: $comments, shares: $shares, views: $views, thumbColor: $thumbColor, logoUrl: $logoUrl, isLive: $isLive)';
}


}

/// @nodoc
abstract mixin class $VideoCopyWith<$Res>  {
  factory $VideoCopyWith(Video value, $Res Function(Video) _then) = _$VideoCopyWithImpl;
@useResult
$Res call({
 String id, String url, String title, String category, String author, String caption, String music, int likes, int comments, int shares, int views, Color thumbColor, String? logoUrl, bool isLive
});




}
/// @nodoc
class _$VideoCopyWithImpl<$Res>
    implements $VideoCopyWith<$Res> {
  _$VideoCopyWithImpl(this._self, this._then);

  final Video _self;
  final $Res Function(Video) _then;

/// Create a copy of Video
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? url = null,Object? title = null,Object? category = null,Object? author = null,Object? caption = null,Object? music = null,Object? likes = null,Object? comments = null,Object? shares = null,Object? views = null,Object? thumbColor = null,Object? logoUrl = freezed,Object? isLive = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String,caption: null == caption ? _self.caption : caption // ignore: cast_nullable_to_non_nullable
as String,music: null == music ? _self.music : music // ignore: cast_nullable_to_non_nullable
as String,likes: null == likes ? _self.likes : likes // ignore: cast_nullable_to_non_nullable
as int,comments: null == comments ? _self.comments : comments // ignore: cast_nullable_to_non_nullable
as int,shares: null == shares ? _self.shares : shares // ignore: cast_nullable_to_non_nullable
as int,views: null == views ? _self.views : views // ignore: cast_nullable_to_non_nullable
as int,thumbColor: null == thumbColor ? _self.thumbColor : thumbColor // ignore: cast_nullable_to_non_nullable
as Color,logoUrl: freezed == logoUrl ? _self.logoUrl : logoUrl // ignore: cast_nullable_to_non_nullable
as String?,isLive: null == isLive ? _self.isLive : isLive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Video].
extension VideoPatterns on Video {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Video value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Video() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Video value)  $default,){
final _that = this;
switch (_that) {
case _Video():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Video value)?  $default,){
final _that = this;
switch (_that) {
case _Video() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String url,  String title,  String category,  String author,  String caption,  String music,  int likes,  int comments,  int shares,  int views,  Color thumbColor,  String? logoUrl,  bool isLive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Video() when $default != null:
return $default(_that.id,_that.url,_that.title,_that.category,_that.author,_that.caption,_that.music,_that.likes,_that.comments,_that.shares,_that.views,_that.thumbColor,_that.logoUrl,_that.isLive);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String url,  String title,  String category,  String author,  String caption,  String music,  int likes,  int comments,  int shares,  int views,  Color thumbColor,  String? logoUrl,  bool isLive)  $default,) {final _that = this;
switch (_that) {
case _Video():
return $default(_that.id,_that.url,_that.title,_that.category,_that.author,_that.caption,_that.music,_that.likes,_that.comments,_that.shares,_that.views,_that.thumbColor,_that.logoUrl,_that.isLive);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String url,  String title,  String category,  String author,  String caption,  String music,  int likes,  int comments,  int shares,  int views,  Color thumbColor,  String? logoUrl,  bool isLive)?  $default,) {final _that = this;
switch (_that) {
case _Video() when $default != null:
return $default(_that.id,_that.url,_that.title,_that.category,_that.author,_that.caption,_that.music,_that.likes,_that.comments,_that.shares,_that.views,_that.thumbColor,_that.logoUrl,_that.isLive);case _:
  return null;

}
}

}

/// @nodoc


class _Video extends Video {
  const _Video({required this.id, required this.url, required this.title, required this.category, required this.author, required this.caption, required this.music, required this.likes, required this.comments, required this.shares, required this.views, required this.thumbColor, this.logoUrl, this.isLive = false}): super._();
  

@override final  String id;
@override final  String url;
@override final  String title;
@override final  String category;
@override final  String author;
@override final  String caption;
@override final  String music;
@override final  int likes;
@override final  int comments;
@override final  int shares;
@override final  int views;
@override final  Color thumbColor;
@override final  String? logoUrl;
@override@JsonKey() final  bool isLive;

/// Create a copy of Video
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VideoCopyWith<_Video> get copyWith => __$VideoCopyWithImpl<_Video>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Video&&(identical(other.id, id) || other.id == id)&&(identical(other.url, url) || other.url == url)&&(identical(other.title, title) || other.title == title)&&(identical(other.category, category) || other.category == category)&&(identical(other.author, author) || other.author == author)&&(identical(other.caption, caption) || other.caption == caption)&&(identical(other.music, music) || other.music == music)&&(identical(other.likes, likes) || other.likes == likes)&&(identical(other.comments, comments) || other.comments == comments)&&(identical(other.shares, shares) || other.shares == shares)&&(identical(other.views, views) || other.views == views)&&(identical(other.thumbColor, thumbColor) || other.thumbColor == thumbColor)&&(identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl)&&(identical(other.isLive, isLive) || other.isLive == isLive));
}


@override
int get hashCode => Object.hash(runtimeType,id,url,title,category,author,caption,music,likes,comments,shares,views,thumbColor,logoUrl,isLive);

@override
String toString() {
  return 'Video(id: $id, url: $url, title: $title, category: $category, author: $author, caption: $caption, music: $music, likes: $likes, comments: $comments, shares: $shares, views: $views, thumbColor: $thumbColor, logoUrl: $logoUrl, isLive: $isLive)';
}


}

/// @nodoc
abstract mixin class _$VideoCopyWith<$Res> implements $VideoCopyWith<$Res> {
  factory _$VideoCopyWith(_Video value, $Res Function(_Video) _then) = __$VideoCopyWithImpl;
@override @useResult
$Res call({
 String id, String url, String title, String category, String author, String caption, String music, int likes, int comments, int shares, int views, Color thumbColor, String? logoUrl, bool isLive
});




}
/// @nodoc
class __$VideoCopyWithImpl<$Res>
    implements _$VideoCopyWith<$Res> {
  __$VideoCopyWithImpl(this._self, this._then);

  final _Video _self;
  final $Res Function(_Video) _then;

/// Create a copy of Video
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? url = null,Object? title = null,Object? category = null,Object? author = null,Object? caption = null,Object? music = null,Object? likes = null,Object? comments = null,Object? shares = null,Object? views = null,Object? thumbColor = null,Object? logoUrl = freezed,Object? isLive = null,}) {
  return _then(_Video(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String,caption: null == caption ? _self.caption : caption // ignore: cast_nullable_to_non_nullable
as String,music: null == music ? _self.music : music // ignore: cast_nullable_to_non_nullable
as String,likes: null == likes ? _self.likes : likes // ignore: cast_nullable_to_non_nullable
as int,comments: null == comments ? _self.comments : comments // ignore: cast_nullable_to_non_nullable
as int,shares: null == shares ? _self.shares : shares // ignore: cast_nullable_to_non_nullable
as int,views: null == views ? _self.views : views // ignore: cast_nullable_to_non_nullable
as int,thumbColor: null == thumbColor ? _self.thumbColor : thumbColor // ignore: cast_nullable_to_non_nullable
as Color,logoUrl: freezed == logoUrl ? _self.logoUrl : logoUrl // ignore: cast_nullable_to_non_nullable
as String?,isLive: null == isLive ? _self.isLive : isLive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
