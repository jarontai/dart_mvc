// Copyright (c) 2015, Jaron Tai. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library dart_mvc.request;

import 'dart:io';

/**
 * The request wrapper
 */
class Request {
  HttpRequest _req;

  Map params = {};

  Request(this._req);

  /**
   * Get request's query parameters
   */
  String input(String name) {
    var result;
    var queries = _req.uri.queryParameters;
    if (queries.containsKey(name)) {
      result = queries[name];
    }
    return result;
  }

  HttpRequest get request => _req;
}
