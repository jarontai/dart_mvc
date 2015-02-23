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
  HttpResponse rawRes;
  String _viewsFolder;

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
  void view(String name, {Map<String, Object> data}) {
    if (name.isNotEmpty) {
      var file = new File(_viewsFolder + name + '.html');
      if (file.existsSync()) {
        var template = new Template(file.readAsStringSync());
        var output = template.renderString(data);
        rawRes.statusCode = HttpStatus.OK;
        rawRes.headers.contentType = new ContentType('text', 'html', charset: 'utf-8');
        rawRes.write(output);
        rawRes.close();
      }
    }
  }

  set viewsFolder(folder) => _viewsFolder = Platform.script.resolve(folder).toFilePath()
                                            + Platform.pathSeparator;
}
