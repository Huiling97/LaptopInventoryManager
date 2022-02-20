class LaptopInventoryManager
  @@overall_inventory = {}

  def initialize(departmentNumLaptopsMap, numSpareLaptops)
    @departmentNumLaptopsMap = @departmentNumLaptopsMap
    @numSpareLaptops = numSpareLaptops

    laptop_arr(departmentNumLaptopsMap, numSpareLaptops)
  end

  def borrowLaptop(department)
    if @@overall_inventory.key?(department) #checks if department exists
      available_laptops = @@overall_inventory[department].find {|k, v| v == false} #returns array of first instance of department laptop not borrowed
      spare_laptops = @@overall_inventory['S'].find {|k, v| v == false} #returnsarray of first instance of spare laptop not borrowed

      if available_laptops != nil
        @@overall_inventory[department][available_laptops[0]] = true
        puts "#{available_laptops[0]} borrowed"
        return available_laptops[0] #returns laptop id if borrowed successfully
      elsif spare_laptops != nil
        @@overall_inventory['S'][spare_laptops[0]] = true
        puts "#{spare_laptops[0]} borrowed"
        return spare_laptops[0] #returns laptop id if borrowed successfully
      else
        puts "All laptops from department #{department} are currently borrowed"
        return nil
      end
    else
      puts "No such department"
      return nil
    end
  end

  def returnLaptop(return_laptop_id) #'A1'
    return_laptop_department_index = return_laptop_id[0] #returns 'A' from 'A1'

    if @@overall_inventory.key?(return_laptop_department_index) #checks if department exists
      return_laptop_department = @@overall_inventory[return_laptop_department_index] #returns hash of laptops for selected department

      if return_laptop_department.include?(return_laptop_id) && return_laptop_department[return_laptop_id] == true
        return_laptop_department[return_laptop_id] = false
        puts "#{return_laptop_id} returned"
        return return_laptop_id
      else
        puts "No such laptop"
        return nil
      end
    else
      puts "No such laptop"
      return nil
    end
  end

  private

  #creating a hash within a hash: eg.{"A"=>{"A1"=>false}, "B"=>{"B1"=>false, "B2"=>false}, "S"=>{"S1"=>false, "S2"=>false}}
  def laptop_arr(departmentNumLaptopsMap, numSpareLaptops)
    borrowed = false #assuming all laptops are not borrowed initially

    departmentNumLaptopsMap[0].each do |k, v| #departmentNumLaptopsMap: [{:A=>1, :B=>2}]
      department_inventory = {} #creates a new hash for each department
      department_str = k.to_s

      for i in 1..v do #creating key-value hash depending on value provided for each department
        laptop_id = department_str + i.to_s #eg. 'A1, A2'
        department_inventory[laptop_id] = borrowed
      end

      @@overall_inventory[department_str] = department_inventory #creates hash within a hash, eg. {"A"=>{"A1"=>false}}
    end

    #creating spare inventory
    department_inventory = {}
    for i in 1..numSpareLaptops do
      laptop_id = 'S' + i.to_s
      department_inventory[laptop_id] = borrowed
    end
    @@overall_inventory["S"] = department_inventory

    return @@overall_inventory
  end

end

lt = LaptopInventoryManager.new([A: 1, B: 2], 2)
# puts lt

lt.borrowLaptop('A') # A1 borrowed
lt.borrowLaptop('B') # B1 borrowed
lt.borrowLaptop('B') # B2 borrowed
lt.borrowLaptop('B') # S1 borrowed
lt.borrowLaptop('A') # S2 borrowed
lt.borrowLaptop('A') # All laptops from department A are currently borrowed

lt.returnLaptop("A1") # A1 returned
lt.borrowLaptop('A') # A1 borrowed
lt.returnLaptop("B2") # B2 returned
