import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'package_info_provider.g.dart';

/// A reference to the [PackageInfo] provider.
@Riverpod(keepAlive: true)
PackageInfo packageInfo(Ref ref) => throw UnimplementedError();