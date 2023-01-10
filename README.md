Weather app
===========

This is the app submission for the Faire take home test for the Senior iOS Engineer role.

# Architecture

The chosen architecture for this coding challenge is MVVM. The reason why this is the best architecture for the given problem is that it provides a good separation of concerns - which helps with unit tests and code manutenability.
The MVVM layers are:
- Model: All data, rules, and utilities that are tigthtly related to the business rules;
- ViewModel: Middle layer between Model and View that is responsible for handling all UI interactions and delegating these events to the business layer;
- View: Any UI componenent that is rendered to the user and also responsible for capturing any UI event (touch, scroll, etc.);

For this architecture, isolated unit tests could be created using mocks injected on components constructors. 

Due to the app complexity, I decided to keep the code lean and simple to easily support new features and change the existing ones.

# Dependencies

No dependencies were added to this project to keep it simple to read and fast to build. Only libraries provided by the iOS SDK were used.

# Tutorials

## How to build and run

Since there are no dependencies needed to build and run the app, you can go directly to the menu `Product > Run` (command + R).

Have fun!

## How to test

You can run all tests on the menu `Product > Test` (command + U).
