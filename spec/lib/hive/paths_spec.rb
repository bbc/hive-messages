require "spec_helper"

describe Hive::Paths do

  it { should be }
  it "has an attribute called 'base'" do
    Hive::Paths.base = :base
    expect(Hive::Paths.base).to eq :base
  end
end
