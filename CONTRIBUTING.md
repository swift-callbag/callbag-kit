<h1>Contributing</h1>

Thank you for your interest in CallbagKit! There are multiple ways you can
contribute to this project. We welcome contributions in all areas, with special
attention to:

- [General rules](#general-rules)
  - [File an Issue](#file-an-issue)
  - [Style Guides](#style-guides)
  - [Fork the Repository](#fork-the-repository)
  - [Make the Pull Request](#make-the-pull-request)
- [Performance improvements](#performance-improvements)
- [Documentation improvements](#documentation-improvements)
- [New operators](#new-operators)
- [Developer's Certificate of Origin 1.1](#developers-certificate-of-origin-11)

Please take the time to carefully read the following guide. These rules help
make the best out of your time, the code reviewer's time and the general
consistency of the project.

<hr align="center" style="background-color: #393939; height: 2px">

## General rules

1. File an issue to notify the maintainers about what you're working on.
2. Fork the repo, develop and test your code changes, add docs.
3. Make sure that your commit messages clearly describe the changes.
4. Send a pull request.

### File an Issue

Use the [issue tracker][Issues] to start the discussion. It is possible that
someone else is already working on your idea, your approach is not quite right,
or that the functionality exists already. The ticket you file in the issue
tracker will be used to hash that all out.

### Style Guides

1. Write in UTF-8 in Swift 5.0
2. User modular architecture to group similar functions, classes, etc. 
3. Always use 2 spaces for indentation (don't use tabs)
4. Try to limit line length to 80 characters
5. Class / Struct names should always be capitalized
6. Function names should always be camelized
7. Look at the existing style and adhere accordingly

### Fork the Repository

Be sure to add the relevant tests before making the pull request. Docs will be
updated automatically when we merge to `master`, but you should also build
the docs yourself and make sure they're readable.

### Make the Pull Request

Once you have made all your changes, tests, and updated the documentation,
make a pull request to move everything back into the main branch of the
`repository`. Be sure to reference the original issue in the pull request.
Expect some back-and-forth with regards to style and compliance of these
rules.

<hr align="center" style="background-color: #393939; height: 2px">

## Performance improvements

We take performance very much to heart. Performance improvements are always
welcome! If you identified a bottleneck, please make sure you follow the
performance fix procedure:

* Prepare a reproducible case that highlights the performance issue, if possible.
  At least, the case should provide a testable timing result.
* Submit a PR with a fix that provides a measurable performance improvement
* Think hard about all the use cases! Threading and concurrency are important to
  think about when it comes to performance, make sure your fix doesn't come with
  a performance regression in some use cases.

As previously highlighted, discussing the matter via an issue is a preferred
starting point. This will allow other contributors to join and express their
point of view, allowing for a smooth glide from problem description to resolution.

Thanks for caring about performance!

<hr align="center" style="background-color: #393939; height: 2px">

## Documentation improvements

CallbagKit is a complex project. Reactive programming in general is a lot about
explaining the concepts, classes and operators. If you spotted a place where
documentation could be improved (be in it-line documentation of project markdown
pages), please feel free to submit a documentation improvement PR. We very much
need a documentation that is as good, as as up-to-date as possible!

We understand the need for foreign language documentation. Unfortunately, due to
the scope and breadth of the project it's a tough promise to keep up-to-date
documentation in other languages than English. Moreover, all contributors only
have English as a common language on the project. Therefore, and to keep the
project as maintainable as possible, we only accept documentation changes and
improvements provided in English. If you're looking at providing a translation
of the in-line documentation, please make sure you have the resources and time
to keep it updated as the framework changes. We care a lot about the quality of
both the code and its documentation, over the long term. Maintaining a foreign
language translation is a longtime commitment that should not be taken lightly.

Thank you for your interest in helping with documentation! Your contributions
will make the life of other developers easier.

<hr align="center" style="background-color: #393939; height: 2px">

## New operators

If you're thinking about adding new operators to CallbagKit, please make sure
you discuss them via an [issue][Issues] first. We understand the desire to
fulfill various kinds of needs, and want to make sure the core serves the
majority of developers.

<hr align="center" style="background-color: #393939; height: 2px">

## Developer's Certificate of Origin 1.1

> By making a contribution to this project, I certify that:
>
> - (a) The contribution was created in whole or in part by me and I
>       have the right to submit it under the open source license
>       indicated in the file; or
> 
> - (b) The contribution is based upon previous work that, to the best
>       of my knowledge, is covered under an appropriate open source
>       license and I have the right under that license to submit that
>       work with modifications, whether created in whole or in part
>       by me, under the same open source license (unless I am
>       permitted to submit under a different license), as indicated
>       in the file; or
> 
> - (c) The contribution was provided directly to me by some other
>       person who certified (a), (b) or (c) and I have not modified
>       it.
> 
> - (d) I understand and agree that this project and the contribution
>       are public and that a record of the contribution (including all
>       personal information I submit with it, including my sign-off) is
>       maintained indefinitely and may be redistributed consistent with
>       this project or the open source license(s) involved.

*Wording of statement copied from [elinux.org][elinux.org]*

[Issues]: <https://github.com/swift-callbag/callbag-kit/issues>
[elinux.org]: <http://elinux.org/Developer_Certificate_Of_Origin>