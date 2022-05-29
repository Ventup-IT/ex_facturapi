force-compile:
	mix compile --force --warnings-as-errors

clean:
	mix deps.clean --unlock --unused

deep-clean:
	rm -rf _build
	rm -rf deps

force-format:
	find test -name '*.ex' -o -name '*.exs' | mix format --check-formatted || mix format
	find lib -name '*.ex' -o -name '*.exs' | mix format --check-formatted || mix format

gcdeps:
	mix deps.get && mix deps.compile

dev:
	MIX_ENV=dev iex -S mix

credo:
	mix credo --strict

dialyzer:
	MIX_DEBUG=1 mix dialyzer --ignore-exit-status --cache=false

sobelow:
	mix sobelow

check-docs:
	mix doctor --raise

dump:
	mix ecto.dump

test-console:
	MIX_ENV=test iex -S mix

delete-compiled-statics:
	mix phx.digest.clean --all

install-dep-tools:
	mix do local.hex --if-missing --force, local.rebar --if-missing --force
