# Responsive Web Implementation References

Use these references when you define, implement, or verify responsive web
behavior.

## Responsive Foundations

Read [Responsive Web Design Basics][responsive-web-design-basics] before you
define viewport behavior, fluid media, content width, or breakpoints.

Apply these rules:

- Include a correct viewport meta element.
- Prevent page-level horizontal scrolling.
- Size media and content within the viewport.
- Add breakpoints when content needs more space.
- Test touch, pointer, and keyboard input.

## CSS Grid

Read [A Complete Guide to CSS Grid][css-grid-guide] when the layout uses CSS
Grid.

Use the guide to check grid containers, tracks, placement, alignment, implicit
grids, responsive functions, and browser behavior. Prefer intrinsic track
sizes such as `minmax()`, `min-content`, `max-content`, and `fr` when they fit
the content requirements.

## Mobile-First Indexing

Read [Mobile Site and Mobile-First Indexing Best Practices][mobile-first-indexing]
when the page contains search-visible content or metadata.

Keep primary content, headings, metadata, structured data, images, and
alternative text equivalent across viewport layouts. Do not require user
interaction to load primary content. Keep required resources available to
crawlers.

## Implementation Checks

Use [PageSpeed Insights][pagespeed-insights] to inspect mobile and desktop
performance, accessibility, and user experience signals. Treat results as
diagnostic evidence, not as a replacement for project acceptance tests.

Use the [W3C Markup Validation Service][w3c-markup-validator] to find invalid
HTML. Correct markup errors that can affect semantics, accessibility, layout,
or browser behavior.

[css-grid-guide]: https://css-tricks.com/complete-guide-css-grid-layout/
[mobile-first-indexing]: https://developers.google.com/search/docs/crawling-indexing/mobile/mobile-sites-mobile-first-indexing
[pagespeed-insights]: https://pagespeed.web.dev/
[responsive-web-design-basics]: https://web.dev/articles/responsive-web-design-basics
[w3c-markup-validator]: https://validator.w3.org/
