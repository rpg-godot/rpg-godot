# Commit Guidelines

Each commit message consists of a **header**, a **body** and a **footer**:

```
<type>: <subject>

<body>

<footer>
```

Any line of the commit message cannot be longer 50 characters. This allows the message to be easier to read on GitHub as well as in various git tools.

Example:

```
feature: add script names to debug log

- The debug log now has a reference to the
  script via the obj parameter
- The debug log now uses script_name var for
  eaiser debugging
- The debug log now uses constants for log level

Fixes #1234
```

## Revert
If the commit reverts a previous commit, it should begin with `revert: `, followed by the header of the reverted commit. In the body it should say: `This reverts commit <hash>.`, where the hash is the SHA of the commit being reverted.

### Type
Must be one of the following:

* **feature**: A new feature
* **fix**: A bug fix
* **docs**: Documentation only changes
* **style**: Changes that do not affect the meaning of the code (white-space, formatting, missing semi-colons, etc)
* **refactor**: A code change that neither fixes a bug nor adds a feature
* **performance**: A code change that improves performance
* **test**: Adding missing tests or correcting existing tests
* **build**: Changes that affect the build system, CI configuration or external dependencies
* **git**: Commits related strictly to git
            (examples: initial commit, merges, gitignore, etc)

### Subject
The subject contains succinct description of the change:

* use the imperative, present tense: "change" not "changed" nor "changes"
* don't capitalize first letter
* no dot (.) at the end

### Body
Just as in the **subject**, use the imperative, present tense: "change" not "changed" nor "changes".

### Footer
The footer should contain any information about **Breaking Changes** or **Deprecations** and
is also the place to reference GitHub issues that this commit **Closes**.

**Breaking Changes** should start with the word `BREAKING CHANGE:` with a space or two newlines.
The rest of the commit message is then used for this.

**Deprecations** should start with the word `DEPRECATED:`. The rest of the commit message will be
used as content for the note.
