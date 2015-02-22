// Copyright (c) 2015, Jaron Tai. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library dart_mvc.request;

import 'dart:io';

/**
 * The request wrapper
 */
class Request {
  HttpRequest rawReq;

  Request(this.rawReq);

  /**
   * get request parameters
   */
  void input(String name) {
    throw UnimplementedError;
  }
}
