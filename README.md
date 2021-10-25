# About this project

The required endpoints for this assignment only deal with getting User information, but have nothing to do with setting up all of the things that the User information is based on. I made a couple extra endpoints that you can use to "seed" the database (manually and on not db installation), so you can simulate events being created, users being invited to those events, and the events coming and passing.

I time blocked 3 hours for this project. In all honesty, I don't do test driven development and typically save my tests for last. This project does not include any tests whatsoever. We can talk about how I <i>would</i> structure my tests though, if I were to spend more time on this.

## The Database

I have three straight forward tables.

### users
Represents a person who can be invited to an event.
| Attribute | Type    |
|-----------|---------|
| id        | integer |
| name      | string  |
| score     | integer |

### events
Represents a calendar event that someone can be invited to
| Attribute | Type                 |
|-----------|----------------------|
| id        | integer              |
| name      | string               |
| time      | enum: [past, future] |

### event_users
This is a joining table for Events and Users. It's basically a guest list. Users and Events have a many to many relationship.
| Attribute | Type                               |
|-----------|------------------------------------|
| id        | integer                            |
| user_id   | integer                            |
| event_id  | integer                            |
| response  | enum [ignored, accepted, declined] |
| present   | boolean                            |

## How I recommend you use this project

- Clone it, and then navigate to the project directory where you can `rake db:setup` and `rake db:migrate`
- Run the rails server locally with `rails s`
- Make a few API calls to the local service to fill the DB with dummy data (I guess I could have written a script for this, but I felt fleshing out the API was a better use of my time. We can talk about why)
- Finally, pass some events via API (more about this later)
- Get a list of Users via API
- Return the score of one User via API

### Fill the DB With Dummy Data
Here I'll walk through the API calls you can make to load up the DB. In real life, these would probably be called by a lot of different services at a lot of different times, but for this example, you have to pretend to be all of those different services.

#### 1. Create some Users
I imagine these calls would really come from whatever service is running the sign-up page.
```
curl -X POST localhost:3000/api/v1/users --header "Content-Type: application/json" --data '{"name":"Tucker"}'
curl -X POST localhost:3000/api/v1/users --header "Content-Type: application/json" --data '{"name":"Adam"}'  
curl -X POST localhost:3000/api/v1/users --header "Content-Type: application/json" --data '{"name":"Houston"}'
```

#### 2. Create some Events
These calls would probably come from a webhook with whatever calendar service we're integrating with.
```
curl -X POST localhost:3000/api/v1/events --header "Content-Type: application/json" --data '{"name":"Standup"}'
curl -X POST localhost:3000/api/v1/events --header "Content-Type: application/json" --data '{"name":"Estimations"}'
curl -X POST localhost:3000/api/v1/events --header "Content-Type: application/json" --data '{"name":"Adam/Houston 1:1"}'
```

#### 3. Create some EventUsers (a joining table that respresents the guest lists of events
These would also probably come from webhooks with an integrating calendar service. By default, an EventUser's response is "ignored" until you update it.

This group of calls represents the activity of user 1, as they are invited to and accept event invitations.
```
curl -X POST localhost:3000/api/v1/event_users --header "Content-Type: application/json" --data '{"user_id":1, "event_id":1}'
curl -X PUT localhost:3000/api/v1/event_users/1 --header "Content-Type: application/json" --data '{"response":"accepted"}'
curl -X POST localhost:3000/api/v1/event_users --header "Content-Type: application/json" --data '{"user_id":1, "event_id":2, "response":"accepted"}'
curl -X POST localhost:3000/api/v1/event_users --header "Content-Type: application/json" --data '{"user_id":1, "event_id":3, "response":"ignored", "present":false}'
```

And here are more calls to help flesh out the database for other users.
```
curl -X POST localhost:3000/api/v1/event_users --header "Content-Type: application/json" --data '{"user_id":2, "event_id":1, "response":"declined","present":false}'
curl -X POST localhost:3000/api/v1/event_users --header "Content-Type: application/json" --data '{"user_id":2, "event_id":2, "response":"declined","present":false}'
curl -X POST localhost:3000/api/v1/event_users --header "Content-Type: application/json" --data '{"user_id":2, "event_id":3, "response":"accepted"}'

curl -X POST localhost:3000/api/v1/event_users --header "Content-Type: application/json" --data '{"user_id":3, "event_id":1, "response":"accepted"}'
curl -X POST localhost:3000/api/v1/event_users --header "Content-Type: application/json" --data '{"user_id":3, "event_id":2, "response":"accepted"}'
curl -X POST localhost:3000/api/v1/event_users --header "Content-Type: application/json" --data '{"user_id":3, "event_id":3, "response":"accepted"}'
```

#### 4. Finally, you can test the calls specced out in the assignment PDF
First, if you get a list of Users, you'll notice that none of them have scores.
```
curl -u user:pass http://localhost:3000/api/v1/users
[
  {
    id: 1,
    name: "Tucker",
    score: null,
    created_at: "2021-10-24T23:28:58.269Z",
    updated_at: "2021-10-24T23:28:58.269Z"
  },
  {
    id: 2,
    name: "Adam",
    score: null,
    created_at: "2021-10-24T23:41:09.727Z",
    updated_at: "2021-10-24T23:41:09.727Z"
  },
  {
    id: 3,
    name: "Houston",
    score: null,
    created_at: "2021-10-24T23:41:11.968Z",
    updated_at: "2021-10-24T23:41:11.968Z"
  }
]
```

This is because no events have passed yet. I did not default scores to 0. Instead they are null until an Event that the user was invited to has passed. This is a convenient way to tell if a User is brand new or not, plus it might help in cleaning up the DB later. If a user has a null score for 90 days, maybe they should be cleaned up by some background job.

Here's how you can pass some events ("pass" as in, move an event from the future, to the past). 
```
curl -X PUT localhost:3000/api/v1/events/1 --header "Content-Type: application/json" --data '{"time":"past"}'
```
You'll notice afterward that fetching the list of Users again, will show that they have had their scores updated. Here I'll show an example of getting the score for just one user.
```
curl -u user:pass localhost:3000/api/v1/users/1/score
2
```

You can continue to "pass" events with the PUT events/:id call and testing out the scoring logic.

I have been writing for a while! Maybe I should have made swagger docs too, but oh well, I have to carry one with my life at somepoint!!
