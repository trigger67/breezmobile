import 'package:breez/services/breezlib/data/rpc.pb.dart';
import 'package:flutter/cupertino.dart';

Map<List<LNUrlPayMetadata>, Image> _imageCache = {};

extension LnurlMetadata on List<LNUrlPayMetadata> {
  String metadataText() {
    final textSource = firstWhere(
      (e) => e.hasDescription(),
      orElse: () => null,
    );
    if (textSource == null) return "";
    return textSource.description;
  }

  Image metadataImage() {
    if (_imageCache.containsKey(this)) {
      return _imageCache[this];
    }

    final imageSource = firstWhere(
      (e) => e.hasImage(),
      orElse: () => null,
    );

    if (imageSource == null) {
      _imageCache[this] = null;
      return null;
    }

    final image = Image.memory(imageSource.image.bytes);
    _imageCache[this] = image;
    return image;
  }
}
