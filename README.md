![](assets/images/logo/flixel-studio.png)

[flixel](https://github.com/HaxeFlixel/flixel) | [addons](https://github.com/HaxeFlixel/flixel-addons) | [ui](https://github.com/HaxeFlixel/flixel-ui) | [demos](https://github.com/HaxeFlixel/flixel-demos) | [tools](https://github.com/HaxeFlixel/flixel-tools) | [studio](https://github.com/Dovyski/flixel-studio) | [templates](https://github.com/HaxeFlixel/flixel-templates) | [docs](https://github.com/HaxeFlixel/flixel-docs) | [haxeflixel.com](https://github.com/HaxeFlixel/haxeflixel.com)

## About

> **NOTICE: this project is in early days of development! Things are expected to change and/or break. Documentation and features are still very rough, but they will eventually mature in the near future. Check the [ROADMAP](ROADMAP.md) to have an idea of how the project will evolve.**

Flixel Studio is an embeddable, in-game editor for [HaxeFlixel](https://haxeflixel.com). Simply put, when enabled in a project, Flixel Studio will turn the existing Flixel debugger into a full-featured editor. You can then organize game elements using layers, edit tilemaps, change properties of game objects, among many more things.

The philosophy behind Flixel Studio is to empower game developers with tools that integrate directly into their game runtime/code.

## Features

![flixel-studio](https://user-images.githubusercontent.com/512405/46570435-79ab9280-c964-11e8-8824-9aca88a43786.gif)

* Full-featured in-game editor.
* Load and modify tilemaps.
* Edit properties of game objects, e.g. position, velocity, etc.
* Manage game elements in layers of content.

## Getting started

### 1. Install the `flixel-studio` lib

Get the latest development version from Github:

```
haxelib git flixel-studio https://github.com/Dovyski/flixel-studio.git
```

___NOTE: in the future, you will be able to install `flixel-studio` from the `haxelib` repository.___

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

After installing and adding `flixel-studio` to your project, you are ready to start using it. To add the FlxStudio windows to the FlxDebugger, call `flixel.addons.studio.FlxStudio.create()` anytime after the FlxGame is created, , e.g. in your Document class or in your FlxState's create override.

```haxe
override public function create():Void
{
	super.create();

	// [your own code here]

	flixel.addons.studio.FlxStudio.start();
}
```

Alterantively, you can import `FlxStudio` and then invoke `FlxStudio.create()`:

```haxe
package;

import flixel.FlxGame;
import flixel.addons.studio.FlxStudio;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new():Void
	{
		super();
		
		addChild(new FlxGame(0, 0, MyInitialState));	
		FlxStudio.create();
	}
}
```

> **IMPORTANT: currently `flixel-studio` will only compile with the development version of HaxeFlixel (`version > 4.5.1`). Follow the inscructions on how to install HaxeFlixel development version [here](http://haxeflixel.com/documentation/install-development-flixel/).**

### 3. Usage (in-game editor)

When you compile and run your game, you can just bring up Flixel's debugger (by pressing the key below <kbd>Esc</kbd>), then click the _interaction tool_ ![](https://haxeflixel.com/documentation/images/02_handbook/debugger/icons/interactive.png) in the bar at the top.

When Flixel Studio is enabled in a project, the interaction's panel of tools on the right have more items, e.g. a tile tool. Addionally, you will see a few new debugger windows showing layers of content, etc. Enjoy your in-game editor!

## Contribute

The development process is a little bit rough right now. It's basically me coding and changing things a lot, documenting things very superficially along the way. At some point, the APIs will stabilize and it will be a lot easier to join the party.

If you want to help now, you can take flixel-studio for a ride and send me your feedback, or suggest a feature, [report a problem]((https://github.com/Dovyski/Codebot/issues/new)), or even send a pull request. Check the [ROADMAP](ROADMAP.md) to have an idea of how the project should evolve.

## License

Flixel Studio is licensed under the terms of the [MIT](https://choosealicense.com/licenses/mit/) Open Source license and is available for free.

## Changelog

See all changes in the [CHANGELOG](CHANGELOG.md) file.
