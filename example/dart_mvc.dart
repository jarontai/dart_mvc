// Copyright (c) 2015, Jaron Tai. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library dart_mvc.example;

import 'package:dart_mvc/dart_mvc.dart';
import 'controllers/users.dart';

main() {
  var server = new MvcServer();
  server.route('users', controller: UserController);
  server.run();
}
