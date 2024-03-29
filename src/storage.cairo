// let's now track the total amount of entries
// we associate a name ot the address. The favorite number is now linked to the name
// a constructor function
// we do this by deriving the person struct, and adding a constructur

// Remember: we're mapping with a LegacyMap and matching the owner's address with a u64, which we set at the value 0
//name and address HAVE to be supplied when deploying the contract

use starknet::ContractAddress;


#[starknet::interface]
pub trait ISimpleStorage<TContractState> {
    fn get_number(self: @TContractState, address: ContractAddress) -> u64;
    fn store_number(ref self: TContractState, number: u64);
// either add get result from sum
}


// add interface other_contract
// 1 fonction implemented insum.cairo

#[starknet::contract]
mod SimpleStorage {
    use starknet::get_caller_address;
    use starknet::ContractAddress;
    use storage4::sum::{ISumDispatcherTrait, ISumDispatcher};

    #[storage]
    pub struct Storage {
        number: LegacyMap::<ContractAddress, u64>,
        owner: person,
        operation_counter: u128,
        sum_contract: ISumDispatcher,
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
    fn constructor(ref self: ContractState, owner: person, sum_contract_address: ContractAddress) {
        self.owner.write(owner); // Person object and written into the contract's storage
        self.number.write(owner.address, 0);
        self.operation_counter.write(1);
        self
            .sum_contract
            .write(
                ISumDispatcher { contract_address: sum_contract_address }
            ) // initialize dispatcher
    }

    #[abi(embed_v0)]
    impl SimpleStorage of super::ISimpleStorage<ContractState> {
        fn get_number(self: @ContractState, address: ContractAddress) -> u64 {
            let number = self.number.read(address);
            number
        }
        fn store_number(ref self: ContractState, number: u64) {
            let caller = get_caller_address();
            let sum_contract = self.sum_contract.read();
            let sum = sum_contract.increment(number); //dispatcher call
            self._store_number(caller, sum);
        }
    }

    #[generate_trait]
    impl Private of PrivateTrait {
        fn _store_number(ref self: ContractState, user: ContractAddress, number: u64) {
            let operation_counter = self.operation_counter.read();
            self.number.write(user, number);
            self.operation_counter.write(operation_counter + 1);
            self.emit(StoredNumber { user: user, number: number });
        }
    }
}
