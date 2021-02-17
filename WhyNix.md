Why Nix?
===================================================================================

I've written these notes to potentially be used as a talk.


What is Nix?

Nix is a package manager.

Competitor to rpm, apt/dpkg, yum, pacman, portage, brew, etc


What is a package manager?

* Gets programs from one machine to another

Bonus: programs still work when they move between machines


Software Deployment is HARD
===================================================================================

### Why is it hard?

https://edolstra.github.io/pubs/phd-thesis.pdf
> This is evidenced by the huge number of mailing list and forum postings about deployment failures, ranging from applications not working due to missing dependencies, to subtle malfunctions caused by incompatible components. Deployment problems also seem curiously resistant to automation: the same concrete problems appear time and again. Deployment is especially difficult in heavily component-based systemssuch as Unix-based open source softwarebecause the effort of dealing with the dependencies can increase super-linearly with each additional dependency.


* Presumably, developers test their software, and software consists of a set of files, so deployment should only be a matter of coping a set of files from one machine to another....right?  No of course not! The reasons why it's not so simple can be categorized into "Environment Issues" and "Mangeability issues"

## Environment Issues

Software can have all sorts of demands on the "environment".  

> AUDIENCE QUERY: what kinds of things could a program require from it's environment?

Configuration files, environment variables, libraries, system calls, networking, hardware devices, drivers, services...the list goes on and on.

##### Identifying Dependencies

One problem is that most software depend on other components to perform work on their behalf, these are the programs "dependencies". It follows that for a program to be deployed "correctly", that all of its "dependnecies" are identified.  However, it is quite hard to test whether a program's dependency list is complete.  If a dependnecy is missing from the list, it will not be discovered until it is tested on a machine that does not have that dependency installed.

##### Build vs Runtime Dependencies

There is also a distinct list of dependencies to build software and to run software.  These lists can be completely different.

##### Dependency Versioning and Variance

Dependencies can also change, and programs may depend on newer or older behavior than what is installed on any given system. Note that even when interfaces remain the same across builds, behavior can change that can break assumptions between components.  Also, alot of software is configurable with a slew of options, some of which may need to be enabled or disabled to work as a dependency of another component.  Even worse is when software becomes dependent on a particular compiler or ABI.

##### Finding Dependencies

Even if all dependencies are present, the software has to know how to find them.  This is often a labor-intensive part of the deployment process.  Some examples of this are managing the dynamic linker search path on unix systems, or the CLASSPATH environment variable in the Java environment.



For "correct software deployment", the job is to identify all these environment requirements, and then "realize" these requirements on the target system.  "Realization" could be installing dependencies, creating/modifying config files, starting services, etc.



## Manageability Issues

These are issues with supporting a system that changes over time.

> AUDIENCE QUERY: what kinds of things do we do to manage our software?

* download/transfer packages, install packages, upgrade packages, remove packages, create packages, query our packages

##### Removing Packages

When we remove a package, how do we make sure it has been completely removed and that our system is back to the same operating state it was in before installing it originally? When something is removed, how do we know which of its dependencies can also be removed without breaking another package that may depend on them?  Also, before we remove a package, how do we know if removing it will break another package?

##### Upgrading Packages

When we upgrade a package, we should be careful not to overwrite any part of any other package that might induce a failure in another part of the system.  This is known as "DLL hell", where upgrading or installing a shared library can cause a failure somewhere else.  Also, users should be able to roll back any upgrade when they don't work out.  This requires that the old configuration is "remembered" and there is a way to reproduce it.

[ Show dependecy Graphic ] Page 10 of Nix thesis

##### Package Customization

Most components have a large amount of "configurability" and "customization".  Users often require specific variants of their software which can include configuration, patches, etc.  Making modifications and realizing them on your system can be a difficult task on most systems.



# Other Package Managers


##### Identifying Dependencies

A fundamental problem of virtually all package management systems is they cannot relizbly determine the correctness of their dependnecy specifications.

If a dependency is missing from the spec, it won't be detected until it runs on a system without the misssing dependency installed.

Note that is is also hard to prevent unnecessary dependencies.  But this does not hard "correctness", only "efficiency".

##### Dependency Versioning and Variance

Package managers typically have some sort of way to configure dependencies. Sometimes you can declare them by name, sometimes you can specify a version, etc.  However, a custom package built with the same name but differnet compiler/ABI options could be installed, but could break compatibility with the software that depends on it.

This inability to specify complete dependencies is what gives rise to alot of the issues with dependency compatibility.  What makes this worse is that alot of package managers perform "destructive upgrading", where the old version of a package is overwritten with the new, potentially breaking any version-specific dependency on the old version.  The reason why package managers use "destructive upgrading" is typically because both versions of the package install the files to the same global pathnames. This also tempoariliy puts the system into an "inconsistent state", where some files come from the old version of the package and some come from the new version.  The operation cannot be done atomically.

##### Multilple Versions Not Allowed

In general, most linux package managers do not allow multiple packages to be installed that contain a file with the same pathname.  For example, if you have one package named "foo" that installs `/usr/bin/magic`, and another package named "bar" that also installs `/usr/bin/magic`, it will not allow you to install both.  Unfortunately, since packages also tend to have at least some of the same filenames accross versions (so they can be found by other packages), this usually means you CANNOT install multiple versions of the same package simultaneously.



# Summary of Motivation for Nix

These are the problems Nix solves:

* Dependency specifications are not validated, leading to incomplete deployment.
* Dependency specifications are inexact (e.g., nominal).
* It is not possible to deploy multiple versions or variants of a component side-by-side.
* Components can interfere with each other.
* It is not possible to roll back to previous configurations.
* Upgrade actions are not atomic.
* Applications must be monolithic, i.e., they must statically contain all their dependencies.
* Deployment actions can only be performed by administrators, not by unprivileged users.
* There is no link between binaries and the sources and build processes that built them.
* The system supports either source deployment or binary deployment, but not both; or it supports both but in a non-unified way.
* It is difficult to adapt components.
* Component composition is manual.
* The component framework is narrowly restricted to components written in a specific programming language or framework.
* The system depends on non-portable techniques.



Problem: install multiple versions of your packages

Nix: <show example>

Problem: transfer a package and all it's dependencies onto another machine

Nix: <show example>

Problem: select different versions of packages on your system

Problem: change a package

Problem: how did a package get built?  Can you build it on your system?  Where are the source files?  How do I submit changes to a package?


NOTE: live demo
===================================================================================
* install nix on a new machine
* remove nix
* install it again
* start pre environments, etc
* show multiple environments with different versions of the same package




