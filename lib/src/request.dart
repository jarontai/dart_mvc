// Copyright (c) 2015, Jaron Tai. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library dart_mvc.request;

import 'dart:io';

class Request {
  HttpRequest rawReq;

  Request(this.rawReq);

  void input(String name) {
    throw UnimplementedError;
  }
}