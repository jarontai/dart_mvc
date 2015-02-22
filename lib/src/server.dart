// Copyright (c) 2015, Jaron Tai. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library dart_mvc.server;

import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:mime/mime.dart' as mime;

export 'dart:io' show HttpRequest;

class _Route {
  String url;
  Symbol action;
  Type controller;

  _Route({this.url, this.action, this.controller});
}

class MvcServer {
  String contentsFolder = 'static';
  Map<String, List<_Route>> _routeMap = new Map();

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
        _handleStatic(req, reqPath);
      } else {
        _handleDynamic(req);
      }
    }
  }

  void _handleStatic(HttpRequest req, String filePath) {
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
    var method = req.method.toLowerCase();

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

  void route(String url, {String method: 'get',
                          Symbol action: #index,
                          Type controller: null}) {
    if (url.isNotEmpty) {
      var routeList = _routeMap[method];
      if (routeList == null) {
        routeList = new List<_Route>();
        _routeMap[method] = routeList;
      }
      _Route route = new _Route(url: url, action: action, controller: controller);
      routeList.add(route);
    }
  }
}
