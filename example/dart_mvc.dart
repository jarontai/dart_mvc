// Copyright (c) 2015, Jaron Tai. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library dart_mvc.example;

import 'package:dart_mvc/dart_mvc.dart';

part 'controllers/user.dart';

main() {
  var server = new MvcServer();
  server.route('/', (req, res) => res.view('index', data: {'name': 'dart_mvc'}));
  server.addRoute('users', controller: UserController, action: #index, method: 'get');
  server.run();
}
