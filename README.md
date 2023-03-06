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

Use these links to skip staright to the section that interests you:

- [Why?](#why)
- [What?](#what)
  - [Core concepts](#core-concepts)


# Why?

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

# What?

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

Before implementing anything, 
we need to *understand* 
how the `Bloc` library works.

The following sections take inspiration 
from the official [`Bloc` docs](https://bloclibrary.dev/#/gettingstarted).
If you want a more in-depth explanation,
we highly encourage you to check them.

## Core concepts

