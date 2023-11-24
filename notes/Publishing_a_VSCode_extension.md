# Notes on publishing a VS Code extension from Windows

Super easy, barely an inconvenience.

Install [node.js](https://nodejs.org/en). This might also install Chocolatey, Visual Studio C++, Python.

Then:

```terminal
> npm install -g @vscode/vsce
> vsce package
```

This creates a package that can be added to the GitHub release assets. Create an alternative package without the animations by temporarily adding a line to `.vscodeignore`, e.g. `animations/*.gif`, and re-running `vsce package`.

Next we need an up-to-date personal access token for Microsoft. Go to `https://dev.azure.com/YOUR_USERNAME`. Click on the person-gears in the upper right corner, then _Personal access tokens_, then _New Token_. In _Scopes_, click on _Show more scopes_, scroll to _Marketplace_, select _Manage_. Click _Create_.

Now:
```terminal
> vsce publish
```

