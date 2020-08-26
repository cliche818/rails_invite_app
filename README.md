### Requirements
* ruby 2.5.3

### Setup

1. `bundle`
2. `rake db:migrate db:test:prepare`
3. `rake db:seed`

### Tests

Run `rake`

### Jeff Documentation

### How to run a sample demo
`in rails c`
1) Create a company
 `Company.create(name: "ABC Company")`
2) Create an invite for the company with a specific invite code
 `Invite.generate('invite_code1', Company.last)`

`in browser`
3) go to localhost:3000/invite/invite_code1
4) sign up or log in for that user to join the company

### Design decisions
1) Using invite_code instead of id
    - harder to guess like if invite_url was localhost:3000/invite/13, there is probably an invite 12
    - invite_code can act as a description
2) Invite being polymorphic
    - initially was thinking of company invite and project invite, but found there will be a lot of similar code in the controllers
3) changed the sign up and log in pages
    - passed invite code as params to these pages and have their corresponding pages handle adding the company and project in the action

### new urls
1) GET localhost:3000/invite/[invite_code] - invite_code being the column in the invite tables
2) POST localhost:3000/join_invite - used on the invite page if the user is signed in so they can join the company/project


### Next Steps
1) figure out how to extract the similar code for adding a project/company in session_controller/new_controller/invite_controller
    - a possible solution would be a class that will return true/false if it was able to add the company/project and an error message for
    the controller to match and return the correct flash message, but this doesn't really reduce the number of if/else branche in the controllers
2) handle if the user fails to sign up / log in with a invite code, the subsequent page does not have the invite code anymore (need to pass the invite code param for redirect)
