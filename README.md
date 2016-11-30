:busts_in_silhouette: Electron user helper for Clientele ITSM
=======================================
A cross-platform application that makes creating Clientele ITSM users a piece of :cake:!
# :page_facing_up: Overview
List the users that you want to create/update and the tool will create an XML that can be imported within Clietele.
The tool  accepts GID, e-mail and domain\\account in the user list.

The user details are fetched form the Active Directory using a Powershell script. See [this Repo](https://code.siemens.com/GS-IT-BT/ps-ADUser-export-XML) for details.

To add users to the attachment group, the tool uses a script from [here](https://code.siemens.com/GS-IT-BT/ps-serverLocaleGrroup-manager).

# :arrow_down: Download
You can find all releases [here](NO_RELEASES_YET)

# :zap: Developer quick start
The only development dependency of this project is [Node.js](https://nodejs.org). So just make sure you have it installed.
Then type few commands known to every Node developer...
~~~bash
git clone https://github.com/Sirius-A/electron-clientele-user-helper
cd electron-clientele-user-helper
npm install
npm start
~~~
... and boom! You have a running desktop application on your screen :sparkles:.

# :memo: Structure of the project
This app is built on [Electron](http://electron.atom.io/) and uses the [electron-boilerplate](https://github.com/szwacz/electron-boilerplate) as a starting point.

The application is split between two main folders...

`src` - this folder is intended for files which need to be transpiled or compiled (files which can't be used directly by Electron).

`app` - contains all static assets (put here images, css, html etc.) which don't need any pre-processing.

The build process compiles all stuff from the `src` folder and puts it into the `app` folder, so after the build has finished, your `app` folder contains the full, runnable application.

Treat `src` and `app` folders like two halves of one bigger thing.

The drawback of this design is that `app` folder contains some files which should be git-ignored and some which shouldn't (see `.gitignore` file). But thanks to this two-folders split development builds are much (much!) faster.

# :wrench: Development

## Starting the app

```
npm start
```

## Upgrading Electron version

The version of Electron runtime your app is using is declared in `package.json`:
```json
"devDependencies": {
  "electron": "1.4.7"
}
```
Side note: [Electron authors advise](http://electron.atom.io/docs/tutorial/electron-versioning/) to use fixed version here.

## Adding npm modules to your app

Remember to respect the split between `dependencies` and `devDependencies` in `package.json` file. Only modules listed in `dependencies` will be included into distributable app.

Side note: If the module you want to use in your app is a native one (not pure JavaScript but compiled C code or something) you should first  run `npm install name_of_npm_module --save` and then `npm run postinstall` to rebuild the module for Electron. This needs to be done only once when you're first time installing the module. Later on postinstall script will fire automatically with every `npm install`.

## Working with modules

Thanks to [rollup](https://github.com/rollup/rollup) you can (and should) use ES6 modules for all code in `src` folder. But because ES6 modules still aren't natively supported you can't use them in the `app` folder.

Use ES6 syntax in the `src` folder like this:
```js
import myStuff from './my_lib/my_stuff';
```

But use CommonJS syntax in `app` folder. So the code from above should look as follows:
```js
var myStuff = require('./my_lib/my_stuff');
```

# :white_check_mark: Testing

## Unit tests

```
npm test
```

Using [electron-mocha](https://github.com/jprichardson/electron-mocha) test runner with the [chai](http://chaijs.com/api/assert/) assertion library. This task searches for all files in `src` directory which respect pattern `*.spec.js`.

## End to end tests

```
npm run e2e
```

Using [mocha](https://mochajs.org/) test runner and [spectron](http://electron.atom.io/spectron/). This task searches for all files in `e2e` directory which respect pattern `*.e2e.js`.

## Code coverage

```
npm run coverage
```

Using [istanbul](http://gotwarlost.github.io/istanbul/) code coverage tool.

You can set the reporter(s) by setting `ISTANBUL_REPORTERS` environment variable (defaults to `text-summary` and `html`). The report directory can be set with `ISTANBUL_REPORT_DIR` (defaults to `coverage`).

# :rocket: Making a release

To package the app into an installer use command:
```
npm run release
```

It will start the packaging process for operating system you are running this command on. Ready for distribution file will be outputted to `dist` directory.

You can create Windows installer only when running on Windows, the same is true for Linux and OSX. So to generate all three installers you need all three operating systems.

All packaging actions are handled by [electron-builder](https://github.com/electron-userland/electron-builder). It has a lot of [customization options](https://github.com/electron-userland/electron-builder/wiki/Options), which you can declare under ["build" key in package.json file](https://github.com/szwacz/electron-boilerplate/blob/master/package.json#L2).

# License

Released under the MIT license.
