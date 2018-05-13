build:
	ocamlbuild -pkg unix -use-ocamlfind \
		-plugin-tag "package(js_of_ocaml.ocamlbuild)" \
		-no-links \
		main.d.js
		ocamlbuild -use-ocamlfind actors.cmo constants.cmo display.cmo state.cmo ai.cmo main.cmo -r
clean:
	ocamlbuild -clean
test:
	ocamlbuild -use-ocamlfind actors.cmo constants.cmo display.cmo state.cmo ai.cmo main.cmo -r
	ocamlbuild -use-ocamlfind -pkg oUnit test.cmo -r
	ocamlbuild -use-ocamlfind test.byte && ./test.byte
