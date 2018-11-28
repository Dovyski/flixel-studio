# Roadmap
This file gives an overview of the direction this project is heading. The roadmap is organized in milestones which focus on a particular theme, e.g. UX. All functionalities described in this roadmap will be primarily implemented using existing Flixel features. For instance, anything related to animations will rely on `FlxTween`. As a last resort features will be implemented based on elements that do not exist in a vanilla version of Flixel.

## [M1 - basic infrastructure](https://github.com/Dovyski/flixel-studio/milestone/1)

Users can minimally add, remove and manipulate game content based on `FlxSprite`. Expected functionality:

- List existing game layers, i.e. `FlxGroup` properties in the current state.
- Freely move the camera around to better inspect the scene.
- Basic capabilities to edit tilemaps, i.e. single tile changes only.
- Scale, rotate and translate `FlxSprite` elements.
- Zoom in/out of current camera.
- Allow elements, i.e. subclasses of `FlxSprite`, to be added to the game from the library.
- Allow custom classes to be registered as library content.

## [M2 - content persistence](https://github.com/Dovyski/flixel-studio/milestone/2)

Content created using Flixel Studio should not be destroyed when the game is closed, i.e. save and load game states. Expected functionality:

- Add UI elements to allow content persistence, i.e. indication of unsaved changes, load state, etc.
- Save the content of a state to a file.
- Load a previously saved state from a file.

## [M3 - complex content](https://github.com/Dovyski/flixel-studio/milestone/3)

Users can add, remove and manipulate complex content, such as `FlxEmitter`. Expected functionality:

- UI: foldable panels.
- UI: tab windows.
- UI: better edit entities nested properties in a panel/window.
- Highlight existing emitters and provide means to manipulate them, e.g. move and change properties.
- Live edit of `FlxText` elements.
- Live edit of `FlxButton` elements.

## [M4 - UX](https://github.com/Dovyski/flixel-studio/milestone/4)

Focus on delivering  the best UX possible. Flixel studio should feel smooth and solid, not a fragile thing. As a rule of thumb, no user-created content should ever be lost. Expected functionality:

- Ensure Flixel is not catching keyboard/mouse events when Flixel studio/interaction is active ([flixel/#2155](https://github.com/HaxeFlixel/flixel/issues/2155))
- Add keyboard shortcuts to all tools.
- Allow users to undo actions, i.e. <kbd>CTRL</kbd>+<kbd>Z</kbd>
- Ability to "lock" particular layers to prevent unwanted interactions, e.g. like the Flash "lock" icon in the timeline.

## [M5 - animation/cinematics](https://github.com/Dovyski/flixel-studio/milestone/5)

Allow the creation of animations within Flixel studio using a timeline similar to Flash. This is an essential feature to help developers easily create great cutscenes in Flixel without spending hours scripting/coding them. Expected functionality:

- UI: create a timeline window.
- UI: allow basic manipulation of keyframes, i.e. add, remote.
- Create the Flixel studio runtime responsible for managing animations using the timeline.
- Save/load animations to a file.
- Allow camera movement to be scripted/managed by the timeline, i.e. follow path.
- Allow elements to be tweened in the timeline, e.g. rotate, scale, etc.

## [M6 - Game FX](https://github.com/Dovyski/flixel-studio/milestone/6)

Enhance tool capabilities regarding the creation of visual effects, e.g. particles and shaders. Expected functionality:

- Integrate [djflixel](https://johndimi.itch.io/djflixel) effects into the animation timeline.
- Allow basic manipulation of shader effects when working sprites.