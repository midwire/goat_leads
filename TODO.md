# TODO List

1. Phase 1 - Lead Distribution platform and Lead Repository. Able to distribute leads any platform or multiple platforms, ie. Google Sheets, GHL, Ringy, any Webhook. Our software needs settings screen to be able to build Webhook to any platform. Reporting dashboard to monitor costs. Interface for staff to handle lead returns. Ability for us to feed leads to system.
2. Phase 2 - move purchasing/stripe to the software and have stripe integration. Main GHL site will have links to purchase from our integrated system. Build landing pages in system to collect leads directly.
3. Phase 3 - move entire store website from GHl to new platform
4. Phase 4 - build Lead portal to replace google sheets. “Lite CRM”
5. Phase 5 - build CRM to replace GHl with Twilio and email integration and wavv and kixie integration.

## Dev Ops & Maint

[x] - Move Postgres to it's own host
[x] - Add recaptcha to user registration
[] - Add low-level throttling in ApplicationController to mitigate DOS attacks and hacking attempts
[] - Add favicon and twitter-card

## Phase 1

[x] Accept incoming LeadOrders on webhook endpoint
[x] Accept incoming Leads on webhook endpoint (incoming lead handler)
[x] Prepare active lead-forms to send a properly formatted lead
[x] Assign Leads to Agents through LeadOrders
[x] Allow distribute Leads to Agents Google Sheets
[x] Send email notifications on lead assignment?
[x] Send SMS notifications on lead assignment
[x] Distribute Leads to Agents GHL
[x] Distribute Leads to Agents Ringy
[x] Distribute Leads to Agents Webhook
[] Turn on lead distribution in production
[.] Build Reporting Dashboard to monitor costs
[] Build Manager interface to handle Lead returns

## Phase 2

[] Stripe integration
[] Native lead-orders
[] Native lead forms


## Ad Spend Info

### Spreadsheet Headers

Vet Leads Daily Spend (Jobs Ad Manager) FB
FEX Leads Daily Spend (Jobs Ad Manager) FB
IUL Leads Daily Spend (Jobs Ad Manager) FB
MP Leads Daily Spend (Jobs Ad Manager) FB
Vet Leads Daily Spend (Allegiance Manager) FB
Spanish FEX Leads
IUL Leads Daily Spend (Allegiance Ad Manager) FB
MP Leads Daily Spend (Allegiance Ad Manager) FB
VET Google Demand Gen
VET Google Search
VET Google PMax
FEX Google Demand Gen
FEX Google Search
FEX Google PMax
IUL Ad Google Demand Gen
IUL Ad Google Search
IUL Ad Google PMax
MP Ad Google Demand Gen
MP Ad GoogleSearch
MP Ad Google PMax
Vet Leads Daily Spend TikTok
FEX Leads Daily Spend TikTok
IUL Leads Daily Spend TikTok
MP Leads Daily Spend TikTok
Annuity Leads Daily Spend (Jobs Ad Manager) FB

## Currently In-Progress

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
* Lead Order endpoint
* Get lead orders feeding from GHL

## Completed Incoming Lead Endpoints

* https://crm.goatleads.com/hooks/leads - All veteran lead types

## Links to remember

* zoom.fflall.com - Zoom Meetings
* https://mycrmcenter.com/update-lead-order - CRM lead orders
* https://mycrmcenter.com/submit-ringy-info - Ringy Info
* https://app.agentcrmcenter.com/v2/preview/PibNxV8i7yM9IrKTOztp - Site preview
* https://app.leadcapture.io/lead-form/20843 - Lead Forms
* https://docs.google.com/spreadsheets/d/1iEQBViYSNDJ9pgUjXkPbt2kbtO08II2gQX3l1_ohr68/edit?gid=0#gid=0 - Vet Leads Example
* https://docs.google.com/spreadsheets/d/1q_GkCYBSQ_zLRm1I0fVde8Nu5r751otb_FjKEdI0FxQ/edit?gid=0#gid=0 - IUL Leads Example
* https://docs.google.com/spreadsheets/d/1wBqtF-NN-HsX7Xri0a7Ck4pdDrbNRsdbj7xP2VENS3I/edit?gid=0#gid=0 - Agent Lead Spreadsheet Example
* https://docs.google.com/spreadsheets/d/1zFKhSUJpb1ZiAWi8C-oExnu3RYGIIZzv9lmq_OevbaA/edit?gid=0#gid=0 - Lead Assignment Spreadsheet Example
* https://youtu.be/RQ4S_nSKR38 - Intro Video

### Spreadsheet Links

#### Agent Spreadsheets

Spreadsheet format

* https://docs.google.com/spreadsheets/d/1ZbqBYHY_BcZ_rXIaQcaw4P0KlzdyL3T8KvDhYV6qWp0/edit?usp=sharing - FEX
* https://docs.google.com/spreadsheets/d/1tFZ4fIJgO8zJnxnqK3Mb634Ho9Gls9T76MVXey1DdQY/edit?usp=sharing - Veteran
* https://docs.google.com/spreadsheets/d/1fgaf0t15pe8M2qEo_aZAEkXv5nlVD7z_QnWdS3n-_nM/edit?usp=sharing - IUL
* https://docs.google.com/spreadsheets/d/17cHSlPESchjMHF6ze8FLCEhZZLWE8VSqOMS4UyYkYyA/edit?usp=sharing - Mortgage Protection

## Questions

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
* Did they earn a raise (dollar amt. over time)
* Everyone who reached the next milestone month to month
* Dashboard interface
* Reports based of agency name, or agent, date ranges

## Old

1. Setup Stripe integration and user-subscriptions and one-off payments for lead orders
2. Build out agent ability to order leads
3. Build out lead order history
4. Agent should see ordered vs delivered lead counts on navbar
5. Setup chat support
6. Refine interface, make all links resolvable
7. Add twitter-card
8. Add CRM functionality to the lead-card for agents

