GOAT LEADS - FFL

Integrity - lead-center & life-center

They buy leads from us, work them and submit ins. biz to integrity
They work leads in GHL. Send data to integrity for underwriting, etc.
They want to work the leads in their Integrity-lead-center.
NPN - unique to each agent which gets sent with integration from GHL.

- CRM - life center (medicare and life), direct marketing drip campaigns, etc.
- Want agents to integrate with their CRM
-- pull in leads
-- pull leads from lead-center
-- to use quote and enroll tool

- Changes in LC need to get pushed to GHL
-- LC will provide endpoints
-- We will sync leads with them

## Info

* https://app.agentcrmcenter.com/v2/preview/PibNxV8i7yM9IrKTOztp - Site preview
* https://mycrmcenter.com/update-lead-order - Lead Orders
* https://app.leadcapture.io/lead-form/20843 - Lead Forms
* https://docs.google.com/spreadsheets/d/1iEQBViYSNDJ9pgUjXkPbt2kbtO08II2gQX3l1_ohr68/edit?gid=0#gid=0 - Vet Leads Example
* https://docs.google.com/spreadsheets/d/1q_GkCYBSQ_zLRm1I0fVde8Nu5r751otb_FjKEdI0FxQ/edit?gid=0#gid=0 - IUL Leads Example
* https://docs.google.com/spreadsheets/d/1wBqtF-NN-HsX7Xri0a7Ck4pdDrbNRsdbj7xP2VENS3I/edit?gid=0#gid=0 - Agent Lead Spreadsheet Example
* https://docs.google.com/spreadsheets/d/1zFKhSUJpb1ZiAWi8C-oExnu3RYGIIZzv9lmq_OevbaA/edit?gid=0#gid=0 - Lead Assignment Spreadsheet Example
* https://docs.google.com/spreadsheets/d/1wkGDPQA2KwCYLC4TtICdGKQQJHWlhii9bZ6T7eEbhyc/edit?exids=71471483%2C71471477 - Lead Count/Costs By Day (All Lead Types) - Dashboard
*

## UTM Parameters

utm_source = Facebook or YouTube
utm_medium  = Location of Ad
utm_campaign = Campaign Name
utm_content  = Ad Name
utm_site_source = ig, fb or yt
utm_owner = RoundRobin (this is for the future if we want to run an ad for an individual
utm_adset = Adset name of Ad
utm_ad_platform = fb, ig, an <<<<<<---- New Field we will use for all reporting. This data is captured on google sheets in field Lead Attribution Platform

Current FB UTM String 03/29/2025
utm_source={{site_source_name}}&utm_medium={{placement}}&utm_campaign={{campaign.name}}&utm_content={{ad.name}}&utm_adset={{adset.name}}&utm_site_source={{site_source_name}}&utm_owner=RoundRobin&fbc_id={{adset.id}}&h_ad_id={{ad.id}}

New UTM String 03/29/2025
utm_source={{site_source_name}}&utm_medium={{placement}}&utm_campaign={{campaign.name}}&utm_content={{ad.name}}&utm_adset={{adset.name}}&utm_site_source={{site_source_name}}&utm_owner=RoundRobin&fbc_id={{adset.id}}&h_ad_id={{ad.id}}&utm_ad_platform={{site_source_name}}

Ad Platform
fb - Facebook
ig - Instagram
an - Audience Network
dg - Google Demand Generation
sh - Google Search
px - Google Performance Max
tk - TikTok
ob - Outbrain
tb - Taboola
bg - Bing

