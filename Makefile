clean:
	mix deps.clean --unlock --unused

format:
	mix format

precommit:
	pre-commit run --all-files

gcdeps:
	mix deps.get && mix deps.compile

test:
	MIX_ENV=test mix test --trace --max-failures 1

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
