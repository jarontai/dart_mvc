// Copyright (c) 2015, Jaron Tai. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

part of dart_mvc.example;

class UserController {

  static List mockUsers = [{'id': 1, 'username': 'jaron'},
                          {'id': 2, 'username': 'dbzard'}];

  static void index(Request req, Response res) {
    res.json(mockUsers);
  }

  static void show(Request req, Response res) {
    var id = int.parse(req.params['id']);
    var result = mockUsers.firstWhere((user) {
      return user['id'] == id;
    });
    res.json([result]);
  }
}