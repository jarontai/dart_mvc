// Copyright (c) 2015, Jaron Tai. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library dart_mvc.server;

import 'dart:io';
import 'dart:mirrors';
import 'package:path/path.dart' as path;
import 'handler.dart';
import 'response.dart';

export 'dart:io' show HttpRequest;

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
        handler.handleStatic(reqPath);
      } else {
        handler.handleDynamic();
      }
    }
  }

  void route(String url, {String method: 'get',
                          Symbol action: #index,
                          Type controller: null}) {
    // TODO - delete mock code below, create route table
    if (controller != null) {
      ClassMirror cm = reflectClass(controller);
      Response res = new Response(null);
      cm.invoke(action, [res]);
    }
  }
}
