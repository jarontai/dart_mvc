// Copyright (c) 2015, Jaron Tai. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library dart_mvc.response;

import 'dart:io';

class Response {
  HttpResponse rawRes;

  Response(this.rawRes);

  void json(List data) {
    throw UnimplementedError;
  }

  void view() {
    throw UnimplementedError;
  }
}
