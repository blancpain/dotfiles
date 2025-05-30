<p align="center">
  <h2 align="center">🌊 KANAGAWA.BLACK.vscode 🌊</h2>
</p>

<p align="center">
  <img src="https://github.com/Lamarcke/kanagawa.black.vscode/raw/HEAD/assets/main.png" width="600" >
</p>

<br>

<p align="center">
A black theme edition for the VS Code port of the amazing <a href="https://github.com/rebelot/kanagawa.nvim">KANAGAWA.nvim</a> colorscheme by rebelot.
Credit for the original port goes to <a href="https://github.com/barklan/kanagawa.vscode">barklan</a>.
</p>

<p align="center">
  <h2 align="center"><img src="https://github.com/Lamarcke/kanagawa.black.vscode/raw/HEAD/assets/screenshot.png"></h2>
</p>

## Fork overview

This is a very simple fork that combines Kanagawa beautiful colors with a full black editor.  
The Kanagawa elegance with the beautiful black, the best of both worlds!

Credit goes entirely to [barklan](https://github.com/barklan) for his awesome port.  
We also take heavy inspiration from the [Pitch Black](https://github.com/ViktorQvarfordt/vscode-pitch-black-theme/) theme colors.

## Semantic tokens

Theme supports and recommends enabling semantic tokens.

### `TypeScript`

Enabled by default.

### `Python`

Enabled by default.

### `Go`

```json
{
  "gopls.ui.semanticTokens": true
}
```

#### `rust-analyzer`

```json
{
  "rust-analyzer.highlighting.strings": true
}
```

#### `C#`

```json
{
  "csharp.semanticHighlighting.enabled": true
}
```

## Screenshots

Blazingly black!

<p align="center">
  <h2 align="center">
    <img src="https://github.com/Lamarcke/kanagawa.black.vscode/raw/HEAD/assets/screenshot-2.png" width=300>
    <img src="https://github.com/Lamarcke/kanagawa.black.vscode/raw/HEAD/assets/screenshot-4.png" width=300>
    <br>
    <img src="https://github.com/Lamarcke/kanagawa.black.vscode/raw/HEAD/assets/screenshot-5.png" width=300>
    <img src="https://github.com/Lamarcke/kanagawa.black.vscode/raw/HEAD/assets/screenshot-6.png" width=300>
    <br>
  </h2>
</p>

## Customization

You can customize this theme to your liking by appending the settings below to your `settings.json` file.

### Comments

The Kanagawa comment color doesn't look as good in a black background, so we are using the default Dark+ theme's comments color.  
If you prefer a stronger color that also looks really nice:

```json
{
  "editor.tokenColorCustomizations": {
    "[Kanagawa]": {
      "comments": {
        "foreground": "#FF9E3B"
      }
    }
  }
}
```

### Indent guides

If you want to make the Editor ident guides "invisible" (they are still visible when using selections), use this:

```json
{
    "workbench.colorCustomizations": {
        "[Kanagawa]": {
            "editorIndentGuide.background": "#000", // Indent lines
            "editorIndentGuide.activeBackground": "#000", // Active indent line
    }
}
```

## Extreme ricing

This theme works really well when used with the [Background](https://marketplace.visualstudio.com/items?itemName=katsute.code-background) extension. It lets you define custom transparent wallpapers for VS Code.

The result looks like this:

<p align="center">
  <h2 align="center"><img src="https://github.com/Lamarcke/kanagawa.black.vscode/raw/HEAD/assets/rice-2.png"></h2>
</p>

I recommend adding this to your `settings.json` to make the terminal transparent:

```json
{
  "workbench.colorCustomizations": {
    "[Kanagawa Black]": {
      "terminal.background": "#1f1f1f00"
    }
  }
}
```

## Misc

You can find this theme's colors for different terminal emulators [here](https://github.com/rebelot/kanagawa.nvim#extras).
If you like this theme, consider supporting the [original author](https://github.com/rebelot/kanagawa.nvim#donate).  
Make sure to checkout the [original port](https://github.com/barklan/kanagawa.vscode).
