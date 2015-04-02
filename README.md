# dart_mvc

A minimal mvc implementation of Dart.

## Usage

A simple usage example:

    library dart_mvc.example;
    
    import 'package:dart_mvc/dart_mvc.dart';
    
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
    
    main() {
      var server = new MvcServer();
      server.route('/', (req, res) => res.view('index', data: {'name': 'dart_mvc'}));
      server.addRoute('/users', controller: UserController, action: #index);
      server.addRoute('/users/{id}', method: 'get', controller: UserController, action: #show);
    
      server.run(port: 8080);
    }

Please examine the [example folder][example] for full example code.

##TODOs

* tests

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/jarontai/dart_mvc/issues
[example]: https://github.com/jarontai/dart_mvc/tree/master/example