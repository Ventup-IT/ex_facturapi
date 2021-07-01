clean:
	mix deps.clean --unlock --unused

format:
	mix format

force-format:
	find test -name '*.ex' -o -name '*.exs' | mix format --check-formatted || mix format
	find lib -name '*.ex' -o -name '*.exs' | mix format --check-formatted || mix format

precommit:
	pre-commit run --all-files

gcdeps:
	mix deps.get && mix deps.compile

t:
	MIX_ENV=test mix test --trace --max-failures 1 --cover

test-watcher:
	MIX_ENV=test mix test.watch

coveralls:
	MIX_ENV=test mix coveralls

credo:
	mix credo

dialyzer:
	mix dialyzer --format dialyzer --ignore-exit-status

sobelow:
	mix sobelow

dev-console:
	MIX_ENV=dev iex -S mix

test-console:
	MIX_ENV=test iex -S mix
