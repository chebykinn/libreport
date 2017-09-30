# libreport 0.1 by Ivan Chebykin <ivan@chebykin.org>

INCLUDE_DIR?=assets
SRCDIR?=.

SRCEXT?=md
FORMAT?=pdf

PANDOC?=pandoc
PANDOC_FLAGS?=-s --latex-engine=xelatex

# Internal variables
SOURCES?=$(wildcard $(SRCDIR)/*.$(SRCEXT))
DOCS?=$(patsubst $(SRCDIR)/%,$(FORMAT)/%,$(SOURCES:.$(SRCEXT)=.$(FORMAT)))

METADATA?=$(wildcard $(INCLUDE_DIR)/*.yaml)

HEADERS?=$(wildcard $(INCLUDE_DIR)/*.def)
HEADERS_OUT=$(HEADERS:.def=.def.out)

TEMPLATES?=$(wildcard $(INCLUDE_DIR)/*.tex)
TEMPLATES_OUT=$(TEMPLATES:.tex=.tex.out)

SPACE=
SPACE+=

HEADERS_FLAGS = -H$(subst $(SPACE),$(SPACE)-H,$(HEADERS_OUT))
TEMPLATES_FLAGS = -V include-before="\input{$(subst $(SPACE),}$(SPACE)\input{,$(TEMPLATES_OUT))}"

PANDOC_RFLAGS=$(PANDOC_FLAGS)
PANDOC_RFLAGS+=$(HEADERS_FLAGS)
PANDOC_RFLAGS+=$(TEMPLATES_FLAGS)

all: $(HEADERS_OUT) $(TEMPLATES_OUT) $(DOCS)
	@rm -f $(TEMPLATES_OUT)
	@rm -f $(HEADERS_OUT)

$(INCLUDE_DIR)/%.def.out: $(INCLUDE_DIR)/%.def
	TEXINPUTS=:$(TEXINPUTS):$(INCLUDE_DIR) $(PANDOC) $(PANDOC_FLAGS) --template=$< $(METADATA) $(SOURCES) -o $@

$(INCLUDE_DIR)/%.tex.out: $(INCLUDE_DIR)/%.tex
	TEXINPUTS=:$(TEXINPUTS):$(INCLUDE_DIR) $(PANDOC) $(PANDOC_FLAGS) --template=$< $(METADATA) $(SOURCES) -o $@

$(FORMAT)/%.$(FORMAT): $(SRCDIR)/%.$(SRCEXT)
	@mkdir -p $(FORMAT)
	TEXINPUTS=:$(TEXINPUTS):$(INCLUDE_DIR) $(PANDOC) $(PANDOC_RFLAGS) $< $(METADATA) -o $@

clean:
	rm -rf $(FORMAT)
	rm -f $(TEMPLATES_OUT)
	rm -f $(HEADERS_OUT)
