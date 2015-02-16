// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

// TODO: Put public facing types in this file.

library dart_mvc.base;

import 'dart:io';

class MvcServer {
  void run() {
    HttpServer.bind(InternetAddress.LOOPBACK_IP_V4, 8080).then((server) {
      print("Serving at ${server.address}:${server.port}");
      server.listen((HttpRequest request) {
        request.response
          ..headers.contentType = new ContentType("text", "plain", charset: "utf-8")
          ..write('Hello, world')
          ..close();
      });
    });
  }
}
