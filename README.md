<div align="center">

![bloc-logo](https://user-images.githubusercontent.com/17494745/223100913-13fdb2de-cfd5-4450-9b65-77ac10893d4e.png)


Learn
**`Block`**
for **Flutter**
to better manage your
app's state.

![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/dwyl/flutter-bloc-tutorial/ci.yml?label=build&style=flat-square&branch=main)
[![codecov.io](https://img.shields.io/codecov/c/github/dwyl/flutter-bloc-tutorial/main.svg?style=flat-square)](https://codecov.io/github/dwyl/flutter-bloc-tutorial?branch=main)
[![contributions welcome](https://img.shields.io/badge/contributions-welcome-brightgreen.svg?style=flat-square)](https://github.com/dwyl/flutter-bloc-tutorial/issues)
[![HitCount](https://hits.dwyl.com/dwyl/flutter-bloc-tutorial.svg)](https://hits.dwyl.com/dwyl/flutter-bloc-tutorial)

</div>
<br />

Use these links to skip straight to the section that interests you:

- [A note 🗒️](#a-note-️)
- [Why? 👀](#why-)
- [What? 🤷‍♂️](#what-️)
  - [Core concepts 🧱](#core-concepts-)
    - [Streams](#streams)
    - [Bloc](#bloc)
    - [Cubit](#cubit)
    - [Wait... so which to use?](#wait-so-which-to-use)
  - [no `flutter concepts`, msotrar como definir um bloc, eventos, handlers, observers, providers...](#no-flutter-concepts-msotrar-como-definir-um-bloc-eventos-handlers-observers-providers)


# A note 🗒️

This tutorial assumes you have prior basic knowledge of `Flutter`.
If this is your first time using `Flutter`,
please visit [`dwyl/learn-flutter`](https://github.com/dwyl/learn-flutter)
first to learn the basics. 

After that, 
we *highly recommend* you
follow [`dwyl/flutter-todo-list-tutorial`](https://github.com/dwyl/flutter-todo-list-tutorial).
You will find great value in it,
to guide you through implementing an app
with shared state *without* `Bloc`.

# Why? 👀

If you've worked with `Flutter`,
you probably came across **stateful widgets**.
In these widgets, the state and
how/when it changes determines how many times
the widget is rendered.
The state that is contained in the widget
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
e-commerce app or user preferences.

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
and *utilize* shared state in your application
and do the heavy lifting for you.
Examples include
[Riverpod](https://riverpod.dev/),
[Provider](https://pub.dev/packages/provider)
and [**Bloc**](https://bloclibrary.dev/#/),
where the latter will be the focus of this tutorial.

# What? 🤷‍♂️

`BLoC` is actually an acronym for 
**B**usiness **L**ogic **C**omponents,
and is effectively a design pattern created by Google
that *separates* business logic from the presentation layer.

From this concept arose [`Bloc`](https://bloclibrary.dev/#/),
a state management library created by 
[Felix Angelov](https://github.com/felangel)
which aims to *easily* implement this design pattern
in Flutter apps.

For every interaction that is made in the application,
**state should emerge from it**. 
For example, when you make an API call,
the app should show a loading animation (**loading state**).
When the internet is disabled,
a notification could be shown to the user
stating there is no internet connection.

There are a few benefits for using `Bloc`:
- the logic is *kept out of the widgets*.
- it's easy to test logic and widgets separately.
"When my state ix X, widgets should be Y".
- we can *trace user interactions*
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

Let's start with the most "difficult" one.
Quoting `Bloc`'s docs:

> A `Bloc` is a more advanced class 
> which relies on `events` to trigger `state` changes rather than functions. 
> `Bloc` also extends `BlocBase`,
> which means it has a similar public API as `Cubit`. 
> However, rather than calling a `function` on a `Bloc` 
> and directly emitting a new `state`, `Blocs` receive `events` 
> and convert the incoming `events` into outgoing `states`.

Phew, that was a mouthful!
Let's break that down.

<img width="1144" alt="bloc-diagram" src="https://user-images.githubusercontent.com/17494745/223118425-a8a86010-82d9-4c1e-8fde-41025d5ae88b.png">

> credits of the image go to https://www.youtube.com/watch?v=sAz_8pRIf5E&ab_channel=BradCypert.

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

A `Cubit` is a **much simpler, minimalistic version of a `Bloc`**.
Unlike `Bloc`,
the `Cubit` exposes functions that can be invoked
to trigger state changes.

Check the following diagram.

<img width="1127" alt="cubit-diagarm" src="https://user-images.githubusercontent.com/17494745/223120206-dee22295-94f4-472a-803d-45ca9f3cab45.png">

> credits of the image go to https://www.youtube.com/watch?v=sAz_8pRIf5E&ab_channel=BradCypert.

In `Cubit`, 
although similar,
differ from `Bloc` because
**they don't have events**.
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
and it's better suited for simple use cases.
If your team is struggling to model event transitions,
you might want to start with `Cubits`.

However, if you value traceability 
or are havinga  hard time mocking cubits for widget tests,
you might want to use `Blocs`.

If you're unsure of the event-driven approach,
start with `Cubit`.
You can always refactor the code later on 
to a `Bloc` when you have a clearer idea
of the possible events of your application.




## no `flutter concepts`, msotrar como definir um bloc, eventos, handlers, observers, providers...