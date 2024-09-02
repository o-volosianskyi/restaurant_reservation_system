The challenge
Please implement a simple restaurant reservation system as a simple rails app. Assume this system would be used by the restaurant hostess as she takes requests over the phone. The restaurant is open 24 hours per day, and each reservation starts on the hour and lasts exactly one hour.

Please implement using ruby ~> 3.2, with Rails 7.x
No user accounts or authentication are necessary
We care about simple phone reservation requests like "I'd like seating for 4 at 7pm on Friday".
We do NOT need to think about special requests ("I want to be near the window", etc)
You can choose as many tables as you want to fill requested capacity. Please define your own sample set of 10 tables, ranging from seating capacity from 2-8 people.
The UI should be a list of all existing reservations, and a field to enter the name and date/time for a new reservation request.
Submitting a new request should either add the reservation and display a success message, or show a capacity error.
Please use sqlite, mysql, or postgres for the database.
Write tests in the framework of your choice.
Please use as few gems as possible to get the task completed efficiently.
Implement a responsive design, ideally using Bootstrap or another common framework.
Please aim for a clean and intuitive interface.