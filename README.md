<div align="center">

<p align='center'>
    <img width="250" alt="bloc-logo" src="https://user-images.githubusercontent.com/17494745/223100913-13fdb2de-cfd5-4450-9b65-77ac10893d4e.png">
</p>



Learn how to use
**`Bloc`**
in **Flutter**
to manage your
App's state.

![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/dwyl/flutter-bloc-tutorial/ci.yml?label=build&style=flat-square&branch=main)
[![codecov.io](https://img.shields.io/codecov/c/github/dwyl/flutter-bloc-tutorial/main.svg?style=flat-square)](https://codecov.io/github/dwyl/flutter-bloc-tutorial?branch=main)
[![contributions welcome](https://img.shields.io/badge/contributions-welcome-brightgreen.svg?style=flat-square)](https://github.com/dwyl/flutter-bloc-tutorial/issues)
[![HitCount](https://hits.dwyl.com/dwyl/flutter-bloc-tutorial.svg)](https://hits.dwyl.com/dwyl/flutter-bloc-tutorial)

</div>
<br />

Use these links to skip straight to the section that interests you:

- [A note 🗒️](#a-note-️)
- [Why? 👀](#why-)
  - [Do I actually need this?](#do-i-actually-need-this)
- [What? 🤷‍♂️](#what-️)
  - [Core concepts 🧱](#core-concepts-)
    - [Streams](#streams)
    - [Bloc](#bloc)
    - [Cubit](#cubit)
    - [Wait... so which to use?](#wait-so-which-to-use)
  - [`BLoC` concepts in Flutter 🦋](#bloc-concepts-in-flutter-)
    - [Defining a `Bloc`](#defining-a-bloc)
    - [`Bloc` Events](#bloc-events)
    - [`Bloc` State](#bloc-state)
    - [Dependency injection with `BlocProvider`](#dependency-injection-with-blocprovider)
    - [Making UI *react* to Bloc state changes with `BlocBuilder`](#making-ui-react-to-bloc-state-changes-with-blocbuilder)
    - [Listening to state changes with `BlocListener`](#listening-to-state-changes-with-bloclistener)
    - [`BlocConsumer`](#blocconsumer)
- [How? 💻](#how-)
  - [Before You Start! 💡](#before-you-start-)
  - [0. Create a new `Flutter` project](#0-create-a-new-flutter-project)
  - [1. `Stopwatch` and `TodoItem` classes](#1-stopwatch-and-todoitem-classes)
    - [1.1 `TodoItem` class](#11-todoitem-class)
    - [1.2 `Stopwatch` class](#12-stopwatch-class)
  - [2. Basic app layout](#2-basic-app-layout)
    - [2.1 Adding widget tests](#21-adding-widget-tests)
    - [2.2 Creating widgets](#22-creating-widgets)
  - [3. Adding `Bloc` to our project](#3-adding-bloc-to-our-project)
    - [3.1 Adding `Bloc` tests](#31-adding-bloc-tests)
    - [3.2 Adding `bloc` to our app](#32-adding-bloc-to-our-app)
      - [3.2.1 `Bloc` states](#321-bloc-states)
      - [3.2.2 `Bloc` events](#322-bloc-events)
      - [3.2.3 Creating the `bloc`](#323-creating-the-bloc)
      - [3.2.4 Run the tests!](#324-run-the-tests)
  - [4. Changing widgets to listen to state changes](#4-changing-widgets-to-listen-to-state-changes)
    - [4.1 Providing our `TodoBloc` to the whole app](#41-providing-our-todobloc-to-the-whole-app)
    - [4.2 Creating and listing `TodoItem` widgets](#42-creating-and-listing-todoitem-widgets)
    - [4.3 Toggling and start/stopping timers in `ItemCard`](#43-toggling-and-startstopping-timers-in-itemcard)
      - [4.3.1 Start and stopping the timer](#431-start-and-stopping-the-timer)
      - [4.3.2 Toggling the `ItemCard`](#432-toggling-the-itemcard)
  - [5. Run the app!](#5-run-the-app)
- [I need help! ❓](#i-need-help-)


# A note 🗒️

This tutorial assumes you have prior basic knowledge of `Flutter`.
If this is your first time using `Flutter`,
please visit [`dwyl/learn-flutter`](https://github.com/dwyl/learn-flutter)
_first_ to learn the basics. 

After that, 
we *highly recommend* you
follow [`dwyl/flutter-todo-list-tutorial`](https://github.com/dwyl/flutter-todo-list-tutorial).
You will find great value in it
to guide you through implementing an app
with shared state *without* `Bloc`.

# Why? 👀

If you've worked with `Flutter`,
you've probably came across **stateful widgets**.
In these widgets, the state and
how/when it changes determines how many times
the widget is rendered.
The state that is contained within the widget
is referred to as "local state".

A `Flutter` app consists of 
*multiple widgets*, 
which together make up the **widget tree**.
While each widget can have its own local state,
other widgets seldom need to access this kind of state.

*However*, there is state 
that **is needed across many widgets of the app**.
This shared state is called **application state**,
and pertains to the state of the whole app.
An example of these are shopping carts in an 
e-commerce app or personal preferences.

Consider the following gif, taken directly from the Flutter docs -> https://docs.flutter.dev/development/data-and-backend/state-mgmt/intro

![shared-state](https://user-images.githubusercontent.com/17494745/223102689-03249a71-3472-4628-b586-c87d167ad3a7.png)


Each widget in the widget tree might have its own local state 
but there's a piece of application state (i.e. shared state) 
in the form of a cart. 
This cart is accessible from any widget of the app - 
in this case, the `MyCart` widget 
uses it to list what item was added to it.

This is an example of shared state.
In the Flutter ecosystem, 
there are a few frameworks that you can choose
that will help you setup 
and *use* shared state in your application
and do the heavy lifting for you.
Examples include
[Riverpod](https://riverpod.dev/),
[Provider](https://pub.dev/packages/provider)
and [**Bloc**](https://bloclibrary.dev/#/).
Bloc is the newest of the options
and is built by people who previously used 
the other options on larger `Flutter` Apps.

## Do I actually need this?

As it often occurs, *it depends*.
For simple apps,
adding the `bloc` library 
and having your code follow an opinionated format
will probably incur more boilerplate 
and learning curve than is actually needed.

Yes, the `bloc` library also has **`cubits`** 
(we will discuss this later on this document),
which aim to simplify the implementation of `blocs`.
However,
by being forced to separate concerns 
(we will see later that `BLoC` effectively separates
business logic from UI) 
and embedding `blocs` into our application
can be *too much* if we just want to create simple features.

The hard part is knowing *where the line is*.
`Bloc`'s properties shine with large apps 
because it's much easier to maintain.
It might not shine in simpler apps because
it will have more code than it actually needs to have.

There's no easy answer for this.
There are often discussions about
whether to use `Riverpod` or `Bloc`,
when these libraries have a few distinctions:

- `Riverpod` is a library that focuses on **dependency injection**,
and makes lifting state up and down the widget tree
much more convenient. 
This process can effectively be used as shared state between widgets.

- `Bloc` os focussed on making state management 
as safe and predictable as possible.
You can find some comments from the creator
of the `flutter_bloc` library in:
[reddit.com/r/FlutterDev/comments/bmrvey](https://www.reddit.com/r/FlutterDev/comments/bmrvey/comment/en1kefb/?utm_source=share&utm_medium=web2x&context=3)

While this app might be "too simple for `Bloc`",
it's meant to showcase on how one implements it
in a `Flutter` app.

# What? 🤷‍♂️

`BLoC` is an acronym for
**B**usiness **L**ogic **C**omponents,
and is a **design pattern** created by **`Google`**
that *separates* business logic 
from the presentation layer.

From this concept arose [`Bloc`](https://bloclibrary.dev/#/),
a state management library created by 
[Felix Angelov](https://github.com/felangel)
which aims to *easily* implement this design pattern
in Flutter apps.

For every interaction that is made in the application,
**state should emerge from it**. 
For example, when you make an API call,
the app should show a loading animation (**loading state**).
When the internet required but not available,
this should be reflected in the interface
so the `person` knows they have reduced functionality.

There are a few benefits for using `Bloc`:
- the logic is *kept out of the widgets*.
- it's easy to test logic and widgets separately.
"When my state is X, widgets should be Y".
- we can *trace person interactions*
made in widgets through **blocs** 
(we will talk about this in the next section).

Before implementing anything, 
we need to *understand* 
how the `Bloc` library works.

The following sections take inspiration 
from the official [`Bloc` docs](https://bloclibrary.dev/#/gettingstarted).
If you want a more in-depth explanation,
we highly encourage you to check them.

## Core concepts 🧱

Let's delve a bit into the core concepts
of `BLoC` design pattern. 
Knowing these will make it *much easier*
to use `Bloc`, the framework.


### [Streams](https://bloclibrary.dev/#/coreconcepts?id=streams)

**Streams** are the cornerstone of `BLoC`.
A `Stream` is an *an order of asynchronous events*.
Quoting `Bloc`'s docs:

> If you're unfamiliar with `Streams`,
> just think of a pipe with water flowing through it. 
> The pipe is the `Stream` and the water is the asynchronous data.

It's like an [Iterable](https://en.wikipedia.org/wiki/Iterator),
but instead of getting the next event when you ask for it,
the `Stream` *tells you* there's an event when it's ready.

A `Stream` provides a way to receive a sequence
of events/elements.
If an error occurs, an error event is thrown.
If the `Stream` has emitted all of its elements,
a "done" event is thrown.


### [Bloc](https://bloclibrary.dev/#/coreconcepts?id=bloc)

Let's start with the most "difficult" concept.
Quoting `Bloc`'s docs:

> A `Bloc` is a more advanced class 
> which relies on `events` to trigger `state` changes rather than functions. 
> `Bloc` also extends `BlocBase`,
> meaning it has a similar public API to `Cubit`. 
> However, rather than calling a `function` on a `Bloc` 
> and directly emitting a new `state`, 
> `Blocs` receive `events` 
> and convert the incoming `events` into outgoing `states`.

Phew, that was a mouthful!
Let's break that down.

<img width="1144" alt="bloc-diagram" src="https://user-images.githubusercontent.com/17494745/223118425-a8a86010-82d9-4c1e-8fde-41025d5ae88b.png">

> Image credit: 
> [youtube.com/BradCypert](https://www.youtube.com/watch?v=sAz_8pRIf5E&ab_channel=BradCypert)

We define `Events` for a given class
that we want to manage. 
In the example above,
we are managing *Pets*.
We have three possible events,
in this scenario.

We can call `petBloc.add(event)` 
(which is a **`bloc`**)
and pass an instance of the event to the `bloc`.

The `bloc` can do some logic inside.
For example, it makes an API call
or accesses a service.

Afterwards, the `bloc` **emits a `state`**.

### [Cubit](https://bloclibrary.dev/#/coreconcepts?id=cubit) 

A `Cubit` is a **much simpler, minimalist version of a `Bloc`**.
Unlike `Bloc`,
the `Cubit` exposes functions that can be invoked
to trigger state changes.

Check the following diagram:

<img width="1127" alt="cubit-diagram" src="https://user-images.githubusercontent.com/17494745/223120206-dee22295-94f4-472a-803d-45ca9f3cab45.png">

> Image credit: 
> [youtube.com/BradCypert](https://www.youtube.com/watch?v=sAz_8pRIf5E&ab_channel=BradCypert)

`Cubits`, 
although similar,
differ from `Blocs` because
**they don't have `events`**.
The `Cubit` has *methods*,
there is no need to pass instances of `events`
like we do in `Blocs`.

Inside these methods you would write your logic
(making a call to an API, for example),
and inside the same method you would also emit state.


### Wait... so which to use?

You may be wondering yourself
"Which one should I choose?".
As always, the answer is... **it depends**.

|    |       **Cubit**      |              **Bloc**              |
|:---------------:|:-----------:|:----------------------------------:|
| **Simplicity**                     | <ul><li>states</li><li>functions</li></ul> | <ul><li>states</li><li>events</li><li>event handlers</li></ul> |
| **Traceability**                   |    | Transition (onTransition())      |
| **Advanced Event Transformations** |    | EventTransformer                   |

`Cubit` shines with its simplicity
and is better suited for simple use cases.
If your team is struggling to model event transitions,
you might want to start with `Cubits`.

However, if you value traceability 
or are having a hard time mocking cubits for widget tests,
you might want to use `Blocs`.

If you're unsure of the event-driven approach,
start with `Cubit`.
You can always refactor the code later on 
to a `Bloc` when you have a clearer idea
of the possible events of your application.

For an in-depth
comparison between the two, 
please see:
[bloclibrary.dev/#/coreconcepts?id=cubit-vs-bloc](https://bloclibrary.dev/#/coreconcepts?id=cubit-vs-bloc)


## `BLoC` concepts in Flutter 🦋

Now that we are aware of the most important `Bloc` concepts,
let's see how these could be implemented in Flutter.

### Defining a `Bloc`

To create a `bloc` in Flutter,
we need to:
- provide an initial state.
- set up event listeners and handlers.
- add events to `bloc` via `bloc.add`.

Check the following piece of code.

```dart
class PetBloc extends Bloc<PetEvent, PetState> {
    final PetRepo repo;

    // Defining the class
    PetBloc(this.repo)) : super(PetInitial()) {
        on<LoadPet>(_loadPet);
        on<DeletePet>(_deletePet);
    }

    // LoadPet event handler
    _loadPet(LoadPet event, Emitter<PetState> emit) async {
        emit(PetLoading());
        var pet = await repo.getById(event.petId).first;
        emit(PetLoaded(pet))
    }

    // DeletePet event handler
    _deletePet(DeletePet event, Emitter<PetState> emit) async {
        emit(PetLoading());
        var pet = await repo.delete(event.petId);
        emit(PetDeleted(pet))
    }
}
```

We are defining `PetBloc`,
which extends the [`Bloc`](https://pub.dev/documentation/bloc/latest/bloc/Bloc-class.html) 
class.
We define `PetBloc`
with the `PetState` base class
and `PetEvent` base class.

The `Bloc` class requires us to register
event handlers via `on<Event>`,
which is what is done in the constructor.

### `Bloc` Events

**Events** are necessary to define `Blocs`.
When defining **`Bloc Events`**,
we should follow some guidelines.

- have a "root"/base class for event (`PetEvent`).
- use [`Equatable`](https://pub.dev/packages/equatable),
a library that allows us to make better equality comparisons 
between class instances.
Having this will prevent duplicate events 
from triggering back-to-back.

```dart
abstract class PetEvent extends Equatable {
    const PetEvent()

    @override
    List<Object> get props => [];
}

class LoadPet extends PetEvent {
    final String petId;

    const LoadPet(this.petId);

    @override
    List<Object> get props => [this.petId];
}
```

### `Bloc` State

A **State** is what is emitted by the `bloc`.
In fact, the app UI will change 
according to state changes.

Similarly to `Bloc Events`,
we can leverage [`Equatable`](https://pub.dev/packages/equatable)
to avoid triggering duplicate emissions of the same state
if nothing has changed.

```dart
abstract class PetState extends Equatable {
    const PetState()

    @override
    List<Object> get props => [];
}

class PetInitial extends PetState {}
class PetDeleted extends PetState {}
class PetLoading extends PetState {}
```


### Dependency injection with `BlocProvider`

**`BlocProvider`** is a Flutter widget
that creates and provides access
to a `Bloc` to all of its children below
on the widget tree.

![bloc-provider](https://user-images.githubusercontent.com/17494745/223143702-faae2b4b-a13c-47cd-b697-a925935c816a.png)

> photocredits go to https://www.mitrais.com/news-updates/getting-started-with-flutter-bloc-pattern/.

We instantiate `BlocProvider`
like so:

```dart
BlocProvider(
    create: (context) => 
        PetBloc(
            Provider.of<PetRepo>(context, listen: false)
        )
)
```

With this widget,
we can dependency inject widgets
(which is great for testing)
and allow *other widgets*
to make calls to the `bloc`.

You can check in the piece of code below
how you can "get" the `bloc` from the tree.

```dart
BlocProvider.of<PetsBloc>(context)
    .add(LoadPets(widget.householdId, PetStatus.All))
```


### Making UI *react* to Bloc state changes with `BlocBuilder`

**`BlocBuilder`** is a widget that helps us
rebuild the UI based on `bloc` state changes.
This widget rebuilds the UI every time
a `bloc`/`cubit` emits a new state.

Here's how it can be used in practice.

```dart
BlocBuilder<PetBloc, PetState>(
    builder: (context, state) {
        if (state is PetLoading) {
            // Show loading icon
        }
        if (state is PetFailed) {
            // Show failed text
        }
        if (state is PetLoaded) {
            // Show loaded text
        }

        // Default return
        return Container()
    }
)
```


### Listening to state changes with `BlocListener`

**`BlocListener`** is a widget
that *listens* to a `bloc` state change
and executes code when the state changes.

A state change will trigger a rerun 
of the listener function.
You don't want to create widgets here,
but you can surely set a new state, 
or change the navigation to another route,
or even show a snackbar notification!

Here's how you can use `BlocListener`.

```dart
BlocListener<PetBloc, PetState>(
    listener: (context, state) {
        // Change navigation route
        if (state is PetDeleted) {
            Navigator.of(context).pop();
        }

        // Show a snackbar
        if (state is PetUpdated) {
            ScaffoldMessenger.of(context).showSnackbar(
                SnackBar(content: Text("Pet updated!"))
            )
        }

    }
)
```


### `BlocConsumer`

If you want to both build widgets
according to state changes *and*
listen to state changes events,
you can inclusively use 
the `BlocConsumer` widget!

This widget basically
combines `BlocListener`
and `BlocBuilder` 
into a single widget!

Here's how you may use it:

```dart
BlocConsumer<PetBloc, PetState>(
  listener: (context, state) {
    // do stuff here based on PetBloc's state
  },
  builder: (context, state) {
    // return widget here based on BlocA's state
  }
)
```

# How? 💻

We are going to be building 
a Todo list app, 
where each todo item has a timer.

The person should be able 
to set the item 
as *done*
and start/stop the item pertaining
to the todo item.

## Before You Start! 💡

Before you attempt to follow this tutorial,
make sure you have everything installed 
on your computer.

If you want a guide on how to install `Flutter`
and the needed dependencies,
follow our guide in `dwyl/learn-flutter`
in https://github.com/dwyl/learn-flutter#install-%EF%B8%8F.

## 0. Create a new `Flutter` project

We need to create a brand new `Flutter` project.
If you don't know how to do this,
we have created a small guide for you 
in https://github.com/dwyl/learn-flutter#0-setting-up-a-new-project.

Follow the steps. 
After this,
your `lib/main.dart` file should look like this.

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Hello World!'),
        ),
      ),
    );
  }
}
```

If you run the application,
you will see the following screen.

<p align='center'>
    <img width="250" alt="cubit-diagram" src="https://user-images.githubusercontent.com/17494745/223190180-c47dc5fa-b237-47c7-95f9-b28278021a3f.png">
</p>

> **Note**
>
> If you are having trouble 
> debugging the `Flutter` project, 
> check the following links:
> 
> - to run on a **real device**, 
> check https://github.com/dwyl/flutter-stopwatch-tutorial#running-on-a-real-device.
> 
> - to run on a **emulator**, visit https://github.com/dwyl/learn-flutter#0-setting-up-a-new-project.


Now we are ready 
to start to implement our project
with `Bloc`!

## 1. `Stopwatch` and `TodoItem` classes

Before starting to implement any widgets,
there are two classes that 
are going to be needed 
to fulfil our app requirements.

Let's start with our `TodoItem` class.

### 1.1 `TodoItem` class 

The `TodoItem` class
will hold all the information pertaining to the person.
We know that the class will have:
- a **description**.
- a **boolean property** so we know it's completed or not.
- an **id**.
- a list of **`timers`**, 
where each `timer` pertains to a
*start* and *stop* operation.

We are expecting this class
to have at least three functions:
one to *start the timer*,
another to *stop the timer*
and another to get 
*the total timers duration*
to display to the person 
how much time has elapsed.

Let's start by writing our tests.
Create a directory and file 
with the path `test/unit/todo_test.dart`,
and write the next two tests in it.

```dart
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:todo/todo.dart';

void main() {
  test('Cumulative duration after starting and stopping timer should be more than 0', () {
    const description = "description";

    final todoItem = TodoItem(description: description);

    // Checking attributes
    expect(todoItem.description, description);

    // Start and stop timer
    todoItem.startTimer();
    sleep(const Duration(milliseconds: 500));
    todoItem.stopTimer();

    // Start and stop timer another time
    todoItem.startTimer();
    sleep(const Duration(milliseconds: 500));
    todoItem.stopTimer();

    // Some time must have passed
    expect(todoItem.getCumulativeDuration(), isNot(equals(0)));
  });

  test('Start timer multiple times and stopping timer will not error out', () {
    const description = "description";

    final todoItem = TodoItem(description: description);

    // Checking attributes
    expect(todoItem.description, description);

    // Start timers three times
    todoItem.startTimer();
    todoItem.startTimer();
    todoItem.startTimer();

    // Stop timer after half a second
    sleep(const Duration(milliseconds: 500));
    todoItem.stopTimer();

    // Some time must have passed
    expect(todoItem.getCumulativeDuration(), isNot(equals(0)));
  });
}
```

We are creating two tests scenarios.

In the first, 
we create a `TodoItem`
with a specific `description` and `id`.
We check if these properties
exist within the class instance.
We then start the timer,
wait for half a second
and stop it.
We do this operation two times,
and finally check if the *cumulative duration*
yielded by the class is not 0.

In the second one,
we check if the person can 
accidentally call `startTimer()`
multiple times.
The class should be able to handle this edge case.

If we run `flutter test`,
the tests will obviously fail,
as we didn't yet implement this class.
Let's do that right now!

Firstly,
we need a way to create `id`s
on the go.
Usually you'd associate the `id` 
of a `TodoItem` class
with the `id` from the database.
However, 
since we are doing everything locally,
we will use the 
[`uuid` package](https://pub.dev/packages/uuid)
to generate random 
[uuid](https://en.wikipedia.org/wiki/Universally_unique_identifier)
every time a class is instantiated. 

To install this package,
add the following line to the 
`dependencies` section 
in `pubspec.yaml`.

```yaml
uuid: ^3.0.6
```

And run `flutter pub get`.
This will install the dependency.

After this, 
create a file in `lib/todo.dart`
and paste the following contents.

```dart
import 'package:uuid/uuid.dart';

// Uuid to generate Ids for the todos
Uuid uuid = const Uuid();

/// Todo class.
/// Each `Todo` has an `id`, `description` and `completed` boolean field.
class TodoItem {
  final String id = uuid.v4();
  final String description;
  final bool completed;
  final List<ItemTimer> _timersList = [];

  TodoItem({
    required this.description,
    this.completed = false,
  });

  // Adds a new timer that starts on current time
  startTimer() {
    if (_timersList.isEmpty) {
      _timersList.add(ItemTimer(null, start: DateTime.now()));
    } else {
      ItemTimer lastTimer = _timersList.last;

      // Only create a new timer if the last one is finished
      if (lastTimer.end != null) {
        _timersList.add(ItemTimer(null, start: DateTime.now()));
      }
    }
  }

  // Stop the timer that is at the end of the list
  stopTimer() {
    if (_timersList.isNotEmpty) {
      ItemTimer lastTimer = _timersList.last;

      // Only stop last timer if the end is null
      if (lastTimer.end == null) {
        lastTimer.end = DateTime.now();
        _timersList[_timersList.length - 1] = lastTimer;
      }
    }
  }

  getCumulativeDuration() {
    if (_timersList.isEmpty) return Duration.zero;

    // Accumulate the duration of every timer
    Duration accumulativeDuration = const Duration();
    for (ItemTimer timer in _timersList) {
      final stop = timer.end;
      if (stop != null) {
        accumulativeDuration += stop.difference(timer.start);
      }
    }

    return accumulativeDuration;
  }
}

// Timer class
class ItemTimer {
  final DateTime start;
  DateTime? end;

  ItemTimer(this.end, {required this.start});
}
```

Let's break this down!
In our `TodoItem` class 
we have the four properties 
we've aforementioned. 
When instantiating this class,
we use the `uuid` package
to create the `id`.

In the `startTimer()` function,
we create add a new timer to the 
`_timersList` timer list only if:
- the list is empty.
- the last `timer` in the list
is **not** ongoing.

In the `stopTimer()` function,
we *alter* the last timer 
in the `_timersList` array
only if:
- the last `timer` object
in the list is ongoing.
- the list is *not* empty.

To get the cumulative duration
of all the timers,
we create the `getCumulativeDuration()` function,
which iterates over the array
and gets the duration of each `timer` object.

The `timer` object is simply a
`ItemTimer` class that has two properties:
a `start` and `end` 
[`DateTime`](https://api.dart.dev/stable/2.19.4/dart-core/DateTime-class.html).
This class is defined at the end of the file.

And that's it!
If we execute the tests we've implemented
by running `flutter test`,
we will see the following output from the terminal.

```sh
00:02 +2 -4: Some tests failed. 
```

Awesome! 
This means the test pass!
We have four failing tests,
all pertaining to the `widget_test.dart` file.
This is normal, as we haven't had the opportunity to implement these features.
We will do that later!

### 1.2 `Stopwatch` class

Now let's focus on the `Stopwatch` class.

We want each todo item to have
**timers** that the person 
can *start* and *stop*. 
Each todo item
**will have a list of `timers`**,
each one with a start and stop `DateTime` property.
To get the cumulative duration,
we simply iterate over the list 
of `timers` and get the duration of each one
and sum them all up!

However, 
we want to *show to the person*
the current ongoing time 
and if the `timer` is ongoing or not.

For this,
we *can* use the [`Stopwatch`](https://api.flutter.dev/flutter/dart-core/Stopwatch-class.html)
class provided by `Flutter` 
for this.
However, 
this Dart SDK class is too simple for what we want.
We want the stopwatch to be able 
to start from an initial offset
so we can compound the duration of each timer properly.
This is *not possible* with the base class.

With this in mind,
we need to *extend* this class to have this capability.
We are going to be using a simplified version
of the `Stopwatch` extension class 
that was implemented in 
[`dwyl/flutter-stopwatch-tutorial`](https://github.com/dwyl/flutter-stopwatch-tutorial#persisting-between-sessions-and-extending-stopwatch-capabilities).

Create the file
`lib/stopwatch.dart`
and paste the following code.

```dart
class StopwatchEx {
  final Stopwatch _stopWatch = Stopwatch();

  final Duration _initialOffset;

  StopwatchEx({Duration initialOffset = Duration.zero}) : _initialOffset = initialOffset;

  start() => _stopWatch.start();

  stop() => _stopWatch.stop();

  bool get isRunning => _stopWatch.isRunning;

  int get elapsedMilliseconds => _stopWatch.elapsedMilliseconds + _initialOffset.inMilliseconds;
}
```

As you can see,
the `Stopwatch` class is wrapped
in our `StopwatchEx`.
It basically allows us to have an 
initial offset on the `stopwatch` object.
This will make it possible to 
*properly print the stopwatch time while it's running*
and not have it reset every time the person
starts and stops the timer.


## 2. Basic app layout

Now that we have everything we need,
let's start building our app!

We should first start with the basic layout.
We will need at least three things:

- a way for the person to create a new todo item.
- a text stating how many items are left.
- a list of *todo items that can be toggled*
and have a way to *create and stop timers* within them.

To build this layout, 
we will be using a 
[**TDD**](https://github.com/dwyl/learn-tdd)
approach.
Let's write the tests first
on what we expect the widgets to do
and *then* implement them!

### 2.1 Adding widget tests

These will be the widget tests
that are relevant for UX.
We are going to be testing the following constraints:

- when loading the app, 
the person should be shown a 
[`Textfield`](https://api.flutter.dev/flutter/material/TextField-class.html)
to create a new todo item
and a 
[`Text`](https://docs.flutter.dev/development/ui/widgets/text)
to show how many incomplete todo items are left.
- when the person inputs the text
and presses `Done` on the keyboard,
a new `TodoItem` widget should be shown.
- when the person clicks on the 
`TodoItem` widget,
it should toggle between a
"completed" or "not completed" state.
- each `TodoItem` widget should have a 
`Timer` [`Button`](https://api.flutter.dev/flutter/material/ElevatedButton-class.html)
that can be pressed
to start/stop the timer.
- the current time spent on each `TodoItem`
should be shown below the button
and start when the person presses the "Start" button
and stop when the person presses the "Stop" button.

Let's create the tests!
Don't worry, since the widgets don't exist,
most of these tests won't even compile at first.
We are going to be adding the widgets
and [**keys**](https://api.flutter.dev/flutter/foundation/UniqueKey-class.html)
on each one to be used in these tests.

Create the file in the
`test/widget/widget_test.dart` path
and paste the following contents.

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo/main.dart';

void main() {
  testWidgets('Build correctly setup and is loaded', (WidgetTester tester) async {
    await tester.pumpWidget(const MainApp());
    await tester.pump();

    // Find the text input and string stating 0 todos created
    expect(find.byKey(textfieldKey), findsOneWidget);
    expect(find.byKey(itemsLeftStringKey), findsOneWidget);
  });

  testWidgets('Adding a new todo item shows a card', (WidgetTester tester) async {
    await tester.pumpWidget(const MainApp());
    await tester.pumpAndSettle();

    // Find the text input and string stating 0 todos created
    expect(find.byKey(textfieldKey), findsOneWidget);
    expect(find.byKey(itemsLeftStringKey), findsOneWidget);
    expect(find.byKey(itemCardWidgetKey), findsNothing);

    // Type text into todo input
    await tester.enterText(find.byKey(textfieldKey), 'new todo');
    expect(
        find.descendant(
          of: find.byKey(textfieldKey),
          matching: find.text('new todo'),
        ),
        findsOneWidget);

    await tester.testTextInput.receiveAction(TextInputAction.done);

    // Input is cleared
    expect(
      find.descendant(
        of: find.byKey(textfieldKey),
        matching: find.text('new todo'),
      ),
      findsNothing,
    );

    // Pump the widget so it renders the new item
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Expect to find at least one widget, pertaining to the one that was added
    expect(find.byKey(itemCardWidgetKey), findsOneWidget);
  });

  testWidgets('Adding a new todo item and checking it as done', (WidgetTester tester) async {
    await tester.pumpWidget(const MainApp());
    await tester.pumpAndSettle();

    // Find the text input and string stating 0 todos created
    expect(find.byKey(textfieldKey), findsOneWidget);
    expect(find.byKey(itemCardWidgetKey), findsNothing);

    // Type text into todo input
    await tester.enterText(find.byKey(textfieldKey), 'new todo');
    await tester.testTextInput.receiveAction(TextInputAction.done);

    // Pump the widget so it renders the new item
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Expect to find at least one widget, pertaining to the one that was added
    expect(find.byKey(itemCardWidgetKey), findsOneWidget);

    // Getting widget to test its value
    Finder checkboxFinder = find.descendant(of: find.byKey(itemCardWidgetKey), matching: find.byType(Icon));
    Icon checkboxWidget = tester.firstWidget<Icon>(checkboxFinder);

    expect(checkboxWidget.icon, Icons.radio_button_unchecked);

    // Tap on item card
    await tester.tap(find.byKey(itemCardWidgetKey));
    await tester.pump(const Duration(seconds: 2));

    // Updating item card widget and checkbox value should be true
    checkboxWidget = tester.firstWidget<Icon>(checkboxFinder);
    expect(checkboxWidget.icon, Icons.task_alt);
  });

    testWidgets('Adding a new todo item and clicking timer button', (WidgetTester tester) async {
    await tester.pumpWidget(const MainApp());
    await tester.pumpAndSettle();

    // Find the text input and string stating 0 todos created
    expect(find.byKey(textfieldKey), findsOneWidget);
    expect(find.byKey(itemCardWidgetKey), findsNothing);

    // Type text into todo input
    await tester.enterText(find.byKey(textfieldKey), 'new todo');
    await tester.testTextInput.receiveAction(TextInputAction.done);

    // Pump the widget so it renders the new item
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Expect to find at least one widget, pertaining to the one that was added
    expect(find.byKey(itemCardWidgetKey), findsOneWidget);

    // Getting widget to test its value
    ElevatedButton buttonWidget = tester.firstWidget<ElevatedButton>(find.byKey(itemCardTimerButtonKey));

    // Button should be stopped
    expect(buttonWidget.child.toString(), const Text("Start").toString());

    // Tap on timer button.
    await tester.tap(find.byKey(itemCardTimerButtonKey));
    await tester.pump(const Duration(seconds: 2));

    // Updating widget and button should be ongoing
    buttonWidget = tester.firstWidget<ElevatedButton>(find.byKey(itemCardTimerButtonKey));
    expect(buttonWidget.child.toString(), const Text("Stop").toString());

    // Tap on timer button AGAIN
    await tester.tap(find.byKey(itemCardTimerButtonKey));
    await tester.pump(const Duration(seconds: 2));

    // Updating widget and button should be stopped
    buttonWidget = tester.firstWidget<ElevatedButton>(find.byKey(itemCardTimerButtonKey));
    expect(buttonWidget.child.toString(), const Text("Start").toString());
  });
}
```

Each test scenario refers
to each bullet point that was stated above.
The comments in each test scenario should be self explanatory.

These tests make use of the *keys*
pertaining to each widget.

- `textfieldKey` pertains to the
`Textfield` input where the person types 
the text to create a new todo item.
- `itemsLeftStringKey` pertains to the 
`Text` string that shows how many items are 
still to be completed.
- `itemCardWidgetKey` pertains
to the todo item card widget.
- `itemCardTimerButtonKey` pertains
to the timer button inside the todo item card widget.


### 2.2 Creating widgets

Now it's high time to start 
changing the `lib/main.dart` file
and create a basic layout for our application!

Head over to `lib/main.dart`
and change it so it looks like the following.

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            body: ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      children: [
        TextField(
          decoration: const InputDecoration(
            labelText: 'What do we need to do?',
          ),
          onSubmitted: (value) {
            print("submit new todo:$value");
          },
        ),
        const SizedBox(height: 42),
        const Padding(
          padding: EdgeInsets.only(bottom: 16.0),
          child: Text('X items left', style: TextStyle(fontSize: 20)),
        ),
        const TodoItem(),
        const TodoItem(),
      ],
    )));
  }
}

class TodoItem extends StatelessWidget {
  const TodoItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 6,
      child: Container(
        constraints: const BoxConstraints(minHeight: 70),
        child: ListTile(
          onTap: () {
            print('tapped');
          },
          leading: const Icon(
            Icons.task_alt,
            color: Colors.blue,
            size: 18.0,
          ),
          trailing: Wrap(
            children: [
              Column(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      elevation: 0,
                    ),
                    onPressed: () {},
                    child: const Text("Start"),
                  ),
                  const Text("00:00:00", style: TextStyle(fontSize: 11))
                ],
              )
            ],
          ),
          title: const Text("sometext"),
        ),
      ),
    );
  }
}
```

As you can see, we've made a few changes.

The `MainApp` stateful widget 
consists of three main elements:

- the `Textfield` where the person will input text
and create a new todo item.
- a `Text` with the string `"X items left"`.
- a list of `TodoItem` widgets.

Each `TodoItem` widget
is a stateless widget 
that uses the 
[`Material`](https://api.flutter.dev/flutter/material/Material-class.html)
class as the root
and has the icon showing whether the todo item is completed,
the timer button that can be pressed
and the description of the todo item.

If you run the app,
it should look like this.

<p align='center'>
    <img width="250" alt="basic-layout" src="https://user-images.githubusercontent.com/17494745/226194954-29b68e1c-bf7b-4971-88d5-43295aecc24a.png">
</p>

As you can see,
the app is *non-functional*.
If we click on any buttons,
todo items
or even try to input text
and press "Done" on the keyboard,
nothing happens.

To make this app *work*,
we're going to be using `Bloc`
to manage the state of the app.

Let's go! 🏃‍♂️

 
## 3. Adding `Bloc` to our project

We are going to be adding two dependencies to this project:

- [`flutter_bloc`](https://pub.dev/packages/flutter_bloc), 
for app state management.
- [`equatable`](https://pub.dev/packages/equatable),
to reduce class comparison boilerplate.

> **Note**
>
> If you are interested in learning *why* `equatable`
> is useful when paired with `bloc`,
> check https://stackoverflow.com/questions/64316700/using-equatable-class-with-flutter-bloc.

Add the following two lines 
to the `dependencies` section
in the `pubspec.yaml` file.

```yaml
  flutter_bloc: ^8.0.0
  equatable: ^2.0.0
```

And then run `flutter pub get` 
to install these newly added dependencies.

Awesome!
Now we are ready to setup the basic
`bloc` components in our `Flutter` app!


### 3.1 Adding `Bloc` tests

We've explained the main concepts
of `Bloc` in 
[`BLoC` concepts in Flutter 🦋](#bloc-concepts-in-flutter-).
We recommend reading through that
*first* so you have a better understanding 
of what we are going to implement now.

Firstly, 
we are going to be writing the tests
for the three `bloc` components we're implementing.

- the `bloc` itself.
- `bloc` events.
- `bloc` states.

Create a directory inside `test` 
called `bloc`
and add a file called `test/bloc/todo_state_test.dart`.

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:todo/bloc/todo_bloc.dart';

void main() {
  group('TodoState', () {
    group('TodoInitialState', () {
      test('supports value comparison', () {
        expect(TodoInitialState(), TodoInitialState());
      });
    });

    group('TodoListLoadedState', () {
      test('supports value comparison', () {
        expect(const TodoListLoadedState(), const TodoListLoadedState());
      });
    });

    group('TodoListErrorState', () {
      test('supports value comparison', () {
        expect(TodoListErrorState(), TodoListErrorState());
      });
    });
  });
}
```

Our `Bloc` instance in the app
will essentially have three states:
- the `TodoInitialState`, 
which refers to the initial state of the app when it loads.
- the `TodoListLoadedState`, 
when the list is correctly loaded.
This makes sense if our app would have to retrieve data
from an API.
Since we'll be doing everything locally,
our app will always achieve this state successfully.
- the `TodoListErrorState`,
in case the list is not correctly loaded.
This will never occur in our case, 
as our app deals with todo items locally.
However, if you were to fetch the todo items
from an API and get an error,
this state would prop up instead 
of `TodoListLoadedState`.

Great!
In the same directory, 
create a file called `todo_event_test.dart` 
inside `test/bloc/`
and paste the following piece of code.

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:todo/bloc/todo_bloc.dart';
import 'package:todo/todo.dart';


void main() {
  group('TodoEvent', () {
    group('TodoListStarted', () {
      test('supports value comparison', () {
        expect(TodoListStarted(), TodoListStarted());
      });
    });

    group('AddTodoEvent', () {
      final item = TodoItem(description: "description");
      test('supports value comparison', () {
        expect(AddTodoEvent(item), AddTodoEvent(item));
      });
    });

    group('RemoveTodoEvent', () {
      final item = TodoItem(description: "description");
      test('supports value comparison', () {
        expect(RemoveTodoEvent(item), RemoveTodoEvent(item));
      });
    });

    group('ToggleTodoEvent', () {
      final item = TodoItem(description: "description");
      test('supports value comparison', () {
        expect(ToggleTodoEvent(item), ToggleTodoEvent(item));
      });
    });
  });
}
```

> **Note**
>
> The reason we are importing `'package:todo/bloc/todo_bloc.dart'`
> and not `'package:todo/bloc/todo_event.dart'` is because
> the latter will be [`part of`](https://dart.dev/guides/language/effective-dart/usage#do-use-strings-in-part-of-directives)
> the `todo_bloc.dart` file.
>
> Both `todo_bloc.dart` and `todo_event.dart` don't exist yet
> because we're doing TDD but will soon enough!

In this file we are testing **`Bloc` events**.
In our application, we will have four possible events:

- `TodoListStarted`,
which is created when the todo list is initialized. 
- `AddTodoEvent`,
which is created whenever a person creates a todo item.
- `RemoveTodoEvent`,
which is created whenever a person wants to delete an item
(we won't be using this event but it's good to show how it can be used).
- `ToggleTodoEvent`,
which is created whenever a todo item is toggled
between "done" and "not done".

We're almost done!
The last (and arguably the most important) test file
we'll create will pertain to the **`bloc` definition**.
For this, 
create a file called `todo_bloc_test.dart` 
inside `test/bloc/` and add the code:

```dart
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo/bloc/todo_bloc.dart';
import 'package:todo/todo.dart';

void main() {
  group('TodoBloc', () {
    // List of items to mock
    TodoItem newTodoItem = TodoItem(description: "todo description");

    blocTest(
      'emits [] when nothing is added',
      build: () => TodoBloc(),
      expect: () => [],
    );

    blocTest(
      'emits [TodoListLoadedState] when AddTodoEvent is created',
      build: () => TodoBloc()..add(TodoListStarted()),
      act: (bloc) {
        bloc.add(AddTodoEvent(newTodoItem));
      },
      expect: () => <TodoState>[
        const TodoListLoadedState(items: []), // when the todo bloc was loaded
        TodoListLoadedState(items: [newTodoItem]) // when the todo bloc was added an event
      ],
    );

    blocTest(
      'emits [TodoListLoadedState] when RemoveTodoEvent is created',
      build: () => TodoBloc()..add(TodoListStarted()),
      act: (bloc) {
        TodoItem newTodoItem = TodoItem(description: "todo description");
        bloc
          ..add(AddTodoEvent(newTodoItem))
          ..add(RemoveTodoEvent(newTodoItem)); // add and remove
      },
      expect: () => <TodoState>[const TodoListLoadedState(items: []), const TodoListLoadedState(items: [])],
    );

    blocTest(
      'emits [TodoListLoadedState] when ToggleTodoEvent is created',
      build: () => TodoBloc()..add(TodoListStarted()),
      act: (bloc) {
        TodoItem newTodoItem = TodoItem(description: "todo description");
        bloc
          ..add(AddTodoEvent(newTodoItem))
          ..add(ToggleTodoEvent(newTodoItem));
      },
      expect: () => [
        isA<TodoListLoadedState>(),
        isA<TodoListLoadedState>().having((obj) => obj.items.first.completed, 'completed', false),
        isA<TodoListLoadedState>().having((obj) => obj.items.first.completed, 'completed', true)
      ],
    );
  });
}
```

In this file we are testing
the possible `bloc` mutations that will occur in the app.
To test this behaviour,
we are using the [`blocTest`](https://pub.dev/documentation/bloc_test/latest/bloc_test/blocTest.html)
function to construct the `bloc` 
(in the `build` parameter),
creating events in the `act` parameter
and checking the behaviour
in the `expect` parameter.

We are testing how the list of todo items
inside the `TodoListLoadedState`
changes when we add, remove and toggle todo items.

> **Note**
>
> We are creating events against the `bloc`
> using the `bloc.add()` method.


### 3.2 Adding `bloc` to our app

If we execute the tests we've coded,
they will obviously fail because we haven't a `bloc` implemented.
Let's do that now!

#### 3.2.1 `Bloc` states

In the `lib` directory, create a directory called `bloc`.
Within this directory,
create a file called `todo_state.dart`
and paste the following code into it.

```dart
part of 'todo_bloc.dart';

abstract class TodoState extends Equatable {
  const TodoState();
}


// Initial TodoBloc state
class TodoInitialState extends TodoState {
  @override
  List<Object> get props => [];
}

// TodoBloc state when the todo item list is loaded
class TodoListLoadedState extends TodoState {
  final List<TodoItem> items;
  const TodoListLoadedState({this.items = const []});
  @override
  List<Object> get props => [items];
}

// TodoBloc state when a todo item errors when loading
class TodoListErrorState extends TodoState {
  @override
  List<Object> get props => [];
}
```

We are simply creating a class pertaining 
to each possible state we've mentioned earlier.
Since we are extending `Equatable` 
to avoid any errors when comparing classes 
and avoid duplicate events being thrown,
we have to *override* the `get` method.

As you can see, 
the `TodoListLoadedState`
**has the todo items list as property**.
This property will be changed throughout the lifecycle of the app
*whenever an event is created* 
(be it adding, removing or toggling an item).


#### 3.2.2 `Bloc` events

Inside the same `lib/bloc` directory, 
create a file called `todo_event.dart`
and use the following code.

```dart
part of 'todo_bloc.dart';

abstract class TodoEvent extends Equatable {
  const TodoEvent();
}

// Event to kick start the todo list event
class TodoListStarted extends TodoEvent {
  @override
  List<Object> get props => [];
}

// AddTodo event when an item is added
class AddTodoEvent extends TodoEvent {
  final TodoItem todoObj;

  const AddTodoEvent(this.todoObj);

  @override
  List<Object> get props => [todoObj];
}

// RemoveTodo event when an item is removed
class RemoveTodoEvent extends TodoEvent {
  final TodoItem todoObj;

  const RemoveTodoEvent(this.todoObj);

  @override
  List<Object> get props => [todoObj];
}

// RemoveTodo event when an item is toggled
class ToggleTodoEvent extends TodoEvent {
  final TodoItem todoObj;

  const ToggleTodoEvent(this.todoObj);

  @override
  List<Object> get props => [todoObj];
}
```

Similarly to the **State** file,
we are using `Equatable` when defining 
the event classes and overriding the `get` method.

We are creating a class for each possible event in the app.
The event *carries information about the item*
that is being edited/removed/added.


#### 3.2.3 Creating the `bloc`

Finally, 
let's add the `bloc`
to manage our list of todo items!

In the same `lib/bloc` directory,
add a file called `todo_bloc.dart`
and use the code displayed next.

```dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:todo/todo.dart';

part 'todo_event.dart';
part 'todo_state.dart';


class TodoBloc extends Bloc<TodoEvent, TodoState> {

  TodoBloc() : super(TodoInitialState()) {
    on<TodoListStarted>(_onStart);
    on<AddTodoEvent>(_addTodo);
    on<RemoveTodoEvent>(_removeTodo);
    on<ToggleTodoEvent>(_toggleTodo);
  }

  _onStart(TodoListStarted event, Emitter<TodoState> emit) {
    emit(const TodoListLoadedState(items: []));
  }

  // AddTodo event handler which emits TodoAdded state
  _addTodo(AddTodoEvent event, Emitter<TodoState> emit) {
    final state = this.state;

    if (state is TodoListLoadedState) {
      emit(TodoListLoadedState(items: [...state.items, event.todoObj]));
    }
  }

  // RemoveTodo event handler which emits TodoDeleted state
  _removeTodo(RemoveTodoEvent event, Emitter<TodoState> emit) {
    final state = this.state;

    if (state is TodoListLoadedState) {
      List<TodoItem> items = state.items;
      items.removeWhere((element) => element.id == event.todoObj.id);

      emit(TodoListLoadedState(items: items));
    }
  }

  _toggleTodo(ToggleTodoEvent event, Emitter<TodoState> emit) {
    final state = this.state;

    if (state is TodoListLoadedState) {

      List<TodoItem> items = List.from(state.items);
      int indexToChange = items.indexWhere((element) => element.id == event.todoObj.id);

      // If the element is found, we create a copy of the element with the `completed` field toggled.
      if (indexToChange != -1) {
        TodoItem itemToChange = items[indexToChange];
        TodoItem updatedItem = TodoItem(description: itemToChange.description, completed: !itemToChange.completed);

        items[indexToChange] = updatedItem;
      }

      emit(TodoListLoadedState(items: [...items]));
    }
  }
}
```

We are defining our `TodoBloc` class
by extending the 
[`Bloc` class ](https://pub.dev/documentation/bloc/latest/bloc/Bloc-class.html).
In the constructor, 
we are defining every event handler.

```dart
  TodoBloc() : super(TodoInitialState()) {
    on<TodoListStarted>(_onStart);
    on<AddTodoEvent>(_addTodo);
    on<RemoveTodoEvent>(_removeTodo);
    on<ToggleTodoEvent>(_toggleTodo);
  }
```

These event handlers emit **states**.
In the UI, we will 
[*listen to state changes*](https://bloclibrary.dev/#/coreconcepts?id=state-changes-1)
and update the widgets accordingly.

You might have noticed
whenever we add/remove/toggle a todo item,
we are **creating a new todo item list**.
We need to create a new `List` object
so widgets like `BlocBuilder` or `BlocListeners`
*know* that the **state has changed**.
For more information,
check the following link:
https://stackoverflow.com/questions/65379743/flutter-bloc-cant-update-my-list-of-boolean.

You might have *also* noticed the following snippet of code
in some of the event handlers.

```dart
if (state is TodoListLoadedState)
```

Adding/removing/toggling todo items 
*only make sense* **when the todo item list is loaded**.
If the app is not in a correct state,
we need to handle these events accordingly.
In our case,
we don't `emit()` any new states
when the app is not on a correct state itself.

#### 3.2.4 Run the tests!

Now that we've defined 
and set up `Bloc` in our app,
we can run the tests
to see if it behaves how we intend it to!

In your terminal window,
run `flutter test`.
You should see the following output.

```sh
00:02 +13 -4: Some tests failed. 
```

Hurray! 🎉

This means our everything works as intended!
We are now *ready* to change our app
to use `bloc`!
It's high time we tackle those pesky failing tests!


## 4. Changing widgets to listen to state changes

Now it's time to change our widgets
so they react ot state changes
and finally add functionality to our app!

Before making any changes,
we need to create the keys for the widgets
we've used in our tests.

On top of the `lib/main.dart` file,
right above the `main` function,
add the following keys.

```dart
final textfieldKey = UniqueKey();
final itemsLeftStringKey = UniqueKey();
final itemCardWidgetKey = UniqueKey();
final itemCardTimerButtonKey = UniqueKey();
```

### 4.1 Providing our `TodoBloc` to the whole app

We first need to **provide `bloc` to our app**.
For this, 
we are going to be using the 
[`BlocProvider`](https://pub.dev/documentation/flutter_bloc/latest/flutter_bloc/BlocProvider-class.html)
function.

We are going to be doing this
in the root of our application.
Locate the `MainApp` stateful widget.
Let's **split it in two**:
`MainApp` will be a *stateless widget*
that will now have the `HomePage` *stateful widget*
as a child.
The code that is currently in the 
`_MainAppState` will be in `HomePage` class.

Change these two classes
in `lib/main.dart`
so they look like this:

```dart
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TodoBloc()..add(TodoListStarted()),
      child: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      ...
    )
  }
```

Inside `BlocProvider`,
we are instantiating 
the `TodoBloc` we defined in 
`lib/bloc/todo_bloc.dart`
and *immediately*
emitting a `TodoListStarted` event.
This event is handled in 
the `TodoBloc` class definition
and emits a `TodoListLoadedState`.

With this provider,
the `TodoBloc` is now accessible
on all the widgets below in the widget tree.
The `child` parameter of `BlocProvider`
is the `HomePage` class we've just created.


### 4.2 Creating and listing `TodoItem` widgets

Now that we've provided the `TodoBloc`
to the widget tree,
it's high time we make use of it!
Let's focus on **creating todo items**
and **listing them** to the person.

Let's focus on the former.
We are going to first need a 
[`TextEditingController`](https://api.flutter.dev/flutter/widgets/TextEditingController-class.html)
to manage the text input in the `TextField`.

Declare it in the `_HomePageState`
as a property 
and properly dispose it to avoid memory leaks.

> **Note**
>
> We are using this in a *stateful widget*
> because we need to dispose the controller properly
> or else we'll have troubles with memory leaks.
>
> Find more information about in
> https://stackoverflow.com/questions/61425969/is-it-okay-to-use-texteditingcontroller-in-statelesswidget-in-flutter.


```dart
class _HomePageState extends State<HomePage> {

  TextEditingController txtFieldController = TextEditingController();

  @override
  void dispose() {
    txtFieldController.dispose();
    super.dispose();
  }
  
  ...
}
```

We are not going to *wrap*
the whole body of the `_HomePageState` with 
[`BlocBuilder`](https://pub.dev/documentation/flutter_bloc/latest/flutter_bloc/BlocBuilder-class.html).
This will make it so we can listen to new state changes
and the UI updates accordingly with new information.

```dart
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Scaffold(body: BlocBuilder<TodoBloc, TodoState>(
      builder: (context, state) {
        return ListView(
          ...
        )
    )
  }
```

We now have access to `context` and `state`.
The latter is quite important,
so we know what to render depending on the state of the app.
In our case,
we are only interested in rendering our app
when it's in a `TodoListLoadedState` state.

Here comes the fun part!
First, change the `TodoItem` widget class
in `lib/main.dart`
to `ItemCard` so it does not conflict
with the `TodoItem` class we've implemented earlier.

```dart
class ItemCard extends StatelessWidget {
  const ItemCard({super.key});
  ...
}
```

And now let's change the `_HomePageState`
`build` function so it looks like so!
Don't worry, we'll break it down what we've changed!

```dart
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Scaffold(body: BlocBuilder<TodoBloc, TodoState>(
      builder: (context, state) {
        // If the list is loaded
        if (state is TodoListLoadedState) {
          int numItemsLeft = state.items.length - state.items.where((element) => element.completed).length;
          List<TodoItem> items = state.items;

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            children: [
              // Textfield to add new todo item
              TextField(
                key: textfieldKey,
                controller: txtFieldController,
                decoration: const InputDecoration(
                  labelText: 'What do we need to do?',
                ),
                onSubmitted: (value) {
                  if(value.isNotEmpty) {
                    // Create new item and create AddTodo event
                    TodoItem newTodoItem = TodoItem(description: value);
                    BlocProvider.of<TodoBloc>(context).add(AddTodoEvent(newTodoItem));

                    // Clear textfield
                    txtFieldController.clear();
                  }
                },
              ),

              const SizedBox(height: 42),

              // Title for items left
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(key: itemsLeftStringKey, '$numItemsLeft items left', style: const TextStyle(fontSize: 20)),
              ),

              // List of items
              if (items.isNotEmpty) const Divider(height: 0),
              for (var i = 0; i < items.length; i++) ...[if (i > 0) const Divider(height: 0), ItemCard()],
            ],
          );
        }

        // If the state of the TodoItemList is not loaded, we show error.
        else {
          return const Center(child: Text("Error loading items list."));
        }
      },
    )));
  }
```

With `BlocBuilder`, by having access to the state,
we therefore have access to the list of todo items.
We can get the number of incomplete todo items
by iterating over the list.
After checking if the state of the app is properly set,
we get this information in the snippet of code below.

```dart
  if (state is TodoListLoadedState) {
    int numItemsLeft = state.items.length - state.items.where((element) => element.completed).length;
    List<TodoItem> items = state.items;

    ...
  }
```

We are going to be using these two properties
in the `Text` that shows the number of items left...

```dart
Text(key: itemsLeftStringKey, '$numItemsLeft items left', style: const TextStyle(fontSize: 20))
```

...and to list the todo items.

```dart
if (items.isNotEmpty) const Divider(height: 0),
for (var i = 0; i < items.length; i++) ...[if (i > 0) const Divider(height: 0), ItemCard(item: items[i])],
```

For each item in the todo list item in `TodoBloc`,
we create an `ItemCard` widget.

> **Note**
> 
> We aren't currently passing any information to these widgets,
> so they will always look the same.
> Don't worry, 
> we will address this in the next section!

The last thing we ought to change 
is the `TextField` to create a new todo items.
Let's check the `onSubmitted` function
we've changed.

```dart
onSubmitted: (value) {
  // Create new item and create AddTodo event
  TodoItem newTodoItem = TodoItem(description: value);
  BlocProvider.of<TodoBloc>(context).add(AddTodoEvent(newTodoItem));

  // Clear textfield
  txtFieldController.clear();
},
```

When the person submits the text,
an `AddTodoEvent` is created with the new text.
This is handled in `TodoBloc`, 
as we've shown prior.

And that's it!
If you run the application now,
input any text you like 
and press `Done`,
you will see the new todo items being created!

<p align='center'>
    <img width="250" alt="listing/creating" src="https://user-images.githubusercontent.com/17494745/226636752-e21c74c6-367e-4624-be79-39fdb7683739.gif">
</p>

Each todo item is the same.
That's because we are not passing
each todo item inside `TodoBloc` 
to the `ItemCard` widget!


### 4.3 Toggling and start/stopping timers in `ItemCard`

As it stands,
the app is not really useful.
People need to be able to toggle 
each `ItemCard` and start/stop timers.
Let's address both of these concerns! 🎉

Firstly,
we are going to be converting our `ItemCard`
from a *stateless widget* to a
**stateful widget**.
We need to do this because we are using
the `StopwatchEx` to show the current timer value
and a [`Timer`](https://api.flutter.dev/flutter/dart-async/Timer-class.html)
class to re-render the widget so the timer value is shown properly.
The `ItemCard` will now receive an item.

```dart
// Widget that controls the item card
class ItemCard extends StatefulWidget {
  final TodoItem item;

  const ItemCard({required this.item, super.key});

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
...
}
```

Don't forget to pass on the `TodoItem` object
when listing the items
inside the `build` function
of `_HomePageState` class!

```dart
if (items.isNotEmpty) const Divider(height: 0),
for (var i = 0; i < items.length; i++) ...[if (i > 0) const Divider(height: 0), ItemCard(item: items[i])],        
```

Let's now change the `_ItemCardState`
to look like the following code.

```dart
class _ItemCardState extends State<ItemCard> {
  // Stopwatch to be displayed
  late StopwatchEx _stopwatch;

  // Used to re-render the text showing the timer
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();

    _stopwatch = StopwatchEx(initialOffset: widget.item.getCumulativeDuration());

    // Timer to rerender the page so the text shows the seconds passing by
    _timer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
      if (_stopwatch.isRunning) {
        setState(() {});
      }
    });
  }

  // Timer needs to be disposed when widget is destroyed to avoid memory leaks
  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  // Start and stop timer button handler
  handleButtonClick() {
    // If timer is ongoing, we stop the stopwatch and the timer in the todo item.
    if (_stopwatch.isRunning) {
      widget.item.stopTimer();
      _stopwatch.stop();

      // Re-render
      setState(() {});
    }

    // If we are to start timer, start the timer in todo item and stopwatch.
    else {
      widget.item.startTimer();
      _stopwatch.start();

      // Re-render
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      key: itemCardWidgetKey,
      color: Colors.white,
      elevation: 6,
      child: Container(
        constraints: const BoxConstraints(minHeight: 70),
        child: ListTile(
          onTap: () {
            // Create a ToggleTodo event to toggle the `complete` field
            context.read<TodoBloc>().add(ToggleTodoEvent(widget.item));
          },

          // Checkbox-style icon showing if it's completed or not
          leading: widget.item.completed
              ? const Icon(
                  Icons.task_alt,
                  color: Colors.blue,
                  size: 18.0,
                )
              : const Icon(
                  Icons.radio_button_unchecked,
                  color: Colors.blue,
                  size: 18.0,
                ),

          // Start and stop timer with stopwatch text
          trailing: Wrap(
            children: [
              Column(
                children: [
                  ElevatedButton(
                    key: itemCardTimerButtonKey,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _stopwatch.isRunning ? Colors.red : Colors.green,
                      elevation: 0,
                    ),
                    onPressed: handleButtonClick,
                    child: _stopwatch.isRunning ? const Text("Stop") : const Text("Start"),
                  ),
                  Text(formatTime(_stopwatch.elapsedMilliseconds), style: const TextStyle(fontSize: 11))
                ],
              )
            ],
          ),

          // Todo item description
          title: Text(widget.item.description),
        ),
      ),
    );
  }
}
```


Let's break down our changes!
We first initialize
`_stopwatch` and `_timer`.
The former is a variable of the class
`StopwatchEx`, 
the wrapper of the `Stopwatch` class
we created earlier. 
This will be used to show the value of the timer.
On the other hand, 
the latter is a `Timer`.
This is used to re-render the widget 
every **200 milliseconds**
so the stopwatch text shows the value of the timer properly.

We are defining these variables 
in the `initState` function,
which is executed when the widget is mounted.
To update the widget every 200 milliseconds,
we simply call `setState(() {});` to force a re-render.

```dart
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();

    _stopwatch = StopwatchEx(initialOffset: widget.item.getCumulativeDuration());

    // Timer to rerender the page so the text shows the seconds passing by
    _timer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
      if (_stopwatch.isRunning) {
        setState(() {});
      }
    });
  }
```

To avoid memory leaks,
we dispose of the `_timer` variable
when the widget is destroyed
in the `dispose()` function.


#### 4.3.1 Start and stopping the timer

The button and the elapsed time text
is placed within the `trailing` parameter 
of the `Container` that is the `ItemCard`.

```dart
trailing: Wrap(
  children: [
    Column(
      children: [
        ElevatedButton(
          key: itemCardTimerButtonKey,
          style: ElevatedButton.styleFrom(
            backgroundColor: _stopwatch.isRunning ? Colors.red : Colors.green,
            elevation: 0,
          ),
          onPressed: handleButtonClick,
          child: _stopwatch.isRunning ? const Text("Stop") : const Text("Start"),
        ),
        Text(formatTime(_stopwatch.elapsedMilliseconds), style: const TextStyle(fontSize: 11))
      ],
    )
  ],
),
```

We are *leveraging* the `_stopwatch` variable
to show either a "Start" or "Stop" button.
Additionally, we call the `elapsedMilliseconds()`
function and show it to the person.
This value is properly shown because the widget is rendered
every 200ms, as stated previously.

We are using a `formatTime()` function.
We have used the code from this answer from StackOverflow -> 
https://stackoverflow.com/a/56458586/20281592.
Create a file in `lib` called `utils.dart`
and paste the following code from it.

```dart
String formatTime(int milliseconds) {
  var secs = milliseconds ~/ 1000;
  var hours = (secs ~/ 3600).toString().padLeft(2, '0');
  var minutes = ((secs % 3600) ~/ 60).toString().padLeft(2, '0');
  var seconds = (secs % 60).toString().padLeft(2, '0');
  return "$hours:$minutes:$seconds";
}
```

This will format the code properly to be shown to the person.

Moving on,
the `handleButtonClick()` is called
every time the button is pressed.
In this function,
depending on whether the timer is running or not,
we call the `stopTimer()` or `startTimer()`
functions of the `TodoItem` class.


#### 4.3.2 Toggling the `ItemCard` 

Luckily, toggling the todo item
between "complete" and "incomplete"
is super easy!
We just need to create a `ToggleTodoEvent`!

```dart
onTap: () {
  // Create a ToggleTodo event to toggle the `complete` field
  context.read<TodoBloc>().add(ToggleTodoEvent(widget.item));
},
```

Check the file
[`lib/main.dart`](https://github.com/dwyl/flutter-bloc-tutorial/blob/0ac576a9ee3ea7bb1fb87787ab4f1cd89972dbaf/lib/main.dart)
for the final version of how
the file should look like!

## 5. Run the app!

We've made all the necessary changes!
Let's run the app and see how it fares!

<p align='center'>
    <img width="250" alt="final" src="https://user-images.githubusercontent.com/17494745/226667102-7d63a74e-4cb6-4090-9cc6-0ffda53f8e1f.gif">
</p>


Awesome! 🎉

Our tests should all pass as well!
Run `flutter test`.
You should see this output.

```sh
00:03 +17: All tests passed! 
```

Heck yeah! 🥳

We are *successfully* leveraging `Bloc`
to manage the list of todo items.
These items are accessible by all the widgets
in the widget tree.
Every widget is able to access them
*and also make changes to them*,
which is what happens when we mutate the todo item list,
either by adding new elements
or toggling items within it.

# I need help! ❓
If you have some feedback or have any question, 
do not hesitate and open an 
[issue](https://github.com/dwyl/flutter-bloc-tutorial/issues?q=is%3Aissue+is%3Aopen+sort%3Aupdated-desc)! 
We are here to help and are happy for your contribution!
