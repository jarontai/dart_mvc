// Copyright (c) 2015, Jaron Tai. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library dart_mvc.response;

import 'dart:io';
import 'dart:convert';
import 'package:mustache/mustache.dart';

/**
 * The response wrapper
 */
class Response {
  HttpResponse _res;
  String _viewsFolder;

  Response(this._res);

  /**
   * response json data
   */
  void json(List data) {
    _res.statusCode = HttpStatus.OK;
    _res.write(JSON.encode(data));
    _res.close();
  }

  /**
   * render html file
   */
  void view(String name, {Map<String, Object> data}) {
    if (name.isNotEmpty) {
      var file = new File(_viewsFolder + name + '.html');
      if (file.existsSync()) {
        var template = new Template(file.readAsStringSync());
        var output = template.renderString(data);
        _res.statusCode = HttpStatus.OK;
        _res.headers.contentType = new ContentType('text', 'html', charset: 'utf-8');
        _res.write(output);
        _res.close();
      }
    }
  }

  set viewsFolder(folder) => _viewsFolder = Platform.script.resolve(folder).toFilePath()
                                            + Platform.pathSeparator;
}
