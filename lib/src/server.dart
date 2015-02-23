// Copyright (c) 2015, Jaron Tai. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library dart_mvc.server;

import 'dart:io';
import 'dart:mirrors';
import 'package:path/path.dart' as path;
import 'package:mime/mime.dart' as mime;
import 'request.dart';
import 'response.dart';

typedef void RouteFn(Request req, Response res);

/**
 * Route
 */
class _Route {
  RouteFn _routeFn;
  String _url;
  Symbol _action;
  Type _controller;
  RegExp _reg;

  _Route({String url, Symbol action, Type controller, RouteFn routeFn}) {
    this._url = url;
    this._action = action;
    this._controller = controller;
    this._routeFn = routeFn;
    if (url.isNotEmpty) {
      _reg = new RegExp(url);
    }
  }

  /**
   * check whether the route is match the url path
   */
  bool match(String path) {
    var result = false;
    if (_reg != null) {
      result = _reg.hasMatch(path);
    }
    return result;
  }

  /**
   * invoke the controller
   */
  void invoke(HttpRequest req, String viewsFolder) {
    var request = new Request(req);
    var response = new Response(req.response);
    response.viewsFolder = viewsFolder;
    if (_routeFn != null) {
      _routeFn(request, response);
    } else if (_controller != null) {
      ClassMirror cm = reflectClass(_controller);
      cm.invoke(_action, [request, response]);
    }
  }
}


/**
 *  MVC server
 */
class MvcServer {
  String contentsFolder = 'static';
  String viewsFolder = 'views';
  Map<String, List<_Route>> _routeMap = new Map();

  /**
   * kick the mvc server to run
   */
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
        _handleDynamic(req, reqPath);
      }
    }
  }

  /**
   * handle the static resources
   */
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

  /**
   * handle daynamic requests
   */
  void _handleDynamic(HttpRequest req, String path) {
    var method = req.method.toLowerCase();
    var routeList = _routeMap[method];
    var route = routeList.firstWhere((_Route route) {
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
      ..statusCode = HttpStatus.OK
      ..write('No route found!')
      ..close();
  }

  /**
   * add route with controller
   */
  void addRoute(String url, {String method: 'get',
                          Symbol action: #index,
                          Type controller: null}) {
    if (url.isNotEmpty) {
      var routeList = _routeMap[method];
      if (routeList == null) {
        routeList = new List<_Route>();
        _routeMap[method] = routeList;
      }
      _Route route = new _Route(url: url, action: action, controller: controller);
      routeList.insert(0, route);
    }
  }

  /**
   * add route with closure
   */
  void route(String url, RouteFn routeFn, {String method: 'get'}) {
    if (url.isNotEmpty) {
      var routeList = _routeMap[method];
      if (routeList == null) {
        routeList = new List<_Route>();
        _routeMap[method] = routeList;
      }
      _Route route = new _Route(url: url, routeFn: routeFn);
      routeList.insert(0, route);
    }
  }
}
