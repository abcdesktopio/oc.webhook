all: webhook
registry: all push
NOCACHE := false 

ifdef $$NOCACHE
  NOCACHE := $$NOCACHE
endif

webhook:
	docker build --no-cache=$(NOCACHE) -t abcdesktopio/webhookd .
push:
	docker push abcdesktopio/webhookd
