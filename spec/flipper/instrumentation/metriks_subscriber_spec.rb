require 'helper'
require 'flipper/adapters/memory'
require 'flipper/instrumentation/metriks'

describe Flipper::Instrumentation::MetriksSubscriber do
  let(:adapter) { Flipper::Adapters::Memory.new }
  let(:flipper) {
    Flipper.new(adapter, :instrumenter => ActiveSupport::Notifications)
  }

  let(:user) { user = Struct.new(:flipper_id).new('1') }

  before do
    Metriks::Registry.default.clear
  end

  context "for enabled feature" do
    it "updates feature metrics when calls happen" do
      flipper[:stats].enable(user)
      flipper[:stats].enabled?(user)

      Metriks.timer("flipper.feature_operation.enable").count.should be(1)
      Metriks.timer("flipper.feature_operation.enabled").count.should be(1)
      Metriks.meter("flipper.feature.stats.enabled").count.should be(1)
    end
  end

  context "for disabled feature" do
    it "updates feature metrics when calls happen" do
      flipper[:stats].disable(user)
      flipper[:stats].enabled?(user)

      Metriks.timer("flipper.feature_operation.disable").count.should be(1)
      Metriks.timer("flipper.feature_operation.enabled").count.should be(1)
      Metriks.meter("flipper.feature.stats.disabled").count.should be(1)
    end
  end
end