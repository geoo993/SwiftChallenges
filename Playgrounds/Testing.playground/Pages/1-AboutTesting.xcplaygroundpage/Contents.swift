import Foundation


/* WHAT IS TESTING?
- Testing on iOS is a process by which your application is tested on Apple devices like iPhone and iPad.
 The goal is to evaluate whether the app works as expected for specific user actions and under different hardware and software configurations.
 The actions may include installation time, load time, user interface, user experience, appearance, behavior, functionality, and performance.
 */

 /* WHY DO WE TEST?
 - The reasons we test is because we know that a lot of people use smartphones and mobile apps on a day-to-day basis.
  Most of these devices are iOS devices with Apple having a large market share worldwide.
  With these high usage and the affinity we have toward using these smartphones and apps, it has become increasingly
  important that app developers deliver apps that run flawlessly, which is critical for ensuring a positive experience
  among your many user who use these smartphone devices.
  for these reasons we need to make sure our apps are well tested before they are released to the public.
  As a result app testing is a process that allows developers and QA teams to evaluate how iOS apps behave based on different device types and configurations.
*/


/* TYPES OF TESTING IN iOS?
 The different types of testing that we can do on iOS testing to ensure our app is at the best state to be released to the public.
 
Using our device
1- System Testing - this type of testing is performed on the system to check if the various components of the system work together.
2- UI/UX Testing - the UI/UX of the iOS devices is a key element of an app success story. Testing will usually involve make sure the app works as expected with all device and system inputs, the app should respond well to all touchscreen functionalities and the screen is tested in all orientations if needed.
3- Security Testing - these testing will involve checking authentication flows, third party integrations, checking data privacy and encryptions, server communication checks.
4- Field Testing - a field test is done to verify the behaviour of the app on the phone’s data network.
 
 
 
Using Emulators/Simulators
1- Unit Testing - testing unit of code in our project source code.
2- Integration Testing - testing the integration of our business logic.
3- UI testing - testing unter inteface and different interactions in our app.
4- Snapshot testing - using new snapshots of our UI to check existing UI hasnt changed unexpectatly.
5- Automation Testing - is a much better way to test iOS applications systematically. We run a suite of tests to evaluate the application every time a change is made to its code. This means we can verify that the application continues to behave and perform as expected and that any problems can be detected before the application is deployed into a production environment. Automated testing is also performed during continuous integration through where your application CI tool will build and run test every time changes are made.

6- End to End testing - In an end-to-end test, the entire application stack is tested, from the UI to the app logic to network requests and backend server functionality. The goal of end-to-end testing is to evaluate how the application as a whole would behave when placed in the hands of actual end-users.
7- Regression Testing - In the ever-changing environment, changes are continuously done to enhance the application or to fix the issues that were found in the previous version of it. While implementing the changes, there comes the chance where the changes done to the application can alter the existing functionality. Which means, the changes done may introduce a new set of issues in the application. To verify if the application performs in the same way even after the changes are implemented, Regression testing has to be performed.
 */


/* BEST PRACTICES OF TESTING?
- Don’t always rely on emulators, in most cases emulators are preferred over the real devices. But that’s not always ideal since things like User interactions, Battery consumption, network availability, performance on usage, memory allocation cannot be tested on the emulators. So testing on real devices leads to more reliable test result.

- Automate testing during continuous integration instead of testing manually, this is because in today’s world, everyone is mainly concerned about the time spent. Automation not only reduces the execution time but also increases effectiveness, efficiency and the coverage of the software testing.
 
- Run tests in parallel, Instead of running tests one-by-one, use a test grid to run many tests at once. You’ll get results much faster, which means you can get your app to users more quickly.

- Run unit and end-to-end tests, as noted above, unit tests and end-to-end tests shouldn’t be an either/or proposition. Run both to maximize your ability to detect problems before they impact your users – and to ensure that you can identify bugs as early in the development process as possible, when they are easier to fix.

 - Make use of Logs, our app may freeze or crash under certain circumstances. To fix the issue, crash logs play a vital role.
 */
