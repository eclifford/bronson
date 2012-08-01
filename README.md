# Bronson JS
no dice

![bronson](http://www.allposters.com/IMAGES/MMPH/186171.jpg)

### R8
[TODO]
- link to R8 repo

#### What is R8?

R8 comprises the core architectural functionality for managing modules.

#### Features

* Module loading
* Module communication
* Logging of errors
* Base class implementation for Backbone Views, Models, Collections
* Memory management

#### Components

* [Api (Fascade)](#api)
* [Core (Mediator)](#core)
* [Permissions](#permissions)
* [Logger](#test)
* [Module](#test)
* [View](#test)
* [Model](#test)
* [Collection](#test)

#### API (Fascade)

The API layer is the public programming interface for communicating with R8. The API abstracts the Core and Permissions layer and presents a closed to modification interface.

##### Responsibility
* Provide interface to pass module loading to core
* Coordinate with Permissions layer to validate events
* Provide interface to pass publish/subscribe events to core

##### Methods
* `api.publish(module, event, data)`
* `api.subscribe(event, data, callback)`
* `api.unsubscribe(event)`
* `api.createModule(module, {}, callback)`
* `api.stopModule(event, callback)`
* `api.stopAllModules(module)`

##### Examples

[TODO]
  - verify we are still going to ASYNC load in API and not make it already loaded
  - it could be R8.API

###### Creating a module

    require ['api'], (api) ->                     
      api.createModule 'app/modules/model-listing',   
        url: '/app/data/model-list-data.json'          
      , ->       
        console.log 'module created'     

###### Publishing an event

    require ['core'], (core) ->                       
      core.publish 'statusChange',                     
        message: 'FooModule says hi'                   

      core.subscribe 'statusChange', (data) ->         
        console.log data.messsage                                 

#### Core (Mediator)

Modules themselves have no knowledge of other modules. We need a mediator to handle tasks such as intermodule communication, creation of modules, deletion of modules etc. This is where the Core steps in. The Core acts as an event bus and funnels all communication to the appropriate modules by publishing events. This pattern is typically called the Publish/Subscribe pattern and is integral in keeping our system loosely coupled.

Responsibility:
* Create new modules by loading them in via RequireJS
* Provide publish/subscribe functionality to modules

##### Methods
* `core.publish(module, event, data)`
* `core.subscribe(event, data, callback)`
* `core.unsubscribe(event)`
* `core.createModule(module, {}, callback)`
* `core.stopModule(event, callback)`

##### Creating a Module

    require ['core'], (core) ->                        # Load core library (RequireJS)
      core.createModule 'app/modules/model-listing',   # call createModule passing the module name or alias
        url: '/app/data/model-list-data.json'          # pass a configuration object to that modules constructor
      , ->       
        console.log 'module created'                   # callback once module is loaded  

##### Publising and Subscribing to events

    require ['core'], (core) ->                        # Load core library (RequireJS)
      core.publish 'statusChange',                     # call publish to emit an event by the name of 'statusChange'
        message: 'FooModule says hi'                   # pass a message object 

      core.subscribe 'statusChange', (data) ->         # Subscribe to event 'statusChange'
        console.log data.messsage                      # upon receipt of event log the message
 
#### Permissions

The role of the permissions library is to act as a gatekeeper for pub/sub communication all events must be verified before they can be listened on. Modules must setup through the permissions object which events they can and cannot listen for.

Responsibility: 
* Act as a single point of validation for all pub/sub events

##### Methods
* `permissions.validate(subscriber, channel)`

##### Example of Permissions configuration

All event's must be configured via the Permissions configuration
TODO

#### Logger

TODO

Responsibility: 
TODO

##### Methods
* `logger.log(level, message, data)`

##### Logging a message
TODO

#### Module 

The role of the module is to act as a base class for all modules. The module is responsible for either handling state through a router or acting as a controller. The module is also responsible for cleaning up the memory that it creates and passing such responsibility to it's children.

Responsibility: 
* Entry point of every module(acts as a controller)
* Forces implementation of init/destroy methods for memory management of sub components

##### Example of inheriting from Module

    define[
      'module'
    ], (Module) ->
      class FooModule extends Module
        constructor: ->
        initialize: ->                  # Required NO-OP 
        dispose: ->                     # Required NO-OP

#### View

The view base class extends Backbone's View object with a dispose method and tracking sub views.

Responsibility:
* Offer future expandability
* Dispose memory created by this view
* Track all sub views created by this view so can recursively dispose all views

##### Methods
* `view.dispose()`
* `view.subview(name, view)`
* `view.removeSubView(name)`

##### Example of inheriting from View

    define[
      'view'
    ], (View) ->
      class FooView extends View
        constructor: ->
        initialize: ->                  # Required NO-OP 
        dispose: ->                     # Required NO-OP
        render: ->                      # Required NO-OP

#### Model

The model base class extends Backbone's Model object with a dispose method

Responsibility:
* Offer future expandability
* Dispose memory created by this model

##### Methods 
* `model.dispose()`

##### Example of inheriting from Model
    
    define[
      'model'
    ], (Model) ->
      class FooModel extends Model

#### Collection

The collection base class extends Backbone's Collection object with a dispose method

Responsibility: 
* Offer future expandability
* Dispose memory created by this collection

##### Methods 
* `model.dispose()`

##### Example of inheriting from a Collection
    
    define[
      'collection'
    ], (Collection) ->
      class FooCollection extends Collection