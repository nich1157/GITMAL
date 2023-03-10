FILES_IPYNB=$(wildcard L??/*.ipynb) $(wildcard L??/*/*.ipynb)
FILES_PY=$(wildcard libitmal/*.py)

CHECK_FOR_TEXT=grep "$1" $(FILES_IPYNB) -R || echo "  OK, no '$1'.."

.PHONY:all
all:
	@ echo "Doing nothing!"
	@ echo "  This makefile just for parsing and checking,"
	@ echo "  enjoy .c"

.PHONY:check
check:
	@ echo "CHECKING (for various no-no's in .ipynb files).."
	@ echo "  FILES: $(FILES_IPYNB)"
	@ $(call CHECK_FOR_TEXT, itundervisining) 
	@ $(call CHECK_FOR_TEXT, BB-Cou-UUVA) 
	@ $(call CHECK_FOR_TEXT, blackboard.au.dk) 
	@ $(call CHECK_FOR_TEXT, blackboard) 
	@ $(call CHECK_FOR_TEXT, Blackboard) 
	@ $(call CHECK_FOR_TEXT, "dk/GITMAL/")
	@ $(call CHECK_FOR_TEXT, "27524")
	@ echo "DONE: all ok"

.PHONY:test
test:
	@#for var in $(FILES_PY); do echo $$var $@; done
	@#libitmal/dataloaders.py
	libitmal/kernelfuns.py
	libitmal/utils.py
	libitmal/versions.py

.PHONY:pull
pull:
	@ echo "PULL" | tee -a log_pull.txt
	@ date        | tee -a log_pull.txt
	@ git pull 2>>log_pull.err | tee -a log_pull.txt

PARSED=$(foreach f,$(FILES_IPYNB),$(shell (python -m json.tool $(f) 1>/dev/null 2>/dev/null && echo >&2 "OK $(f)")|| (echo >&2 $(f) && python -m json.tool $(f))))
.PHONY:parsecheck
parsecheck:
	@#echo PARSE_ERRORS=$(PARSED)
	@#cat $(PARSED) | tr ' ' '\n' # |  xargs -I % sh -c 'echo %;'
