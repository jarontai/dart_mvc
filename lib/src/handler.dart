// Copyright (c) 2015, Jaron Tai. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library dart_mvc.handler;

import 'dart:io';
import 'package:mime/mime.dart' as mime;

class RequestHandler {
  HttpRequest _req;
  String contentsFolder = 'static';

  RequestHandler(this._req);

  void handleStatic(String filePath) {
    final CONTENTS_PATH = Platform.script.resolve(contentsFolder).toFilePath();
    var file = new File(CONTENTS_PATH + filePath);
    if (file.existsSync()) {
      var mimeType = mime.lookupMimeType(file.path);
      _req.response.headers.set('Content-Type', mimeType);
      file.openRead().pipe(_req.response).catchError((e) {});
    } else {
      notFound();
    }
  }

  void handleDynamic() {
    _req.response
      ..headers.contentType = new ContentType("text", "plain", charset: "utf-8")
      ..write('Hello, Dynamic')
      ..close();
  }

  void notFound() {
    _req.response
      ..statusCode = HttpStatus.NOT_FOUND
      ..write('Not found!')
      ..close();
  }

  void renderView(String view) {
    // TODO - rendering process
  }
}
