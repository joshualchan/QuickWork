# QuickWork

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)

## Overview
### Description
[Description of your app]

### App Evaluation
[Evaluation of your app across the following attributes]
- **Category:** Business
- **Mobile:** This app is optimized for iOS (mobile) because of the native features of Swift.
- **Story:** We want to develop a quick and efficient freelancing app that enables users to post and search tasks, communicate easily, and perform transactions all in one app.
- **Market:** People in densely populated communities looking to effectively get a task done. Freelancers looking to complete tasks.
- **Habit:**
- **Scope:**

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

* User can create an account and add basic personal info.
* User can login to a feed of tasks.
* User can add a new task.
* User can view the tasks they posted in profile tab
* User can tap on a task to view additional details
* User can message another user about a task

**Optional Nice-to-have Stories**

* User can search for a task
* User can pay on the app
* User can mark when a task is finished/ delete a task

### 2. Screen Archetypes

* [list first screen here]
   * [list associated required story here]
   * ...
* [list second screen here]
   * [list associated required story here]
   * ...

### 3. Navigation

**Tab Navigation** (Tab to Screen)

* Profile screen
* Feed screen
* Messages screen

**Flow Navigation** (Screen to Screen)

* [list first screen here]
   * [list screen navigation here]
   * ...
* [list second screen here]
   * [list screen navigation here]
   * ...

## Wireframes
[Add picture of your hand sketched wireframes in this section]
<img src="YOUR_WIREFRAME_IMAGE_URL" width=600>

### [BONUS] Digital Wireframes & Mockups

### [BONUS] Interactive Prototype

## Schema 
## Schema 
### Models
#### User

   | Property      | Type     | Description |
   | ------------- | -------- | ------------|
   | objectId      | String   | unique id for the user (default field) |
   | number        | String   | user's phone number |
   | username      | String   | user's username |
   | password      | String   | (hidden) |
   | email         | Number   | user's email address |
   | picture       | File?    | user can upload an optional photo |
   | createdAt     | DateTime | date when post is created (default field) |
#### Message

   | Property      | Type     | Description |
   | ------------- | -------- | ------------|
   | objectId      | String   | unique id for the message (default field) |
   | message        | String   | message sent by user |
   | recipient      | String   | foreign key from User's objectId |
   | sender      | String   | foreign key from User's objectId |
   | name         | Number   | name of the user that sent the message |
   | createdAt     | DateTime | date when message is created (default field) |
#### Tasks

   | Property      | Type     | Description |
   | ------------- | -------- | ------------|
   | objectId      | String   | unique id for the task (default field) |
   | city          | String   | city in which task takes place |
   | name          | String   | name of the task |
   | user          | String   | foreign key from User's objectId of the user that posted the task |
   | image         | File?   | optional image for task |
   | description   | String   | description for the task |
   | createdAt     | DateTime | date when post is created (default field) |


### Networking
- [Add list of network requests by screen ]
- [Create basic snippets for each Parse network request]
- [OPTIONAL: List endpoints if using existing API such as Yelp]
