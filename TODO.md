# TODO List

1. Setup Stripe integration and user-subscriptions and one-off payments for lead orders
2. Build out agent ability to order leads
3. Build out lead order history
4. Agent should see ordered vs delivered lead counts on navbar
5. Setup additional incoming lead endpoints
6. Setup chat support
7. Refine interface, make all links resolvable
8. Add twitter-card
9. Add CRM functionality to the lead-card for agents

## Currently In-Progress

Number 2

Waiting for access to do stripe integration

## Current non-resolvable links

Guessing we will build each of these out with the appropriate functionality.

* Order Leads - Needs Stripe integration
* G.O.A.T. CRM - Get details on CRM functionality
* Become an Affiliate - Build out an affiliate program?

## Complete

* Refactor leads to use Single Table Inheritance so we can handle them differently based on lead type
* Reverse engineer the lead-assignment algorithm
* Configure asynchronous job to run the lead-assignment algorithm - Use Sidekiq
* Stylize email templates
* Build out lead order model
* Modify algorithm to use lead_order.lead_class instead of user.lead_types and account for lead_order being active (or paused), expired_on, days_per_week and max_per_day
* Configure exception/error notifications to send emails to me and in a slack channel
* Flesh out the whitelabeling support

## Completed Incoming Lead Endpoints

* https://crm.goatleads.com/leads/veteran_lead - All veteran lead types

## Links to remember

* https://mycrmcenter.com/update-lead-order - CRM lead orders
* https://app.agentcrmcenter.com/v2/preview/PibNxV8i7yM9IrKTOztp - Site preview
* https://mycrmcenter.com/update-lead-order - Lead Orders
* https://app.leadcapture.io/lead-form/20843 - Lead Forms
* https://docs.google.com/spreadsheets/d/1iEQBViYSNDJ9pgUjXkPbt2kbtO08II2gQX3l1_ohr68/edit?gid=0#gid=0 - Vet Leads Example
* https://docs.google.com/spreadsheets/d/1q_GkCYBSQ_zLRm1I0fVde8Nu5r751otb_FjKEdI0FxQ/edit?gid=0#gid=0 - IUL Leads Example
* https://docs.google.com/spreadsheets/d/1wBqtF-NN-HsX7Xri0a7Ck4pdDrbNRsdbj7xP2VENS3I/edit?gid=0#gid=0 - Agent Lead Spreadsheet Example
* https://docs.google.com/spreadsheets/d/1zFKhSUJpb1ZiAWi8C-oExnu3RYGIIZzv9lmq_OevbaA/edit?gid=0#gid=0 - Lead Assignment Spreadsheet Example

## Questions

* When an agent registers on the site what fields are required?
*   email - currently required
*   password/password confirmation - currently required
*   first/last name
*   phone
*   licensed states
* When they click on the CRM link at crm.goatleads.com what should they see? In other words what functionality do we want for the CRM portion of the site?
*   Lead cards with clickable telephone and email links? Notes, Date Contacted, etc?

## Meeting Notes

### Competition

* Lead Byte: leadbyte.co.uk
* Boberdoo: boberdoo.com
* LeadProsper.io: leadprosper.io

Push leads into our system, assign them and push to another system

## Reporting Site

* Upload CSV files by each manager
