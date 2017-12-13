Template Repository
===================

This is the standard repository template for the ADAS project.
This template repository sets up the following repository settings:

- `master` and `integration` branch, containing this README.md
- Default and development branch: `integration`, production branch is `master`
- Forks are allowed
- Branch permissions for `master`, `integration` and all branch types (release, feature, bugfix, hotfix)
  - `master` and `integration` are not allowed to be deleted or updated without pull requests
  - release branches are not allowed to be updated without pull request but can be deleted
  - feature, bugfix and hotfix branches can be updated without pull request but rewriting history is not allowed
- No additional access keys or access permissions except for the project permissions
- Force Push is not allowed
- Require no approvers for pull requests

If you want to import an existing repository (e.g., an SVN import), you have two options:
- Create a repository from this template, add it as a new remote and merge master and integration branch
  with your existing branches
- Create an empty repository without a template, push your existing repository code as master and integration
  branch, then set this repository as template in the settings of the new repository and trigger the template
  synchronization.

The following other repository templates are also available:

- Templates for customer project repositories: TBD.

After creating a new repository from this template
--------------------------------------------------

When you create a new repository based on this template, you need to

- Setup the categories for this repository in the Repository details settings
- Replace the content of this README.md file with a meaningful REAMDE for the repository
  - Start with the template from below
  - Commit the new readme to integration and merge into master (or vice versa)
  - Push the changes before you enforce pull requests ;)
- Adapt the Workzone settings
  - In Properties, enable 'Unapprove Pull Requests on Source Change'
  - Add default reviewers for `master` and `integration` branches, possibly also add mandatory reviewers
- Setup the number of required reviewers and builds in the Pull request settings


The readme template starts below this line.
For formatting rules, please refer to https://bitbucket.org/tutorials/markdowndemo

------------------------------------------------------------------------------

Repository Title
================

Describe what this repository contains.

Further Information
-------------------

- Links to Confluence pages
- [Git Setup Quickstart Guid](https://confluence.tttech.com/display/GIT/Setup+Quickstart+Guide) for
  instructions how to setup your local git client.
- [ADAS Git Quickstart Guide](https://confluence.tttech.com/display/AD/ADAS+Git+Quickstart+Guide) for 
  instructions to checkout and build ADAS with CAMEL.
- Changelog: See CHANGELOG.md
- Maintainer: Your Name <yourname@tttech.com>

Requirements
------------

- List what is required to build and use this package.
- Give tested version numbers of the required programs and libraries.

Quick Start
-----------

#### Building and Installation
```
./configure
make
make install
```

#### Usage
```
$ run_this --awesome-command
```

Build Instructions
------------------

Describe how to build this repository.

Install Instructions
--------------------

Describe how to install this repository.

- Flashing instructions.
- Python packages to install.

Usage
-----

Describe how to use the artifacts in this repository.


