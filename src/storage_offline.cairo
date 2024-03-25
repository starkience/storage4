// let's now track the total amount of entries
// we associate a name ot the address. The favorite number is now linked to the name
// a constructor function
// we do this by deriving the person struct, and adding a constructur

// Remember: we're mapping with a LegacyMap and matching the owner's address with a u64, which we set at the value 0
//name and address HAVE to be supplied when deploying the contract

use starknet::ContractAddress;


#[starknet::interface]
pub trait ISimpleStorage<TContractState> {
    fn get_number(self: @TContractState) -> u64;
    fn store_number(ref self: TContractState, number: u64);
}


#[starknet::contract]
mod SimpleStorage {
    use starknet::ContractAddress;

    #[storage]
    pub struct Storage {
        number: u64,
        owner: person,
        total_unique_numbers: u128
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        StoredNumber: StoredNumber,
    }

     #[derive(Drop, starknet::Event)]
     struct StoredNumber {
         #[key]
         number: u64,
        }


    #[derive(
        Copy, Drop, Serde, starknet::Store
    )] // we added a person struct that specifies the owner of the address. The owner has a name to 
    struct person {
        name: felt252,
        address: ContractAddress,
    }

    #[constructor]
    fn constructor(ref self: ContractState, owner: person) {
        self.owner.write(owner); // Person object and written into the contract's storage
        self.number.write(owner.address, 0);
        self.total_unique_numbers.write(1);
    }

    #[abi(embed_v0)]
    impl SimpleStorage of super::ISimpleStorage<ContractState> {
        fn get_number(self: @ContractState) -> u64 {
            let number = self.number.read();
            number
        }
        fn store_number(ref self: ContractState, number: u64) {
            let caller = get_caller_address();
            self._store_number(caller, number);
        }
    }

    #[generate_trait]
    impl Private of PrivateTrait {
        fn _store_number(ref self: ContractState, number: u64) {
            let mut total_unique_numbers = self.total_unique_numbers.read();
            self.number.write(number);
            self.total_unique_numbers.write(total_unique_numbers + 1);
            self.emit(StoredNumber {number: number });
        }
    }
}
