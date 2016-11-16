:busts_in_silhouette: Electron user helper for Clientele ITSM 
=======================================
A cross-platform application, that makes creating Clietele ITSM users a piece of :cake:! 
# :page_facing_up:Overview
List the users that you want to create/update and the tool will create an XML that can be imported within Clietele. 
The tool  accepts GID, e-mail and domain\\account in the user list.

The user details are fetched form the Active Directory using a Powershell script. See [this Repo](https://code.siemens.com/GS-IT-BT/ps-ADUser-export-XML) for details.

To add users to the attachment group, the tool uses a script from [here](https://code.siemens.com/GS-IT-BT/ps-serverLocaleGrroup-manager). 

# :arrow_down:Download 
You can find all releases [here](NO_RELEASES_YET)

# :zap:Developer quick start
The only development dependency of this project is [Node.js](https://nodejs.org). So just make sure you have it installed.
Then type few commands known to every Node developer...
~~~bash
git clone https://github.com/Sirius-A/electron-clientele-user-helper
cd electron-clientele-user-helper
npm install
npm start
~~~
... and boom! You have a running desktop application on your screen :sparkles:.

# :memo:Structure of the project
This app is built on [Electron](http://electron.atom.io/) and uses the [electron-boilerplate](https://github.com/szwacz/electron-boilerplate) as a starting point. 
Below is some information on how to the whole setup works. (All info is from the  [electron-boilerplate](https://github.com/szwacz/electron-boilerplate)).

## :package:Declaring dependencies

There are **two** `package.json` files:

#### 1. `package.json` for development
Sits on path: `electron-boilerplate/package.json`. This is where you should declare dependencies for your development environment and build scripts. **This file is not distributed with real application!**

It's also the place to specify the Electron runtime version you want to use:
```json
"devDependencies": {
  "electron": "1.3.3"
}
```
Note: [Electron authors advise](http://electron.atom.io/docs/tutorial/electron-versioning/) to use fixed version here.

#### 2. `package.json` for your application
Sits on path: `electron-boilerplate/app/package.json`. This is **real** manifest of your application. Declare your app dependencies here.

#### OMG, but seriously why there are two `package.json`?
1. Native npm modules (those written in C, not JavaScript) need to be compiled, and here we have two different compilation targets for them. Those used in application need to be compiled against electron runtime, and all `devDependencies` need to be compiled against your locally installed node.js. Thanks to having two files this is trivial.
2. When you package the app for distribution there is no need to add up to size of the app with your `devDependencies`. Here those are always not included (reside outside the `app` directory).

## :file_folder:Folders for application code

The application is split between two main folders...

`src` - this folder is intended for files which need to be transpiled or compiled (files which can't be used directly by electron).

`app` - contains all static assets (put here images, css, html etc.) which don't need any pre-processing.

The build process compiles all stuff from the `src` folder and puts it into the `app` folder, so after the build has finished, your `app` folder contains the full, runnable application.

Treat `src` and `app` folders like two halves of one bigger thing.

The drawback of this design is that `app` folder contains some files which should be git-ignored and some which shouldn't (see `.gitignore` file). But thanks to this two-folders split development builds are much (much!) faster.

# :wrench:Development

### Installation

```
npm install
```
It will also download Electron runtime and install dependencies for the second `package.json` file inside the `app` folder.

### Starting the app

```
npm start
```

### Adding npm modules to your app

Remember to add your dependencies to `app/package.json` file:
```
cd app
npm install name_of_npm_module --save
```

### Working with modules

Thanks to [rollup](https://github.com/rollup/rollup) you can (and should) use ES6 modules for all code in `src` folder. But because ES6 modules still aren't natively supported you can't use them in the `app` folder.

Use ES6 syntax in the `src` folder like this:
```js
import myStuff from './my_lib/my_stuff';
```

But use CommonJS syntax in `app` folder. So the code from above should look as follows:
```js
var myStuff = require('./my_lib/my_stuff');
```

# :white_check_mark:Testing

### Unit tests

Using [electron-mocha](https://github.com/jprichardson/electron-mocha) test runner with the [chai](http://chaijs.com/api/assert/) assertion library. To run the tests go with standard and use the npm test script:
```
npm test
```
This task searches for all files in `src` directory which respect pattern `*.spec.js`.

### End to end tests

Using [mocha](https://mochajs.org/) test runner and [spectron](http://electron.atom.io/spectron/). Run with command:
```
npm run e2e
```
This task searches for all files in `e2e` directory which respect pattern `*.e2e.js`.

### Code coverage

Using [istanbul](http://gotwarlost.github.io/istanbul/) code coverage tool. Run with command:
```
npm run coverage
```
You can set the reporter(s) by setting `ISTANBUL_REPORTERS` environment variable (defaults to `text-summary` and `html`). The report directory can be set with `ISTANBUL_REPORT_DIR` (defaults to `coverage`).

# :rocket:Making a release

To package the app into an installer use command:
```
npm run release
```
It will start the packaging process for operating system you are running this command on. Ready for distribution file will be outputted to `dist` directory.

You can create Windows installer only when running on Windows, the same is true for Linux and OSX. So to generate all three installers you need all three operating systems.

All packaging actions are handled by [electron-builder](https://github.com/electron-userland/electron-builder). See docs of this tool if you want to customize something.

