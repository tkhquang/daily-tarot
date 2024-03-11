defmodule DailyTarotUtils.WebHelperTest do
  @moduledoc false
  use ExUnit.Case

  alias DailyTarotUtils.WebHelper

  describe "classes/1" do
    test "returns correct values" do
      assert WebHelper.classes(test: true) == "test"
      assert WebHelper.classes(test: false) == ""
      assert WebHelper.classes(test: true, test2: true) == "test test2"
      assert WebHelper.classes(test: false, test2: true) == "test2"
      assert WebHelper.classes(test: false, test2: false) == ""
    end
  end
end
