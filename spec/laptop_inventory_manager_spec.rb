require 'laptop_inventory_manager'

describe LaptopInventoryManager do
  let(:laptop_inventory_manager) {LaptopInventoryManager.new([A: 1, B: 2], 2)}

  it "LaptopInventoryManager constructor should take 2 parameters" do
    initialize_parameters_count = LaptopInventoryManager.allocate.method(:initialize).arity
    expect(initialize_parameters_count).to eq 2
  end

  it "given a department id 'A', returns the department laptopID if borrowed successful" do
    expect(laptop_inventory_manager.borrowLaptop('A')).to eql('A1')
  end

  it "given all laptops are borrowed, returns spare department laptopID if borrowed successful" do
    1.times { laptop_inventory_manager.borrowLaptop('A') }
    expect(laptop_inventory_manager.borrowLaptop('A')).to eql('S1')
  end

  it "given all laptops are borrowed, return nil" do
    3.times { laptop_inventory_manager.borrowLaptop('A') }
    expect(laptop_inventory_manager.borrowLaptop('A')).to eq(nil)
  end

  it "given a laptop id 'A1', returns the laptop back to the inventory" do
    laptop_inventory_manager.borrowLaptop('A')
    expect(laptop_inventory_manager.returnLaptop('A1')).to eql('A1')
  end

  it "given an invalid department id when returning laptop, return nil" do
    expect(laptop_inventory_manager.returnLaptop('C1')).to eq(nil)
  end

  it "given valid department but an invalid laptop id when returning laptop, return nil" do
    expect(laptop_inventory_manager.returnLaptop('A11')).to eq(nil)
  end

end
