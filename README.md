# MixGenCallback

## Usage

```
$ mix archive.install github wojtekmach/mix_gen_callback
$ mix gen.callback GenServer
```

Produces the following output on STDOUT:

```elixir
defmodule MyGenServer do
  @behaviour GenServer

  # Optional
  @impl true
  def code_change(_old_vsn, _state, _extra) do
    raise "not implemented yet"
  end

  # Optional
  @impl true
  def format_status(_reason, _pdict_and_state) do
    raise "not implemented yet"
  end

  # Optional
  @impl true
  def handle_call(_request, _from, _state) do
    raise "not implemented yet"
  end

  # Optional
  @impl true
  def handle_cast(_request, _state) do
    raise "not implemented yet"
  end

  # Optional
  @impl true
  def handle_continue(_continue, _state) do
    raise "not implemented yet"
  end

  # Optional
  @impl true
  def handle_info(_msg, _state) do
    raise "not implemented yet"
  end

  @impl true
  def init(_init_arg) do
    raise "not implemented yet"
  end

  # Optional
  @impl true
  def terminate(_reason, _state) do
    raise "not implemented yet"
  end
end
```

Since every protocol is also a behaviour, this also works:

```
$ mix gen.callback Enumerable
```

```elixir
defmodule MyEnumerable do
  @behaviour Enumerable

  @impl true
  def count(_t) do
    raise "not implemented yet"
  end

  @impl true
  def member?(_t, _term) do
    raise "not implemented yet"
  end

  @impl true
  def reduce(_t, _acc, _reducer) do
    raise "not implemented yet"
  end

  @impl true
  def slice(_t) do
    raise "not implemented yet"
  end
end
```

## License

Copyright (c) 2019 Wojciech Mach

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
