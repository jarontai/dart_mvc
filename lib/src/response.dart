// Copyright (c) 2015, Jaron Tai. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library dart_mvc.response;

import 'dart:io';
import 'dart:convert';

/**
 * The response wrapper
 */
class Response {
  HttpResponse rawRes;

  Response(this.rawRes);

  /**
   * response json data
   */
  void json(List data) {
    rawRes.statusCode = HttpStatus.OK;
    rawRes.write(JSON.encode(data));
    rawRes.close();
  }

  /**
   * rendering html view file
   */
  void view() {
    throw UnimplementedError;
  }
}
