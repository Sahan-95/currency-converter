# currency_converter

This mobile app features a real-time currency converter with API-based updates.

## Getting Started

The application can be tested using both a simulator and a real device. I created an account to obtain the currency conversion API endpoints, which include an App ID for authentication. This App ID allows for up to 1000 requests per month.

The app architecture follows a clean architecture pattern, consisting of three layers: data, domain, and presentation. Each layer operates independently. The presentation layer includes screens and components necessary for displaying the UI. SharedPreferences is used for saving and loading data to/from local storage.

The application is almost complete, except for the functionality to load favorite items. Although I implemented this feature, it currently causes an error, so I have commented out that part of the code.
