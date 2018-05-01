build:
	ocamlbuild -use-ocamlfind \
		-plugin-tag "package(js_of_ocaml.ocamlbuild)" \
		-no-links \
		main.d.js
	ocamlbuild -use-ocamlfind helper.cmo types.cmo state.cmo ai.cmo command.cmo gui.cmo sprites.cmo game.cmo -r

clean:
	ocamlbuild -clean
