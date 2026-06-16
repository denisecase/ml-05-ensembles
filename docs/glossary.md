# Glossary

Use this page to record terms and ideas that help you understand
professional analytics projects.

This project is not only about EDA. It is also a chance to practice
how professional projects are organized, reused, documented, and verified.

Pro-tip: Expand the VS Code **Outline** view (below the navigator on the right)
to see this file organization at-a-glance.

## Project Organization

### source code

Source code are instructions that tell the computer what to do.
In a Python project, source code lives in files ending with `.py`.

### module

A module is one Python file that contains related code.
A module may include constants, functions, imports, and a `main()` function.
A project may have many modules working together.
Being able to organize project code into modules, and reusable functions is a valuable skill.

### package

A package is a folder of related Python modules.
A package usually includes an `__init__.py` file
(it can be empty or just a docstring comment).
The init file allows code in that folder to be
imported and reused across a project.

### notebook

A notebook is an interactive file used to combine
code, output, notes, and narrative.
Notebooks are useful for exploration, experiments,
and explaining analysis step by step.

## Reuse and Workflow

### reusable function

A reusable function is a named block of code that performs
one clear task and can be called more than once.
Good functions make projects easier to read, test, debug, and modify.

### dependency

A dependency is an external package or tool that a project
needs in order to run.
Dependencies are listed in `pyproject.toml`
and the environment can be easily recreated using `uv`.

### workflow

A workflow is an ordered process for completing work.
In a project, a workflow might include running code,
checking results, making changes, testing again,
and saving progress with Git.

## Data and Outputs

### raw data

Raw data is the original input data used by the project.
It should usually be kept unchanged so the analysis
can be repeated from the original source.

### processed data

Processed data is data that has been
cleaned, filtered, transformed, summarized, or prepared for later use.

### artifact

An artifact is a file created by running a project.
Examples include logs, charts, reports, exported data files,
generated databases, and documentation output.
