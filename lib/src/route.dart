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
    }
  }

  /**
   * check whether the route is match the url path
   */
  bool match(String path) {
    var result = false;
    if (_reg != null) {
      Iterable<Match> matches = _reg.allMatches(path);
      for (var i = 0; i < matches.length; i++) {
        var key = _keys[i];
        var m = matches.elementAt(i);
        var val = m[i+1];
        if (key != null) {
          _params[key['name']] = val;
        }
      }
      result = matches.length > 0;
    }
    return result;
  }

  /**
   * invoke the controller
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
    var normal = path.replaceAll(new RegExp(r'\/\('), r'(?:/')
                .replaceAllMapped(new RegExp(r'(\/)?(\.)?:(\w+)(?:(\(.*?\)))?(\?)?(\*)?'), (Match m) {
                  var optional = m[5] != null;
                  var slash = (m[1] != null)? m[1] : '';
                  var format = (m[2] != null)? m[2] : '';
                  var capture = m[4];
                  var star = m[5];
                  _keys.add({'name': m[3], 'optional': optional});

                  var result = '';
                  result += optional? '' : slash;
                  result += '(?:';
                  result += optional? slash : '';
                  result += format;
                  result += (capture != null)? capture : (format.length > 0)? '([^/.]+?)' : '([^/]+?)';
                  result += ')';
                  result += (star != null)? '(/*)?' : '';
                  return result;
               })
               .replaceAll(new RegExp(r'\*'), r'(.*)');
    var result = new RegExp(r'^' + normal + r'$');

//    /\{([^}]+)\}/
//
//    /        - delimiter
//    \{       - opening literal brace escaped because it is a special character used for quantifiers eg {2,3}
//    (        - start capturing
//    [^}]     - character class consisting of
//        ^    - not
//        }    - a closing brace (no escaping necessary because special characters in a character class are different)
//    +        - one or more of the character class
//    )        - end capturing
//    \}       - the closing literal brace
//    /        - delimiter
    return result;
  }
}