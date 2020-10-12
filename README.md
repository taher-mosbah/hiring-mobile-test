Cuvva Mobile Tech Test

## Hello fellow iOS developer.

We’re really happy you’re interested in joining our iOS team at Cuvva.

The point of this task is to demonstrate your thinking process, deductive reasoning, problem solving and how well you can interpret and implement a brief.
We’re looking for a clean, well factored Swift codebase. Your submission should demonstrate your ability to produce functionally correct, maintainable, testable code. And of course, we want to see your well-versed understanding of the Swift language and the iOS SDK.  
  
What we are not going to look at is any “boilerplate code”.  We don’t care how you get the data from the API for instance, feel free to do a blocking synchronous hack if you want to!  
  
There is no need to persist the data and it’s safe to assume the device running will be connected to the internet.

If you have any questions, feel free to reach out to the team – we’re here to help you succeed.

## The challenge

We want you to spend the amount of time necessary to demonstrate the best of your awesome iOS abilities. The test should take somewhere between 4 and 6 hours to complete the minimum requirements defined below. If you’re having fun and want to spend longer that’s fine!

### Requirements

 * **Data**: Efficiently de-serialise and process the JSON REST API (described below)

 * **UI & App**: Build an app that closely matches the design supplied. The app needs to work in portrait mode only and on iOS 13 and above

* **Tests**: Write no more than 3 or 4 tests which cover the most important aspects you feel require test coverage.

* **Documentation**: Include a README that includes:
  * Roughly how long you took
  * Any special instructions on how to build and run the app
  * A list of "Things I would include / do differently if I had more time" 
  * Rationale for using any 3rd party libraries (if any)
  * Detail any assumptions you made or known issues you didn't get time to resolve
  * Please add any comments or notes that we should consider as part of your application


## Task 1: Data Processing

Retrieve the policy event stream from the end point: **https://cuvva.herokuapp.com/08-10-2020**  

Process the stream into a collection of policies that can be easily queried for vehicle, duration and end time.  

The event stream data contains multiple events for multiple policies.

Each event has an event type and a variable content payload. The description and processing instructions for each type are as follows:  
  
**1. Policy Created**

This occurs when a new insurance policy has been created.  It contains the vehicle details, a unique policy ID and the start and end times of the policy.

**2. Policy Cancelled**

This occurs when a policy has been cancelled. There will only be one of these events per policy.  It contains the ID of the policy that should be cancelled along with a cancellation reason and an option new end date for the policy.  If there is no end date then use the start date of the cancelled policy as the effective end date for any calculations you may need.

**3. Policy Extension**

This occurs when an existing policy needs to be extended for another period of time. It contains the ID of the policy that should be extended along with start and end dates for the extension.

***A few tips to help you later in the UI task:***

An “Active” policy is one where the current real-world time is between the policy start_date and the policy end_date (or the maximum end date of any of its extensions)

Keep the extension payload details as they need to be displayed later.

## Task 2: UI and App

Taking the processed data from the first task you now need to display this in a simple two screen app.  Your completed app should look as close as possible to the supplied screen shots  
  
The policies should be grouped by vehicle and vehicles should be split into two groups:- those with a currently active policy and those with no active policy (see the home screen design for details)  
  
Tapping a vehicle on the homes screen should navigate to a “details” page.  This page will show an optional box for any active policy and a list of all policies and extensions (see the detail screen design for details)  

**Colors**
* txt_normal : #0A0A5C 
* txt_highlight : #6666FF 
* txt_minor : #9999AB
* txt_minorMuted : #BEBEC6
* txt_white : #FFFFFF
* bg_main : #FFFFFF
* bg_surface : #F7F7FF
* bg_surface_highlight : #6666FF
* bg_green : #33CC99
* separator : #F0F0FF

**Fonts**

* title bold - size: 22 weight: bold
* body - size: 15 weight: regular
* body bold - size: 15 weight: bold
* body small - size: 13 weight: regular
* body small bold - size: 13 weight: bold

  

**HOMESCREEN**  
![HomeScreen](https://raw.githubusercontent.com/cuvva/hiring-mobile-test/update12Oct2020/HomeScreen.png)

**DETAILSCREEN WITH ACTIVE POLICY**
![ActiveDetail](https://raw.githubusercontent.com/cuvva/hiring-mobile-test/update12Oct2020/ActiveDetail.png)

**DETAIL SCREEN WITTH NO ACTIVE POLICY AND EXTENSION**
![InactiveDetail](https://raw.githubusercontent.com/cuvva/hiring-mobile-test/update12Oct2020/InactiveDetail.png)

  

## Completion

Share your private Github repo with the user ***@cuvvatest***.  
  
Remember to mention your Github username in communication with us or include your name in the repository description so that we know whose code we’re looking at.

After we have considered your submission you may be asked to discuss your solution either face to face or over a video / screen sharing call.

Good luck and we look forward to speaking with you very soon.
