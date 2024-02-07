---
title: "Why I Self-Host My Website Analytics"
author: Andreas Lien
date: 2024-02-07T08:22:22+02:00
draft: false
toc: false
images:
tags:
  - analytics
  - self-host
  - ackee
  - google analytic
---

Recently I made the switch to self-hosted analytics, after being a long-term Google Analytics user. Almost every website you visit will have a Google Analytics tracker on it. I think there are idealogical and technical reasons to opt for self-hosted analytics instead.

## Tracking efficacy
This one’s quick. You’re more likely to get analytics for a given user if you’re using self-hosted analytics, than if you’re using Google Analytics. About [26% of people](https://www.statista.com/statistics/804008/ad-blocking-reach-usage-us/) are running adblockers now, a large percentage of which will also block tracking scripts, like GA. Having your analytics on analytics.yourdomain.com makes your requests less likely to be blocked.

## On principle - being a customer vs being a lead
Google Analytics (including gtag and universal analytics), has a whopping [73% market share](https://www.datanyze.com/market-share/web-analytics--1). That’s millions and millions of sites, and billions of data points processed every day. Google’s spending millions on this service (disclaimer: that number is pulled from absolutely nowhere, but even if 5 engineers are carrying the entirety of Google Analytics on their back and server costs are zero, that already puts it in the millions).

Google, like any company, isn’t providing an expensive service for free out of the goodness of their heart, or because they can spare the money. They’re hoping that by being a Google Analytics customer, you’ll become an AdWords customer. Google Analytics users aren’t customers, they’re leads. Personally I feel a lot more secure in my transactions knowing I’m a customer.

There’s also the data privacy standpoint. I don’t want Google to know as much about my website visitors as I do. Something doesn’t feel right to me about giving Google that amount of insight into my site. With self-hosting I’m in control of my visitors’ data.

## Simplicity
Google Analytics, for my purposes, has way too much complexity. I know there are sites that benefit from the comparisons and stats you can pull up through Google Analytics. Some website out there can probably benefit from finding out what % of male users in Germany, who visited the marketing page between January and March, signed up for a paid account in July. Maybe in the future I’ll have a website receiving billions of hits per month where I could materially benefit from such a query. But for now, I really don’t need it, and I don’t want the complex UX that comes along with the ability to run queries like that. All I need is a rough idea of how much traffic I’m getting, where it’s coming from, and what pages it goes to. A simple self-hosted analytics service gives me that.

## My new analytics setup
My GA-alternative of choice is [Ackee](https://github.com/electerious/Ackee). It took me all of 10 minutes to set up using the [helm chart](https://artifacthub.io/packages/helm/suda/ackee) (admittedly, longer than Google Analytic’s 30-second copy and paste), it shows me the stats I care about in a clean UI, it’s open-source, and it’s self-hosted.
