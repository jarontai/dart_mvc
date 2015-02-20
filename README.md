# dart_mvc

A minimal mvc implementation of Dart.

## Usage

A simple usage example:

    library dart_mvc.example;
    
    import 'package:dart_mvc/dart_mvc.dart';
    
    part 'controllers/user.dart';
    
    main() {
      var server = new MvcServer();
      server.route('users', controller: UserController);
      server.run();
    }

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/jarontai/dart_mvc/issues
