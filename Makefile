# libreport 0.2 by Ivan Chebykin <ivan@chebykin.org>

LOCAL_HEADERS?=
LOCAL_TEMPLATES?=
LOCAL_METADATA?=
LOCAL_FLAGS?=

INCLUDE_DIR?=assets
SRCDIR?=.

SRCEXT?=md
FORMAT?=pdf

PANDOC?=pandoc
PANDOC_FLAGS?=-s --pdf-engine=xelatex $(LOCAL_FLAGS)

VIEWER_pdf?=evince
VIEWER_FLAGS_pdf?=

# Internal variables
SOURCES?=$(wildcard $(SRCDIR)/*.$(SRCEXT))
DOCS?=$(patsubst $(SRCDIR)/%,$(FORMAT)/%,$(SOURCES:.$(SRCEXT)=.$(FORMAT)))

METADATA?=$(LOCAL_METADATA) $(wildcard $(INCLUDE_DIR)/*.yaml)

HEADERS?=$(LOCAL_HEADERS) $(wildcard $(INCLUDE_DIR)/*.def)
HEADERS_OUT=$(HEADERS:.def=.def.out)

TEMPLATES?=$(LOCAL_TEMPLATES) $(wildcard $(INCLUDE_DIR)/*.tex)
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
	TEXINPUTS=:$(TEXINPUTS):$(INCLUDE_DIR) $(PANDOC) $(PANDOC_FLAGS)  \
	--template=$< $(SOURCES) $(METADATA) -V pagetitle=tmp -o $@

$(INCLUDE_DIR)/%.tex.out: $(INCLUDE_DIR)/%.tex
	TEXINPUTS=:$(TEXINPUTS):$(INCLUDE_DIR) $(PANDOC) $(PANDOC_FLAGS)  \
	--template=$< $(SOURCES) $(METADATA) -V pagetitle=tmp -o $@

$(FORMAT)/%.$(FORMAT): $(SRCDIR)/%.$(SRCEXT)
	@mkdir -p $(FORMAT)
	TEXINPUTS=:$(TEXINPUTS):$(INCLUDE_DIR) $(PANDOC) $(PANDOC_RFLAGS) $< $(METADATA) -o $@

run:
	$(VIEWER_pdf) $(VIEWER_FLAGS_pdf) $(FORMAT)/*.$(FORMAT)


clean:
	rm -rf $(FORMAT)
	rm -f $(TEMPLATES_OUT)
	rm -f $(HEADERS_OUT)
