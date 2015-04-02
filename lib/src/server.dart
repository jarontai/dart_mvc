// Copyright (c) 2015, Jaron Tai. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library dart_mvc.server;

import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:mime/mime.dart' as mime;
import 'route.dart';

/**
 *  MVC server
 */
class MvcServer {
  String contentsFolder = 'static';
  String viewsFolder = 'views';
  Map<String, List<Route>> _routeMap = new Map();
  static const String _slash = '/';


  /**
   * Kick the mvc server to run
   */
  void run({int port: 8080}) {
    HttpServer.bind(InternetAddress.ANY_IP_V4, port).then((server) {
      print("Serving at ${server.address}:${server.port}");
      server.listen((HttpRequest request) {
        _serve(request);
      });
    });
  }

  /**
   * Serve
   */
  void _serve(HttpRequest req) {
    var reqPath = req.uri.toString();
    print("Request: ${reqPath}  ${new DateTime.now()}");

    // skip favicon
    if (reqPath != '/favicon.ico') {
      var ext = path.extension(reqPath);
      if (ext.length > 0) {
        _handleStatic(req, reqPath);
      } else {
        _handleDynamic(req, reqPath);
      }
    }
  }

  /**
   * Handle static resources
   */
  void _handleStatic(HttpRequest req, String filePath) {
    final CONTENTS_PATH = Platform.script.resolve(contentsFolder).toFilePath();
    var file = new File(CONTENTS_PATH + filePath);
    file.exists().then((bool exists) {
      if (exists) {
        var mimeType = mime.lookupMimeType(file.path);
        req.response.headers.set('Content-Type', mimeType);
        file.openRead().pipe(req.response).catchError((e) {});
      } else {
        _notFound(req);
      }
    });
  }

  /**
   * Handle daynamic requests
   */
  void _handleDynamic(HttpRequest req, String path) {
    var method = req.method.toLowerCase();
    var routeList = _routeMap[method];
    var route = routeList.firstWhere((Route route) {
      return route.match(path);
    }, orElse: () => null);

    if (route != null ) {
      route.invoke(req, viewsFolder);
    } else {
      _notFound(req);
    }
  }

  /**
   * not found
   */
  void _notFound(HttpRequest req) {
    req.response
      ..statusCode = HttpStatus.NOT_FOUND
      ..write('Not found!')
      ..close();
  }

  /**
   * Add route with controller
   */
  void addRoute(String path, {String method: 'get',
                          Symbol action: #index,
                          Type controller: null}) {
    if (path.isNotEmpty) {
      var routeList = _routeMap[method];
      if (routeList == null) {
        routeList = new List<Route>();
        _routeMap[method] = routeList;
      }
      Route route = new Route(path: path, action: action, controller: controller);
      _addRoute(routeList, route);
    }
  }

  /**
   * Add route with closure
   */
  void route(String url, RouteFn routeFn, {String method: 'get'}) {
    if (url.isNotEmpty) {
      var routeList = _routeMap[method];
      if (routeList == null) {
        routeList = new List<Route>();
        _routeMap[method] = routeList;
      }
      Route route = new Route(path: url, routeFn: routeFn);
      _addRoute(routeList, route);
    }
  }

  void _addRoute(List<Route> list, Route route) {
    if (route.path == _slash) {
      list.add(route);
    } else {
      list.insert(0, route);
    }
  }
}
