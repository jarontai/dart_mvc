# dart_mvc

A minimal mvc implementation of Dart.

## Usage

A simple usage example:

    library dart_mvc.example;
    
    import 'package:dart_mvc/dart_mvc.dart';
    
    class UserController {
      static void index(Request req, Response res) {
        List mockUsers = [{'id': 1, 'username': 'jaron'},
                                {'id': 2, 'username': 'dbzard'}];
        res.json(mockUsers);
      }
    }
    
    main() {
      var server = new MvcServer();
      server.route('/', (req, res) => res.view('index', data: {'name': 'dart_mvc'}));
      server.addRoute('users', controller: UserController, action: #index, method: 'get');
      server.run();
    }

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/jarontai/dart_mvc/issues
