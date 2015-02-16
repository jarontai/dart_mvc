// Copyright (c) 2015, Jaron Tai. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library dart_mvc.base;

import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:mime/mime.dart' as mime;

class MvcServer {

  String contentsFolder = 'contents';

  void run() {
    HttpServer.bind(InternetAddress.LOOPBACK_IP_V4, 8080).then((server) {
      print("Serving at ${server.address}:${server.port}");
      server.listen((HttpRequest request) {
        _serve(request);
      });
    });
  }

  void _serve(HttpRequest req) {
    var reqPath = req.uri.toString();
    print("Request: ${reqPath}  ${new DateTime.now()}");

    // skip favicon
    if (reqPath != '/favicon.ico') {
      var ext = path.extension(reqPath);
      if (ext.length > 0) {
        _handleContent(req, reqPath);
      } else {
        _handleDynamic(req);
      }
    }
  }

  void _handleContent(HttpRequest req, String filePath) {
    final CONTENTS_PATH = Platform.script.resolve(contentsFolder).toFilePath();
    var file = new File(CONTENTS_PATH + filePath);
    if (file.existsSync()) {
      var mimeType = mime.lookupMimeType(file.path);
      req.response.headers.set('Content-Type', mimeType);
      file.openRead().pipe(req.response).catchError((e) {});
    } else {
      _notFound(req);
    }
  }

  void _handleDynamic(HttpRequest req) {
    req.response
      ..headers.contentType = new ContentType("text", "plain", charset: "utf-8")
      ..write('Hello, Dynamic')
      ..close();
  }

  void _notFound(HttpRequest req) {
    req.response
      ..statusCode = HttpStatus.NOT_FOUND
      ..write('Not found!')
      ..close();
  }
}
