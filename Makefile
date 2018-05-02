build:
	ocamlbuild -pkg unix -use-ocamlfind \
		-plugin-tag "package(js_of_ocaml.ocamlbuild)" \
		-no-links \
		main.d.js
	ocamlbuild -use-ocamlfind actors.cmo display.cmo state.cmo main.cmo -r

clean:
	ocamlbuild -clean
