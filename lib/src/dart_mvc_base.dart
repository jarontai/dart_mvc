// Copyright (c) 2015, Jaron Tai. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library dart_mvc.base;

import 'dart:io';
import 'package:path/path.dart' as path;

class MvcServer {

  void run() {
    HttpServer.bind(InternetAddress.LOOPBACK_IP_V4, 8080).then((server) {
      print("Serving at ${server.address}:${server.port}");
      server.listen((HttpRequest request) {
        serve(request);
      });
    });
  }

  void serve(HttpRequest req) {
    var reqPath = req.uri.path;
    print("Request: ${reqPath}  ${new DateTime.now()}");
    var ext = path.extension(reqPath);
    if (ext.length > 0) {
      handleContent(req);
    } else {
      handleDynamic(req);
    }
  }

  void handleContent(HttpRequest req) {
    req.response
      ..headers.contentType = new ContentType("text", "plain", charset: "utf-8")
      ..write('Hello, Content')
      ..close();
  }

  void handleDynamic(HttpRequest req) {
    req.response
      ..headers.contentType = new ContentType("text", "plain", charset: "utf-8")
      ..write('Hello, Dynamic')
      ..close();
  }
}
