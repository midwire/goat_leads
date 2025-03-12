# TODO List

* Build out lead order model, lead order history
* Setup Stripe integration and user-subscriptions and one-off payments for lead orders
* Agent should see ordered vs delivered leads on navbar
* Stylize email templates
* Setup incoming lead endpoints
* Configure exception/error notifications to send emails to me and in a slack channel
* Setup chat support
* Flesh out the whitelabeling support
* Refine interface, make all links resolvable

## Current non-resolvable links

Guessing we will build each of these out with the appropriate functionality.

* Order Leads - Internal lead order system or integration with 3rd party?
* G.O.A.T. CRM - Get details on CRM functionality
* Become an Affiliate - Build out an affiliate program?

## Complete

* Refactor leads to use Single Table Inheritance so we can handle them differently based on lead type
* Reverse engineer the lead-assignment algorithm
* Configure asynchronous job to run the lead-assignment algorithm - Use Sidekiq

## Completed Incoming Lead Endpoints

* https://crm.goatleads.com/leads/veteran_lead - All veteran lead types

## Questions

* When an agent registers on the site what fields are required?
*   email - currently required
*   password/password confirmation - currently required
*   first/last name
*   phone
*   licensed states
* When they click on the CRM link at crm.goatleads.com what should they see? In other words what functionality do we want for the CRM portion of the site?
*   Lead cards with clickable telephone and email links? Notes, Date Contacted, etc?


