// let's now track the total amount of entries
// we associate a name ot the address. The favorite number is now linked to the name
// a constructor function
// we do this by deriving the person struct, and adding a constructur
use starknet::ContractAddress;


#[starknet::interface]
trait ISimpleStorage<TContractState> {
    fn set_number(ref self: TContractState, number: u64);
    fn get_number(self: @TContractState) -> u64;
}

#[starknet::contract]
mod SimpleStorage {
    use starknet::get_caller_address;
    use starknet::ContractAddress;

    #[storage]
    struct Storage {
        numbers: LegacyMap::<ContractAddress, u64>,
        owner: person // not same ownership we're talking about
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        StoredNumber: StoredNumber,
    }

    #[derive(Drop, starknet::Event)]
    struct StoredNumber {
        #[key]
        user: ContractAddress,
        name: felt252
    }


    #[derive(
        Copy, Drop, Serde, starknet::Store
    )] // we added a person struct that specifies the owner of the address. The owner has a name to 
    struct person {
        name: felt252,
        address: ContractAddress
    }

    #[constructor] // we're adding a constructor function, the contract will be deployd and initiate the first number at 0
    fn constructor(ref self: ContractState, owner: person) {
        self.owner.write(owner); // Person object and written into the contract's storage
        self.numbers.write(owner.address, 0);
    // Remember: we're mapping with a LegacyMap and matching the owner's address with a u64, which we set at the value 0
    } //name and address HAVE to be supplied when deploying the contract

    #[abi(embed_v0)]
    impl SimpleStorage of super::ISimpleStorage<ContractState> {
        fn set_number(ref self: ContractState, number: u64) {
            let caller = get_caller_address();
            self.numbers.write(caller, number);
        }
        fn get_number(self: @ContractState) -> u64 {
            let caller = get_caller_address();
            return self.numbers.read(caller);
        }
    }
}
