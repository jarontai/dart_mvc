// Copyright (c) 2015, Jaron Tai. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library dart_mvc.server;

import 'dart:io';
import 'package:path/path.dart' as path;
import 'handler.dart';

class MvcServer {
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
      var handler = new RequestHandler(req);
      var ext = path.extension(reqPath);
      if (ext.length > 0) {
        handler.handleContent(reqPath);
      } else {
        handler.handleDynamic();
      }
    }
  }
}
