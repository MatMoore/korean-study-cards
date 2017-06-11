.PHONY=elm live

elm:
	elm make Main.elm --output docs/elm.js

live:
	elm-live --open --dir=docs Main.elm -- --output docs/elm.js
