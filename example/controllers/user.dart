// Copyright (c) 2015, Jaron Tai. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

part of dart_mvc.example;

class UserController {

  static void index(Request req, Response res) {
    List<Map> mockUsers = [{'id': 1, 'username': 'jaron'},
                            {'id': 2, 'username': 'dbzard'}];
    res.json(mockUsers);
  }
}