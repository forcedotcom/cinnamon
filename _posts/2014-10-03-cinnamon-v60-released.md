---
layout: news_item
title: 'Cinnamon v.60 is released!'
sub-title: 'Cinnamon v.60'
date: 2014-10-03
author: jheritagesf
version: v60.0
categories: [release]
---

Hi there!

Cinnamon Package Version 60 is now available. 

Starting with this release, PageObjects are initialized automatically so you no longer have to explicitly call `PageObject.initializePageObject()`. Now, simply call `Context.getPageObject(<PageObject Class>)` and use the pre-initialized returned instance. 

There is also a new ExpectedCondition called TitleToContain. This ExpectedCondition tests whether the title of the Web browser contains the text passed in as a parameter.

Please click [here](https://login.salesforce.com/packaging/installPackage.apexp?p0=04td0000000N2SV) to install this version.

If you see issues or bugs, please let us know via our [Github Issues](https://github.com/forcedotcom/cinnamon/issues) page.

Happy testing!
