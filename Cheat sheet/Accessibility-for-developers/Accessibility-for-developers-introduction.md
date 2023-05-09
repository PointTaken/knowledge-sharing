# A beginners guide to Web Accessibility for developers: Part 1 – introduction
> Originally published at [acupof.dev](https://elischei.com/a-beginners-guide-to-web-accessibility-for-developers-part-1-introduction/)

You have probably heard about web accessibility on more than one occasion, especially if you work as a front-end developer. But a lot of front-enders think that making their applications accessible is a hassle. That’s not because we don’t care, but because the approach to how we implement it is kind of backwards.

Typically the site is almost finished before someone suddenly showes up with the “accessibility check list” and (since we are not allowed to write every little thing all over again from the start) we try to put some ARIA-attributes on top of the stuff that are already built – and hope for the best.

In this blogpost series I will cover the things you should know as a developer, to **make the web an accessible place for everyone**, and to **create a better developer experience** for yourself and others.

The complete blogpost series will consist of five blogpost. In this first one I will give you an overview of web accessibility. Why is it important, what makes a web page (in)accessable, and what are the things that we as developers should take into concideration when creating web applications?

## Why is it important?
The internet is such a huge part of education, commerce, socializing and entertainment, so it’s important to make it accessible to create equal access and equal opportunity. And if you chose not to, you chose to actively exclude potential users/customers.

## What makes a web page (in)accessible?
When we talk about web accessibilty most of us think of blind people, or maybe someone that can’t use a mouse. That’s not wrong, and they are an important target group, but webiste accessibility is about more than supporting screen readers and tab-navigation.

Have you ever tried to navigate a webpage and become lost, or been unable to find what you were looking for? Or maybe you started to fill out a form, then you got interrupted by a phone call, and afterwards you can’t remember what the input-field was supposed to contain – and the error you get only says “There is an error in the form”.
What about reading the content of a webpage on your phone, outside in bright sunshine?

By creating an accessiblie web application we make the experience better for all users.

### Users diversity
There are four categories of access impairments: cognitive, motor, hearing and visual. And for each of them the impairment can be situational, temporary or permanent.

Lets look at some examples:

* A very noisy environment can make it difficult to hear. This is a situational hearing impairment.
* Blindness is a permanent visual impairment. Having difficulty reading on your phone because of bright light/sunshine is situational and visual.
* A broken arm can make it impossible to use a mouse. This is a temporary motor impairment. While being paralyzed is a permanent motor impairment.

Feeling a bit overwhelmed by all the possibilities and challenges we should try to meet in our web applications? Don’t worry, someone else has done a lot of work for you, and written down a wide range of recommendations for making web content more accessible. These recomendations are called Web Content Accessibility Guidelines (WCAG), and we will take a look at them in the next section.

## Take an “accessibility first” approach
If you’ve been working in tech for a while you might remember when “mobile first” became a thing? In the beginning a lot of people (typically clients who didn’t want to pay more to support multiple screen sizes) was against it. Why should we care about users who visited our site from a phone? They can use a laptop! It took some time but after a while everyone was expecting front-end developers to create these amazing responsive web sites. And today that is something as natural as having a website in the first place.

I think that it is the same thing with accessibility. Everyone is starting to realise that it is important, and that it will benefit everyone, but it is not common to have a “accessibility firts” approach yet. But I’m here to tell you that you as a developer should take this approach even though those around you are not there yet.

It will make your developer experience better if you have accessibility in the forefront of your mind from the start. When you take that into concideration when deciding how to structure your code, or how to solve a user interaction, your creations will be accessible from the beginning. And you dont have to go back and refactor – or haphazardly put some ARIA-attributes on top of it.

In the next blogposts in this series I will give you some practical examples, but first lets take a look at the guidelines that exists.

### Web Content Accessibility Guidelines (WCAG)
The WCAG guidelines are created by The World Wide Web Consortium (W3C) Web Accessibility Initiative (WAI). If you [want to read more about the initiative you can find their website here](https://www.w3.org/WAI/about/).

We have allready covered that WCAG is a set of guidelines and resources that we can use to create more accessible websites. WCAG is divided into four main principals, they say that web content should be percivable, operable, understandable and robust. From a high level this is what they cover:

* **Perceivable**
Information should be presented in a way that all users can perceive. This means that you should not rely only on one of the users senses.
* **Operable**
The web is interactive and it is important that users can navigate, click on buttons, fill in information, toggle hidden content etc, all without realying on a mouse.
* **Understandable**
The principle is about predictability, simple language, good help functionality.
* **Robust**
The principal about robustness is mostly about the code. The content should be accessible as technology evolves. This includes for assistive technology.

In addition to guidelines WCAG also [covers concrete examples of how to implement different types of content](https://www.w3.org/WAI/tips/developing/).

**Levels of WCAG**
For each of the main principals there are guidelines that are categorized into three levels. A (lowest), AA (mid range and AAA (highest). For some types of content it is not possible to achive level AAA complience, so most sites should have level AA as their goal.

This blogpost is already getting to long, and we have one more topic to cover, so I won’t go into more detail about WCAG for now. If you want to learn more about WCAG take a look at the official site.

### Accessible Rich Internet Applications (ARIA)
As a developer you have probably encountered ARIA attributes before. If you haven’t used them when writing code yourself maybe you’ve seen them in other peoples code, or in code examples. ARIA is a set of attributes we use to describe the intent of our code for screen readers and other assistant technology.

**What is ARIA**
The [MDN Web Docs](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA) defines ARIA like this: “Accessible Rich Internet Applications (ARIA) is a set of attributes that define ways to make web content and web applications (especially those developed with JavaScript) more accessible to people with disabilities.”

As mentioned ARIA is a set of attributes you can use to add metadata to your html. Lets look at an example

```html
<button aria-describedby="myButtonDescription">Click here</button>
<div id="myButtonDescription">When you click here ** will happen</div>
```
In the example above the “aria-describedby” tells us (or the assistance technology) that the functionality of the button is described by the div that has id “myButtonDescription”. _Note, the better solution here would be to have a more descriptive text on the button itself, like "Register for the conference", WAI-ARIA should be the last resort_.

ARIA is a huge topic so I’ve dedicated a whole blogpost to it (part 4 of this series). If you want to learn more you should take a look at the [MDN Web Docs](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA) or the [Web Accessibility Initiative site](https://www.w3.org/WAI/standards-guidelines/aria/).

## Summary
Yay, you made it all through this text-heavy introduction! (Or you just jumped here for the TL;DR; Thats ok too 😀 )

Lets summarize what you just learned.

Accessibility is about more than blind people and screen readers, and making the web more accessible will benefit all users.

Access impairments can be categorized as **cognitive, motor, hearing and visual**, and they can be **situational, temporary or permanent**.

By taking av “accessibility first” approach you will get a better developer experience and help create equal access and equal opportunity by makin the web accessible to all. There are a lot of things to consider but luckily we have resources like WCAG and ARIA to help us create more accessible web applications.



<link rel="canonical" href="https://elischei.com/a-beginners-guide-to-web-accessibility-for-developers-part-1-introduction/"/>
