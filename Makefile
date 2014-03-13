SRCS = $$(find . -maxdepth 1 \
	! -name . \
	! -name .git \
	! -name Makefile \
	! -name README \
	-exec basename {} \;)

install:
	@for f in $(SRCS); do ln -s $$PWD/$$f $$HOME/$$f; done

clean:
	@for f in $(SRCS); do rm $$HOME/$$f; done
