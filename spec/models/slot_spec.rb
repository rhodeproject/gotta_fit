require 'spec_helper'

describe Slot do
  before(:each) do
    @slot = Slot.new(:date => Date.today,
                      :start_time => Time.now,
                      :end_time => Time.now,
                      :spots => 1)

  end

  it "should be valid with valid attributes" do
    @slot.should be_valid
  end

  it "should not be valid with out date" do
    @slot.date = nil
    @slot.should_not be_valid
  end

  it "should not be valid without start_time" do
    @slot.start_time = nil
    @slot.should_not be_valid
  end

  it "should not be valid without end_time" do
    @slot.end_time = nil
    @slot.should_not be_valid
  end

  it "should not be valid without spots" do
    @slot.spots = nil
    @slot.should_not be_valid
  end
end


