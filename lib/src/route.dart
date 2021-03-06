// Copyright (c) 2015, Jaron Tai. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library dart_mvc.route;

import 'dart:io';
import 'dart:mirrors';
import 'request.dart';
import 'response.dart';

typedef void RouteFn(Request req, Response res);

/**
 * Route
 */
class Route {
  RouteFn routeFn;
  String path;
  Symbol action;
  Type controller;
  RegExp _reg;
  List<Map> _keys = [];
  Map _params = {};

  Route({String path, Symbol action, Type controller, RouteFn routeFn}) {
    this.path = path;
    this.action = action;
    this.controller = controller;
    this.routeFn = routeFn;
    if (path.isNotEmpty) {
      _reg = _pathRegexp(path);
    } else if (!path.startsWith('/')) {
      throw new ArgumentError('Route path must start with /');
    } else {
      throw new ArgumentError('Route path can not be empty');
    }
  }

  /**
   * Check whether the route is match the url path then extra path variable
   */
  bool match(String path) {
    var result = false;
    if (_reg != null) {
      Match match = _reg.firstMatch(path);
      if (match != null) {
        result = true;
        if (_keys.isNotEmpty) {
          for (var i = 0; i < _keys.length; i++) {
            var key = _keys[i];
            var val = match.group(i+1);
            if (key != null) {
              _params[key['name']] = val;
            }
          }
        }
      }
    }
    return result;
  }

  /**
   * Invoke the controller
   */
  void invoke(HttpRequest req, String viewsFolder) {
    var request = new Request(req);
    var response = new Response(req.response);
    request.params.addAll(_params);
    response.viewsFolder = viewsFolder;
    if (routeFn != null) {
      routeFn(request, response);
    } else if (controller != null) {
      ClassMirror cm = reflectClass(controller);
      cm.invoke(action, [request, response]);
    }
  }

  /**
   * Normalize the given path
   */
  RegExp _pathRegexp(String path) {
    var normal = path
                .replaceAllMapped(new RegExp('\{([^}]+)\}'), (Match m) {
                   var key = m[1];
                   var optional = false;
                  _keys.add({'name': key, 'optional': optional});

                  var result = '(.+)';
                  return result;
               });
    var result = new RegExp(r'^' + normal.replaceAll(r'/', r'\/') + r'$');
    return result;
  }
}