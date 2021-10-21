---
title: "Apple ∑Mn"
author: Andreas Lien
date: 2021-10-21T14:01:42+02:00
draft: false
toc: false
images:
tags:
  - Apple
  - SoC
  - Apple M1
  - October event
  - chip
  - M1 Max
  - M1 Pro
---

Its October! That is also a synonym for a new [Apple event](https://en.wikipedia.org/wiki/List_of_Apple_Inc._media_events#Apple_Event_(October_18,_2021)), well it is actually either October or September if I have to be precise. This October was my attention wrapped around the new [SoCs](https://en.wikipedia.org/wiki/System_on_a_chip) in Apple Silicons line-up, to be more precise the upgrade of Apple's 2020 [M1](https://en.wikipedia.org/wiki/Apple_M1) chip, [Apple M1 Pro](https://en.wikipedia.org/wiki/Apple_M1_Pro) and [Apple M1 Max](https://en.wikipedia.org/wiki/Apple_M1_Max). Where Apple continues to make the naming conventions more confusing with direct connection to the names of [iPhones](https://en.wikipedia.org/wiki/IPhone) models. So, to break it down for ordinary people `Pro` is like iPhone 13 Pro and `Max` is like iPhone 13 Pro Max but without the Pro part. It's super easy to understand, right? Well its a bit more intricate than that. Apple has showed with the M1 chip that the transition over from [Intel-based x86](https://en.wikipedia.org/wiki/Apple%E2%80%93Intel_architecture) CPUs to the own in-house designed microprocessors running on the [Arm](https://en.wikipedia.org/wiki/AArch64#ARMv8.4-A) instruction set don't need to be so problematic, do you [follow Microsoft](https://www.theverge.com/2020/6/10/21285866/mac-arm-processors-windows-lessons-transition-coexist)? Apple M1 wasn't that groundbreaking in terms of performance, but more of a unexpectedly good transition to Arm. 

{{< image src="/media/Apple_M1.jpg" alt="Illustration of Apple M1"
class="center" width="420"
attrlink="https://commons.wikimedia.org/wiki/File:Apple_M1.jpg"
caption="Illustration of Apple's M1 processor." attr="Henriok, CC0 1.0" >}}

The two new chips look to change that situation, with Apple going all-out for performance, with more CPU cores, more GPU cores, much more silicon investment, and Apple now also increasing their power budget far past anything they’ve ever done in the smartphone or tablet space.

{{< tweet 1450255227945242628 >}}

### The M1 Pro: The Middle Child
The first of the two chips which were announced was M1 Pro – laying the ground-work for what Apple calls no-compromise laptop SoCs.

The company divulges that they’ve doubled up on the memory bus for the M1 Pro compared to the M1, moving from a 128-bit LPDDR4X interface to a new much wider and faster 256-bit LPDDR5 interface, promising system bandwidth of up to 200GB/s. That is most likely a rounded number, for an LPDDR5-6400 interface of that width would achieve 204.8GB/s.

### The M1 Max: The Big Brother
Alongside the M1 Pro, Apple also announced a bigger brother – the M1 Max. While the M1 Pro catches up and outpaces the laptop competition in terms of performance, the M1 Max is aiming at delivering supercharging the GPU to a total of 32 cores. Essentially it’s no longer an SoC with an integrated [GPU](https://en.wikipedia.org/wiki/Graphics_processing_unit), rather it’s a GPU with an SoC around it.

The packaging for the M1 Max changes slightly in that it’s bigger – the most obvious change is the increase of [DRAM](https://en.wikipedia.org/wiki/Dynamic_random-access_memory) chips from 2 to 4, which also corresponds to the increase in memory interface width from 256-bit to 512-bit. Apple is also advertising a massive 400GB/s of bandwidth, which if it’s LPDDR5-6400, would possibly be more exact 409.6GB/s. This kind of bandwidth is unheard of in an SoC, but quite the norm in very high-end GPUs.



