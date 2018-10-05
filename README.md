![](https://raw.github.com/HaxeFlixel/haxeflixel.com/master/src/files/images/flixel-logos/flixel-tools.png)

[flixel](https://github.com/HaxeFlixel/flixel) | [addons](https://github.com/HaxeFlixel/flixel-addons) | [ui](https://github.com/HaxeFlixel/flixel-ui) | [demos](https://github.com/HaxeFlixel/flixel-demos) | [tools](https://github.com/HaxeFlixel/flixel-tools) | [templates](https://github.com/HaxeFlixel/flixel-templates) | [docs](https://github.com/HaxeFlixel/flixel-docs) | [haxeflixel.com](https://github.com/HaxeFlixel/haxeflixel.com)

## About

> **NOTICE: this project is in early days of development! Things are expected to change and/or break. Documentation and features are still very rough, but they will eventually mature in the near future.**

Flixel Studio is an embeddable, in-game editor for HaxeFlixel. Simply put, when enabled in a project, Flixel Studio will turn the existing Flixel debugger into a full-featured editor. You can then organize game elements using layers, edit tilemaps, change properties of game objects, among many more things.

The philosophy behind Flixel Studio is to empower game developers with tools that integrate directly into their game runtime/code.

## Features

![](https://user-images.githubusercontent.com/512405/42411758-ecede658-8201-11e8-920f-b7805185ab86.gif)

* Full-featured in-game editor.
* Load and modify tilemaps.
* Edit properties of game objects, e.g. position, velocity, etc.

## Getting started

### 1. Install the `flixel-studio` lib

Get the latest development version from Github:

```
haxelib git flixel-studio https://github.com/Dovyski/flixel-studio.git
```

___NOTE: in the future, you will be able to install flixel-studio from `haxelib` repository.___

### 2. Add the `flixel-studio` lib to your project

Go to the folder where you have your project files, open the file `Project.xml`, then add the following:

```xml
<haxelib name="flixel-studio"/>
```

Usually libs are listed in the libraries section of the `Project.xml` file, which will probably look like the following after you add flixel-studio:

```xml
<!--------------------------------LIBRARIES------------------------------------->

<haxelib name="flixel"/>

<!--In case you want to use the addons package-->
<!--<haxelib name="flixel-addons" />-->

<!--In case you want to use the ui package-->
<!--<haxelib name="flixel-ui" />-->

<!--In case you want to use nape with flixel-->
<!--<haxelib name="nape" />-->

<haxelib name="flixel-studio"/>
```

### 3. Usage (code)

After installing and adding flixel-studio to your project, you are ready to start using it.

Open any class that describes a state of your game, e.g. `PlayState`. In the `create()` method, add the following line (no matter the place):

```haxe
flixel.addons.studio.FlxStudio.start();
```

Your `create()` method will end up looking like this:

```haxe
override public function create():Void
{
	super.create();

	// [your own code here]

	flixel.addons.studio.FlxStudio.start();
}
```

Alterantively, you can import `FlxStudio` and then invoke `FlxStudio.start()`:

```haxe

import flixel.FlxState;
import flixel.addons.studio.FlxStudio;

class PlayState extends FlxState
{
	override public function create():Void
	{
		super.create();

		// [your own code here]

		FlxStudio.start();
	}
}
```

> ***IMPORTANT: currently `flixel-studio` will not compile with any unmodified version of HaxeFlixel. HaxeFlixel's `addTool()` method in the debugger is currently private, so you need to make it public by changing HaxeFlixel code yourself. A pull request to fix that will be sent to the HaxeFlixel repository.  ***

### 3. Usage (in-game editor)

When you compile and run your game, you can just bring up Flixel debugger (by pressing the key below <kbd>Esc</kbd>), then click the _interaction tool_ ![](https://haxeflixel.com/documentation/images/02_handbook/debugger/icons/interactive.png) in the bar at the top.

When flixel-studio is enabled in a project, the interaction's panel of tools on the right have more tools, e.g. tile. Addionally, you will see a few new debugger windows showing layers of content, etc. Enjoy your in-game editor!

## Contribute

The development process is a little bit rough right now. It's basically me coding and changing things a lot, documenting things very superficially along the way. At some point, the APIs will stabilize and it will be a lot easier to join the party.

If you want to help now, you can take flixel-studio for a ride and send me your feedback, or suggest a feature, [report a problem]((https://github.com/Dovyski/Codebot/issues/new)), or even send a pull request.

## License

flixel-studio is licensed under the terms of the [MIT](https://choosealicense.com/licenses/mit/) Open Source license and is available for free.

## Changelog

See all changes in the [CHANGELOG](CHANGELOG.md) file.