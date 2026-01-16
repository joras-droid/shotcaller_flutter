# Convert SVG to PNG for App Icon

The `flutter_launcher_icons` package requires PNG format, not SVG. You need to convert your SVG logo to PNG.

## Option 1: Online Converter (Easiest)
1. Go to https://cloudconvert.com/svg-to-png or https://convertio.co/svg-png/
2. Upload `assets/logo/logo_shotcaller_finalized.svg`
3. Set output size to **1024x1024 pixels** (or higher for better quality)
4. Download the PNG file
5. Save it as `assets/logo/logo_shotcaller_finalized.png`

## Option 2: Using ImageMagick (Command Line)
If you have ImageMagick installed:
```bash
magick convert -background none -resize 1024x1024 assets/logo/logo_shotcaller_finalized.svg assets/logo/logo_shotcaller_finalized.png
```

## Option 3: Using Inkscape (Free Desktop App)
1. Open Inkscape
2. Open `assets/logo/logo_shotcaller_finalized.svg`
3. Go to File > Export PNG Image
4. Set width and height to 1024px
5. Export to `assets/logo/logo_shotcaller_finalized.png`

## Option 4: Using GIMP (Free Desktop App)
1. Open GIMP
2. Open `assets/logo/logo_shotcaller_finalized.svg`
3. Scale image to 1024x1024px
4. Export as PNG to `assets/logo/logo_shotcaller_finalized.png`

## After Converting:
1. Make sure `assets/logo/logo_shotcaller_finalized.png` exists
2. Run: `dart run flutter_launcher_icons`
3. The icons will be generated automatically!

